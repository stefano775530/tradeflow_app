const express = require("express");
const controller = require("../controllers/alert.controller");
const { checkAuth } = require("../middleware/check-auth");

const router = express.Router();

/**
 * @openapi
 * /api/alerts/low-stock:
 *   get:
 *     tags:
 *       - Alerts
 *     summary: Get low stock alerts for the authenticated user
 *     responses:
 *       200:
 *         description: Low stock alerts fetched successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Alert'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/low-stock", checkAuth, controller.getLowStockAlerts);

module.exports = router;
