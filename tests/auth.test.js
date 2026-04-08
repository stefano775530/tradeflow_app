const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { cleanDatabase } = require("./helpers/cleanup");

describe("Auth API", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  afterAll(async () => {
    await models.sequelize.close();
  });

  test("signup succeeds", async () => {
    const res = await request(app).post("/api/user/signup").send({
      name: "Adnan",
      email: "adnan@test.com",
      password: "123456",
      phone_number: "+14155550111",
    });

    expect(res.statusCode).toBe(201);
    expect(res.body.message).toBe("User created successfully");
    expect(res.body.userId).toBeDefined();
  });

  test("login succeeds", async () => {
    await request(app).post("/api/user/signup").send({
      name: "Adnan",
      email: "adnan@test.com",
      password: "123456",
      phone_number: "+14155550111",
    });

    const res = await request(app).post("/api/user/login").send({
      email: "adnan@test.com",
      password: "123456",
    });

    expect(res.statusCode).toBe(200);
    expect(res.body.token).toBeDefined();
  });

  test("login with wrong password returns 401", async () => {
    await request(app).post("/api/user/signup").send({
      name: "Adnan",
      email: "adnan@test.com",
      password: "123456",
      phone_number: "+14155550111",
    });

    const res = await request(app).post("/api/user/login").send({
      email: "adnan@test.com",
      password: "wrongpass",
    });

    expect(res.statusCode).toBe(401);
    expect(res.body.message).toBe("Invalid credentials!");
  });

  test("protected route without token returns 401", async () => {
    const res = await request(app).get("/api/checks");

    expect(res.statusCode).toBe(401);
  });

  test("protected route with invalid token returns 401", async () => {
    const res = await request(app)
      .get("/api/checks")
      .set("Authorization", "Bearer invalid_token_here");

    expect(res.statusCode).toBe(401);
  });
});
