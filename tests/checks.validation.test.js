const request = require("supertest");
const app = require("../app");
const { cleanDatabase } = require("./helpers/cleanup");
const { createUserAndLogin } = require("./helpers/auth");

describe("Checks validation", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  test("cashed check without cashing_date returns 400", async () => {
    const { token } = await createUserAndLogin({
      email: "cv1@test.com",
      phone_number: "+14155550161",
    });

    const res = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-V-1",
        amount: 500,
        issue_date: "2026-04-01",
        status: "cashed",
        type: "incoming",
        company_name: "abo ali",
      });

    expect(res.statusCode).toBe(400);
  });

  test("pending check with cashing_date returns 400", async () => {
    const { token } = await createUserAndLogin({
      email: "cv2@test.com",
      phone_number: "+14155550162",
    });

    const res = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-V-2",
        amount: 500,
        issue_date: "2026-04-01",
        cashing_date: "2026-04-05",
        status: "pending",
        type: "incoming",
        company_name: "abo ali",
      });

    expect(res.statusCode).toBe(400);
  });

  test("cashing date before issue date returns 400", async () => {
    const { token } = await createUserAndLogin({
      email: "cv3@test.com",
      phone_number: "+14155550163",
    });

    const res = await request(app)
      .post("/api/checks")
      .set("Authorization", `Bearer ${token}`)
      .send({
        bank_name: "ABC Bank",
        check_number: "CHK-V-3",
        amount: 500,
        issue_date: "2026-04-10",
        cashing_date: "2026-04-05",
        status: "cashed",
        type: "incoming",
        company_name: "abo ali",
      });

    expect(res.statusCode).toBe(400);
  });
});
