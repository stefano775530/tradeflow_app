const models = require("../models");

async function createStorageInWarehouse(req, res) {
  try {
    const { warehouseId } = req.params;
    const {
      name,
      quantity,
      expiration_date,
      minimum_quantity,
      purchase_price,
      sale_price,
      thickness, // ✅ إضافة
    } = req.body;

    const warehouse = await models.Warehouse.findOne({
      where: { id: warehouseId, user_id: req.userData.userId },
    });

    if (!warehouse) {
      return res
        .status(404)
        .json({ message: "Warehouse not found or unauthorized" });
    }

    const storage = await models.Storage.create({
      warehouse_id: warehouseId,
      name,
      quantity,
      expiration_date,
      minimum_quantity: minimum_quantity !== undefined ? minimum_quantity : 10,
      purchase_price,
      sale_price,
      thickness, // ✅ إضافة
    });

    res.status(201).json({ message: "Storage item created", storage });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function getStorageByWarehouse(req, res) {
  try {
    const { warehouseId } = req.params;

    const warehouse = await models.Warehouse.findOne({
      where: { id: warehouseId, user_id: req.userData.userId },
    });

    if (!warehouse) {
      return res
        .status(404)
        .json({ message: "Warehouse not found or unauthorized" });
    }

    const storage = await models.Storage.findAll({
      where: { warehouse_id: warehouseId },
    });

    res.status(200).json(storage);
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function getStorage(req, res) {
  try {
    const { warehouseId, id } = req.params;

    const storage = await models.Storage.findOne({
      where: { id, warehouse_id: warehouseId },
      include: [
        {
          model: models.Warehouse,
          where: { user_id: req.userData.userId },
          attributes: ["id", "name"],
        },
      ],
    });

    if (!storage) {
      return res
        .status(404)
        .json({ message: "Storage item not found or unauthorized" });
    }

    res.status(200).json(storage);
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function updateStorage(req, res) {
  try {
    const { warehouseId, id } = req.params;
    const {
      name,
      quantity,
      expiration_date,
      minimum_quantity,
      purchase_price,
      sale_price,
      thickness, // ✅ إضافة
    } = req.body;

    const storage = await models.Storage.findOne({
      where: { id, warehouse_id: warehouseId },
      include: [
        {
          model: models.Warehouse,
          where: { user_id: req.userData.userId },
        },
      ],
    });

    if (!storage) {
      return res
        .status(404)
        .json({ message: "Storage item not found or unauthorized" });
    }

    storage.name = name !== undefined ? name : storage.name;
    storage.quantity = quantity !== undefined ? quantity : storage.quantity;
    storage.expiration_date =
      expiration_date !== undefined ? expiration_date : storage.expiration_date;
    storage.minimum_quantity =
      minimum_quantity !== undefined
        ? minimum_quantity
        : storage.minimum_quantity;

    storage.purchase_price =
      purchase_price !== undefined ? purchase_price : storage.purchase_price;
    storage.sale_price =
      sale_price !== undefined ? sale_price : storage.sale_price;

    storage.thickness = thickness !== undefined ? thickness : storage.thickness; // ✅ إضافة

    await storage.save();

    res.status(200).json({ message: "Storage item updated", storage });
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function deleteStorage(req, res) {
  try {
    const { warehouseId, id } = req.params;

    const storage = await models.Storage.findOne({
      where: { id, warehouse_id: warehouseId },
      include: [
        {
          model: models.Warehouse,
          where: { user_id: req.userData.userId },
        },
      ],
    });

    if (!storage) {
      return res
        .status(404)
        .json({ message: "Storage item not found or unauthorized" });
    }

    await storage.destroy();

    res.status(200).json({ message: "Storage item deleted" });
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

module.exports = {
  createStorageInWarehouse,
  getStorageByWarehouse,
  getStorage,
  updateStorage,
  deleteStorage,
};
