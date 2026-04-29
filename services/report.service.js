const models = require("../models");
const { Op, fn, col } = require("sequelize");
const { AppError } = require("../utils/app-error");

function buildMonthlyRange(month, year) {
  if (!month || !year) {
    throw new AppError(400, "Month and year are required");
  }

  const normalizedMonth = Number(month);
  const normalizedYear = Number(year);

  const startDate = `${normalizedYear}-${String(normalizedMonth).padStart(2, "0")}-01`;

  const nextMonth = normalizedMonth === 12 ? 1 : normalizedMonth + 1;
  const nextYear = normalizedMonth === 12 ? normalizedYear + 1 : normalizedYear;

  const endDate = `${nextYear}-${String(nextMonth).padStart(2, "0")}-01`;

  return {
    month: normalizedMonth,
    year: normalizedYear,
    startDate,
    endDate,
  };
}

function buildYearlyRange(year) {
  if (!year) {
    throw new AppError(400, "Year is required");
  }

  const normalizedYear = Number(year);

  return {
    year: normalizedYear,
    startDate: `${normalizedYear}-01-01`,
    endDate: `${normalizedYear + 1}-01-01`,
  };
}

async function sumTransactionAmount(where) {
  const result = await models.Transaction.findAll({
    where,
    attributes: [[fn("SUM", col("amount")), "total"]],
    raw: true,
  });

  return Number(result[0]?.total || 0);
}

async function sumModelField(model, fieldName, where) {
  const result = await model.findAll({
    where,
    attributes: [[fn("SUM", col(fieldName)), "total"]],
    raw: true,
  });

  return Number(result[0]?.total || 0);
}

async function getMonthlyReportForUser(userId, query) {
  const { month, year, startDate, endDate } = buildMonthlyRange(
    query.month,
    query.year,
  );

  const [totalIncome, totalExpense] = await Promise.all([
    sumTransactionAmount({
      user_id: userId,
      type: "income",
      transaction_date: {
        [Op.gte]: startDate,
        [Op.lt]: endDate,
      },
    }),
    sumTransactionAmount({
      user_id: userId,
      type: "expense",
      transaction_date: {
        [Op.gte]: startDate,
        [Op.lt]: endDate,
      },
    }),
  ]);

  return {
    month,
    year,
    totalIncome,
    totalExpense,
    netProfit: totalIncome - totalExpense,
  };
}

async function getDashboardSummaryForUser(userId) {
  const activeSaleWhere = {
    user_id: userId,
    status: {
      [Op.ne]: "cancelled",
    },
  };

  const activePurchaseWhere = {
    user_id: userId,
    status: {
      [Op.ne]: "cancelled",
    },
  };

  const [
    totalWarehouses,
    totalTransactions,
    totalChecks,
    totalPendingChecks,
    totalCashedChecks,
    totalBouncedChecks,
    totalStorageItems,
    totalIncome,
    totalExpense,

    totalSales,
    totalPurchases,

    totalUnpaidSales,
    totalPartialSales,
    totalPaidSales,

    totalUnpaidPurchases,
    totalPartialPurchases,
    totalPaidPurchases,

    totalSalesAmount,
    totalPurchasesAmount,

    totalReceivedFromSales,
    totalPaidForPurchases,

    totalReceivables,
    totalPayables,
  ] = await Promise.all([
    models.Warehouse.count({
      where: { user_id: userId },
    }),
    models.Transaction.count({
      where: { user_id: userId },
    }),
    models.Check.count({
      where: { user_id: userId },
    }),
    models.Check.count({
      where: {
        user_id: userId,
        status: "pending",
      },
    }),
    models.Check.count({
      where: {
        user_id: userId,
        status: "cashed",
      },
    }),
    models.Check.count({
      where: {
        user_id: userId,
        status: "bounced",
      },
    }),
    models.Storage.count({
      include: [
        {
          model: models.Warehouse,
          where: { user_id: userId },
          attributes: [],
        },
      ],
    }),
    sumTransactionAmount({
      user_id: userId,
      type: "income",
    }),
    sumTransactionAmount({
      user_id: userId,
      type: "expense",
    }),

    models.Sale.count({
      where: activeSaleWhere,
    }),
    models.Purchase.count({
      where: activePurchaseWhere,
    }),

    models.Sale.count({
      where: {
        ...activeSaleWhere,
        payment_status: "unpaid",
      },
    }),
    models.Sale.count({
      where: {
        ...activeSaleWhere,
        payment_status: "partial",
      },
    }),
    models.Sale.count({
      where: {
        ...activeSaleWhere,
        payment_status: "paid",
      },
    }),

    models.Purchase.count({
      where: {
        ...activePurchaseWhere,
        payment_status: "unpaid",
      },
    }),
    models.Purchase.count({
      where: {
        ...activePurchaseWhere,
        payment_status: "partial",
      },
    }),
    models.Purchase.count({
      where: {
        ...activePurchaseWhere,
        payment_status: "paid",
      },
    }),

    sumModelField(models.Sale, "total_amount", activeSaleWhere),
    sumModelField(models.Purchase, "total_amount", activePurchaseWhere),

    sumModelField(models.Sale, "paid_amount", activeSaleWhere),
    sumModelField(models.Purchase, "paid_amount", activePurchaseWhere),

    sumModelField(models.Sale, "remaining_amount", activeSaleWhere),
    sumModelField(models.Purchase, "remaining_amount", activePurchaseWhere),
  ]);

  return {
    totalWarehouses,
    totalStorageItems,

    totalTransactions,
    totalChecks,
    totalPendingChecks,
    totalCashedChecks,
    totalBouncedChecks,

    totalIncome,
    totalExpense,
    netProfit: totalIncome - totalExpense,

    totalSales,
    totalPurchases,

    totalSalesAmount,
    totalPurchasesAmount,

    totalReceivedFromSales,
    totalPaidForPurchases,

    totalReceivables,
    totalPayables,

    totalUnpaidSales,
    totalPartialSales,
    totalPaidSales,

    totalUnpaidPurchases,
    totalPartialPurchases,
    totalPaidPurchases,
  };
}

async function getCategoryReportForUser(userId, query) {
  const { month, year, startDate, endDate } = buildMonthlyRange(
    query.month,
    query.year,
  );

  const categories = await models.Transaction.findAll({
    where: {
      user_id: userId,
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

  return {
    month,
    year,
    categories: categories.map((item) => ({
      type: item.type,
      category: item.category,
      total: Number(item.total),
    })),
  };
}

async function getYearlyReportForUser(userId, query) {
  const { year, startDate, endDate } = buildYearlyRange(query.year);

  const transactions = await models.Transaction.findAll({
    where: {
      user_id: userId,
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
    const monthNumber = new Date(transaction.transaction_date).getMonth() + 1;

    if (transaction.type === "income") {
      monthlyData[monthNumber].income += Number(transaction.amount);
    }

    if (transaction.type === "expense") {
      monthlyData[monthNumber].expense += Number(transaction.amount);
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

  return {
    year,
    totalIncome,
    totalExpense,
    netProfit: totalIncome - totalExpense,
    monthlyBreakdown,
  };
}

async function getInventoryValuationForUser(userId) {
  const storageItems = await models.Storage.findAll({
    include: [
      {
        model: models.Warehouse,
        where: { user_id: userId },
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
      thickness: item.thickness,
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

  return {
    totalItems: items.length,
    totalPurchaseValue,
    totalSaleValue,
    totalExpectedProfit,
    items,
  };
}

async function getZakatReportForUser(userId) {
  const [totalIncome, totalExpense, storageItems] = await Promise.all([
    sumTransactionAmount({
      user_id: userId,
      type: "income",
    }),
    sumTransactionAmount({
      user_id: userId,
      type: "expense",
    }),
    models.Storage.findAll({
      include: [
        {
          model: models.Warehouse,
          where: { user_id: userId },
          attributes: [],
        },
      ],
      raw: true,
    }),
  ]);

  const netCash = totalIncome - totalExpense;

  const inventoryValue = storageItems.reduce((sum, item) => {
    return sum + Number(item.quantity) * Number(item.sale_price);
  }, 0);

  const zakatBase = netCash + inventoryValue;
  const zakatDue = zakatBase > 0 ? zakatBase * 0.025 : 0;

  return {
    totalIncome,
    totalExpense,
    netCash,
    inventoryValue,
    zakatBase,
    zakatRate: 0.025,
    zakatDue,
  };
}

module.exports = {
  getMonthlyReportForUser,
  getDashboardSummaryForUser,
  getCategoryReportForUser,
  getYearlyReportForUser,
  getInventoryValuationForUser,
  getZakatReportForUser,
};
