const express = require("express");
const controller = require("../controllers/storage.controller");
const { checkAuth } = require("../middleware/check-auth");
const { storageValidation } = require("../middleware/validators");

const router = express.Router({ mergeParams: true });

router.post(
  "/",
  checkAuth,
  storageValidation,
  controller.createStorageInWarehouse,
);
router.get("/", checkAuth, controller.getStorageByWarehouse);
router.get("/:id", checkAuth, controller.getStorage);
router.patch("/:id", checkAuth, storageValidation, controller.updateStorage);
router.delete("/:id", checkAuth, controller.deleteStorage);

module.exports = router;
