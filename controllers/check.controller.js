const models = require("../models");
const checkService = require("../services/check.service");
const { AppError } = require("../utils/app-error");

async function createCheck(req, res) {
  const check = await checkService.createCheckForUser(
    req.userData.userId,
    req.body,
  );

  res.status(201).json({
    message: "Check created",
    check,
  });
}

async function getChecks(req, res) {
  const result = await checkService.getChecksForUser(
    req.userData.userId,
    req.query,
  );

  res.status(200).json(result);
}

async function getCheck(req, res) {
  const check = await models.Check.findOne({
    where: {
      id: req.params.id,
      user_id: req.userData.userId,
    },
  });

  if (!check) {
    throw new AppError(404, "Check not found");
  }

  res.status(200).json(check);
}

async function updateCheck(req, res) {
  const check = await checkService.updateCheckForUser(
    req.userData.userId,
    req.params.id,
    req.body,
  );

  res.status(200).json({
    message: "Check updated",
    check,
  });
}

async function deleteCheck(req, res) {
  await checkService.deleteCheckForUser(req.userData.userId, req.params.id);

  res.status(200).json({ message: "Check deleted" });
}

module.exports = {
  createCheck,
  getChecks,
  getCheck,
  updateCheck,
  deleteCheck,
};
