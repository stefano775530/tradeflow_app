const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { cleanDatabase } = require("./helpers/cleanup");
const { createUserAndLogin } = require("./helpers/auth");

describe("Warehouses API", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  afterAll(async () => {
    await models.sequelize.close();
  });

  test("create warehouse succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "warehouse@test.com",
      phone_number: "+14155550121",
    });

    const res = await request(app)
      .post("/api/warehouse")
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Main Warehouse",
        location: "Seattle",
      });

    expect(res.statusCode).toBe(201);
    expect(res.body.warehouse.name).toBe("Main Warehouse");
  });

  test("get all warehouses returns only current user warehouses", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "wa@test.com",
      phone_number: "+14155550122",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "wb@test.com",
      phone_number: "+14155550123",
    });

    await request(app)
      .post("/api/warehouse")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({ name: "A Warehouse", location: "A City" });

    await request(app)
      .post("/api/warehouse")
      .set("Authorization", `Bearer ${tokenB}`)
      .send({ name: "B Warehouse", location: "B City" });

    const res = await request(app)
      .get("/api/warehouse")
      .set("Authorization", `Bearer ${tokenA}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.length).toBe(1);
    expect(res.body[0].name).toBe("A Warehouse");
  });

  test("update warehouse succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "updatewarehouse@test.com",
      phone_number: "+14155550124",
    });

    const createRes = await request(app)
      .post("/api/warehouse")
      .set("Authorization", `Bearer ${token}`)
      .send({ name: "Old Name", location: "Old Location" });

    const warehouseId = createRes.body.warehouse.id;

    const updateRes = await request(app)
      .patch(`/api/warehouse/${warehouseId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({ name: "New Name", location: "New Location" });

    expect(updateRes.statusCode).toBe(200);
    expect(updateRes.body.warehouse.name).toBe("New Name");
    expect(updateRes.body.warehouse.location).toBe("New Location");
  });

  test("delete warehouse succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "deletewarehouse@test.com",
      phone_number: "+14155550125",
    });

    const createRes = await request(app)
      .post("/api/warehouse")
      .set("Authorization", `Bearer ${token}`)
      .send({ name: "Delete Me", location: "Somewhere" });

    const warehouseId = createRes.body.warehouse.id;

    const deleteRes = await request(app)
      .delete(`/api/warehouse/${warehouseId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(deleteRes.statusCode).toBe(200);

    const warehouse = await models.Warehouse.findByPk(warehouseId);
    expect(warehouse).toBeNull();
  });
});
