const models = require("../models");
const { AppError } = require("../utils/app-error");

async function createWarehouseForUser(userId, payload) {
  const { name, location } = payload;

  const warehouse = await models.Warehouse.create({
    name,
    location,
    user_id: userId,
  });

  return warehouse;
}

async function getWarehousesForUser(userId, query = {}) {
  const { page = 1, limit = 10, sortBy = "id", sortOrder = "DESC" } = query;

  const normalizedPage = Math.max(Number(page) || 1, 1);
  const normalizedLimit = Math.min(Math.max(Number(limit) || 10, 1), 100);
  const offset = (normalizedPage - 1) * normalizedLimit;

  const allowedSortFields = ["id", "name", "location", "created_at"];
  const finalSortBy = allowedSortFields.includes(sortBy) ? sortBy : "id";
  const finalSortOrder =
    String(sortOrder).toUpperCase() === "ASC" ? "ASC" : "DESC";

  const { count, rows } = await models.Warehouse.findAndCountAll({
    where: { user_id: userId },
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

async function findOwnedWarehouseOrThrow(userId, warehouseId) {
  const warehouse = await models.Warehouse.findOne({
    where: {
      id: warehouseId,
      user_id: userId,
    },
  });

  if (!warehouse) {
    throw new AppError(404, "Warehouse not found");
  }

  return warehouse;
}

async function updateWarehouseForUser(userId, warehouseId, payload) {
  const warehouse = await findOwnedWarehouseOrThrow(userId, warehouseId);

  const { name, location } = payload;

  warehouse.name = name !== undefined ? name : warehouse.name;
  warehouse.location = location !== undefined ? location : warehouse.location;

  await warehouse.save();

  return warehouse;
}

async function deleteWarehouseForUser(userId, warehouseId) {
  const warehouse = await findOwnedWarehouseOrThrow(userId, warehouseId);

  await warehouse.destroy();
}

module.exports = {
  createWarehouseForUser,
  getWarehousesForUser,
  findOwnedWarehouseOrThrow,
  updateWarehouseForUser,
  deleteWarehouseForUser,
};
