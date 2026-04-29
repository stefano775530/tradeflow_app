const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { createUserAndLogin } = require("./helpers/auth");

async function cleanPurchaseRelatedDatabase() {
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
    quantity: 50,
    minimum_quantity: 10,
    thickness: "6",
    purchase_price: 250,
    sale_price: 400,
    expiration_date: null,
    ...overrides,
  });
}

describe("Purchases API", () => {
  beforeEach(async () => {
    await cleanPurchaseRelatedDatabase();
  });

  test("create purchase succeeds with mixed cash and pending check distributed to multiple warehouses", async () => {
    const { token, user } = await createAuthUser(
      "purchase1@test.com",
      "+14155550401",
    );

    const supplier = await createSupplierForUser(user.id);

    const warehouseA = await createWarehouseForUser(user.id, {
      name: "Warehouse A",
    });
    const warehouseB = await createWarehouseForUser(user.id, {
      name: "Warehouse B",
    });

    const res = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        invoice_number: "PUR-1001",
        notes: "wood purchase",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 500,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [
              { warehouse_id: warehouseA.id, quantity: 200 },
              { warehouse_id: warehouseB.id, quantity: 300 },
            ],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 50000,
            payment_date: "2026-04-12",
            notes: "cash part",
          },
          {
            payment_method: "check",
            amount: 100000,
            payment_date: "2026-04-12",
            notes: "check part",
            check: {
              bank_name: "ABC Bank",
              check_number: "OUT-1001",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.purchase.total_amount)).toBe(150000);
    expect(Number(res.body.purchase.paid_amount)).toBe(150000);
    expect(Number(res.body.purchase.remaining_amount)).toBe(0);
    expect(res.body.purchase.payment_status).toBe("paid");

    const purchasesCount = await models.Purchase.count();
    const purchaseItemsCount = await models.PurchaseItem.count();
    const allocationsCount = await models.PurchaseItemAllocation.count();
    const paymentsCount = await models.Payment.count();
    const checksCount = await models.Check.count();
    const transactionsCount = await models.Transaction.count();

    expect(purchasesCount).toBe(1);
    expect(purchaseItemsCount).toBe(1);
    expect(allocationsCount).toBe(2);
    expect(paymentsCount).toBe(2);
    expect(checksCount).toBe(1);
    expect(transactionsCount).toBe(1);

    const storageA = await models.Storage.findOne({
      where: { warehouse_id: warehouseA.id, name: "wood", thickness: "6" },
    });
    const storageB = await models.Storage.findOne({
      where: { warehouse_id: warehouseB.id, name: "wood", thickness: "6" },
    });

    expect(storageA).not.toBeNull();
    expect(storageB).not.toBeNull();
    expect(storageA.quantity).toBe(200);
    expect(storageB.quantity).toBe(300);

    const cashTransaction = await models.Transaction.findOne({
      where: {
        type: "expense",
        reference_type: "purchase_payment",
      },
    });

    expect(cashTransaction).not.toBeNull();
    expect(Number(cashTransaction.amount)).toBe(50000);
  });

  test("create purchase with cashed check creates outgoing check transaction", async () => {
    const { token, user } = await createAuthUser(
      "purchase2@test.com",
      "+14155550402",
    );

    const supplier = await createSupplierForUser(user.id, {
      company_name: "Supplier Two",
    });

    const warehouse = await createWarehouseForUser(user.id);

    const res = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        invoice_number: "PUR-1002",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 40,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouse.id, quantity: 40 }],
          },
        ],
        payments: [
          {
            payment_method: "check",
            amount: 12000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "XYZ Bank",
              check_number: "OUT-2001",
              issue_date: "2026-04-12",
              cashing_date: "2026-04-13",
              status: "cashed",
            },
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.purchase.paid_amount)).toBe(12000);
    expect(Number(res.body.purchase.remaining_amount)).toBe(0);
    expect(res.body.purchase.payment_status).toBe("paid");

    const checksCount = await models.Check.count();
    const transactionsCount = await models.Transaction.count();

    expect(checksCount).toBe(1);
    expect(transactionsCount).toBe(1);

    const checkTransaction = await models.Transaction.findOne({
      where: { category: "check_out" },
    });

    expect(checkTransaction).not.toBeNull();
    expect(Number(checkTransaction.amount)).toBe(12000);

    const storage = await models.Storage.findOne({
      where: { warehouse_id: warehouse.id, name: "wood", thickness: "6" },
    });

    expect(storage).not.toBeNull();
    expect(storage.quantity).toBe(40);
  });

  test("create purchase increases existing storage quantity when storage already exists", async () => {
    const { token, user } = await createAuthUser(
      "purchase3@test.com",
      "+14155550403",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const storage = await createStorageForWarehouse(warehouse.id, {
      name: "wood",
      quantity: 50,
      thickness: "6",
      purchase_price: 250,
      sale_price: 400,
      expiration_date: null,
    });

    const res = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 20,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [
              {
                warehouse_id: warehouse.id,
                storage_id: storage.id,
                quantity: 20,
              },
            ],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 6000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.purchase.paid_amount)).toBe(6000);
    expect(Number(res.body.purchase.remaining_amount)).toBe(0);
    expect(res.body.purchase.payment_status).toBe("paid");

    const updatedStorage = await models.Storage.findByPk(storage.id);
    expect(updatedStorage.quantity).toBe(70);
    expect(Number(updatedStorage.purchase_price)).toBe(300);
    expect(Number(updatedStorage.sale_price)).toBe(500);
  });

  test("create purchase without payments creates unpaid purchase", async () => {
    const { token, user } = await createAuthUser(
      "purchase-unpaid@test.com",
      "+14155550410",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const res = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        invoice_number: "PUR-1003",
        notes: "unpaid purchase",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 100,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouse.id, quantity: 100 }],
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.purchase.total_amount)).toBe(30000);
    expect(Number(res.body.purchase.paid_amount)).toBe(0);
    expect(Number(res.body.purchase.remaining_amount)).toBe(30000);
    expect(res.body.purchase.payment_status).toBe("unpaid");

    const paymentsCount = await models.Payment.count();
    const transactionsCount = await models.Transaction.count();

    expect(paymentsCount).toBe(0);
    expect(transactionsCount).toBe(0);
  });

  test("create purchase with debt stores partial payment fields correctly", async () => {
    const { token, user } = await createAuthUser(
      "purchase-partial@test.com",
      "+14155550417",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const res = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        invoice_number: "PUR-1004",
        notes: "purchase with debt",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 500,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouse.id, quantity: 500 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 50000,
            payment_date: "2026-04-12",
          },
          {
            payment_method: "check",
            amount: 30000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "OUT-5001",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.purchase.total_amount)).toBe(150000);
    expect(Number(res.body.purchase.paid_amount)).toBe(80000);
    expect(Number(res.body.purchase.remaining_amount)).toBe(70000);
    expect(res.body.purchase.payment_status).toBe("partial");
  });

  test("create purchase fails when allocations do not match item quantity", async () => {
    const { token, user } = await createAuthUser(
      "purchase4@test.com",
      "+14155550404",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const res = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 200,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouse.id, quantity: 150 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 60000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(res.statusCode).toBe(400);

    const purchasesCount = await models.Purchase.count();
    const storagesCount = await models.Storage.count();

    expect(purchasesCount).toBe(0);
    expect(storagesCount).toBe(0);
  });

  test("user cannot create purchase using another user's warehouse", async () => {
    const { token: tokenA, user: userA } = await createAuthUser(
      "purchase5a@test.com",
      "+14155550405",
    );

    const { user: userB } = await createAuthUser(
      "purchase5b@test.com",
      "+14155550406",
    );

    const supplierA = await createSupplierForUser(userA.id);

    const warehouseB = await createWarehouseForUser(userB.id, {
      name: "Other Warehouse",
    });

    const res = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        partner_id: supplierA.id,
        purchase_date: "2026-04-12",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 50,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouseB.id, quantity: 50 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 15000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(res.statusCode).toBe(404);

    const purchasesCount = await models.Purchase.count();
    expect(purchasesCount).toBe(0);
  });

  test("add cash payment to partial purchase updates debt fields and creates transaction", async () => {
    const { token, user } = await createAuthUser(
      "purchase-payment1@test.com",
      "+14155550411",
    );

    const supplier = await createSupplierForUser(user.id);

    const warehouse = await createWarehouseForUser(user.id);

    const createRes = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        invoice_number: "PUR-2001",
        notes: "purchase with debt",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 500,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouse.id, quantity: 500 }],
          },
        ],
        payments: [
          {
            payment_method: "cash",
            amount: 50000,
            payment_date: "2026-04-12",
          },
          {
            payment_method: "check",
            amount: 30000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "OUT-6001",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(createRes.statusCode).toBe(201);
    expect(Number(createRes.body.purchase.paid_amount)).toBe(80000);
    expect(Number(createRes.body.purchase.remaining_amount)).toBe(70000);
    expect(createRes.body.purchase.payment_status).toBe("partial");

    const purchaseId = createRes.body.purchase.id;

    const addPaymentRes = await request(app)
      .post(`/api/purchases/${purchaseId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "cash",
        amount: 20000,
        payment_date: "2026-04-13",
        notes: "second purchase payment",
      });

    expect(addPaymentRes.statusCode).toBe(201);
    expect(Number(addPaymentRes.body.purchase.paid_amount)).toBe(100000);
    expect(Number(addPaymentRes.body.purchase.remaining_amount)).toBe(50000);
    expect(addPaymentRes.body.purchase.payment_status).toBe("partial");

    const purchase = await models.Purchase.findByPk(purchaseId);
    expect(Number(purchase.paid_amount)).toBe(100000);
    expect(Number(purchase.remaining_amount)).toBe(50000);
    expect(purchase.payment_status).toBe("partial");

    const paymentsCount = await models.Payment.count({
      where: { purchase_id: purchaseId },
    });
    expect(paymentsCount).toBe(3);

    const cashTransactions = await models.Transaction.findAll({
      where: {
        type: "expense",
        reference_type: "purchase_payment",
      },
    });

    expect(cashTransactions.length).toBe(2);
  });

  test("add check payment to partial purchase updates debt fields and creates check", async () => {
    const { token, user } = await createAuthUser(
      "purchase-payment2@test.com",
      "+14155550412",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const createRes = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        items: [
          {
            item_name: "wood",
            thickness: "6",
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
            amount: 20000,
            payment_date: "2026-04-12",
          },
        ],
      });

    expect(createRes.statusCode).toBe(201);
    const purchaseId = createRes.body.purchase.id;

    const addPaymentRes = await request(app)
      .post(`/api/purchases/${purchaseId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "check",
        amount: 5000,
        payment_date: "2026-04-13",
        notes: "third purchase payment by check",
        check: {
          bank_name: "ABC Bank",
          check_number: "OUT-6002",
          issue_date: "2026-04-13",
          status: "pending",
        },
      });

    expect(addPaymentRes.statusCode).toBe(201);
    expect(Number(addPaymentRes.body.purchase.paid_amount)).toBe(25000);
    expect(Number(addPaymentRes.body.purchase.remaining_amount)).toBe(5000);
    expect(addPaymentRes.body.purchase.payment_status).toBe("partial");

    const checksCount = await models.Check.count();
    expect(checksCount).toBe(1);

    const paymentsCount = await models.Payment.count({
      where: { purchase_id: purchaseId },
    });
    expect(paymentsCount).toBe(2);
  });

  test("add payment cannot exceed remaining amount for purchase", async () => {
    const { token, user } = await createAuthUser(
      "purchase-payment3@test.com",
      "+14155550413",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const createRes = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        items: [
          {
            item_name: "wood",
            thickness: "6",
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
            amount: 25000,
            payment_date: "2026-04-12",
          },
        ],
      });

    const purchaseId = createRes.body.purchase.id;

    const res = await request(app)
      .post(`/api/purchases/${purchaseId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "cash",
        amount: 10000,
        payment_date: "2026-04-13",
      });

    expect(res.statusCode).toBe(400);

    const purchase = await models.Purchase.findByPk(purchaseId);
    expect(Number(purchase.paid_amount)).toBe(25000);
    expect(Number(purchase.remaining_amount)).toBe(5000);
    expect(purchase.payment_status).toBe("partial");
  });

  test("cannot add payment to fully paid purchase", async () => {
    const { token, user } = await createAuthUser(
      "purchase-payment4@test.com",
      "+14155550414",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const createRes = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: supplier.id,
        purchase_date: "2026-04-12",
        items: [
          {
            item_name: "wood",
            thickness: "6",
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
            amount: 30000,
            payment_date: "2026-04-12",
          },
        ],
      });

    const purchaseId = createRes.body.purchase.id;

    const res = await request(app)
      .post(`/api/purchases/${purchaseId}/payments`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        payment_method: "cash",
        amount: 5000,
        payment_date: "2026-04-13",
      });

    expect(res.statusCode).toBe(400);
  });

  test("user cannot add payment to another user's purchase", async () => {
    const { token: tokenA, user: userA } = await createAuthUser(
      "purchase-payment5a@test.com",
      "+14155550415",
    );

    const { token: tokenB } = await createAuthUser(
      "purchase-payment5b@test.com",
      "+14155550416",
    );

    const supplierA = await createSupplierForUser(userA.id);
    const warehouseA = await createWarehouseForUser(userA.id);

    const createRes = await request(app)
      .post("/api/purchases")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        partner_id: supplierA.id,
        purchase_date: "2026-04-12",
        items: [
          {
            item_name: "wood",
            thickness: "6",
            quantity: 100,
            unit_cost: 300,
            sale_price: 500,
            expiration_date: null,
            minimum_quantity: 10,
            allocations: [{ warehouse_id: warehouseA.id, quantity: 100 }],
          },
        ],
      });

    const purchaseId = createRes.body.purchase.id;

    const res = await request(app)
      .post(`/api/purchases/${purchaseId}/payments`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        payment_method: "cash",
        amount: 10000,
        payment_date: "2026-04-13",
      });

    expect(res.statusCode).toBe(404);
  });

  test("unauthenticated purchase creation returns 401", async () => {
    const res = await request(app).post("/api/purchases").send({
      purchase_date: "2026-04-12",
      items: [],
      payments: [],
    });

    expect(res.statusCode).toBe(401);
  });

  test("unauthenticated add purchase payment returns 401", async () => {
    const res = await request(app).post("/api/purchases/999/payments").send({
      payment_method: "cash",
      amount: 10000,
      payment_date: "2026-04-13",
    });

    expect(res.statusCode).toBe(401);
  });
});
