const storageService = require("../services/storage.service");

async function createStorageInWarehouse(req, res) {
  const storage = await storageService.createStorageInWarehouseForUser(
    req.userData.userId,
    req.params.warehouseId,
    req.body,
  );

  res.status(201).json({
    message: "Storage item created",
    storage,
  });
}

async function getStorageByWarehouse(req, res) {
  const result = await storageService.getStorageByWarehouseForUser(
    req.userData.userId,
    req.params.warehouseId,
    req.query,
  );

  res.status(200).json(result);
}

async function getStorage(req, res) {
  const storage = await storageService.findOwnedStorageOrThrow(
    req.userData.userId,
    req.params.warehouseId,
    req.params.id,
  );

  res.status(200).json(storage);
}

async function updateStorage(req, res) {
  const storage = await storageService.updateStorageForUser(
    req.userData.userId,
    req.params.warehouseId,
    req.params.id,
    req.body,
  );

  res.status(200).json({
    message: "Storage item updated",
    storage,
  });
}

async function deleteStorage(req, res) {
  await storageService.deleteStorageForUser(
    req.userData.userId,
    req.params.warehouseId,
    req.params.id,
  );

  res.status(200).json({ message: "Storage item deleted" });
}

module.exports = {
  createStorageInWarehouse,
  getStorageByWarehouse,
  getStorage,
  updateStorage,
  deleteStorage,
};
