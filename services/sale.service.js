const models = require("../models");
const { AppError } = require("../utils/app-error");

function toNumber(value) {
  return Number(value || 0);
}

function assertPositiveNumber(value, fieldName) {
  const num = Number(value);
  if (!Number.isFinite(num) || num <= 0) {
    throw new AppError(400, `${fieldName} must be a positive number`);
  }
  return num;
}

function buildCheckState(checkInput = {}, paymentAmount, partnerName) {
  const finalIssueDate = checkInput.issue_date || null;
  const finalCashingDate = checkInput.cashing_date || null;

  let finalStatus = checkInput.status || null;
  if (!finalStatus) {
    finalStatus = finalCashingDate ? "cashed" : "pending";
  }

  if (finalStatus === "cashed" && !finalCashingDate) {
    throw new AppError(
      400,
      "Cashing date is required when check status is cashed",
    );
  }

  if (finalStatus === "pending" && finalCashingDate) {
    throw new AppError(400, "Pending check cannot have a cashing date");
  }

  if (finalCashingDate && finalIssueDate && finalCashingDate < finalIssueDate) {
    throw new AppError(400, "Cashing date cannot be before issue date");
  }

  if (!checkInput.bank_name) {
    throw new AppError(400, "bank_name is required for check payment");
  }

  if (!checkInput.check_number) {
    throw new AppError(400, "check_number is required for check payment");
  }

  if (!finalIssueDate) {
    throw new AppError(400, "issue_date is required for check payment");
  }

  return {
    bank_name: checkInput.bank_name,
    company_name: checkInput.company_name || partnerName || "Unknown",
    check_number: checkInput.check_number,
    amount: paymentAmount,
    issue_date: finalIssueDate,
    cashing_date: finalCashingDate,
    status: finalStatus,
    type: "incoming",
  };
}

async function findOwnedPartnerOrNull(userId, partnerId, transaction) {
  if (!partnerId) return null;

  const partner = await models.Partner.findOne({
    where: {
      id: partnerId,
      user_id: userId,
    },
    transaction,
  });

  if (!partner) {
    throw new AppError(404, "Partner not found");
  }

  return partner;
}

async function getOwnedStoragesMap(userId, storageIds, transaction) {
  const uniqueIds = [...new Set(storageIds.map(Number))];

  const storages = await models.Storage.findAll({
    where: { id: uniqueIds },
    include: [
      {
        model: models.Warehouse,
        where: { user_id: userId },
        attributes: [],
        required: true,
      },
    ],
    transaction,
    lock: transaction.LOCK.UPDATE,
  });

  if (storages.length !== uniqueIds.length) {
    throw new AppError(404, "One or more storages not found or unauthorized");
  }

  return new Map(storages.map((storage) => [Number(storage.id), storage]));
}

function validatePayload(payload) {
  if (!Array.isArray(payload.items) || payload.items.length === 0) {
    throw new AppError(
      400,
      "items is required and must contain at least one item",
    );
  }

  if (payload.payments !== undefined && !Array.isArray(payload.payments)) {
    throw new AppError(400, "payments must be an array");
  }

  if (!payload.sale_date) {
    throw new AppError(400, "sale_date is required");
  }
}

function calculatePaymentStatus(totalAmount, paidAmount) {
  const total = toNumber(totalAmount);
  const paid = toNumber(paidAmount);

  if (paid <= 0) return "unpaid";
  if (paid < total) return "partial";
  return "paid";
}

async function createSaleForUser(userId, payload) {
  validatePayload(payload);

  return models.sequelize.transaction(async (transaction) => {
    const partner = await findOwnedPartnerOrNull(
      userId,
      payload.partner_id,
      transaction,
    );

    const allStorageIds = payload.items.flatMap((item) => {
      if (!Array.isArray(item.allocations) || item.allocations.length === 0) {
        throw new AppError(
          400,
          "Each sale item must contain at least one allocation",
        );
      }

      return item.allocations.map((allocation) => allocation.storage_id);
    });

    const storagesMap = await getOwnedStoragesMap(
      userId,
      allStorageIds,
      transaction,
    );

    const remainingQuantities = new Map(
      [...storagesMap.entries()].map(([id, storage]) => [
        id,
        Number(storage.quantity),
      ]),
    );

    const preparedItems = payload.items.map((item, itemIndex) => {
      const itemQuantity = assertPositiveNumber(
        item.quantity,
        `items[${itemIndex}].quantity`,
      );
      const unitPrice = assertPositiveNumber(
        item.unit_price,
        `items[${itemIndex}].unit_price`,
      );

      let allocatedTotal = 0;
      let weightedPurchaseTotal = 0;
      let firstStorage = null;

      const preparedAllocations = item.allocations.map(
        (allocation, allocationIndex) => {
          const storageId = Number(allocation.storage_id);
          const allocationQty = assertPositiveNumber(
            allocation.quantity,
            `items[${itemIndex}].allocations[${allocationIndex}].quantity`,
          );

          const storage = storagesMap.get(storageId);
          if (!storage) {
            throw new AppError(
              404,
              `Storage ${storageId} not found or unauthorized`,
            );
          }

          if (!firstStorage) {
            firstStorage = storage;
          } else {
            if (storage.name !== firstStorage.name) {
              throw new AppError(
                400,
                `All allocations for item ${itemIndex + 1} must be from storages with the same item name`,
              );
            }

            if (storage.thickness !== firstStorage.thickness) {
              throw new AppError(
                400,
                `All allocations for item ${itemIndex + 1} must be from storages with the same thickness`,
              );
            }
          }

          const currentlyAvailable = remainingQuantities.get(storageId);
          if (currentlyAvailable < allocationQty) {
            throw new AppError(
              400,
              `Insufficient quantity in storage ${storageId}`,
            );
          }

          remainingQuantities.set(
            storageId,
            currentlyAvailable - allocationQty,
          );

          allocatedTotal += allocationQty;
          weightedPurchaseTotal +=
            allocationQty * toNumber(storage.purchase_price);

          return {
            storage_id: storageId,
            quantity: allocationQty,
          };
        },
      );

      if (allocatedTotal !== itemQuantity) {
        throw new AppError(
          400,
          `Allocated quantity must exactly match item quantity for item ${itemIndex + 1}`,
        );
      }

      const purchasePriceSnapshot = weightedPurchaseTotal / itemQuantity;
      const lineTotal = itemQuantity * unitPrice;

      return {
        item_name_snapshot: firstStorage.name,
        thickness_snapshot: firstStorage.thickness,
        quantity: itemQuantity,
        unit_price: unitPrice,
        purchase_price_snapshot: purchasePriceSnapshot,
        line_total: lineTotal,
        allocations: preparedAllocations,
      };
    });

    const totalAmount = preparedItems.reduce(
      (sum, item) => sum + toNumber(item.line_total),
      0,
    );

    const incomingPayments = Array.isArray(payload.payments)
      ? payload.payments
      : [];

    const preparedPayments = incomingPayments.map((payment, paymentIndex) => {
      if (!payment.payment_method) {
        throw new AppError(
          400,
          `payments[${paymentIndex}].payment_method is required`,
        );
      }

      const amount = assertPositiveNumber(
        payment.amount,
        `payments[${paymentIndex}].amount`,
      );

      if (!payment.payment_date) {
        throw new AppError(
          400,
          `payments[${paymentIndex}].payment_date is required`,
        );
      }

      if (payment.payment_method === "cash") {
        return {
          payment_method: "cash",
          amount,
          payment_date: payment.payment_date,
          notes: payment.notes || null,
        };
      }

      if (payment.payment_method === "check") {
        return {
          payment_method: "check",
          amount,
          payment_date: payment.payment_date,
          notes: payment.notes || null,
          check: buildCheckState(
            payment.check,
            amount,
            partner?.company_name || null,
          ),
        };
      }

      throw new AppError(
        400,
        `Unsupported payment_method at payments[${paymentIndex}]`,
      );
    });

    const totalPaid = preparedPayments.reduce(
      (sum, payment) => sum + toNumber(payment.amount),
      0,
    );

    if (totalPaid > totalAmount) {
      throw new AppError(
        400,
        `Total payments (${totalPaid}) cannot exceed sale total (${totalAmount})`,
      );
    }

    const remainingAmount = totalAmount - totalPaid;
    const paymentStatus = calculatePaymentStatus(totalAmount, totalPaid);

    const sale = await models.Sale.create(
      {
        user_id: userId,
        partner_id: partner?.id || null,
        sale_date: payload.sale_date,
        invoice_number: payload.invoice_number || null,
        status: payload.status || "completed",
        total_amount: totalAmount,
        paid_amount: totalPaid,
        remaining_amount: remainingAmount,
        payment_status: paymentStatus,
        notes: payload.notes || null,
      },
      { transaction },
    );

    for (const preparedItem of preparedItems) {
      const saleItem = await models.SaleItem.create(
        {
          sale_id: sale.id,
          item_name_snapshot: preparedItem.item_name_snapshot,
          thickness_snapshot: preparedItem.thickness_snapshot,
          quantity: preparedItem.quantity,
          unit_price: preparedItem.unit_price,
          purchase_price_snapshot: preparedItem.purchase_price_snapshot,
          line_total: preparedItem.line_total,
        },
        { transaction },
      );

      for (const allocation of preparedItem.allocations) {
        await models.SaleItemAllocation.create(
          {
            sale_item_id: saleItem.id,
            storage_id: allocation.storage_id,
            quantity: allocation.quantity,
          },
          { transaction },
        );
      }
    }

    for (const [storageId, newQuantity] of remainingQuantities.entries()) {
      const storage = storagesMap.get(storageId);
      storage.quantity = newQuantity;
      await storage.save({ transaction });
    }

    for (const paymentData of preparedPayments) {
      let checkId = null;

      if (paymentData.payment_method === "check") {
        const createdCheck = await models.Check.create(
          {
            user_id: userId,
            ...paymentData.check,
          },
          { transaction },
        );

        checkId = createdCheck.id;
      }

      const payment = await models.Payment.create(
        {
          user_id: userId,
          sale_id: sale.id,
          purchase_id: null,
          payment_method: paymentData.payment_method,
          amount: paymentData.amount,
          payment_date: paymentData.payment_date,
          check_id: checkId,
          notes: paymentData.notes,
        },
        { transaction },
      );

      if (paymentData.payment_method === "cash") {
        await models.Transaction.create(
          {
            user_id: userId,
            type: "income",
            category: "sale",
            amount: paymentData.amount,
            description: `Cash payment for sale #${sale.id}`,
            transaction_date: paymentData.payment_date,
            reference_type: "sale_payment",
            reference_id: payment.id,
            company_name: partner?.company_name || null,
          },
          { transaction },
        );
      }

      if (
        paymentData.payment_method === "check" &&
        paymentData.check.status === "cashed"
      ) {
        await models.Transaction.create(
          {
            user_id: userId,
            type: "income",
            category: "check_in",
            amount: paymentData.amount,
            description: `incoming check ${paymentData.check.check_number} - ${paymentData.check.bank_name}`,
            transaction_date: paymentData.check.cashing_date,
            reference_type: "check",
            reference_id: checkId,
            company_name: paymentData.check.company_name,
          },
          { transaction },
        );
      }
    }

    return models.Sale.findByPk(sale.id, {
      include: [
        {
          model: models.SaleItem,
          include: [
            {
              model: models.SaleItemAllocation,
              include: [{ model: models.Storage }],
            },
          ],
        },
        {
          model: models.Payment,
          include: [{ model: models.Check }],
        },
        {
          model: models.Partner,
          attributes: ["id", "company_name", "partner_type", "phone_number"],
        },
      ],
      transaction,
    });
  });
}

async function findOwnedSaleOrThrow(userId, saleId, transaction) {
  const sale = await models.Sale.findOne({
    where: {
      id: saleId,
      user_id: userId,
    },
    include: [
      {
        model: models.Partner,
        attributes: ["id", "company_name", "partner_type", "phone_number"],
      },
    ],
    transaction,
    lock: transaction.LOCK.UPDATE,
  });

  if (!sale) {
    throw new AppError(404, "Sale not found");
  }

  return sale;
}

function validateAddPaymentPayload(payload) {
  if (!payload.payment_method) {
    throw new AppError(400, "payment_method is required");
  }

  assertPositiveNumber(payload.amount, "amount");

  if (!payload.payment_date) {
    throw new AppError(400, "payment_date is required");
  }
}

async function addPaymentToSaleForUser(userId, saleId, payload) {
  validateAddPaymentPayload(payload);

  return models.sequelize.transaction(async (transaction) => {
    const sale = await findOwnedSaleOrThrow(userId, saleId, transaction);

    if (sale.status === "cancelled") {
      throw new AppError(400, "Cannot add payment to a cancelled sale");
    }

    const currentRemaining = toNumber(sale.remaining_amount);

    if (currentRemaining <= 0) {
      throw new AppError(400, "This sale is already fully paid");
    }

    const paymentAmount = assertPositiveNumber(payload.amount, "amount");

    if (paymentAmount > currentRemaining) {
      throw new AppError(
        400,
        `Payment amount (${paymentAmount}) cannot exceed remaining amount (${currentRemaining})`,
      );
    }

    let checkId = null;

    if (payload.payment_method === "check") {
      const checkData = buildCheckState(
        payload.check,
        paymentAmount,
        sale.Partner?.company_name || null,
      );

      const createdCheck = await models.Check.create(
        {
          user_id: userId,
          ...checkData,
        },
        { transaction },
      );

      checkId = createdCheck.id;
    } else if (payload.payment_method !== "cash") {
      throw new AppError(400, "Unsupported payment_method");
    }

    const payment = await models.Payment.create(
      {
        user_id: userId,
        sale_id: sale.id,
        purchase_id: null,
        payment_method: payload.payment_method,
        amount: paymentAmount,
        payment_date: payload.payment_date,
        check_id: checkId,
        notes: payload.notes || null,
      },
      { transaction },
    );

    if (payload.payment_method === "cash") {
      await models.Transaction.create(
        {
          user_id: userId,
          type: "income",
          category: "sale",
          amount: paymentAmount,
          description: `Cash payment added to sale #${sale.id}`,
          transaction_date: payload.payment_date,
          reference_type: "sale_payment",
          reference_id: payment.id,
          company_name: sale.Partner?.company_name || null,
        },
        { transaction },
      );
    }

    if (
      payload.payment_method === "check" &&
      payload.check &&
      payload.check.status === "cashed"
    ) {
      await models.Transaction.create(
        {
          user_id: userId,
          type: "income",
          category: "check_in",
          amount: paymentAmount,
          description: `incoming check ${payload.check.check_number} - ${payload.check.bank_name}`,
          transaction_date: payload.check.cashing_date,
          reference_type: "check",
          reference_id: checkId,
          company_name: sale.Partner?.company_name || null,
        },
        { transaction },
      );
    }

    const updatedPaidAmount = toNumber(sale.paid_amount) + paymentAmount;
    const updatedRemainingAmount =
      toNumber(sale.total_amount) - updatedPaidAmount;
    const updatedPaymentStatus = calculatePaymentStatus(
      sale.total_amount,
      updatedPaidAmount,
    );

    sale.paid_amount = updatedPaidAmount;
    sale.remaining_amount = updatedRemainingAmount;
    sale.payment_status = updatedPaymentStatus;

    await sale.save({ transaction });

    return models.Sale.findByPk(sale.id, {
      include: [
        {
          model: models.SaleItem,
          include: [
            {
              model: models.SaleItemAllocation,
              include: [{ model: models.Storage }],
            },
          ],
        },
        {
          model: models.Payment,
          include: [{ model: models.Check }],
        },
        {
          model: models.Partner,
          attributes: ["id", "company_name", "partner_type", "phone_number"],
        },
      ],
      transaction,
    });
  });
}

module.exports = {
  createSaleForUser,
  addPaymentToSaleForUser,
};
