const express = require("express");
const checkController = require("../controllers/check.controller");
const { checkAuth } = require("../middleware/check-auth");
const {
  createCheckValidation,
  updateCheckValidation,
} = require("../middleware/validators");

const router = express.Router();

/**
 * @openapi
 * /api/checks:
 *   post:
 *     tags:
 *       - Checks
 *     summary: Create a new check
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CheckCreateRequest'
 *     responses:
 *       201:
 *         description: Check created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/CheckResponse'
 *       400:
 *         description: Validation error or invalid business rule
 *         content:
 *           application/json:
 *             schema:
 *               oneOf:
 *                 - $ref: '#/components/schemas/ValidationErrorResponse'
 *                 - $ref: '#/components/schemas/ErrorResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */

router.post("/", checkAuth, createCheckValidation, checkController.createCheck);

/**
 * @openapi
 * /api/checks:
 *   get:
 *     tags:
 *       - Checks
 *     summary: Get all checks for the authenticated user
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: status
 *         required: false
 *         schema:
 *           type: string
 *           enum: [pending, cashed, bounced]
 *         description: Filter checks by status
 *       - in: query
 *         name: type
 *         required: false
 *         schema:
 *           type: string
 *           enum: [incoming, outgoing]
 *         description: Filter checks by type
 *       - in: query
 *         name: page
 *         required: false
 *         schema:
 *           type: integer
 *           example: 1
 *       - in: query
 *         name: limit
 *         required: false
 *         schema:
 *           type: integer
 *           example: 10
 *       - in: query
 *         name: sortBy
 *         required: false
 *         schema:
 *           type: string
 *           enum: [issue_date, cashing_date, amount, created_at, id]
 *           example: issue_date
 *       - in: query
 *         name: sortOrder
 *         required: false
 *         schema:
 *           type: string
 *           enum: [ASC, DESC]
 *           example: DESC
 *     responses:
 *       200:
 *         description: Paginated list of checks
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/CheckListResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */

router.get("/", checkAuth, checkController.getChecks);
/**
 * @openapi
 * /api/checks/{id}:
 *   get:
 *     tags:
 *       - Checks
 *     summary: Get one check by ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Check ID
 *     responses:
 *       200:
 *         description: Check found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Check'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 *       404:
 *         description: Check not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get("/:id", checkAuth, checkController.getCheck);

/**
 * @openapi
 * /api/checks/{id}:
 *   patch:
 *     tags:
 *       - Checks
 *     summary: Update an existing check
 *     description: Updates a check and synchronizes related transaction and debt fields for linked sales or purchases.
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Check ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CheckUpdateRequest'
 *           examples:
 *             markCashed:
 *               summary: Mark check as cashed
 *               value:
 *                 status: cashed
 *                 cashing_date: "2026-04-15"
 *             markBounced:
 *               summary: Mark check as bounced
 *               value:
 *                 status: bounced
 *             revertToPending:
 *               summary: Revert check to pending
 *               value:
 *                 status: pending
 *                 cashing_date: null
 *             updateAmount:
 *               summary: Update check amount
 *               value:
 *                 amount: 15000
 *     responses:
 *       200:
 *         description: Check updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/CheckResponse'
 *       400:
 *         description: Invalid payload or invalid status transition data
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
 *         description: Check not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.patch(
  "/:id",
  checkAuth,
  updateCheckValidation,
  checkController.updateCheck,
);

/**
 * @openapi
 * /api/checks/{id}:
 *   delete:
 *     tags:
 *       - Checks
 *     summary: Delete a check by ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Check ID
 *     responses:
 *       200:
 *         description: Check deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Check deleted
 *       400:
 *         description: Cannot delete a check that is linked to a payment
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
 *         description: Check not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.delete("/:id", checkAuth, checkController.deleteCheck);

module.exports = router;
