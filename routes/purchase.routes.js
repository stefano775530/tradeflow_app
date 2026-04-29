const express = require("express");
const controller = require("../controllers/purchase.controller");
const { checkAuth } = require("../middleware/check-auth");

const router = express.Router();
/**
 * @openapi
 * /api/purchases:
 *   post:
 *     tags:
 *       - Purchases
 *     summary: Create a new purchase with items, allocations, and payments
 *     description: Creates a purchase, distributes stock into warehouses and storages, creates payments, and generates cash/check financial records.
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/PurchaseCreateRequest'
 *           examples:
 *             unpaidPurchase:
 *               summary: Create unpaid purchase
 *               value:
 *                 partner_id: 1
 *                 purchase_date: "2026-04-12"
 *                 invoice_number: "PUR-1001"
 *                 notes: "unpaid purchase"
 *                 items:
 *                   - item_name: wood
 *                     thickness: "6"
 *                     quantity: 100
 *                     unit_cost: 300
 *                     sale_price: 500
 *                     expiration_date: null
 *                     minimum_quantity: 10
 *                     allocations:
 *                       - warehouse_id: 1
 *                         quantity: 100
 *             partialPurchase:
 *               summary: Create partially paid purchase
 *               value:
 *                 partner_id: 1
 *                 purchase_date: "2026-04-12"
 *                 invoice_number: "PUR-1002"
 *                 notes: "purchase with debt"
 *                 items:
 *                   - item_name: wood
 *                     thickness: "6"
 *                     quantity: 500
 *                     unit_cost: 300
 *                     sale_price: 500
 *                     expiration_date: null
 *                     minimum_quantity: 10
 *                     allocations:
 *                       - warehouse_id: 1
 *                         quantity: 200
 *                       - warehouse_id: 2
 *                         quantity: 300
 *                 payments:
 *                   - payment_method: cash
 *                     amount: 50000
 *                     payment_date: "2026-04-12"
 *                   - payment_method: check
 *                     amount: 30000
 *                     payment_date: "2026-04-12"
 *                     check:
 *                       bank_name: ABC Bank
 *                       check_number: OUT-5001
 *                       issue_date: "2026-04-12"
 *                       status: pending
 *             paidPurchase:
 *               summary: Create fully paid purchase
 *               value:
 *                 partner_id: 1
 *                 purchase_date: "2026-04-12"
 *                 invoice_number: "PUR-1003"
 *                 notes: "fully paid purchase"
 *                 items:
 *                   - item_name: wood
 *                     thickness: "6"
 *                     quantity: 100
 *                     unit_cost: 300
 *                     sale_price: 500
 *                     expiration_date: null
 *                     minimum_quantity: 10
 *                     allocations:
 *                       - warehouse_id: 1
 *                         quantity: 100
 *                 payments:
 *                   - payment_method: cash
 *                     amount: 30000
 *                     payment_date: "2026-04-12"
 *     responses:
 *       201:
 *         description: Purchase created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/PurchaseCreateResponse'
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
 *         description: Partner or warehouse not found or unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post("/", checkAuth, controller.createPurchase);

/**
 * @openapi
 * /api/purchases/{id}/payments:
 *   post:
 *     tags:
 *       - Purchases
 *     summary: Add a new payment to an existing purchase
 *     description: Adds a cash or check payment to a partially paid purchase and updates paid_amount, remaining_amount, and payment_status.
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Purchase ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/PurchaseAddPaymentRequest'
 *           examples:
 *             cashPayment:
 *               summary: Add cash payment
 *               value:
 *                 payment_method: cash
 *                 amount: 20000
 *                 payment_date: "2026-04-13"
 *                 notes: second purchase payment
 *             checkPayment:
 *               summary: Add check payment
 *               value:
 *                 payment_method: check
 *                 amount: 15000
 *                 payment_date: "2026-04-14"
 *                 notes: third purchase payment by check
 *                 check:
 *                   bank_name: ABC Bank
 *                   check_number: OUT-7001
 *                   issue_date: "2026-04-14"
 *                   status: pending
 *     responses:
 *       201:
 *         description: Payment added successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/PurchaseAddPaymentResponse'
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
 *         description: Purchase not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post("/:id/payments", checkAuth, controller.addPurchasePayment);

module.exports = router;
