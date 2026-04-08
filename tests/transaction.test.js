const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { cleanDatabase } = require("./helpers/cleanup");
const { createUserAndLogin } = require("./helpers/auth");

describe("Transactions API", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  test("create transaction succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "tx1@test.com",
      phone_number: "+14155550141",
    });

    const res = await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${token}`)
      .send({
        type: "income",
        category: "sale",
        amount: 150,
        description: "Sale income",
        transaction_date: "2026-04-05",
      });

    expect(res.statusCode).toBe(201);
    expect(Number(res.body.transaction.amount)).toBe(150);
    expect(res.body.transaction.description).toBe("Sale income");
  });

  test("get transactions returns current user transactions only", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "txa@test.com",
      phone_number: "+14155550142",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "txb@test.com",
      phone_number: "+14155550143",
    });

    await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        type: "income",
        category: "sale",
        amount: 100,
        description: "A transaction",
        transaction_date: "2026-04-05",
      });

    await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        type: "expense",
        category: "rent",
        amount: 80,
        description: "B transaction",
        transaction_date: "2026-04-05",
      });

    const res = await request(app)
      .get("/api/transactions")
      .set("Authorization", `Bearer ${tokenA}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.length).toBe(1);
    expect(res.body[0].description).toBe("A transaction");
  });

  test("get one transaction succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "tx2@test.com",
      phone_number: "+14155550144",
    });

    const createRes = await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${token}`)
      .send({
        type: "expense",
        category: "rent",
        amount: 75,
        description: "Monthly rent",
        transaction_date: "2026-04-05",
      });

    const transactionId = createRes.body.transaction.id;

    const res = await request(app)
      .get(`/api/transactions/${transactionId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.id).toBe(transactionId);
    expect(res.body.description).toBe("Monthly rent");
  });

  test("update transaction succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "tx3@test.com",
      phone_number: "+14155550145",
    });

    const createRes = await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${token}`)
      .send({
        type: "income",
        category: "sale",
        amount: 100,
        description: "Before update",
        transaction_date: "2026-04-05",
      });

    const transactionId = createRes.body.transaction.id;

    const updateRes = await request(app)
      .patch(`/api/transactions/${transactionId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        amount: 250,
        description: "After update",
      });

    expect(updateRes.statusCode).toBe(200);
    expect(Number(updateRes.body.transaction.amount)).toBe(250);
    expect(updateRes.body.transaction.description).toBe("After update");

    const dbTransaction = await models.Transaction.findByPk(transactionId);
    expect(Number(dbTransaction.amount)).toBe(250);
    expect(dbTransaction.description).toBe("After update");
  });

  test("delete transaction succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "tx4@test.com",
      phone_number: "+14155550146",
    });

    const createRes = await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${token}`)
      .send({
        type: "expense",
        category: "rent",
        amount: 75,
        description: "Delete me",
        transaction_date: "2026-04-05",
      });

    const transactionId = createRes.body.transaction.id;

    const deleteRes = await request(app)
      .delete(`/api/transactions/${transactionId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(deleteRes.statusCode).toBe(200);

    const dbTransaction = await models.Transaction.findByPk(transactionId);
    expect(dbTransaction).toBeNull();
  });

  test("unauthenticated transaction access returns 401", async () => {
    const res = await request(app).get("/api/transactions");
    expect(res.statusCode).toBe(401);
  });

  test("user A cannot read user B transaction", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "txa2@test.com",
      phone_number: "+14155550147",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "txb2@test.com",
      phone_number: "+14155550148",
    });

    const createRes = await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        type: "income",
        category: "sale",
        amount: 111,
        description: "Private tx",
        transaction_date: "2026-04-05",
      });

    const transactionId = createRes.body.transaction.id;

    const res = await request(app)
      .get(`/api/transactions/${transactionId}`)
      .set("Authorization", `Bearer ${tokenB}`);

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot update user B transaction", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "txa3@test.com",
      phone_number: "+14155550149",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "txb3@test.com",
      phone_number: "+14155550150",
    });

    const createRes = await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        type: "income",
        category: "sale",
        amount: 222,
        description: "Locked tx",
        transaction_date: "2026-04-05",
      });

    const transactionId = createRes.body.transaction.id;

    const res = await request(app)
      .patch(`/api/transactions/${transactionId}`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        amount: 999,
      });

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot delete user B transaction", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "txa4@test.com",
      phone_number: "+14155550151",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "txb4@test.com",
      phone_number: "+14155550152",
    });

    const createRes = await request(app)
      .post("/api/transactions")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        type: "expense",
        category: "rent",
        amount: 333,
        description: "Protected tx",
        transaction_date: "2026-04-05",
      });

    const transactionId = createRes.body.transaction.id;

    const res = await request(app)
      .delete(`/api/transactions/${transactionId}`)
      .set("Authorization", `Bearer ${tokenB}`);

    expect(res.statusCode).toBe(404);
  });

  test("update non-existing transaction returns 404", async () => {
    const { token } = await createUserAndLogin({
      email: "tx5@test.com",
      phone_number: "+14155550153",
    });

    const res = await request(app)
      .patch("/api/transactions/999999")
      .set("Authorization", `Bearer ${token}`)
      .send({
        amount: 999,
      });

    expect(res.statusCode).toBe(404);
  });

  test("delete non-existing transaction returns 404", async () => {
    const { token } = await createUserAndLogin({
      email: "tx6@test.com",
      phone_number: "+14155550154",
    });

    const res = await request(app)
      .delete("/api/transactions/999999")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(404);
  });
});
