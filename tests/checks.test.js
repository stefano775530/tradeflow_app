const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { createUserAndLogin } = require("./helpers/auth");

describe("Checks API", () => {
  beforeEach(async () => {
    await models.Transaction.destroy({ where: {} });
    await models.Check.destroy({ where: {} });
    await models.PasswordReset.destroy({ where: {} });
    await models.User.destroy({ where: {} });
  });

  test("rejects unauthenticated create check", async () => {
    const res = await request(app).post("/api/checks").send({
      bank_name: "ABC Bank",
      check_number: "CHK-1001",
      amount: 500,
      issue_date: "2026-04-01",
      type: "incoming",
    });

    expect(res.statusCode).toBe(401);
  });

  test("creates pending check without linked transaction", async () => {
    const { token } = await createUserAndLogin();

    const res = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-1002",
        amount: 500,
        issue_date: "2026-04-01",
        type: "incoming",
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

  test("creates cashed check with linked transaction", async () => {
    const { token } = await createUserAndLogin();

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

  test("updating a cashed check to pending removes linked transaction", async () => {
    const { token } = await createUserAndLogin();

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

  test("deleting a check removes linked transaction", async () => {
    const { token } = await createUserAndLogin();

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
});
