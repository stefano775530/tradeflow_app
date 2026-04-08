const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { cleanDatabase } = require("./helpers/cleanup");
const { createUserAndLogin } = require("./helpers/auth");

describe("Storage API", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  async function createWarehouse(token, data = {}) {
    const res = await request(app)
      .post("/api/warehouse")
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Warehouse 1",
        location: "Seattle",
        ...data,
      });

    return res.body.warehouse;
  }

  test("create storage inside a warehouse succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "storage1@test.com",
      phone_number: "+14155550131",
    });

    const warehouse = await createWarehouse(token);

    const res = await request(app)
      .post(`/api/warehouse/${warehouse.id}/storage`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Rice",
        quantity: 100,
        minimum_quantity: 10,
        purchase_price: 5,
        sale_price: 8,
        expiration_date: "2026-12-31",
      });

    expect(res.statusCode).toBe(201);
    expect(res.body.storage.name).toBe("Rice");
    expect(res.body.storage.warehouse_id).toBe(`${warehouse.id}`);
  });

  test("get all storage for a warehouse succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "storage2@test.com",
      phone_number: "+14155550132",
    });

    const warehouse = await createWarehouse(token);

    await request(app)
      .post(`/api/warehouse/${warehouse.id}/storage`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Sugar",
        quantity: 50,
        minimum_quantity: 5,
        purchase_price: 3,
        sale_price: 6,
      });

    const res = await request(app)
      .get(`/api/warehouse/${warehouse.id}/storage`)
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.length).toBe(1);
    expect(res.body[0].name).toBe("Sugar");
  });

  test("get one storage item succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "storage3@test.com",
      phone_number: "+14155550133",
    });

    const warehouse = await createWarehouse(token);

    const createRes = await request(app)
      .post(`/api/warehouse/${warehouse.id}/storage`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Tea",
        quantity: 20,
        minimum_quantity: 3,
        purchase_price: 2,
        sale_price: 4,
      });

    const storageId = createRes.body.storage.id;

    const res = await request(app)
      .get(`/api/warehouse/${warehouse.id}/storage/${storageId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.id).toBe(storageId);
    expect(res.body.name).toBe("Tea");
  });

  test("update storage succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "storage4@test.com",
      phone_number: "+14155550134",
    });

    const warehouse = await createWarehouse(token);

    const createRes = await request(app)
      .post(`/api/warehouse/${warehouse.id}/storage`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Coffee",
        quantity: 40,
        minimum_quantity: 5,
        purchase_price: 7,
        sale_price: 10,
      });

    const storageId = createRes.body.storage.id;

    const updateRes = await request(app)
      .patch(`/api/warehouse/${warehouse.id}/storage/${storageId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Premium Coffee",
        quantity: 55,
      });

    expect(updateRes.statusCode).toBe(200);
    expect(updateRes.body.storage.name).toBe("Premium Coffee");
    expect(updateRes.body.storage.quantity).toBe(55);

    const dbStorage = await models.Storage.findByPk(storageId);
    expect(dbStorage.name).toBe("Premium Coffee");
    expect(dbStorage.quantity).toBe(55);
  });

  test("delete storage succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "storage5@test.com",
      phone_number: "+14155550135",
    });

    const warehouse = await createWarehouse(token);

    const createRes = await request(app)
      .post(`/api/warehouse/${warehouse.id}/storage`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        name: "Milk",
        quantity: 15,
        minimum_quantity: 2,
        purchase_price: 4,
        sale_price: 6,
      });

    const storageId = createRes.body.storage.id;

    const deleteRes = await request(app)
      .delete(`/api/warehouse/${warehouse.id}/storage/${storageId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(deleteRes.statusCode).toBe(200);

    const dbStorage = await models.Storage.findByPk(storageId);
    expect(dbStorage).toBeNull();
  });

  test("unauthenticated storage access returns 401", async () => {
    const res = await request(app).get("/api/warehouse/1/storage");
    expect(res.statusCode).toBe(401);
  });

  test("user A cannot create storage in user B warehouse", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "storagea1@test.com",
      phone_number: "+14155550136",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "storageb1@test.com",
      phone_number: "+14155550137",
    });

    const warehouseB = await createWarehouse(tokenB, {
      name: "B Warehouse",
    });

    const res = await request(app)
      .post(`/api/warehouse/${warehouseB.id}/storage`)
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        name: "Unauthorized Item",
        quantity: 10,
        purchase_price: 1,
        sale_price: 2,
      });

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot view storage list in user B warehouse", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "storagea2@test.com",
      phone_number: "+14155550138",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "storageb2@test.com",
      phone_number: "+14155550139",
    });

    const warehouseB = await createWarehouse(tokenB);

    await request(app)
      .post(`/api/warehouse/${warehouseB.id}/storage`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        name: "B Item",
        quantity: 11,
        purchase_price: 2,
        sale_price: 3,
      });

    const res = await request(app)
      .get(`/api/warehouse/${warehouseB.id}/storage`)
      .set("Authorization", `Bearer ${tokenA}`);

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot view one storage item in user B warehouse", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "storagea3@test.com",
      phone_number: "+14155550140",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "storageb3@test.com",
      phone_number: "+14155550141",
    });

    const warehouseB = await createWarehouse(tokenB);

    const createRes = await request(app)
      .post(`/api/warehouse/${warehouseB.id}/storage`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        name: "Secret Item",
        quantity: 12,
        purchase_price: 2,
        sale_price: 4,
      });

    const storageId = createRes.body.storage.id;

    const res = await request(app)
      .get(`/api/warehouse/${warehouseB.id}/storage/${storageId}`)
      .set("Authorization", `Bearer ${tokenA}`);

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot update storage in user B warehouse", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "storagea4@test.com",
      phone_number: "+14155550142",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "storageb4@test.com",
      phone_number: "+14155550143",
    });

    const warehouseB = await createWarehouse(tokenB);

    const createRes = await request(app)
      .post(`/api/warehouse/${warehouseB.id}/storage`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        name: "Locked Item",
        quantity: 20,
        purchase_price: 5,
        sale_price: 7,
      });

    const storageId = createRes.body.storage.id;

    const res = await request(app)
      .patch(`/api/warehouse/${warehouseB.id}/storage/${storageId}`)
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        quantity: 999,
      });

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot delete storage in user B warehouse", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "storagea5@test.com",
      phone_number: "+14155550144",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "storageb5@test.com",
      phone_number: "+14155550145",
    });

    const warehouseB = await createWarehouse(tokenB);

    const createRes = await request(app)
      .post(`/api/warehouse/${warehouseB.id}/storage`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        name: "Delete Protected",
        quantity: 9,
        purchase_price: 2,
        sale_price: 5,
      });

    const storageId = createRes.body.storage.id;

    const res = await request(app)
      .delete(`/api/warehouse/${warehouseB.id}/storage/${storageId}`)
      .set("Authorization", `Bearer ${tokenA}`);

    expect(res.statusCode).toBe(404);
  });

  test("create storage without required fields returns 400", async () => {
    const { token } = await createUserAndLogin({
      email: "storage6@test.com",
      phone_number: "+14155550146",
    });

    const warehouse = await createWarehouse(token);

    const res = await request(app)
      .post(`/api/warehouse/${warehouse.id}/storage`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        quantity: 10,
      });

    expect(res.statusCode).toBe(400);
  });

  test("update non-existing storage returns 404", async () => {
    const { token } = await createUserAndLogin({
      email: "storage7@test.com",
      phone_number: "+14155550147",
    });

    const warehouse = await createWarehouse(token);

    const res = await request(app)
      .patch(`/api/warehouse/${warehouse.id}/storage/999999`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        quantity: 100,
      });

    expect(res.statusCode).toBe(404);
  });

  test("delete non-existing storage returns 404", async () => {
    const { token } = await createUserAndLogin({
      email: "storage8@test.com",
      phone_number: "+14155550148",
    });

    const warehouse = await createWarehouse(token);

    const res = await request(app)
      .delete(`/api/warehouse/${warehouse.id}/storage/999999`)
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(404);
  });
});
