const models = require("../models"); // تأكد من استدعاء المودلز بنفس الطريقة

// 1. إضافة شريك جديد (مرتبط بالـ User)
async function createPartner(req, res) {
  try {
    const { company_name, partner_type, phone_number } = req.body;

    // التحقق من المدخلات
    if (!company_name || !partner_type || !phone_number) {
      return res.status(400).json({ message: "جميع الحقول مطلوبة" });
    }

    const partner = await models.Partner.create({
      company_name,
      partner_type,
      phone_number,
      user_id: req.userData.userId, // ربط الشريك بالمستخدم الحالي
    });

    res.status(201).json({
      message: "Partner created successfully",
      partner,
    });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ message: "Something went wrong", error: err.message });
  }
}

// 2. جلب جميع شركاء المستخدم الحالي
async function getPartners(req, res) {
  try {
    const partners = await models.Partner.findAll({
      where: { user_id: req.userData.userId },
      order: [["createdAt", "DESC"]],
    });

    res.status(200).json(partners);
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

// 3. جلب شريك واحد محدد (بشرط أن يخص المستخدم)
async function getPartner(req, res) {
  try {
    const { id } = req.params;

    const partner = await models.Partner.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!partner) {
      return res.status(404).json({ message: "Partner not found" });
    }

    res.status(200).json(partner);
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

// 4. تحديث بيانات الشريك
async function updatePartner(req, res) {
  try {
    const { id } = req.params;
    const { company_name, partner_type, phone_number } = req.body;

    const partner = await models.Partner.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!partner) {
      return res.status(404).json({ message: "Partner not found" });
    }

    partner.company_name = company_name || partner.company_name;
    partner.partner_type = partner_type || partner.partner_type;
    partner.phone_number = phone_number || partner.phone_number;

    await partner.save();

    res.status(200).json({ message: "Updated successfully", partner });
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

// 5. حذف شريك
async function deletePartner(req, res) {
  try {
    const { id } = req.params;

    const partner = await models.Partner.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!partner) {
      return res.status(404).json({ message: "Partner not found" });
    }

    await partner.destroy();

    res.status(200).json({ message: "Partner deleted" });
  } catch (err) {
    res.status(500).json({ message: "Something went wrong" });
  }
}

module.exports = {
  createPartner,
  getPartners,
  getPartner,
  updatePartner,
  deletePartner,
};
