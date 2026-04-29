const express = require("express");
const controller = require("../controllers/storage.controller");
const { checkAuth } = require("../middleware/check-auth");
const {
  createStorageValidation,
  updateStorageValidation,
} = require("../middleware/validators");

const router = express.Router({ mergeParams: true });

/**
 * @openapi
 * /api/warehouse/{warehouseId}/storage:
 *   post:
 *     tags:
 *       - Storage
 *     summary: Create a storage item inside a warehouse
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: warehouseId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/StorageCreateRequest'
 *     responses:
 *       201:
 *         description: Storage created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/StorageCreateResponse'
 *       400:
 *         description: Validation error
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
 *         description: Warehouse not found or unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.post(
  "/",
  checkAuth,
  createStorageValidation,
  controller.createStorageInWarehouse,
);

/**
 * @openapi
 * /api/warehouse/{warehouseId}/storage:
 *   get:
 *     tags:
 *       - Storage
 *     summary: Get all storage items for a warehouse
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: warehouseId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
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
 *         description: Paginated list of storage items in the warehouse
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/StorageListResponse'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 *       404:
 *         description: Warehouse not found or unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get("/", checkAuth, controller.getStorageByWarehouse);

/**
 * @openapi
 * /api/warehouse/{warehouseId}/storage/{id}:
 *   get:
 *     tags:
 *       - Storage
 *     summary: Get one storage item by ID inside a warehouse
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: warehouseId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Storage ID
 *     responses:
 *       200:
 *         description: Storage item found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Storage'
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 *       404:
 *         description: Storage not found or unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.get("/:id", checkAuth, controller.getStorage);

/**
 * @openapi
 * /api/warehouse/{warehouseId}/storage/{id}:
 *   patch:
 *     tags:
 *       - Storage
 *     summary: Update a storage item by ID inside a warehouse
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: warehouseId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Storage ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/StorageUpdateRequest'
 *     responses:
 *       200:
 *         description: Storage updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/StorageUpdateResponse'
 *       400:
 *         description: Validation error
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
 *         description: Storage not found or unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.patch(
  "/:id",
  checkAuth,
  updateStorageValidation,
  controller.updateStorage,
);

/**
 * @openapi
 * /api/warehouse/{warehouseId}/storage/{id}:
 *   delete:
 *     tags:
 *       - Storage
 *     summary: Delete a storage item by ID inside a warehouse
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: warehouseId
 *         required: true
 *         schema:
 *           type: integer
 *         description: Warehouse ID
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Storage ID
 *     responses:
 *       200:
 *         description: Storage deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: Storage deleted successfully
 *       401:
 *         description: Unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/UnauthorizedResponse'
 *       404:
 *         description: Storage not found or unauthorized
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
router.delete("/:id", checkAuth, controller.deleteStorage);

module.exports = router;
