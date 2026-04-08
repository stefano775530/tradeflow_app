const request = require("supertest");
const app = require("../../app");

async function createUserAndLogin(overrides = {}) {
  const user = {
    name: "Test User",
    email: `test_${Date.now()}@mail.com`,
    password: "123456",
    phone_number: "+14155550123",
    ...overrides,
  };

  await request(app).post("/api/user/signup").send(user);

  const loginRes = await request(app).post("/api/user/login").send({
    email: user.email,
    password: user.password,
  });

  console.log("loginRes.body =", loginRes.body);

  return {
    user,
    token: loginRes.body.token,
  };
}

module.exports = { createUserAndLogin };
