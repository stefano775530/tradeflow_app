const { not } = require("supertest/lib/cookies");
const models = require("../models");
const { AppError } = require("../utils/app-error");

function toNumber(value) {
  return Number(value || 0);
}

function calculatePaymentStatus(totalAmount, paidAmount) {
  const total = toNumber(totalAmount);
  const paid = toNumber(paidAmount);

  if (paid <= 0) return "unpaid";
  if (paid < total) return "partial";
  return "paid";
}

function resolveCheckState(input, existing = null) {
  const finalIssueDate =
    input.issue_date !== undefined
      ? input.issue_date
      : (existing?.issue_date ?? null);

  const finalCashingDate =
    input.cashing_date !== undefined
      ? input.cashing_date
      : (existing?.cashing_date ?? null);

  let finalStatus =
    input.status !== undefined ? input.status : (existing?.status ?? null);

  if (!finalStatus) {
    finalStatus = finalCashingDate ? "cashed" : "pending";
  }

  if (
    input.status === undefined &&
    input.cashing_date !== undefined &&
    input.cashing_date !== null
  ) {
    finalStatus = "cashed";
  }

  const finalType = input.type !== undefined ? input.type : existing?.type;

  if (finalStatus === "cashed" && !finalCashingDate) {
    throw new AppError(400, "Cashing date is required when status is cashed");
  }

  //if (finalStatus === "pending" && finalCashingDate) {
  //  throw new AppError(400, "Pending check cannot have a cashing date");
  //}

  if (finalCashingDate && finalIssueDate && finalCashingDate < finalIssueDate) {
    throw new AppError(400, "Cashing date cannot be before issue date");
  }

  const companyName =
    input.company_name !== undefined
      ? input.company_name
      : existing?.company_name;

  return {
    bank_name:
      input.bank_name !== undefined ? input.bank_name : existing?.bank_name,
    check_number:
      input.check_number !== undefined
        ? input.check_number
        : existing?.check_number,
    amount: input.amount !== undefined ? input.amount : existing?.amount,
    issue_date: finalIssueDate,
    cashing_date: finalStatus === "cashed" ? finalCashingDate : null,
    status: finalStatus,
    type: finalType,
    company_name: companyName,
    note: input.note !== undefined ? input.note : existing?.note,
  };
}

async function findOwnedCheckOrThrow(userId, id, transaction) {
  const check = await models.Check.findOne({
    where: { id, user_id: userId },
    transaction,
  });

  if (!check) {
    throw new AppError(404, "Check not found");
  }

  return check;
}

async function findLinkedPaymentByCheckId(checkId, transaction) {
  return models.Payment.findOne({
    where: { check_id: checkId },
    transaction,
  });
}

async function recalculateSaleDebt(saleId, transaction) {
  const sale = await models.Sale.findByPk(saleId, { transaction });

  if (!sale) return;

  const payments = await models.Payment.findAll({
    where: { sale_id: saleId },
    include: [{ model: models.Check }],
    transaction,
  });

  const paidAmount = payments.reduce((sum, payment) => {
    if (payment.payment_method === "cash") {
      return sum + toNumber(payment.amount);
    }

    if (payment.payment_method === "check") {
      if (!payment.Check) return sum;
      if (payment.Check.status === "bounced") return sum;

      return sum + toNumber(payment.amount);
    }

    return sum;
  }, 0);

  const totalAmount = toNumber(sale.total_amount);
  const remainingAmount = Math.max(totalAmount - paidAmount, 0);
  const paymentStatus = calculatePaymentStatus(totalAmount, paidAmount);

  sale.paid_amount = paidAmount;
  sale.remaining_amount = remainingAmount;
  sale.payment_status = paymentStatus;

  await sale.save({ transaction });
}

async function recalculatePurchaseDebt(purchaseId, transaction) {
  const purchase = await models.Purchase.findByPk(purchaseId, { transaction });

  if (!purchase) return;

  const payments = await models.Payment.findAll({
    where: { purchase_id: purchaseId },
    include: [{ model: models.Check }],
    transaction,
  });

  const paidAmount = payments.reduce((sum, payment) => {
    if (payment.payment_method === "cash") {
      return sum + toNumber(payment.amount);
    }

    if (payment.payment_method === "check") {
      if (!payment.Check) return sum;
      if (payment.Check.status === "bounced") return sum;

      return sum + toNumber(payment.amount);
    }

    return sum;
  }, 0);

  const totalAmount = toNumber(purchase.total_amount);
  const remainingAmount = Math.max(totalAmount - paidAmount, 0);
  const paymentStatus = calculatePaymentStatus(totalAmount, paidAmount);

  purchase.paid_amount = paidAmount;
  purchase.remaining_amount = remainingAmount;
  purchase.payment_status = paymentStatus;

  await purchase.save({ transaction });
}

async function syncCheckLinkedPaymentAndDebt(check, transaction) {
  const payment = await findLinkedPaymentByCheckId(check.id, transaction);

  if (!payment) {
    return;
  }

  // keep payment amount synchronized with the check amount
  if (toNumber(payment.amount) !== toNumber(check.amount)) {
    payment.amount = check.amount;
    await payment.save({ transaction });
  }

  if (payment.sale_id) {
    await recalculateSaleDebt(payment.sale_id, transaction);
  }

  if (payment.purchase_id) {
    await recalculatePurchaseDebt(payment.purchase_id, transaction);
  }
}

async function syncCheckTransaction(check, transaction) {
  const existingTransaction = await models.Transaction.findOne({
    where: {
      user_id: check.user_id,
      reference_type: "check",
      reference_id: check.id,
    },
    transaction,
  });

  if (check.status !== "cashed") {
    if (existingTransaction) {
      await existingTransaction.destroy({ transaction });
    }
    return;
  }

  const transactionType = check.type === "incoming" ? "income" : "expense";
  const transactionCategory =
    check.type === "incoming" ? "check_in" : "check_out";

  const transactionData = {
    user_id: check.user_id,
    type: transactionType,
    category: transactionCategory,
    amount: check.amount,
    description: `${check.type} check ${check.check_number} - ${check.bank_name}`,
    transaction_date: check.cashing_date,
    reference_type: "check",
    reference_id: check.id,
    company_name: check.company_name,
    note: check.note,
  };

  if (!existingTransaction) {
    await models.Transaction.create(transactionData, { transaction });
    return;
  }

  existingTransaction.type = transactionData.type;
  existingTransaction.category = transactionData.category;
  existingTransaction.amount = transactionData.amount;
  existingTransaction.description = transactionData.description;
  existingTransaction.transaction_date = transactionData.transaction_date;
  existingTransaction.company_name = transactionData.company_name;
  existingTransaction.note = transactionData.note;

  await existingTransaction.save({ transaction });
}

async function createCheckForUser(userId, payload) {
  return models.sequelize.transaction(async (transaction) => {
    const data = resolveCheckState(payload);

    const check = await models.Check.create(
      {
        user_id: userId,
        ...data,
      },
      { transaction },
    );

    await syncCheckTransaction(check, transaction);
    await syncCheckLinkedPaymentAndDebt(check, transaction);

    return check;
  });
}

async function updateCheckForUser(userId, id, payload) {
  return models.sequelize.transaction(async (transaction) => {
    const check = await findOwnedCheckOrThrow(userId, id, transaction);

    const data = resolveCheckState(payload, check);

    check.bank_name = data.bank_name;
    check.check_number = data.check_number;
    check.amount = data.amount;
    check.issue_date = data.issue_date;
    check.cashing_date = data.cashing_date;
    check.status = data.status;
    check.type = data.type;
    check.company_name = data.company_name;
    check.note = data.note;

    await check.save({ transaction });

    await syncCheckTransaction(check, transaction);
    await syncCheckLinkedPaymentAndDebt(check, transaction);

    return check;
  });
}

async function deleteCheckForUser(userId, id) {
  return models.sequelize.transaction(async (transaction) => {
    const check = await findOwnedCheckOrThrow(userId, id, transaction);

    const linkedPayment = await findLinkedPaymentByCheckId(
      check.id,
      transaction,
    );

    if (linkedPayment) {
      throw new AppError(
        400,
        "Cannot delete a check that is linked to a payment",
      );
    }

    await models.Transaction.destroy({
      where: {
        user_id: userId,
        reference_type: "check",
        reference_id: check.id,
      },
      transaction,
    });

    await check.destroy({ transaction });
  });
}

async function getChecksForUser(userId, query) {
  const {
    status,
    type,
    page = 1,
    limit = 10,
    sortBy = "issue_date",
    sortOrder = "DESC",
  } = query;

  const normalizedPage = Math.max(Number(page) || 1, 1);
  const normalizedLimit = Math.min(Math.max(Number(limit) || 10, 1), 100);
  const offset = (normalizedPage - 1) * normalizedLimit;

  const allowedSortFields = [
    "issue_date",
    "cashing_date",
    "amount",
    "created_at",
    "id",
  ];

  const finalSortBy = allowedSortFields.includes(sortBy)
    ? sortBy
    : "issue_date";

  const finalSortOrder =
    String(sortOrder).toUpperCase() === "ASC" ? "ASC" : "DESC";

  const where = {
    user_id: userId,
  };

  if (status) {
    where.status = status;
  }

  if (type) {
    where.type = type;
  }

  const { count, rows } = await models.Check.findAndCountAll({
    where,
    order: [
      [finalSortBy, finalSortOrder],
      ["id", "DESC"],
    ],
    limit: normalizedLimit,
    offset,
  });

  const totalItems = count;
  const totalPages = Math.ceil(totalItems / normalizedLimit) || 1;

  return {
    page: normalizedPage,
    limit: normalizedLimit,
    totalItems,
    totalPages,
    hasNextPage: normalizedPage < totalPages,
    hasPrevPage: normalizedPage > 1,
    data: rows,
  };
}

module.exports = {
  createCheckForUser,
  getChecksForUser,
  updateCheckForUser,
  deleteCheckForUser,
  findOwnedCheckOrThrow,
};
