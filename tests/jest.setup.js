const models = require("../models");

afterAll(async () => {
  await models.sequelize.close();
});
