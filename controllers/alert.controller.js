const models = require("../models");
const { Op, literal } = require("sequelize");

async function getLowStockAlerts(req, res) {
  try {
    const lowStockItems = await models.Storage.findAll({
      where: literal("quantity <= minimum_quantity"),
      include: [
        {
          model: models.Warehouse,
          where: {
            user_id: req.userData.userId,
          },
          attributes: ["id", "name", "location"],
        },
      ],
      order: [["quantity", "ASC"]],
    });

    res.status(200).json({
      count: lowStockItems.length,
      items: lowStockItems,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Something went wrong",
    });
  }
}

module.exports = {
  getLowStockAlerts: getLowStockAlerts,
};
