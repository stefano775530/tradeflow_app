const express = require("express");
const controller = require("../controllers/sale.controller");
const { checkAuth } = require("../middleware/check-auth");

const router = express.Router();
/**
 * @openapi
 * /api/sales:
 *   post:
 *     tags:
 *       - Sales
 *     summary: Create a new sale with items, allocations, and payments
 *     description: Creates a sale, deducts stock from allocated storages, creates payments, and generates cash/check financial records.
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/SaleCreateRequest'
 *           examples:
 *             unpaidSale:
 *               summary: Create unpaid sale
 *               value:
 *                 partner_id: 1
 *                 sale_date: "2026-04-12"
 *                 invoice_number: "INV-1001"
 *                 notes: "unpaid sale"
 *                 items:
 *                   - quantity: 100
 *                     unit_price: 500
 *                     allocations:
 *                       - storage_id: 11
 *                         quantity: 100
 *             partialSale:
 *               summary: Create partially paid sale
 *               value:
 *                 partner_id: 1
 *                 sale_date: "2026-04-12"
 *                 invoice_number: "INV-1002"
 *                 notes: "sale with debt"
 *                 items:
 *                   - quantity: 200
 *                     unit_price: 500
 *                     allocations:
 *                       - storage_id: 11
 *                         quantity: 100
 *                       - storage_id: 27
 *                         quantity: 100
 *                 payments:
 *                   - payment_method: cash
 *                     amount: 20000
 *                     payment_date: "2026-04-12"
 *                   - payment_method: check
 *                     amount: 30000
 *                     payment_date: "2026-04-12"
 *                     check:
 *                       bank_name: ABC Bank
 *                       check_number: CHK-5001
 *                       issue_date: "2026-04-12"
 *                       status: pending
 *             paidSale:
 *               summary: Create fully paid sale
 *               value:
 *                 partner_id: 1
 *                 sale_date: "2026-04-12"
 *                 invoice_number: "INV-1003"
 *                 notes: "fully paid sale"
 *                 items:
 *                   - quantity: 100
 *                     unit_price: 500
 *                     allocations:
 *                       - storage_id: 11
 *                         quantity: 100
 *                 payments:
 *                   - payment_method: cash
 *                     amount: 50000
 *                     payment_date: "2026-04-12"
 *     responses:
 *       201:
 *         description: Sale created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/SaleCreateResponse'
 *       400:
 *         description: Invalid payload or business rule violation
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 *       404:
 *         description: Partner or storage not found or unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post("/", checkAuth, controller.createSale);

/**
 * @openapi
 * /api/sales/{id}/payments:
 *   post:
 *     tags:
 *       - Sales
 *     summary: Add a new payment to an existing sale
 *     description: Adds a cash or check payment to a partially paid sale and updates paid_amount, remaining_amount, and payment_status.
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Sale ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/SaleAddPaymentRequest'
 *           examples:
 *             cashPayment:
 *               summary: Add cash payment
 *               value:
 *                 payment_method: cash
 *                 amount: 20000
 *                 payment_date: "2026-04-13"
 *                 notes: second payment
 *             checkPayment:
 *               summary: Add check payment
 *               value:
 *                 payment_method: check
 *                 amount: 15000
 *                 payment_date: "2026-04-14"
 *                 notes: third payment by check
 *                 check:
 *                   bank_name: ABC Bank
 *                   check_number: CHK-7001
 *                   issue_date: "2026-04-14"
 *                   status: pending
 *     responses:
 *       201:
 *         description: Payment added successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/SaleAddPaymentResponse'
 *       400:
 *         description: Invalid payload or payment exceeds remaining amount
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 *       404:
 *         description: Sale not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post("/:id/payments", checkAuth, controller.addSalePayment);

module.exports = router;
