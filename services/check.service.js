const models = require("../models");
const { AppError } = require("../utils/app-error");

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

  if (finalStatus === "pending" && finalCashingDate) {
    throw new AppError(400, "Pending check cannot have a cashing date");
  }

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
    cashing_date: finalCashingDate,
    status: finalStatus,
    type: finalType,
    company_name: companyName,
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

    await check.save({ transaction });
    await syncCheckTransaction(check, transaction);

    return check;
  });
}

async function deleteCheckForUser(userId, id) {
  return models.sequelize.transaction(async (transaction) => {
    const check = await findOwnedCheckOrThrow(userId, id, transaction);

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

module.exports = {
  createCheckForUser,
  updateCheckForUser,
  deleteCheckForUser,
  findOwnedCheckOrThrow,
};
