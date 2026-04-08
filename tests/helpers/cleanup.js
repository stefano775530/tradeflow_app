const models = require("../../models");

async function cleanDatabase() {
  await models.Transaction.destroy({ where: {}, force: true });
  await models.Check.destroy({ where: {}, force: true });
  await models.Storage.destroy({ where: {}, force: true });
  await models.Warehouse.destroy({ where: {}, force: true });
  await models.Partner.destroy({ where: {}, force: true });
  await models.PasswordReset.destroy({ where: {}, force: true });
  await models.User.destroy({ where: {}, force: true });
}

module.exports = { cleanDatabase };
