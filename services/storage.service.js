const models = require("../models");
const { AppError } = require("../utils/app-error");
const warehouseService = require("./warehouse.service");

async function createStorageInWarehouseForUser(userId, warehouseId, payload) {
  await warehouseService.findOwnedWarehouseOrThrow(userId, warehouseId);

  const {
    name,
    quantity,
    expiration_date,
    minimum_quantity,
    purchase_price,
    sale_price,
    thickness,
  } = payload;

  const storage = await models.Storage.create({
    warehouse_id: warehouseId,
    name,
    quantity,
    expiration_date,
    minimum_quantity: minimum_quantity !== undefined ? minimum_quantity : 10,
    purchase_price,
    sale_price,
    thickness,
  });

  return storage;
}

async function getStorageByWarehouseForUser(userId, warehouseId, query = {}) {
  await warehouseService.findOwnedWarehouseOrThrow(userId, warehouseId);

  const {
    page = 1,
    limit = 10,
    sortBy = "created_at",
    sortOrder = "DESC",
  } = query;

  const normalizedPage = Math.max(Number(page) || 1, 1);
  const normalizedLimit = Math.min(Math.max(Number(limit) || 10, 1), 100);
  const offset = (normalizedPage - 1) * normalizedLimit;

  const allowedSortFields = [
    "name",
    "quantity",
    "minimum_quantity",
    "purchase_price",
    "sale_price",
    "expiration_date",
    "created_at",
    "id",
  ];

  const finalSortBy = allowedSortFields.includes(sortBy)
    ? sortBy
    : "created_at";

  const finalSortOrder =
    String(sortOrder).toUpperCase() === "ASC" ? "ASC" : "DESC";

  const { count, rows } = await models.Storage.findAndCountAll({
    where: { warehouse_id: warehouseId },
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

async function findOwnedStorageOrThrow(userId, warehouseId, storageId) {
  const storage = await models.Storage.findOne({
    where: {
      id: storageId,
      warehouse_id: warehouseId,
    },
    include: [
      {
        model: models.Warehouse,
        where: { user_id: userId },
        attributes: ["id", "name"],
      },
    ],
  });

  if (!storage) {
    throw new AppError(404, "Storage item not found or unauthorized");
  }

  return storage;
}

async function updateStorageForUser(userId, warehouseId, storageId, payload) {
  const storage = await findOwnedStorageOrThrow(userId, warehouseId, storageId);

  const {
    name,
    quantity,
    expiration_date,
    minimum_quantity,
    purchase_price,
    sale_price,
    thickness,
  } = payload;

  storage.name = name !== undefined ? name : storage.name;
  storage.quantity = quantity !== undefined ? quantity : storage.quantity;
  storage.expiration_date =
    expiration_date !== undefined ? expiration_date : storage.expiration_date;
  storage.minimum_quantity =
    minimum_quantity !== undefined
      ? minimum_quantity
      : storage.minimum_quantity;
  storage.purchase_price =
    purchase_price !== undefined ? purchase_price : storage.purchase_price;
  storage.sale_price =
    sale_price !== undefined ? sale_price : storage.sale_price;
  storage.thickness = thickness !== undefined ? thickness : storage.thickness;

  await storage.save();

  return storage;
}

async function deleteStorageForUser(userId, warehouseId, storageId) {
  const storage = await findOwnedStorageOrThrow(userId, warehouseId, storageId);

  await storage.destroy();
}

module.exports = {
  createStorageInWarehouseForUser,
  getStorageByWarehouseForUser,
  findOwnedStorageOrThrow,
  updateStorageForUser,
  deleteStorageForUser,
};
