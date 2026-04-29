const partnerService = require("../services/partner.service");

async function createPartner(req, res) {
  const partner = await partnerService.createPartnerForUser(
    req.userData.userId,
    req.body,
  );

  res.status(201).json({
    message: "Partner created successfully",
    partner,
  });
}

async function getPartners(req, res) {
  const result = await partnerService.getPartnersForUser(
    req.userData.userId,
    req.query,
  );

  res.status(200).json(result);
}

async function getPartner(req, res) {
  const partner = await partnerService.findOwnedPartnerOrThrow(
    req.userData.userId,
    req.params.id,
  );

  res.status(200).json(partner);
}

async function updatePartner(req, res) {
  const partner = await partnerService.updatePartnerForUser(
    req.userData.userId,
    req.params.id,
    req.body,
  );

  res.status(200).json({
    message: "Updated successfully",
    partner,
  });
}

async function deletePartner(req, res) {
  await partnerService.deletePartnerForUser(req.userData.userId, req.params.id);

  res.status(200).json({ message: "Partner deleted" });
}

module.exports = {
  createPartner,
  getPartners,
  getPartner,
  updatePartner,
  deletePartner,
};
