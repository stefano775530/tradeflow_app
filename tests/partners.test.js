const request = require("supertest");
const app = require("../app");
const models = require("../models");
const { cleanDatabase } = require("./helpers/cleanup");
const { createUserAndLogin } = require("./helpers/auth");

describe("Partners API", () => {
  beforeEach(async () => {
    await cleanDatabase();
  });

  test("create partner succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "partner1@test.com",
      phone_number: "+14155550190",
    });

    const res = await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "Supplier One",
        partner_type: "supplier",
        phone_number: "+14155550191",
      });

    expect(res.statusCode).toBe(201);
    expect(res.body.partner.company_name).toBe("Supplier One");
    expect(res.body.partner.partner_type).toBe("supplier");
  });

  test("get partners returns paginated structure for current user only", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "partnera@test.com",
      phone_number: "+14155550192",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "partnerb@test.com",
      phone_number: "+14155550193",
    });

    await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        company_name: "A Company",
        partner_type: "customer",
        phone_number: "+14155550194",
      });

    await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        company_name: "B Company",
        partner_type: "supplier",
        phone_number: "+14155550195",
      });

    const res = await request(app)
      .get("/api/partners/all?page=1&limit=10")
      .set("Authorization", `Bearer ${tokenA}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.page).toBe(1);
    expect(res.body.limit).toBe(10);
    expect(res.body.totalItems).toBe(1);
    expect(res.body.totalPages).toBe(1);
    expect(Array.isArray(res.body.data)).toBe(true);
    expect(res.body.data.length).toBe(1);
    expect(res.body.data[0].company_name).toBe("A Company");
  });

  test("get partners respects limit and page", async () => {
    const { token } = await createUserAndLogin({
      email: "partnerpage@test.com",
      phone_number: "+14155550196",
    });

    for (let i = 1; i <= 5; i++) {
      await request(app)
        .post("/api/partners/add")
        .set("Authorization", `Bearer ${token}`)
        .send({
          company_name: `Company ${i}`,
          partner_type: "customer",
          phone_number: `+1415555019${i}`,
        });
    }

    const res = await request(app)
      .get("/api/partners/all?page=2&limit=2")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.page).toBe(2);
    expect(res.body.limit).toBe(2);
    expect(res.body.totalItems).toBe(5);
    expect(res.body.totalPages).toBe(3);
    expect(res.body.hasNextPage).toBe(true);
    expect(res.body.hasPrevPage).toBe(true);
    expect(res.body.data.length).toBe(2);
  });

  test("get partners sorts by company_name ascending", async () => {
    const { token } = await createUserAndLogin({
      email: "partnersort@test.com",
      phone_number: "+14155550200",
    });

    await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "Z Company",
        partner_type: "customer",
        phone_number: "+14155550201",
      });

    await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "A Company",
        partner_type: "supplier",
        phone_number: "+14155550202",
      });

    await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "M Company",
        partner_type: "customer",
        phone_number: "+14155550203",
      });

    const res = await request(app)
      .get("/api/partners/all?sortBy=company_name&sortOrder=asc")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.data.length).toBe(3);
    expect(res.body.data[0].company_name).toBe("A Company");
    expect(res.body.data[1].company_name).toBe("M Company");
    expect(res.body.data[2].company_name).toBe("Z Company");
  });

  test("get one partner succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "partnerone@test.com",
      phone_number: "+14155550204",
    });

    const createRes = await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "Single Partner",
        partner_type: "supplier",
        phone_number: "+14155550205",
      });

    const partnerId = createRes.body.partner.id;

    const res = await request(app)
      .get(`/api/partners/${partnerId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(200);
    expect(res.body.id).toBe(partnerId);
    expect(res.body.company_name).toBe("Single Partner");
  });

  test("update partner succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "partnerupdate@test.com",
      phone_number: "+14155550206",
    });

    const createRes = await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "Old Partner",
        partner_type: "supplier",
        phone_number: "+14155550207",
      });

    const partnerId = createRes.body.partner.id;

    const updateRes = await request(app)
      .patch(`/api/partners/${partnerId}`)
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "New Partner",
        partner_type: "customer",
      });

    expect(updateRes.statusCode).toBe(200);
    expect(updateRes.body.partner.company_name).toBe("New Partner");
    expect(updateRes.body.partner.partner_type).toBe("customer");

    const dbPartner = await models.Partner.findByPk(partnerId);
    expect(dbPartner.company_name).toBe("New Partner");
    expect(dbPartner.partner_type).toBe("customer");
  });

  test("delete partner succeeds", async () => {
    const { token } = await createUserAndLogin({
      email: "partnerdelete@test.com",
      phone_number: "+14155550208",
    });

    const createRes = await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "Delete Partner",
        partner_type: "supplier",
        phone_number: "+14155550209",
      });

    const partnerId = createRes.body.partner.id;

    const deleteRes = await request(app)
      .delete(`/api/partners/${partnerId}`)
      .set("Authorization", `Bearer ${token}`);

    expect(deleteRes.statusCode).toBe(200);

    const dbPartner = await models.Partner.findByPk(partnerId);
    expect(dbPartner).toBeNull();
  });

  test("unauthenticated partner access returns 401", async () => {
    const res = await request(app).get("/api/partners/all");
    expect(res.statusCode).toBe(401);
  });

  test("user A cannot read user B partner", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "partnera2@test.com",
      phone_number: "+14155550210",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "partnerb2@test.com",
      phone_number: "+14155550211",
    });

    const createRes = await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        company_name: "Private Partner",
        partner_type: "supplier",
        phone_number: "+14155550212",
      });

    const partnerId = createRes.body.partner.id;

    const res = await request(app)
      .get(`/api/partners/${partnerId}`)
      .set("Authorization", `Bearer ${tokenB}`);

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot update user B partner", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "partnera3@test.com",
      phone_number: "+14155550213",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "partnerb3@test.com",
      phone_number: "+14155550214",
    });

    const createRes = await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        company_name: "Locked Partner",
        partner_type: "supplier",
        phone_number: "+14155550215",
      });

    const partnerId = createRes.body.partner.id;

    const res = await request(app)
      .patch(`/api/partners/${partnerId}`)
      .set("Authorization", `Bearer ${tokenB}`)
      .send({
        company_name: "Hacked Partner",
      });

    expect(res.statusCode).toBe(404);
  });

  test("user A cannot delete user B partner", async () => {
    const { token: tokenA } = await createUserAndLogin({
      email: "partnera4@test.com",
      phone_number: "+14155550216",
    });

    const { token: tokenB } = await createUserAndLogin({
      email: "partnerb4@test.com",
      phone_number: "+14155550217",
    });

    const createRes = await request(app)
      .post("/api/partners/add")
      .set("Authorization", `Bearer ${tokenA}`)
      .send({
        company_name: "Protected Partner",
        partner_type: "supplier",
        phone_number: "+14155550218",
      });

    const partnerId = createRes.body.partner.id;

    const res = await request(app)
      .delete(`/api/partners/${partnerId}`)
      .set("Authorization", `Bearer ${tokenB}`);

    expect(res.statusCode).toBe(404);
  });

  test("update non-existing partner returns 404", async () => {
    const { token } = await createUserAndLogin({
      email: "partnermissing1@test.com",
      phone_number: "+14155550219",
    });

    const res = await request(app)
      .patch("/api/partners/999999")
      .set("Authorization", `Bearer ${token}`)
      .send({
        company_name: "Missing Partner",
      });

    expect(res.statusCode).toBe(404);
  });

  test("delete non-existing partner returns 404", async () => {
    const { token } = await createUserAndLogin({
      email: "partnermissing2@test.com",
      phone_number: "+14155550220",
    });

    const res = await request(app)
      .delete("/api/partners/999999")
      .set("Authorization", `Bearer ${token}`);

    expect(res.statusCode).toBe(404);
  });
});
