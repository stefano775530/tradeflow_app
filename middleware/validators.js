const { body, validationResult, param } = require("express-validator");

const validate = (validations) => {
  return async (req, res, next) => {
    await Promise.all(validations.map((validation) => validation.run(req)));

    const errors = validationResult(req);
    if (errors.isEmpty()) {
      return next();
    }

    return res.status(400).json({ errors: errors.array() });
  };
};

const signUpValidation = validate([
  body("name")
    .notEmpty()
    .withMessage("Name is required")
    .isLength({ min: 2 })
    .withMessage("Name must be at least 2 characters"),
  body("email").isEmail().withMessage("Must be a valid email"),
  body("password")
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters"),
  body("phone_number")
    .optional()
    .isMobilePhone()
    .withMessage("Must be a valid phone number"),
]);

const loginValidation = validate([
  body("email").isEmail().withMessage("Must be a valid email"),
  body("password").notEmpty().withMessage("Password is required"),
]);

const forgotPasswordValidation = validate([
  body("email").isEmail().withMessage("Must be a valid email"),
]);

const resetPasswordValidation = validate([
  body("password")
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters"),
]);

const createWarehouseValidation = validate([
  body("name")
    .trim()
    .notEmpty()
    .withMessage("Warehouse name is required")
    .isLength({ min: 2 })
    .withMessage("Name must be at least 2 characters")
    .isLength({ max: 100 })
    .withMessage("Name cannot exceed 100 characters"),

  body("location")
    .optional()
    .trim()
    .isLength({ max: 255 })
    .withMessage("Location cannot exceed 255 characters"),
]);

const updateWarehouseValidation = validate([
  body("name")
    .optional()
    .trim()
    .isLength({ min: 2 })
    .withMessage("Name must be at least 2 characters")
    .isLength({ max: 100 })
    .withMessage("Name cannot exceed 100 characters"),

  body("location")
    .optional()
    .trim()
    .isLength({ max: 255 })
    .withMessage("Location cannot exceed 255 characters"),
]);

const warehouseIdValidation = validate([
  param("id").isInt().withMessage("Warehouse ID must be an integer"),
]);

const storageValidation = validate([
  body("name")
    .notEmpty()
    .withMessage("Name is required")
    .isLength({ min: 2 })
    .withMessage("Name must be at least 2 characters"),
  body("quantity")
    .notEmpty()
    .withMessage("Quantity is required")
    .isInt({ min: 0 })
    .withMessage("Quantity must be a positive number"),
  body("expiration_date")
    .optional()
    .isDate()
    .withMessage("Expiration date must be valid"),
]);
const createPartnerValidation = validate([
  body("company_name")
    .trim()
    .notEmpty()
    .withMessage("اسم الشركة مطلوب")
    .isLength({ min: 3 })
    .withMessage("اسم الشركة يجب أن يكون 3 حروف على الأقل"),

  body("partner_type")
    .trim()
    .notEmpty()
    .withMessage("نوع الشريك مطلوب")
    .isIn(["supplier", "customer", "distributor"]) // مثال على أنواع محددة، يمكنك تعديلها أو حذف isIn
    .withMessage("نوع الشريك غير صالح"),

  body("phone_number")
    .trim()
    .notEmpty()
    .withMessage("رقم الهاتف مطلوب")
    .isMobilePhone()
    .withMessage("يرجى إدخال رقم هاتف صحيح"),
]);

const updatePartnerValidation = validate([
  body("company_name")
    .optional()
    .trim()
    .isLength({ min: 3 })
    .withMessage("اسم الشركة يجب أن يكون 3 حروف على الأقل"),

  body("partner_type")
    .optional()
    .trim()
    .isIn(["supplier", "customer", "distributor"])
    .withMessage("نوع الشريك غير صالح"),

  body("phone_number")
    .optional()
    .trim()
    .isMobilePhone()
    .withMessage("يرجى إدخال رقم هاتف صحيح"),
]);

const partnerIdValidation = validate([
  param("id").isInt().withMessage("Partner ID must be an integer"),
]);

module.exports = {
  signUpValidation,
  loginValidation,
  forgotPasswordValidation,
  resetPasswordValidation,

  createWarehouseValidation,
  updateWarehouseValidation,
  warehouseIdValidation,
  storageValidation,

  partnerIdValidation,
  createPartnerValidation,
  updatePartnerValidation,
};
