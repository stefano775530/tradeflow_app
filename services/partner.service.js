const models = require("../models");
const { AppError } = require("../utils/app-error");
const { Sequelize } = require("sequelize"); // التعديل 1: استيراد Sequelize للعمليات الحسابية

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
  const {
    page = 1,
    limit = 10,
    sortBy = "id",
    sortOrder = "DESC",
    partner_type, // التعديل 2: استقبال نوع الشريك من الرابط (Query)
  } = query;

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

  // التعديل 3: بناء شرط البحث ليشمل التصفية حسب النوع
  const whereClause = { user_id: userId };
  if (partner_type) {
    whereClause.partner_type = partner_type;
  }

  const { count, rows } = await models.Partner.findAndCountAll({
    where: whereClause,
    // التعديل 4: إضافة حقل total_debt بحساب المبالغ المتبقية من جدول المشتريات
    attributes: {
      include: [
        [
          models.sequelize.literal(`(
            SELECT COALESCE(SUM(remaining_amount), 0)
            FROM Purchases
            WHERE Purchases.partner_id = Partner.id
          )`),
          "total_debt",
        ],
      ],
    },
    order: [
      [finalSortBy, finalSortOrder],
      ["id", "DESC"],
    ],
    limit: normalizedLimit,
    offset,
    distinct: true, // التعديل 5: ضمان دقة النتائج عند استخدام الـ Literal
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
