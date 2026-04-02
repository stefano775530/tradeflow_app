const express = require("express");
const controller = require("../controllers/warehouse.controller");
const { checkAuth } = require("../middleware/check-auth");
const {
  createWarehouseValidation,
  updateWarehouseValidation,
  warehouseIdValidation,
} = require("../middleware/validators");
const storageRouter = require("./storage");

const router = express.Router();

router.post(
  "/",
  checkAuth,
  createWarehouseValidation,
  controller.createWarehouse,
);
router.get("/", checkAuth, controller.getWarehouses);
router.get("/:id", checkAuth, warehouseIdValidation, controller.getWarehouse);
router.patch(
  "/:id",
  checkAuth,
  warehouseIdValidation,
  updateWarehouseValidation,
  controller.updateWarehouse,
);
router.delete(
  "/:id",
  checkAuth,
  warehouseIdValidation,
  controller.deleteWarehouse,
);

router.use("/:warehouseId/storage", storageRouter);

module.exports = router;
