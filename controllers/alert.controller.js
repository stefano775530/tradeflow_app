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

async function getExpiringItemsAlerts(req, res) {
  try {
    const days = req.query.days ? Number(req.query.days) : 7;

    const today = new Date();
    const endDate = new Date();
    endDate.setDate(today.getDate() + days);

    const todayString = today.toISOString().split("T")[0];
    const endDateString = endDate.toISOString().split("T")[0];

    const expiringItems = await models.Storage.findAll({
      where: {
        expiration_date: {
          [Op.between]: [todayString, endDateString],
        },
      },
      include: [
        {
          model: models.Warehouse,
          where: {
            user_id: req.userData.userId,
          },
          attributes: ["id", "name", "location"],
        },
      ],
      order: [["expiration_date", "ASC"]],
    });

    res.status(200).json({
      days,
      count: expiringItems.length,
      items: expiringItems,
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
  getExpiringItemsAlerts: getExpiringItemsAlerts,
};
