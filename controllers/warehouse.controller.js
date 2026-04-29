const warehouseService = require("../services/warehouse.service");

async function createWarehouse(req, res) {
  const warehouse = await warehouseService.createWarehouseForUser(
    req.userData.userId,
    req.body,
  );

  res.status(201).json({
    message: "Warehouse created",
    warehouse,
  });
}

async function getWarehouses(req, res) {
  const result = await warehouseService.getWarehousesForUser(
    req.userData.userId,
    req.query,
  );

  res.status(200).json(result);
}

async function getWarehouse(req, res) {
  const warehouse = await warehouseService.findOwnedWarehouseOrThrow(
    req.userData.userId,
    req.params.id,
  );

  res.status(200).json(warehouse);
}

async function updateWarehouse(req, res) {
  const warehouse = await warehouseService.updateWarehouseForUser(
    req.userData.userId,
    req.params.id,
    req.body,
  );

  res.status(200).json({
    message: "Updated",
    warehouse,
  });
}

async function deleteWarehouse(req, res) {
  await warehouseService.deleteWarehouseForUser(
    req.userData.userId,
    req.params.id,
  );

  res.status(200).json({ message: "Warehouse deleted" });
}

module.exports = {
  createWarehouse,
  getWarehouses,
  getWarehouse,
  updateWarehouse,
  deleteWarehouse,
};
