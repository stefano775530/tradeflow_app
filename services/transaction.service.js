const models = require("../models");
const { Op } = require("sequelize");
const { AppError } = require("../utils/app-error");

async function createTransactionForUser(userId, payload) {
  const {
    type,
    category,
    amount,
    description,
    transaction_date,
    reference_type,
    reference_id,
    company_name,
  } = payload;

  const transaction = await models.Transaction.create({
    user_id: userId,
    type,
    category,
    amount,
    description,
    transaction_date,
    reference_type,
    reference_id,
    company_name,
  });

  return transaction;
}

async function getTransactionsForUser(userId, query) {
  const {
    type,
    category,
    month,
    year,
    reference_type,
    page = 1,
    limit = 10,
    sortBy = "transaction_date",
    sortOrder = "DESC",
  } = query;

  const normalizedPage = Math.max(Number(page) || 1, 1);
  const normalizedLimit = Math.min(Math.max(Number(limit) || 10, 1), 100);
  const offset = (normalizedPage - 1) * normalizedLimit;

  const allowedSortFields = ["transaction_date", "amount", "createdAt", "id"];
  const finalSortBy = allowedSortFields.includes(sortBy)
    ? sortBy
    : "transaction_date";

  const finalSortOrder =
    String(sortOrder).toUpperCase() === "ASC" ? "ASC" : "DESC";

  const where = {
    user_id: userId,
  };

  if (type) {
    where.type = type;
  }

  if (category) {
    where.category = category;
  }

  if (reference_type) {
    where.reference_type = reference_type;
  }

  if (month && year) {
    const startDate = `${year}-${String(month).padStart(2, "0")}-01`;

    const nextMonth = Number(month) === 12 ? 1 : Number(month) + 1;
    const nextYear = Number(month) === 12 ? Number(year) + 1 : Number(year);
    const endDate = `${nextYear}-${String(nextMonth).padStart(2, "0")}-01`;

    where.transaction_date = {
      [Op.gte]: startDate,
      [Op.lt]: endDate,
    };
  }

  const { count, rows } = await models.Transaction.findAndCountAll({
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

async function findOwnedTransactionOrThrow(userId, transactionId) {
  const transaction = await models.Transaction.findOne({
    where: {
      id: transactionId,
      user_id: userId,
    },
  });

  if (!transaction) {
    throw new AppError(404, "Transaction not found");
  }

  return transaction;
}

async function updateTransactionForUser(userId, transactionId, payload) {
  const transaction = await findOwnedTransactionOrThrow(userId, transactionId);

  const {
    type,
    category,
    amount,
    description,
    transaction_date,
    reference_type,
    reference_id,
    company_name,
  } = payload;

  transaction.type = type !== undefined ? type : transaction.type;
  transaction.category =
    category !== undefined ? category : transaction.category;
  transaction.amount = amount !== undefined ? amount : transaction.amount;
  transaction.description =
    description !== undefined ? description : transaction.description;
  transaction.transaction_date =
    transaction_date !== undefined
      ? transaction_date
      : transaction.transaction_date;
  transaction.reference_type =
    reference_type !== undefined ? reference_type : transaction.reference_type;
  transaction.reference_id =
    reference_id !== undefined ? reference_id : transaction.reference_id;
  transaction.company_name =
    company_name !== undefined ? company_name : transaction.company_name;

  await transaction.save();

  return transaction;
}

async function deleteTransactionForUser(userId, transactionId) {
  const transaction = await findOwnedTransactionOrThrow(userId, transactionId);

  await transaction.destroy();
}

module.exports = {
  createTransactionForUser,
  getTransactionsForUser,
  findOwnedTransactionOrThrow,
  updateTransactionForUser,
  deleteTransactionForUser,
};
