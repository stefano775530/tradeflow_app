const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { cleanDatabase } = require("./helpers/cleanup");
const { createUserAndLogin } = require("./helpers/auth");

describe("Checks ownership", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  afterAll(async () => {
    await models.sequelize.close();
  });

  test("user A cannot read user B check", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "a@test.com",
      phone_number: "+14155550101",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "b@test.com",
      phone_number: "+14155550102",
    });

    const createRes = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-A-1",
        amount: 300,
        issue_date: "2026-04-01",
        type: "incoming",
      });

    const checkId = createRes.body.check.id;

    const res = await request(app)
      .get(`/api/checks/${checkId}`)
      .set("Authorization", `Bearer ${tokenB}`);

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot update user B check", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "a@test.com",
      phone_number: "+14155550103",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "b@test.com",
      phone_number: "+14155550104",
    });

    const createRes = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-A-2",
        amount: 400,
        issue_date: "2026-04-01",
        type: "incoming",
      });

    const checkId = createRes.body.check.id;

    const res = await request(app)
      .patch(`/api/checks/${checkId}`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({ amount: 999 });

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot delete user B check", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "a@test.com",
      phone_number: "+14155550105",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "b@test.com",
      phone_number: "+14155550106",
    });

    const createRes = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-A-3",
        amount: 500,
        issue_date: "2026-04-01",
        type: "incoming",
      });

    const checkId = createRes.body.check.id;

    const res = await request(app)
      .delete(`/api/checks/${checkId}`)
      .set("Authorization", `Bearer ${tokenB}`);

    expect(res.statusCode).toBe(404);
  });
});
