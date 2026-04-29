const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { createUserAndLogin } = require("./helpers/auth");

async function cleanChecksRelatedDatabase() {
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

describe("Checks API", () => {
  beforeEach(async () => {
    await cleanChecksRelatedDatabase();
  });

  test("rejects unauthenticated create check", async () => {
    const res = await request(app).post("/api/checks").send({
      bank_name: "ABC Bank",
      check_number: "CHK-1001",
      amount: 500,
      issue_date: "2026-04-01",
      type: "incoming",
      company_name: "abo ali",
    });

    expect(res.statusCode).toBe(401);
  });

  test("creates pending standalone check without linked transaction", async () => {
    const { token } = await createAuthUser(
      "check-basic1@test.com",
      "+14155550501",
    );

    const res = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-1002",
        amount: 500,
        issue_date: "2026-04-01",
        type: "incoming",
        company_name: "abo ali",
      });

    expect(res.statusCode).toBe(201);
    expect(res.body.check.status).toBe("pending");

    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: res.body.check.id,
      },
    });

    expect(tx).toBeNull();
  });

  test("creates cashed standalone check with linked transaction", async () => {
    const { token } = await createAuthUser(
      "check-basic2@test.com",
      "+14155550502",
    );

    const res = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-1003",
        amount: 900,
        issue_date: "2026-04-01",
        cashing_date: "2026-04-03",
        status: "cashed",
        type: "incoming",
        company_name: "abo ali",
      });

    expect(res.statusCode).toBe(201);
    expect(res.body.check.status).toBe("cashed");

    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: res.body.check.id,
      },
    });

    expect(tx).not.toBeNull();
    expect(Number(tx.amount)).toBe(900);
    expect(tx.type).toBe("income");
  });

  test("updating a standalone cashed check to pending removes linked transaction", async () => {
    const { token } = await createAuthUser(
      "check-basic3@test.com",
      "+14155550503",
    );

    const createRes = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-1004",
        amount: 700,
        issue_date: "2026-04-01",
        cashing_date: "2026-04-03",
        status: "cashed",
        type: "incoming",
        company_name: "abo ali",
      });

    const checkId = createRes.body.check.id;

    const updateRes = await request(app)
      .patch(`/api/checks/${checkId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        status: "pending",
        cashing_date: null,
      });

    expect(updateRes.statusCode).toBe(200);
    expect(updateRes.body.check.status).toBe("pending");

    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: checkId,
      },
    });

    expect(tx).toBeNull();
  });

  test("deleting a standalone check removes linked transaction", async () => {
    const { token } = await createAuthUser(
      "check-basic4@test.com",
      "+14155550504",
    );

    const createRes = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-1005",
        amount: 1200,
        issue_date: "2026-04-01",
        cashing_date: "2026-04-04",
        status: "cashed",
        type: "incoming",
        company_name: "abo ali",
      });

    const checkId = createRes.body.check.id;

    const deleteRes = await request(app)
      .delete(`/api/checks/${checkId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(deleteRes.statusCode).toBe(200);

    const check = await models.Check.findByPk(checkId);
    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: checkId,
      },
    });

    expect(check).toBeNull();
    expect(tx).toBeNull();
  });

  test("pending sale check that becomes cashed keeps debt unchanged and creates transaction", async () => {
    const { token, user } = await createAuthUser(
      "check-sale1@test.com",
      "+14155550511",
    );

    const customer = await createCustomerForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 100,
    });

    const createSaleRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: customer.id,
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
            payment_method: "check",
            amount: 20000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-SALE-1",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(createSaleRes.statusCode).toBe(201);

    const saleId = createSaleRes.body.sale.id;
    const check = await models.Check.findOne({
      where: { check_number: "CHK-SALE-1" },
    });

    expect(Number(createSaleRes.body.sale.paid_amount)).toBe(20000);
    expect(Number(createSaleRes.body.sale.remaining_amount)).toBe(30000);
    expect(createSaleRes.body.sale.payment_status).toBe("partial");

    const updateRes = await request(app)
      .patch(`/api/checks/${check.id}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        status: "cashed",
        cashing_date: "2026-04-13",
      });

    expect(updateRes.statusCode).toBe(200);

    const sale = await models.Sale.findByPk(saleId);
    expect(Number(sale.paid_amount)).toBe(20000);
    expect(Number(sale.remaining_amount)).toBe(30000);
    expect(sale.payment_status).toBe("partial");

    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: check.id,
      },
    });

    expect(tx).not.toBeNull();
    expect(tx.category).toBe("check_in");
    expect(Number(tx.amount)).toBe(20000);
  });

  test("pending sale check that becomes bounced removes its effect from debt", async () => {
    const { token, user } = await createAuthUser(
      "check-sale2@test.com",
      "+14155550512",
    );

    const customer = await createCustomerForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 100,
    });

    const createSaleRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: customer.id,
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
            payment_method: "check",
            amount: 20000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-SALE-2",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(createSaleRes.statusCode).toBe(201);

    const saleId = createSaleRes.body.sale.id;
    const check = await models.Check.findOne({
      where: { check_number: "CHK-SALE-2" },
    });

    const updateRes = await request(app)
      .patch(`/api/checks/${check.id}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        status: "bounced",
      });

    expect(updateRes.statusCode).toBe(200);

    const sale = await models.Sale.findByPk(saleId);
    expect(Number(sale.paid_amount)).toBe(0);
    expect(Number(sale.remaining_amount)).toBe(50000);
    expect(sale.payment_status).toBe("unpaid");

    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: check.id,
      },
    });

    expect(tx).toBeNull();
  });

  test("changing linked sale check amount updates payment amount and debt fields", async () => {
    const { token, user } = await createAuthUser(
      "check-sale3@test.com",
      "+14155550513",
    );

    const customer = await createCustomerForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 100,
    });

    const createSaleRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: customer.id,
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
            payment_method: "check",
            amount: 10000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-SALE-3",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(createSaleRes.statusCode).toBe(201);

    const saleId = createSaleRes.body.sale.id;
    const check = await models.Check.findOne({
      where: { check_number: "CHK-SALE-3" },
    });

    const updateRes = await request(app)
      .patch(`/api/checks/${check.id}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        amount: 15000,
      });

    expect(updateRes.statusCode).toBe(200);

    const payment = await models.Payment.findOne({
      where: { check_id: check.id },
    });

    expect(Number(payment.amount)).toBe(15000);

    const sale = await models.Sale.findByPk(saleId);
    expect(Number(sale.paid_amount)).toBe(15000);
    expect(Number(sale.remaining_amount)).toBe(35000);
    expect(sale.payment_status).toBe("partial");
  });

  test("pending purchase check that becomes bounced removes its effect from debt", async () => {
    const { token, user } = await createAuthUser(
      "check-purchase1@test.com",
      "+14155550514",
    );

    const supplier = await createSupplierForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);

    const createPurchaseRes = await request(app)
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
            payment_method: "check",
            amount: 10000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "OUT-PUR-1",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(createPurchaseRes.statusCode).toBe(201);

    const purchaseId = createPurchaseRes.body.purchase.id;
    const check = await models.Check.findOne({
      where: { check_number: "OUT-PUR-1" },
    });

    const updateRes = await request(app)
      .patch(`/api/checks/${check.id}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        status: "bounced",
      });

    expect(updateRes.statusCode).toBe(200);

    const purchase = await models.Purchase.findByPk(purchaseId);
    expect(Number(purchase.paid_amount)).toBe(0);
    expect(Number(purchase.remaining_amount)).toBe(30000);
    expect(purchase.payment_status).toBe("unpaid");
  });

  test("cannot delete check linked to payment", async () => {
    const { token, user } = await createAuthUser(
      "check-linked-delete@test.com",
      "+14155550515",
    );

    const customer = await createCustomerForUser(user.id);
    const warehouse = await createWarehouseForUser(user.id);
    const storage = await createStorageForWarehouse(warehouse.id, {
      quantity: 100,
    });

    const createSaleRes = await request(app)
      .post("/api/sales")
      .set("Authorization", `Bearer ${token}`)
      .send({
        partner_id: customer.id,
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
            payment_method: "check",
            amount: 20000,
            payment_date: "2026-04-12",
            check: {
              bank_name: "ABC Bank",
              check_number: "CHK-LINKED-1",
              issue_date: "2026-04-12",
              status: "pending",
            },
          },
        ],
      });

    expect(createSaleRes.statusCode).toBe(201);

    const check = await models.Check.findOne({
      where: { check_number: "CHK-LINKED-1" },
    });

    const deleteRes = await request(app)
      .delete(`/api/checks/${check.id}`)
      .set("Authorization", `Bearer ${token}`);

    expect(deleteRes.statusCode).toBe(400);

    const stillThere = await models.Check.findByPk(check.id);
    expect(stillThere).not.toBeNull();
  });

  test("unauthenticated purchase creation returns 401", async () => {
    const res = await request(app).post("/api/purchases").send({
      purchase_date: "2026-04-12",
      items: [],
      payments: [],
    });

    expect(res.statusCode).toBe(401);
  });
});
