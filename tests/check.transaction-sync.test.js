const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { cleanDatabase } = require("./helpers/cleanup");
const { createUserAndLogin } = require("./helpers/auth");

describe("Checks linked transaction sync", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  test("outgoing cashed check creates expense transaction", async () => {
    const { token } = await createUserAndLogin({
      email: "sync1@test.com",
      phone_number: "+14155550171",
    });

    const res = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "SYNC-1",
        amount: 650,
        issue_date: "2026-04-01",
        cashing_date: "2026-04-03",
        status: "cashed",
        type: "outgoing",
      });

    expect(res.statusCode).toBe(201);

    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: res.body.check.id,
      },
    });

    expect(tx).not.toBeNull();
    expect(tx.type).toBe("expense");
    expect(tx.category).toBe("check_out");
    expect(Number(tx.amount)).toBe(650);
  });

  test("updating check amount updates linked transaction amount", async () => {
    const { token } = await createUserAndLogin({
      email: "sync2@test.com",
      phone_number: "+14155550172",
    });

    const createRes = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "SYNC-2",
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
        amount: 900,
      });

    expect(updateRes.statusCode).toBe(200);

    const tx = await models.Transaction.findOne({
      where: {
        reference_type: "check",
        reference_id: checkId,
      },
    });

    expect(tx).not.toBeNull();
    expect(Number(tx.amount)).toBe(900);
  });
});
