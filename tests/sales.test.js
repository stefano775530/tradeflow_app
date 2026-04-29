const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { createUserAndLogin } = require("./helpers/auth");

async function cleanSalesRelatedDatabase() {
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

async function createPartnerForUser(userId, overrides = {}) {
  return models.Partner.create({
    user_id: userId,
    company_name: "Customer One",
    partner_type: "customer",
    phone_number: "+14155550999",
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

describe("Sales API", () => {
  beforeEach(async () => {
    await cleanSalesRelatedDatabase();
  });

  test("create sale succeeds with mixed cash and pending check from multiple storages", async () => {
    const { token, user } = await createAuthUser(
      "sale1@test.com",
      "+14155550301",
    );

    const partner = await createPartnerForUser(user.id);

    const warehouseA = await createWarehouseForUser(user.id, {
      name: "Warehouse A",
    });
    const warehouseB = await createWarehouseForUser(user.id, {
      name: "Warehouse B",
    });

    const storageA = await createStorageForWarehouse(warehouseA.id, {
      name: "wood",
      quantity: 100,
      thickness: "6",
      purchase_price: 300,
      sale_price: 500,
    });

    const storageB = await createStorageForWarehouse(warehouseB.id, {
      name: "wood",
      quantity: 100,
      thickness: "6",
      purchase_price: 300,
      sale_price: 500,
    });

    const res = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        invoice_number: "INV-1001",
        notes: "wood sale",
        items: [
          {
            quantity: 200,
            unit_price: 500,
            allocations: [
              { storage_id: storageA.id, quantity: 100 },
              { storage_id: storageB.id, quantity: 100 },
            ],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 30000,
            payment_date: "2026-04-12",
            notes: "cash part",
          },
          {
            payment_method: "check",
            amount: 70000,
            payment_date: "2026-04-12",
            notes: "check part",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-1001",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.sale.total_amount)).toBe(100000);
    expect(Number(res.body.sale.paid_amount)).toBe(100000);
    expect(Number(res.body.sale.remaining_amount)).toBe(0);
    expect(res.body.sale.payment_status).toBe("paid");

    const salesCount = await models.Sale.count();
    const saleItemsCount = await models.SaleItem.count();
    const allocationsCount = await models.SaleItemAllocation.count();
    const paymentsCount = await models.Payment.count();
    const checksCount = await models.Check.count();
    const transactionsCount = await models.Transaction.count();

    expect(salesCount).toBe(1);
    expect(saleItemsCount).toBe(1);
    expect(allocationsCount).toBe(2);
    expect(paymentsCount).toBe(2);
    expect(checksCount).toBe(1);
    expect(transactionsCount).toBe(1);

    const updatedStorageA = await models.Storage.findByPk(storageA.id);
    const updatedStorageB = await models.Storage.findByPk(storageB.id);

    expect(updatedStorageA.quantity).toBe(0);
    expect(updatedStorageB.quantity).toBe(0);

    const cashTransaction = await models.Transaction.findOne({
      where: {
        type: "income",
        reference_type: "sale_payment",
      },
    });

    expect(cashTransaction).not.toBeNull();
    expect(Number(cashTransaction.amount)).toBe(30000);
  });

  test("create sale with cashed check creates check transaction", async () => {
    const { token, user } = await createAuthUser(
      "sale2@test.com",
      "+14155550302",
    );

    const partner = await createPartnerForUser(user.id, {
      company_name: "Customer Two",
    });

    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      name: "wood",
      quantity: 40,
      thickness: "6",
      purchase_price: 300,
      sale_price: 500,
    });

    const res = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        invoice_number: "INV-1002",
        items: [
          {
            quantity: 40,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 40 }],
          },
        ],
        payments: [
          {
            payment_method: "check",
            amount: 20000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "XYZ Bank",
              check_number: "CHK-2001",
              issue_date: "2026-04-12",
              cashing_date: "2026-04-13",
              status: "cashed",
            },
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.sale.paid_amount)).toBe(20000);
    expect(Number(res.body.sale.remaining_amount)).toBe(0);
    expect(res.body.sale.payment_status).toBe("paid");

    const checksCount = await models.Check.count();
    const transactionsCount = await models.Transaction.count();

    expect(checksCount).toBe(1);
    expect(transactionsCount).toBe(1);

    const checkTransaction = await models.Transaction.findOne({
      where: { category: "check_in" },
    });

    expect(checkTransaction).not.toBeNull();
    expect(Number(checkTransaction.amount)).toBe(20000);

    const updatedStorage = await models.Storage.findByPk(storage.id);
    expect(updatedStorage.quantity).toBe(0);
  });

  test("create sale without payments creates unpaid sale", async () => {
    const { token, user } = await createAuthUser(
      "sale-unpaid@test.com",
      "+14155550310",
    );

    const partner = await createPartnerForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 100,
    });

    const res = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        invoice_number: "INV-1003",
        notes: "unpaid sale",
        items: [
          {
            quantity: 100,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 100 }],
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.sale.total_amount)).toBe(50000);
    expect(Number(res.body.sale.paid_amount)).toBe(0);
    expect(Number(res.body.sale.remaining_amount)).toBe(50000);
    expect(res.body.sale.payment_status).toBe("unpaid");

    const paymentsCount = await models.Payment.count();
    const transactionsCount = await models.Transaction.count();

    expect(paymentsCount).toBe(0);
    expect(transactionsCount).toBe(0);
  });

  test("create sale with debt stores partial payment fields correctly", async () => {
    const { token, user } = await createAuthUser(
      "sale-partial@test.com",
      "+14155550317",
    );

    const partner = await createPartnerForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 200,
    });

    const res = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        invoice_number: "INV-1004",
        notes: "sale with debt",
        items: [
          {
            quantity: 200,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 200 }],
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
            amount: 30000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-5001",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.sale.total_amount)).toBe(100000);
    expect(Number(res.body.sale.paid_amount)).toBe(50000);
    expect(Number(res.body.sale.remaining_amount)).toBe(50000);
    expect(res.body.sale.payment_status).toBe("partial");
  });

  test("create sale fails when allocations do not match item quantity", async () => {
    const { token, user } = await createAuthUser(
      "sale3@test.com",
      "+14155550303",
    );

    const partner = await createPartnerForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 200,
    });

    const res = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        items: [
          {
            quantity: 200,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 150 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 100000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(res.statusCode).toBe(400);

    const salesCount = await models.Sale.count();
    const updatedStorage = await models.Storage.findByPk(storage.id);

    expect(salesCount).toBe(0);
    expect(updatedStorage.quantity).toBe(200);
  });

  test("user cannot create sale using another user's storage", async () => {
    const { token: tokenA, user: userA } = await createAuthUser(
      "sale4a@test.com",
      "+14155550304",
    );

    const { user: userB } = await createAuthUser(
      "sale4b@test.com",
      "+14155550305",
    );

    const partnerA = await createPartnerForUser(userA.id);

    const warehouseB = await createWarehouseForUser(userB.id, {
      name: "Other Warehouse",
    });

    const storageB = await createStorageForWarehouse(warehouseB.id, {
      quantity: 50,
    });

    const res = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        partner_id: partnerA.id,
        sale_date: "2026-04-12",
        items: [
          {
            quantity: 50,
            unit_price: 500,
            allocations: [{ storage_id: storageB.id, quantity: 50 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 25000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(res.statusCode).toBe(404);

    const salesCount = await models.Sale.count();
    expect(salesCount).toBe(0);
  });

  test("add cash payment to partial sale updates debt fields and creates transaction", async () => {
    const { token, user } = await createAuthUser(
      "sale-payment1@test.com",
      "+14155550311",
    );

    const partner = await createPartnerForUser(user.id);

    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      name: "wood",
      quantity: 200,
      thickness: "6",
      purchase_price: 300,
      sale_price: 500,
    });

    const createRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        invoice_number: "INV-2001",
        notes: "sale with debt",
        items: [
          {
            quantity: 200,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 200 }],
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
            amount: 30000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-6001",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(createRes.statusCode).toBe(201);
    expect(Number(createRes.body.sale.paid_amount)).toBe(50000);
    expect(Number(createRes.body.sale.remaining_amount)).toBe(50000);
    expect(createRes.body.sale.payment_status).toBe("partial");

    const saleId = createRes.body.sale.id;

    const addPaymentRes = await request(app)
      .post(`/api/sales/${saleId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "cash",
        amount: 20000,
        payment_date: "2026-04-13",
        notes: "second payment",
      });

    expect(addPaymentRes.statusCode).toBe(201);
    expect(Number(addPaymentRes.body.sale.paid_amount)).toBe(70000);
    expect(Number(addPaymentRes.body.sale.remaining_amount)).toBe(30000);
    expect(addPaymentRes.body.sale.payment_status).toBe("partial");

    const sale = await models.Sale.findByPk(saleId);
    expect(Number(sale.paid_amount)).toBe(70000);
    expect(Number(sale.remaining_amount)).toBe(30000);
    expect(sale.payment_status).toBe("partial");

    const paymentsCount = await models.Payment.count({
      where: { sale_id: saleId },
    });
    expect(paymentsCount).toBe(3);

    const cashTransactions = await models.Transaction.findAll({
      where: {
        type: "income",
        reference_type: "sale_payment",
      },
    });

    expect(cashTransactions.length).toBe(2);
  });

  test("add check payment to partial sale updates debt fields and creates check", async () => {
    const { token, user } = await createAuthUser(
      "sale-payment2@test.com",
      "+14155550312",
    );

    const partner = await createPartnerForUser(user.id);

    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      name: "wood",
      quantity: 100,
      thickness: "6",
      purchase_price: 300,
      sale_price: 500,
    });

    const createRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        items: [
          {
            quantity: 100,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 100 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 20000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(createRes.statusCode).toBe(201);
    const saleId = createRes.body.sale.id;

    const addPaymentRes = await request(app)
      .post(`/api/sales/${saleId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "check",
        amount: 15000,
        payment_date: "2026-04-13",
        notes: "third payment by check",
        check: {
          bank_name: "ABC Bank",
          check_number: "CHK-6002",
          issue_date: "2026-04-13",
          status: "pending",
        },
      });

    expect(addPaymentRes.statusCode).toBe(201);
    expect(Number(addPaymentRes.body.sale.paid_amount)).toBe(35000);
    expect(Number(addPaymentRes.body.sale.remaining_amount)).toBe(15000);
    expect(addPaymentRes.body.sale.payment_status).toBe("partial");

    const checksCount = await models.Check.count();
    expect(checksCount).toBe(1);

    const paymentsCount = await models.Payment.count({
      where: { sale_id: saleId },
    });
    expect(paymentsCount).toBe(2);
  });

  test("add payment cannot exceed remaining amount", async () => {
    const { token, user } = await createAuthUser(
      "sale-payment3@test.com",
      "+14155550313",
    );

    const partner = await createPartnerForUser(user.id);

    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 100,
    });

    const createRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        items: [
          {
            quantity: 100,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 100 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 40000,
            payment_date: "2026-04-12",
          },
        ],
      });

    const saleId = createRes.body.sale.id;

    const res = await request(app)
      .post(`/api/sales/${saleId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "cash",
        amount: 20000,
        payment_date: "2026-04-13",
      });

    expect(res.statusCode).toBe(400);

    const sale = await models.Sale.findByPk(saleId);
    expect(Number(sale.paid_amount)).toBe(40000);
    expect(Number(sale.remaining_amount)).toBe(10000);
    expect(sale.payment_status).toBe("partial");
  });

  test("cannot add payment to fully paid sale", async () => {
    const { token, user } = await createAuthUser(
      "sale-payment4@test.com",
      "+14155550314",
    );

    const partner = await createPartnerForUser(user.id);

    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 100,
    });

    const createRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: partner.id,
        sale_date: "2026-04-12",
        items: [
          {
            quantity: 100,
            unit_price: 500,
            allocations: [{ storage_id: storage.id, quantity: 100 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 50000,
            payment_date: "2026-04-12",
          },
        ],
      });

    const saleId = createRes.body.sale.id;

    const res = await request(app)
      .post(`/api/sales/${saleId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "cash",
        amount: 5000,
        payment_date: "2026-04-13",
      });

    expect(res.statusCode).toBe(400);
  });

  test("user cannot add payment to another user's sale", async () => {
    const { token: tokenA, user: userA } = await createAuthUser(
      "sale-payment5a@test.com",
      "+14155550315",
    );

    const { token: tokenB, user: userB } = await createAuthUser(
      "sale-payment5b@test.com",
      "+14155550316",
    );

    const partnerA = await createPartnerForUser(userA.id);

    const warehouseA = await createWarehouseForUser(userA.id);
    const storageA = await createStorageForWarehouse(warehouseA.id, {
      quantity: 100,
    });

    const createRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        partner_id: partnerA.id,
        sale_date: "2026-04-12",
        items: [
          {
            quantity: 100,
            unit_price: 500,
            allocations: [{ storage_id: storageA.id, quantity: 100 }],
          },
        ],
      });

    const saleId = createRes.body.sale.id;

    const res = await request(app)
      .post(`/api/sales/${saleId}/payments`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        payment_method: "cash",
        amount: 10000,
        payment_date: "2026-04-13",
      });

    expect(res.statusCode).toBe(404);
  });

  test("unauthenticated sale creation returns 401", async () => {
    const res = await request(app).post("/api/sales").send({
      sale_date: "2026-04-12",
      items: [],
      payments: [],
    });

    expect(res.statusCode).toBe(401);
  });

  test("unauthenticated add sale payment returns 401", async () => {
    const res = await request(app).post("/api/sales/999/payments").send({
      payment_method: "cash",
      amount: 10000,
      payment_date: "2026-04-13",
    });

    expect(res.statusCode).toBe(401);
  });
});
