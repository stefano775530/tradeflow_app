// routes/partner.routes.js
const express = require("express");
const router = express.Router();
const partnerController = require("../controllers/partner.controller");
const { checkAuth } = require("../middleware/check-auth");
const {
  partnerIdValidation,
  createPartnerValidation,
  updatePartnerValidation,
} = require("../middleware/validators");

// مسار الإضافة
router.post(
  "/add",
  checkAuth,
  createPartnerValidation,
  partnerController.createPartner,
);

// مسار العرض
router.get("/all", checkAuth, partnerController.getPartners);

module.exports = router;
