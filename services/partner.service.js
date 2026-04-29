const models = require("../models");
const { AppError } = require("../utils/app-error");

async function createPartnerForUser(userId, payload) {
  const { company_name, partner_type, phone_number } = payload;

  const partner = await models.Partner.create({
    company_name,
    partner_type,
    phone_number,
    user_id: userId,
  });

  return partner;
}

async function getPartnersForUser(userId, query = {}) {
  const { page = 1, limit = 10, sortBy = "id", sortOrder = "DESC" } = query;

  const normalizedPage = Math.max(Number(page) || 1, 1);
  const normalizedLimit = Math.min(Math.max(Number(limit) || 10, 1), 100);
  const offset = (normalizedPage - 1) * normalizedLimit;

  const allowedSortFields = [
    "id",
    "company_name",
    "partner_type",
    "phone_number",
    "created_at",
  ];

  const finalSortBy = allowedSortFields.includes(sortBy) ? sortBy : "id";
  const finalSortOrder =
    String(sortOrder).toUpperCase() === "ASC" ? "ASC" : "DESC";

  const { count, rows } = await models.Partner.findAndCountAll({
    where: { user_id: userId },
    order: [
      [finalSortBy, finalSortOrder],
      ["id", "DESC"],
    ],
    limit: normalizedLimit,
    offset,
  });

  const totalItems = count;
  const totalPages = Math.ceil(totalItems / normalizedLimit) || 1;

  return {
    page: normalizedPage,
    limit: normalizedLimit,
    totalItems,
    totalPages,
    hasNextPage: normalizedPage < totalPages,
    hasPrevPage: normalizedPage > 1,
    data: rows,
  };
}

async function findOwnedPartnerOrThrow(userId, partnerId) {
  const partner = await models.Partner.findOne({
    where: {
      id: partnerId,
      user_id: userId,
    },
  });

  if (!partner) {
    throw new AppError(404, "Partner not found");
  }

  return partner;
}

async function updatePartnerForUser(userId, partnerId, payload) {
  const partner = await findOwnedPartnerOrThrow(userId, partnerId);

  const { company_name, partner_type, phone_number } = payload;

  partner.company_name =
    company_name !== undefined ? company_name : partner.company_name;
  partner.partner_type =
    partner_type !== undefined ? partner_type : partner.partner_type;
  partner.phone_number =
    phone_number !== undefined ? phone_number : partner.phone_number;

  await partner.save();

  return partner;
}

async function deletePartnerForUser(userId, partnerId) {
  const partner = await findOwnedPartnerOrThrow(userId, partnerId);
  await partner.destroy();
}

module.exports = {
  createPartnerForUser,
  getPartnersForUser,
  findOwnedPartnerOrThrow,
  updatePartnerForUser,
  deletePartnerForUser,
};
