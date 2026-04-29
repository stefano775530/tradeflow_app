const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { createUserAndLogin } = require("./helpers/auth");

async function cleanReportsDatabase() {
  await models.Transaction.destroy({ where: {} });
  await models.Payment.destroy({ where: {} });

  await models.SaleItemAllocation.destroy({ where: {} });
  await models.SaleItem.destroy({ where: {} });
  await models.Sale.destroy({ where: {} });

  await models.PurchaseItemAllocation.destroy({ where: {} });
  await models.PurchaseItem.destroy({ where: {} });
  await models.Purchase.destroy({ where: {} });

  await models.Check.destroy({ where: {} });
  await models.Storage.destroy({ where: {} });
  await models.Warehouse.destroy({ where: {} });
  await models.Partner.destroy({ where: {} });
  await models.PasswordReset.destroy({ where: {} });
  await models.User.destroy({ where: {} });
}

async function createAuthUser(email, phone_number) {
  const { token } = await createUserAndLogin({ email, phone_number });
  const user = await models.User.findOne({ where: { email } });
  return { token, user };
}

async function createCustomerForUser(userId, overrides = {}) {
  return models.Partner.create({
    user_id: userId,
    company_name: "Customer One",
    partner_type: "customer",
    phone_number: "+14155550999",
    ...overrides,
  });
}

async function createSupplierForUser(userId, overrides = {}) {
  return models.Partner.create({
    user_id: userId,
    company_name: "Supplier One",
    partner_type: "supplier",
    phone_number: "+14155550998",
    ...overrides,
  });
}

async function createWarehouseForUser(userId, overrides = {}) {
  return models.Warehouse.create({
    user_id: userId,
    name: "Main Warehouse",
    location: "Seattle",
    ...overrides,
  });
}

async function createStorageForWarehouse(warehouseId, overrides = {}) {
  return models.Storage.create({
    warehouse_id: warehouseId,
    name: "wood",
    quantity: 100,
    minimum_quantity: 10,
    thickness: "6",
    purchase_price: 300,
    sale_price: 500,
    expiration_date: null,
    ...overrides,
  });
}

describe("Reports API", () => {
  beforeEach(async () => {
    await cleanReportsDatabase();
  });

  test("dashboard report includes debt summary, check counts, and financial totals", async () => {
    const { token, user } = await createAuthUser(
      "report-dashboard@test.com",
      "+14155550601",
    );

    const customer = await createCustomerForUser(user.id);
    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const saleStorage = await createStorageForWarehouse(warehouse.id, {
      name: "wood",
      quantity: 100,
      thickness: "6",
      purchase_price: 300,
      sale_price: 500,
    });

    const saleRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: customer.id,
        sale_date: "2026-04-12",
        invoice_number: "INV-REPORT-1",
        items: [
          {
            quantity: 100,
            unit_price: 500,
            allocations: [{ storage_id: saleStorage.id, quantity: 100 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 20000,
            payment_date: "2026-04-12",
          },
          {
            payment_method: "check",
            amount: 10000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-REPORT-1",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(saleRes.statusCode).toBe(201);

    const purchaseRes = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        invoice_number: "PUR-REPORT-1",
        items: [
          {
            item_name: "wood",
            thickness: "8",
            quantity: 100,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouse.id, quantity: 100 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 5000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(purchaseRes.statusCode).toBe(201);

    const res = await request(app)
      .get("/api/reports/dashboard")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);

    expect(res.body.totalWarehouses).toBe(1);
    expect(res.body.totalStorageItems).toBe(2);

    expect(res.body.totalTransactions).toBe(2);
    expect(res.body.totalChecks).toBe(1);
    expect(res.body.totalPendingChecks).toBe(1);
    expect(res.body.totalCashedChecks).toBe(0);
    expect(res.body.totalBouncedChecks).toBe(0);

    expect(Number(res.body.totalIncome)).toBe(20000);
    expect(Number(res.body.totalExpense)).toBe(5000);
    expect(Number(res.body.netProfit)).toBe(15000);

    expect(res.body.totalSales).toBe(1);
    expect(res.body.totalPurchases).toBe(1);

    expect(Number(res.body.totalSalesAmount)).toBe(50000);
    expect(Number(res.body.totalPurchasesAmount)).toBe(30000);

    expect(Number(res.body.totalReceivedFromSales)).toBe(30000);
    expect(Number(res.body.totalPaidForPurchases)).toBe(5000);

    expect(Number(res.body.totalReceivables)).toBe(20000);
    expect(Number(res.body.totalPayables)).toBe(25000);

    expect(res.body.totalUnpaidSales).toBe(0);
    expect(res.body.totalPartialSales).toBe(1);
    expect(res.body.totalPaidSales).toBe(0);

    expect(res.body.totalUnpaidPurchases).toBe(0);
    expect(res.body.totalPartialPurchases).toBe(1);
    expect(res.body.totalPaidPurchases).toBe(0);
  });

  test("monthly report sums income and expense transactions for the selected month", async () => {
    const { token, user } = await createAuthUser(
      "report-monthly@test.com",
      "+14155550602",
    );

    await models.Transaction.bulkCreate([
      {
        user_id: user.id,
        type: "income",
        category: "sale",
        amount: 1000,
        description: "sale income",
        transaction_date: "2026-04-01",
        reference_type: "manual",
        reference_id: 1,
        company_name: "Customer One",
      },
      {
        user_id: user.id,
        type: "income",
        category: "check_in",
        amount: 400,
        description: "cashed check",
        transaction_date: "2026-04-15",
        reference_type: "check",
        reference_id: 2,
        company_name: "Customer One",
      },
      {
        user_id: user.id,
        type: "expense",
        category: "purchase",
        amount: 300,
        description: "purchase expense",
        transaction_date: "2026-04-20",
        reference_type: "manual",
        reference_id: 3,
        company_name: "Supplier One",
      },
      {
        user_id: user.id,
        type: "expense",
        category: "rent",
        amount: 200,
        description: "outside month",
        transaction_date: "2026-05-01",
        reference_type: "manual",
        reference_id: 4,
        company_name: "Office",
      },
    ]);

    const res = await request(app)
      .get("/api/reports/monthly?month=4&year=2026")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.month).toBe(4);
    expect(res.body.year).toBe(2026);
    expect(Number(res.body.totalIncome)).toBe(1400);
    expect(Number(res.body.totalExpense)).toBe(300);
    expect(Number(res.body.netProfit)).toBe(1100);
  });

  test("category report groups transactions by type and category", async () => {
    const { token, user } = await createAuthUser(
      "report-categories@test.com",
      "+14155550603",
    );

    await models.Transaction.bulkCreate([
      {
        user_id: user.id,
        type: "income",
        category: "sale",
        amount: 1000,
        description: "sale income",
        transaction_date: "2026-04-01",
        reference_type: "manual",
        reference_id: 1,
        company_name: "Customer One",
      },
      {
        user_id: user.id,
        type: "income",
        category: "sale",
        amount: 500,
        description: "another sale income",
        transaction_date: "2026-04-10",
        reference_type: "manual",
        reference_id: 2,
        company_name: "Customer One",
      },
      {
        user_id: user.id,
        type: "expense",
        category: "purchase",
        amount: 300,
        description: "purchase expense",
        transaction_date: "2026-04-20",
        reference_type: "manual",
        reference_id: 3,
        company_name: "Supplier One",
      },
    ]);

    const res = await request(app)
      .get("/api/reports/categories?month=4&year=2026")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.month).toBe(4);
    expect(res.body.year).toBe(2026);

    const saleCategory = res.body.categories.find(
      (item) => item.type === "income" && item.category === "sale",
    );
    const purchaseCategory = res.body.categories.find(
      (item) => item.type === "expense" && item.category === "purchase",
    );

    expect(saleCategory).toBeDefined();
    expect(Number(saleCategory.total)).toBe(1500);

    expect(purchaseCategory).toBeDefined();
    expect(Number(purchaseCategory.total)).toBe(300);
  });

  test("yearly report returns correct totals and monthly breakdown", async () => {
    const { token, user } = await createAuthUser(
      "report-yearly@test.com",
      "+14155550604",
    );

    await models.Transaction.bulkCreate([
      {
        user_id: user.id,
        type: "income",
        category: "sale",
        amount: 1000,
        description: "jan income",
        transaction_date: "2026-01-05",
        reference_type: "manual",
        reference_id: 1,
        company_name: "Customer One",
      },
      {
        user_id: user.id,
        type: "expense",
        category: "purchase",
        amount: 200,
        description: "jan expense",
        transaction_date: "2026-01-10",
        reference_type: "manual",
        reference_id: 2,
        company_name: "Supplier One",
      },
      {
        user_id: user.id,
        type: "income",
        category: "sale",
        amount: 500,
        description: "mar income",
        transaction_date: "2026-03-03",
        reference_type: "manual",
        reference_id: 3,
        company_name: "Customer One",
      },
      {
        user_id: user.id,
        type: "expense",
        category: "rent",
        amount: 100,
        description: "dec expense",
        transaction_date: "2026-12-15",
        reference_type: "manual",
        reference_id: 4,
        company_name: "Office",
      },
    ]);

    const res = await request(app)
      .get("/api/reports/yearly?year=2026")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.year).toBe(2026);
    expect(Number(res.body.totalIncome)).toBe(1500);
    expect(Number(res.body.totalExpense)).toBe(300);
    expect(Number(res.body.netProfit)).toBe(1200);
    expect(Array.isArray(res.body.monthlyBreakdown)).toBe(true);
    expect(res.body.monthlyBreakdown).toHaveLength(12);

    const january = res.body.monthlyBreakdown.find((item) => item.month === 1);
    const march = res.body.monthlyBreakdown.find((item) => item.month === 3);
    const december = res.body.monthlyBreakdown.find(
      (item) => item.month === 12,
    );

    expect(Number(january.income)).toBe(1000);
    expect(Number(january.expense)).toBe(200);
    expect(Number(january.netProfit)).toBe(800);

    expect(Number(march.income)).toBe(500);
    expect(Number(march.expense)).toBe(0);
    expect(Number(march.netProfit)).toBe(500);

    expect(Number(december.income)).toBe(0);
    expect(Number(december.expense)).toBe(100);
    expect(Number(december.netProfit)).toBe(-100);
  });

  test("inventory valuation report returns correct totals from current storage", async () => {
    const { token, user } = await createAuthUser(
      "report-valuation@test.com",
      "+14155550605",
    );

    const warehouse = await createWarehouseForUser(user.id);

    await createStorageForWarehouse(warehouse.id, {
      name: "wood",
      quantity: 10,
      thickness: "6",
      purchase_price: 5,
      sale_price: 8,
    });

    await createStorageForWarehouse(warehouse.id, {
      name: "wood premium",
      quantity: 20,
      thickness: "8",
      purchase_price: 3,
      sale_price: 4,
    });

    const res = await request(app)
      .get("/api/reports/storage-valuation")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.totalItems).toBe(2);
    expect(Number(res.body.totalPurchaseValue)).toBe(110);
    expect(Number(res.body.totalSaleValue)).toBe(160);
    expect(Number(res.body.totalExpectedProfit)).toBe(50);
    expect(Array.isArray(res.body.items)).toBe(true);
    expect(res.body.items).toHaveLength(2);
  });

  test("zakat report combines net cash and inventory value", async () => {
    const { token, user } = await createAuthUser(
      "report-zakat@test.com",
      "+14155550606",
    );

    const warehouse = await createWarehouseForUser(user.id);

    await createStorageForWarehouse(warehouse.id, {
      name: "wood",
      quantity: 10,
      thickness: "6",
      purchase_price: 5,
      sale_price: 8,
    });

    await createStorageForWarehouse(warehouse.id, {
      name: "wood premium",
      quantity: 20,
      thickness: "8",
      purchase_price: 3,
      sale_price: 4,
    });

    await models.Transaction.bulkCreate([
      {
        user_id: user.id,
        type: "income",
        category: "sale",
        amount: 2000,
        description: "income",
        transaction_date: "2026-04-01",
        reference_type: "manual",
        reference_id: 1,
        company_name: "Customer One",
      },
      {
        user_id: user.id,
        type: "expense",
        category: "purchase",
        amount: 500,
        description: "expense",
        transaction_date: "2026-04-02",
        reference_type: "manual",
        reference_id: 2,
        company_name: "Supplier One",
      },
    ]);

    const res = await request(app)
      .get("/api/reports/zakat")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(Number(res.body.totalIncome)).toBe(2000);
    expect(Number(res.body.totalExpense)).toBe(500);
    expect(Number(res.body.netCash)).toBe(1500);
    expect(Number(res.body.inventoryValue)).toBe(160);
    expect(Number(res.body.zakatBase)).toBe(1660);
    expect(Number(res.body.zakatRate)).toBe(0.025);
    expect(Number(res.body.zakatDue)).toBe(41.5);
  });

  test("unauthenticated reports access returns 401", async () => {
    const res = await request(app).get("/api/reports/dashboard");
    expect(res.statusCode).toBe(401);
  });
});
