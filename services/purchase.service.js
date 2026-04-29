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

function normalizeDateOnly(value) {
  if (!value) return null;

  if (value instanceof Date) {
    return value.toISOString().slice(0, 10);
  }

  return String(value).slice(0, 10);
}

function sameDateOnly(a, b) {
  return normalizeDateOnly(a) === normalizeDateOnly(b);
}

function calculatePaymentStatus(totalAmount, paidAmount) {
  const total = toNumber(totalAmount);
  const paid = toNumber(paidAmount);

  if (paid <= 0) return "unpaid";
  if (paid < total) return "partial";
  return "paid";
}

function buildOutgoingCheckState(checkInput = {}, paymentAmount, partnerName) {
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
    type: "صادر",
  };
}

async function findOwnedSupplierOrNull(userId, partnerId, transaction) {
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

  if (partner.partner_type !== "supplier") {
    throw new AppError(
      400,
      "Partner must be a supplier for purchase operations",
    );
  }

  return partner;
}

async function getOwnedWarehousesMap(userId, warehouseIds, transaction) {
  const uniqueIds = [...new Set(warehouseIds.map(Number))];

  const warehouses = await models.Warehouse.findAll({
    where: {
      id: uniqueIds,
      user_id: userId,
    },
    transaction,
  });

  if (warehouses.length !== uniqueIds.length) {
    throw new AppError(404, "One or more warehouses not found or unauthorized");
  }

  return new Map(
    warehouses.map((warehouse) => [Number(warehouse.id), warehouse]),
  );
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

  if (!payload.purchase_date) {
    throw new AppError(400, "purchase_date is required");
  }
}

async function resolveStorageForPurchaseAllocation(
  itemData,
  allocation,
  warehousesMap,
  transaction,
) {
  const warehouseId = Number(allocation.warehouse_id);
  const warehouse = warehousesMap.get(warehouseId);

  if (!warehouse) {
    throw new AppError(
      404,
      `Warehouse ${warehouseId} not found or unauthorized`,
    );
  }

  if (allocation.storage_id) {
    const storage = await models.Storage.findOne({
      where: {
        id: Number(allocation.storage_id),
        warehouse_id: warehouseId,
      },
      transaction,
      lock: transaction.LOCK.UPDATE,
    });

    if (!storage) {
      throw new AppError(
        404,
        `Storage ${allocation.storage_id} not found in warehouse ${warehouseId}`,
      );
    }

    if (storage.name !== itemData.item_name_snapshot) {
      throw new AppError(
        400,
        `Storage ${storage.id} name does not match purchase item name`,
      );
    }

    if (String(storage.thickness) !== String(itemData.thickness_snapshot)) {
      throw new AppError(
        400,
        `Storage ${storage.id} thickness does not match purchase item thickness`,
      );
    }

    if (
      !sameDateOnly(storage.expiration_date, itemData.expiration_date_snapshot)
    ) {
      throw new AppError(
        400,
        `Storage ${storage.id} expiration date does not match purchase item expiration date`,
      );
    }

    return storage;
  }

  const existingStorage = await models.Storage.findOne({
    where: {
      warehouse_id: warehouseId,
      name: itemData.item_name_snapshot,
      thickness: itemData.thickness_snapshot,
      expiration_date: itemData.expiration_date_snapshot,
    },
    transaction,
    lock: transaction.LOCK.UPDATE,
  });

  if (existingStorage) {
    return existingStorage;
  }

  return models.Storage.create(
    {
      warehouse_id: warehouseId,
      name: itemData.item_name_snapshot,
      quantity: 0,
      minimum_quantity: itemData.minimum_quantity,
      thickness: itemData.thickness_snapshot,
      purchase_price: itemData.unit_cost,
      sale_price: itemData.sale_price_snapshot,
      expiration_date: itemData.expiration_date_snapshot,
    },
    { transaction },
  );
}

async function createPurchaseForUser(userId, payload) {
  validatePayload(payload);

  return models.sequelize.transaction(async (transaction) => {
    const partner = await findOwnedSupplierOrNull(
      userId,
      payload.partner_id,
      transaction,
    );

    const allWarehouseIds = payload.items.flatMap((item, itemIndex) => {
      if (!Array.isArray(item.allocations) || item.allocations.length === 0) {
        throw new AppError(
          400,
          `Each purchase item must contain at least one allocation. Problem at items[${itemIndex}]`,
        );
      }

      return item.allocations.map((allocation) => allocation.warehouse_id);
    });

    const warehousesMap = await getOwnedWarehousesMap(
      userId,
      allWarehouseIds,
      transaction,
    );

    const preparedItems = payload.items.map((item, itemIndex) => {
      const itemName = item.item_name || item.item_name_snapshot;
      const thickness = String(item.thickness || item.thickness_snapshot);
      const quantity = assertPositiveNumber(
        item.quantity,
        `items[${itemIndex}].quantity`,
      );
      const unitCost = assertPositiveNumber(
        item.unit_cost,
        `items[${itemIndex}].unit_cost`,
      );
      const salePrice = assertPositiveNumber(
        item.sale_price || item.sale_price_snapshot,
        `items[${itemIndex}].sale_price`,
      );

      if (!itemName) {
        throw new AppError(400, `items[${itemIndex}].item_name is required`);
      }

      if (!thickness) {
        throw new AppError(400, `items[${itemIndex}].thickness is required`);
      }

      const minimumQuantity =
        item.minimum_quantity !== undefined
          ? Number(item.minimum_quantity)
          : 10;

      const expirationDate = normalizeDateOnly(
        item.expiration_date || item.expiration_date_snapshot,
      );

      let allocatedTotal = 0;

      const preparedAllocations = item.allocations.map(
        (allocation, allocationIndex) => {
          if (!allocation.warehouse_id) {
            throw new AppError(
              400,
              `items[${itemIndex}].allocations[${allocationIndex}].warehouse_id is required`,
            );
          }

          const allocationQty = assertPositiveNumber(
            allocation.quantity,
            `items[${itemIndex}].allocations[${allocationIndex}].quantity`,
          );

          allocatedTotal += allocationQty;

          return {
            warehouse_id: Number(allocation.warehouse_id),
            storage_id: allocation.storage_id
              ? Number(allocation.storage_id)
              : null,
            quantity: allocationQty,
          };
        },
      );

      if (allocatedTotal !== quantity) {
        throw new AppError(
          400,
          `Allocated quantity must exactly match item quantity for item ${itemIndex + 1}`,
        );
      }

      return {
        item_name_snapshot: itemName,
        thickness_snapshot: thickness,
        quantity,
        unit_cost: unitCost,
        sale_price_snapshot: salePrice,
        expiration_date_snapshot: expirationDate,
        minimum_quantity: minimumQuantity,
        line_total: quantity * unitCost,
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
          check: buildOutgoingCheckState(
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
        `Total payments (${totalPaid}) cannot exceed purchase total (${totalAmount})`,
      );
    }

    const remainingAmount = totalAmount - totalPaid;
    const paymentStatus = calculatePaymentStatus(totalAmount, totalPaid);

    const purchase = await models.Purchase.create(
      {
        user_id: userId,
        partner_id: partner?.id || null,
        purchase_date: payload.purchase_date,
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
      const purchaseItem = await models.PurchaseItem.create(
        {
          purchase_id: purchase.id,
          item_name_snapshot: preparedItem.item_name_snapshot,
          thickness_snapshot: preparedItem.thickness_snapshot,
          quantity: preparedItem.quantity,
          unit_cost: preparedItem.unit_cost,
          sale_price_snapshot: preparedItem.sale_price_snapshot,
          expiration_date_snapshot: preparedItem.expiration_date_snapshot,
          line_total: preparedItem.line_total,
        },
        { transaction },
      );

      for (const allocation of preparedItem.allocations) {
        const storage = await resolveStorageForPurchaseAllocation(
          preparedItem,
          allocation,
          warehousesMap,
          transaction,
        );

        storage.quantity = Number(storage.quantity) + allocation.quantity;
        storage.purchase_price = preparedItem.unit_cost;
        storage.sale_price = preparedItem.sale_price_snapshot;
        storage.minimum_quantity = preparedItem.minimum_quantity;
        storage.expiration_date = preparedItem.expiration_date_snapshot;

        await storage.save({ transaction });

        await models.PurchaseItemAllocation.create(
          {
            purchase_item_id: purchaseItem.id,
            storage_id: storage.id,
            quantity: allocation.quantity,
          },
          { transaction },
        );
      }
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
          sale_id: null,
          purchase_id: purchase.id,
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
            type: "expense",
            category: "purchase",
            amount: paymentData.amount,
            description: `Cash payment for purchase #${purchase.id}`,
            transaction_date: paymentData.payment_date,
            reference_type: "purchase_payment",
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
            type: "expense",
            category: "check_out",
            amount: paymentData.amount,
            description: `outgoing check ${paymentData.check.check_number} - ${paymentData.check.bank_name}`,
            transaction_date: paymentData.check.cashing_date,
            reference_type: "check",
            reference_id: checkId,
            company_name: paymentData.check.company_name,
          },
          { transaction },
        );
      }
    }

    return models.Purchase.findByPk(purchase.id, {
      include: [
        {
          model: models.PurchaseItem,
          include: [
            {
              model: models.PurchaseItemAllocation,
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
async function findOwnedPurchaseOrThrow(userId, purchaseId, transaction) {
  const purchase = await models.Purchase.findOne({
    where: {
      id: purchaseId,
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

  if (!purchase) {
    throw new AppError(404, "Purchase not found");
  }

  return purchase;
}

function validateAddPurchasePaymentPayload(payload) {
  if (!payload.payment_method) {
    throw new AppError(400, "payment_method is required");
  }

  assertPositiveNumber(payload.amount, "amount");

  if (!payload.payment_date) {
    throw new AppError(400, "payment_date is required");
  }
}

async function addPaymentToPurchaseForUser(userId, purchaseId, payload) {
  validateAddPurchasePaymentPayload(payload);

  return models.sequelize.transaction(async (transaction) => {
    const purchase = await findOwnedPurchaseOrThrow(
      userId,
      purchaseId,
      transaction,
    );

    if (purchase.status === "cancelled") {
      throw new AppError(400, "Cannot add payment to a cancelled purchase");
    }

    const currentRemaining = toNumber(purchase.remaining_amount);

    if (currentRemaining <= 0) {
      throw new AppError(400, "This purchase is already fully paid");
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
      const checkData = buildOutgoingCheckState(
        payload.check,
        paymentAmount,
        purchase.Partner?.company_name || null,
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
        sale_id: null,
        purchase_id: purchase.id,
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
          type: "expense",
          category: "purchase",
          amount: paymentAmount,
          description: `Cash payment added to purchase #${purchase.id}`,
          transaction_date: payload.payment_date,
          reference_type: "purchase_payment",
          reference_id: payment.id,
          company_name: purchase.Partner?.company_name || null,
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
          type: "expense",
          category: "check_out",
          amount: paymentAmount,
          description: `outgoing check ${payload.check.check_number} - ${payload.check.bank_name}`,
          transaction_date: payload.check.cashing_date,
          reference_type: "check",
          reference_id: checkId,
          company_name: purchase.Partner?.company_name || null,
        },
        { transaction },
      );
    }

    const updatedPaidAmount = toNumber(purchase.paid_amount) + paymentAmount;
    const updatedRemainingAmount =
      toNumber(purchase.total_amount) - updatedPaidAmount;
    const updatedPaymentStatus = calculatePaymentStatus(
      purchase.total_amount,
      updatedPaidAmount,
    );

    purchase.paid_amount = updatedPaidAmount;
    purchase.remaining_amount = updatedRemainingAmount;
    purchase.payment_status = updatedPaymentStatus;

    await purchase.save({ transaction });

    return models.Purchase.findByPk(purchase.id, {
      include: [
        {
          model: models.PurchaseItem,
          include: [
            {
              model: models.PurchaseItemAllocation,
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
  createPurchaseForUser,
  addPaymentToPurchaseForUser,
};
