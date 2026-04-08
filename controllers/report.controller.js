const models = require("../models");
const { Op, fn, col } = require("sequelize");

async function getMonthlyReport(req, res) {
  try {
    const { month, year } = req.query;

    if (!month || !year) {
      return res.status(400).json({
        message: "Month and year are required",
      });
    }

    const startDate = `${year}-${String(month).padStart(2, "0")}-01`;

    const nextMonth = Number(month) === 12 ? 1 : Number(month) + 1;
    const nextYear = Number(month) === 12 ? Number(year) + 1 : Number(year);

    const endDate = `${nextYear}-${String(nextMonth).padStart(2, "0")}-01`;

    const incomeResult = await models.Transaction.findAll({
      where: {
        user_id: req.userData.userId,
        type: "income",
        transaction_date: {
          [Op.gte]: startDate,
          [Op.lt]: endDate,
        },
      },
      attributes: [[fn("SUM", col("amount")), "total"]],
      raw: true,
    });

    const expenseResult = await models.Transaction.findAll({
      where: {
        user_id: req.userData.userId,
        type: "expense",
        transaction_date: {
          [Op.gte]: startDate,
          [Op.lt]: endDate,
        },
      },
      attributes: [[fn("SUM", col("amount")), "total"]],
      raw: true,
    });

    const totalIncome = Number(incomeResult[0].total || 0);
    const totalExpense = Number(expenseResult[0].total || 0);
    const netProfit = totalIncome - totalExpense;

    res.status(200).json({
      month: Number(month),
      year: Number(year),
      totalIncome,
      totalExpense,
      netProfit,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Something went wrong",
    });
  }
}

async function getDashboardSummary(req, res) {
  try {
    const userId = req.userData.userId;

    const totalWarehouses = await models.Warehouse.count({
      where: { user_id: userId },
    });

    const totalTransactions = await models.Transaction.count({
      where: { user_id: userId },
    });

    const totalChecks = await models.Check.count({
      where: { user_id: userId },
    });

    const totalPendingChecks = await models.Check.count({
      where: {
        user_id: userId,
        status: "pending",
      },
    });

    const totalCashedChecks = await models.Check.count({
      where: {
        user_id: userId,
        status: "cashed",
      },
    });

    const totalBouncedChecks = await models.Check.count({
      where: {
        user_id: userId,
        status: "bounced",
      },
    });

    const totalStorageItems = await models.Storage.count({
      include: [
        {
          model: models.Warehouse,
          where: { user_id: userId },
          attributes: [],
        },
      ],
    });

    const incomeResult = await models.Transaction.findAll({
      where: {
        user_id: userId,
        type: "income",
      },
      attributes: [[fn("SUM", col("amount")), "total"]],
      raw: true,
    });

    const expenseResult = await models.Transaction.findAll({
      where: {
        user_id: userId,
        type: "expense",
      },
      attributes: [[fn("SUM", col("amount")), "total"]],
      raw: true,
    });

    const totalIncome = Number(incomeResult[0].total || 0);
    const totalExpense = Number(expenseResult[0].total || 0);
    const netProfit = totalIncome - totalExpense;

    res.status(200).json({
      totalWarehouses,
      totalStorageItems,
      totalTransactions,
      totalChecks,
      totalPendingChecks,
      totalCashedChecks,
      totalBouncedChecks,
      totalIncome,
      totalExpense,
      netProfit,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Something went wrong",
    });
  }
}

async function getCategoryReport(req, res) {
  try {
    const { month, year } = req.query;

    if (!month || !year) {
      return res.status(400).json({
        message: "Month and year are required",
      });
    }

    const startDate = `${year}-${String(month).padStart(2, "0")}-01`;

    const nextMonth = Number(month) === 12 ? 1 : Number(month) + 1;
    const nextYear = Number(month) === 12 ? Number(year) + 1 : Number(year);

    const endDate = `${nextYear}-${String(nextMonth).padStart(2, "0")}-01`;

    const categories = await models.Transaction.findAll({
      where: {
        user_id: req.userData.userId,
        transaction_date: {
          [Op.gte]: startDate,
          [Op.lt]: endDate,
        },
      },
      attributes: ["type", "category", [fn("SUM", col("amount")), "total"]],
      group: ["type", "category"],
      order: [
        ["type", "ASC"],
        ["category", "ASC"],
      ],
      raw: true,
    });

    res.status(200).json({
      month: Number(month),
      year: Number(year),
      categories: categories.map((item) => ({
        type: item.type,
        category: item.category,
        total: Number(item.total),
      })),
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Something went wrong",
    });
  }
}

async function getYearlyReport(req, res) {
  try {
    const { year } = req.query;

    if (!year) {
      return res.status(400).json({
        message: "Year is required",
      });
    }

    const startDate = `${year}-01-01`;
    const endDate = `${Number(year) + 1}-01-01`;

    const transactions = await models.Transaction.findAll({
      where: {
        user_id: req.userData.userId,
        transaction_date: {
          [Op.gte]: startDate,
          [Op.lt]: endDate,
        },
      },
      attributes: ["type", "amount", "transaction_date"],
      raw: true,
      order: [["transaction_date", "ASC"]],
    });

    const monthlyData = {};

    for (let i = 1; i <= 12; i++) {
      monthlyData[i] = {
        month: i,
        income: 0,
        expense: 0,
        netProfit: 0,
      };
    }

    for (const transaction of transactions) {
      const month = new Date(transaction.transaction_date).getMonth() + 1;

      if (transaction.type === "income") {
        monthlyData[month].income += Number(transaction.amount);
      }

      if (transaction.type === "expense") {
        monthlyData[month].expense += Number(transaction.amount);
      }
    }

    const monthlyBreakdown = Object.values(monthlyData).map((item) => {
      item.netProfit = item.income - item.expense;
      return item;
    });

    const totalIncome = monthlyBreakdown.reduce(
      (sum, item) => sum + item.income,
      0,
    );
    const totalExpense = monthlyBreakdown.reduce(
      (sum, item) => sum + item.expense,
      0,
    );
    const netProfit = totalIncome - totalExpense;

    res.status(200).json({
      year: Number(year),
      totalIncome,
      totalExpense,
      netProfit,
      monthlyBreakdown,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Something went wrong",
    });
  }
}

async function getInventoryValuation(req, res) {
  try {
    const storageItems = await models.Storage.findAll({
      include: [
        {
          model: models.Warehouse,
          where: { user_id: req.userData.userId },
          attributes: ["id", "name", "location"],
        },
      ],
      order: [["id", "DESC"]],
    });

    const items = storageItems.map((item) => {
      const purchaseValue = Number(item.quantity) * Number(item.purchase_price);
      const saleValue = Number(item.quantity) * Number(item.sale_price);
      const expectedProfit = saleValue - purchaseValue;

      return {
        id: item.id,
        name: item.name,
        quantity: item.quantity,
        minimum_quantity: item.minimum_quantity,
        purchase_price: Number(item.purchase_price),
        sale_price: Number(item.sale_price),
        purchaseValue,
        saleValue,
        expectedProfit,
        expiration_date: item.expiration_date,
        warehouse: item.Warehouse,
      };
    });

    const totalPurchaseValue = items.reduce(
      (sum, item) => sum + item.purchaseValue,
      0,
    );
    const totalSaleValue = items.reduce((sum, item) => sum + item.saleValue, 0);
    const totalExpectedProfit = totalSaleValue - totalPurchaseValue;

    res.status(200).json({
      totalItems: items.length,
      totalPurchaseValue,
      totalSaleValue,
      totalExpectedProfit,
      items,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Something went wrong",
    });
  }
}

async function getZakatReport(req, res) {
  try {
    const userId = req.userData.userId;

    const incomeResult = await models.Transaction.findAll({
      where: {
        user_id: userId,
        type: "income",
      },
      attributes: [[fn("SUM", col("amount")), "total"]],
      raw: true,
    });

    const expenseResult = await models.Transaction.findAll({
      where: {
        user_id: userId,
        type: "expense",
      },
      attributes: [[fn("SUM", col("amount")), "total"]],
      raw: true,
    });

    const totalIncome = Number(incomeResult[0].total || 0);
    const totalExpense = Number(expenseResult[0].total || 0);
    const netCash = totalIncome - totalExpense;

    const storageItems = await models.Storage.findAll({
      include: [
        {
          model: models.Warehouse,
          where: { user_id: userId },
          attributes: [],
        },
      ],
      raw: true,
    });

    const inventoryValue = storageItems.reduce((sum, item) => {
      return sum + Number(item.quantity) * Number(item.sale_price);
    }, 0);

    const zakatBase = netCash + inventoryValue;
    const zakatDue = zakatBase > 0 ? zakatBase * 0.025 : 0;

    res.status(200).json({
      totalIncome,
      totalExpense,
      netCash,
      inventoryValue,
      zakatBase,
      zakatRate: 0.025,
      zakatDue,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({
      message: "Something went wrong",
    });
  }
}
module.exports = {
  getMonthlyReport: getMonthlyReport,
  getDashboardSummary: getDashboardSummary,
  getCategoryReport: getCategoryReport,
  getYearlyReport: getYearlyReport,
  getInventoryValuation: getInventoryValuation,
  getZakatReport: getZakatReport,
};
