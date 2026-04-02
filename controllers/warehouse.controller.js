const models = require("../models");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
require("dotenv").config();

async function createWarehouse(req, res) {
  try {
    const { name, location } = req.body;

    const warehouse = await models.Warehouse.create({
      name,
      location,
      user_id: req.userData.userId,
    });

    res.status(201).json({
      message: "Warehouse created",
      warehouse,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function getWarehouses(req, res) {
  try {
    const warehouses = await models.Warehouse.findAll({
      where: { user_id: req.userData.userId },
    });

    res.status(200).json(warehouses);
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function getWarehouse(req, res) {
  try {
    const { id } = req.params;

    const warehouse = await models.Warehouse.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!warehouse) {
      return res.status(404).json({ message: "Warehouse not found" });
    }

    res.status(200).json(warehouse);
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function updateWarehouse(req, res) {
  try {
    const { id } = req.params;
    const { name, location } = req.body;

    const warehouse = await models.Warehouse.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!warehouse) {
      return res.status(404).json({ message: "Warehouse not found" });
    }

    warehouse.name = name || warehouse.name;
    warehouse.location = location || warehouse.location;

    await warehouse.save();

    res.status(200).json({ message: "Updated", warehouse });
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function deleteWarehouse(req, res) {
  try {
    const { id } = req.params;

    const warehouse = await models.Warehouse.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!warehouse) {
      return res.status(404).json({ message: "Warehouse not found" });
    }

    await warehouse.destroy();

    res.status(200).json({ message: "Warehouse deleted" });
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

module.exports = {
  createWarehouse: createWarehouse,
  getWarehouses: getWarehouses,
  getWarehouse: getWarehouse,
  updateWarehouse: updateWarehouse,
  deleteWarehouse: deleteWarehouse,
};
