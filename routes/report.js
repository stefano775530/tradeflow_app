const express = require("express");
const controller = require("../controllers/report.controller");
const { checkAuth } = require("../middleware/check-auth");

const router = express.Router();

/**
 * @openapi
 * /api/reports/monthly:
 *   get:
 *     tags:
 *       - Reports
 *     summary: Get monthly financial report for the authenticated user
 *     responses:
 *       200:
 *         description: Monthly report generated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/MonthlyReportResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/monthly", checkAuth, controller.getMonthlyReport);
/**
 * @openapi
 * /api/reports/dashboard:
 *   get:
 *     tags:
 *       - Reports
 *     summary: Get dashboard summary for the authenticated user
 *     responses:
 *       200:
 *         description: Dashboard summary generated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/DashboardSummaryResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/dashboard", checkAuth, controller.getDashboardSummary);
/**
 * @openapi
 * /api/reports/categories:
 *   get:
 *     tags:
 *       - Reports
 *     summary: Get report grouped by transaction categories
 *     responses:
 *       200:
 *         description: Category report generated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/CategoryReportItem'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/categories", checkAuth, controller.getCategoryReport);
/**
 * @openapi
 * /api/reports/yearly:
 *   get:
 *     tags:
 *       - Reports
 *     summary: Get yearly financial report for the authenticated user
 *     responses:
 *       200:
 *         description: Yearly report generated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/YearlyReportResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/yearly", checkAuth, controller.getYearlyReport);
/**
 * @openapi
 * /api/reports/storage-valuation:
 *   get:
 *     tags:
 *       - Reports
 *     summary: Get inventory valuation report for the authenticated user
 *     responses:
 *       200:
 *         description: Inventory valuation generated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/InventoryValuationResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/storage-valuation", checkAuth, controller.getInventoryValuation);
/**
 * @openapi
 * /api/reports/zakat:
 *   get:
 *     tags:
 *       - Reports
 *     summary: Get zakat report for the authenticated user
 *     responses:
 *       200:
 *         description: Zakat report generated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ZakatReportResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/zakat", checkAuth, controller.getZakatReport);

module.exports = router;
