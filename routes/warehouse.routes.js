const express = require("express");
const controller = require("../controllers/warehouse.controller");
const { checkAuth } = require("../middleware/check-auth");
const {
  createWarehouseValidation,
  updateWarehouseValidation,
  warehouseIdValidation,
} = require("../middleware/validators");
const storageRouter = require("./storage.routes");

const router = express.Router();

/**
 * @openapi
 * /api/warehouse:
 *   post:
 *     tags:
 *       - Warehouses
 *     summary: Create a new warehouse
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/WarehouseCreateRequest'
 *     responses:
 *       201:
 *         description: Warehouse created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/WarehouseCreateResponse'
 *       400:
 *         description: Validation error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ValidationErrorResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.post(
  "/",
  checkAuth,
  createWarehouseValidation,
  controller.createWarehouse,
);

/**
 * @openapi
 * /api/warehouse:
 *   get:
 *     tags:
 *       - Warehouses
 *     summary: Get all warehouses for the authenticated user
 *     security:
 *       - bearerAuth: []
 *     parameters:
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
 *           example: created_at
 *       - in: query
 *         name: sortOrder
 *         required: false
 *         schema:
 *           type: string
 *           enum: [ASC, DESC]
 *           example: DESC
 *     responses:
 *       200:
 *         description: Paginated list of warehouses
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/WarehouseListResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 */
router.get("/", checkAuth, controller.getWarehouses);

/**
 * @openapi
 * /api/warehouse/{id}:
 *   get:
 *     tags:
 *       - Warehouses
 *     summary: Get one warehouse by ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
 *     responses:
 *       200:
 *         description: Warehouse found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Warehouse'
 *       400:
 *         description: Invalid warehouse ID
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
 *       404:
 *         description: Warehouse not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get("/:id", checkAuth, warehouseIdValidation, controller.getWarehouse);

/**
 * @openapi
 * /api/warehouse/{id}:
 *   patch:
 *     tags:
 *       - Warehouses
 *     summary: Update a warehouse by ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/WarehouseUpdateRequest'
 *     responses:
 *       200:
 *         description: Warehouse updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/WarehouseUpdateResponse'
 *       400:
 *         description: Validation error or invalid warehouse ID
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
 *       404:
 *         description: Warehouse not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.patch(
  "/:id",
  checkAuth,
  warehouseIdValidation,
  updateWarehouseValidation,
  controller.updateWarehouse,
);

/**
 * @openapi
 * /api/warehouse/{id}:
 *   delete:
 *     tags:
 *       - Warehouses
 *     summary: Delete a warehouse by ID
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
 *     responses:
 *       200:
 *         description: Warehouse deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Warehouse deleted successfully
 *       400:
 *         description: Invalid warehouse ID
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
 *       404:
 *         description: Warehouse not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.delete(
  "/:id",
  checkAuth,
  warehouseIdValidation,
  controller.deleteWarehouse,
);

router.use("/:warehouseId/storage", storageRouter);

module.exports = router;
