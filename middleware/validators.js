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

const createStorageValidation = validate([
  body("name")
    .notEmpty()
    .withMessage("Name is required")
    .isLength({ min: 2 })
    .withMessage("Name must be at least 2 characters"),

  body("quantity")
    .notEmpty()
    .withMessage("Quantity is required")
    .isInt({ min: 0 })
    .withMessage("Quantity must be a non-negative integer"),

  body("minimum_quantity")
    .optional()
    .isInt({ min: 0 })
    .withMessage("Minimum quantity must be a non-negative integer"),

  body("purchase_price")
    .notEmpty()
    .withMessage("Purchase price is required")
    .isFloat({ min: 0 })
    .withMessage("Purchase price must be a non-negative number"),

  body("sale_price")
    .notEmpty()
    .withMessage("Sale price is required")
    .isFloat({ min: 0 })
    .withMessage("Sale price must be a non-negative number"),

  body("expiration_date")
    .optional({ nullable: true })
    .isDate()
    .withMessage("Expiration date must be valid"),
]);

const updateStorageValidation = validate([
  body("name")
    .optional()
    .isLength({ min: 2 })
    .withMessage("Name must be at least 2 characters"),

  body("quantity")
    .optional()
    .isInt({ min: 0 })
    .withMessage("Quantity must be a non-negative integer"),

  body("minimum_quantity")
    .optional()
    .isInt({ min: 0 })
    .withMessage("Minimum quantity must be a non-negative integer"),

  body("purchase_price")
    .optional()
    .isFloat({ min: 0 })
    .withMessage("Purchase price must be a non-negative number"),

  body("sale_price")
    .optional()
    .isFloat({ min: 0 })
    .withMessage("Sale price must be a non-negative number"),

  body("expiration_date")
    .optional({ nullable: true })
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

const createCheckValidation = validate([
  body("bank_name")
    .notEmpty()
    .withMessage("Bank name is required")
    .isLength({ min: 2 })
    .withMessage("Bank name must be at least 2 characters"),

  body("check_number")
    .notEmpty()
    .withMessage("Check number is required")
    .isLength({ min: 3 })
    .withMessage("Check number must be valid"),

  body("amount")
    .notEmpty()
    .withMessage("Amount is required")
    .isFloat({ gt: 0 })
    .withMessage("Amount must be greater than 0"),

  body("issue_date")
    .notEmpty()
    .withMessage("Issue date is required")
    .isDate()
    .withMessage("Issue date must be valid"),
  body("company_name").notEmpty().withMessage("Company name is required"),
  body("cashing_date")
    .optional()
    .isDate()
    .withMessage("Cashing date must be valid")
    .custom((value, { req }) => {
      if (value && req.body.issue_date && value < req.body.issue_date) {
        throw new Error("Cashing date cannot be before issue date");
      }
      return true;
    }),

  body("type")
    .notEmpty()
    .withMessage("Type is required")
    .isIn(["incoming", "outgoing"])
    .withMessage("Type must be incoming or outgoing"),

  body("status")
    .optional()
    .isIn(["pending", "cashed", "bounced"])
    .custom((value, { req }) => {
      const cashingDate = req.body.cashing_date;

      if (value === "cashed" && !cashingDate) {
        throw new Error("Cashing date is required when status is cashed");
      }

      if (value === "pending" && cashingDate) {
        throw new Error("Pending check cannot have a cashing date");
      }

      return true;
    }),

  body().custom((_, { req }) => {
    const { status, cashing_date, company_name } = req.body;

    if (!status) {
      return true;
    }

    if (status === "cashed" && !cashing_date) {
      throw new Error("Cashing date is required when status is cashed");
    }

    if (status === "pending" && cashing_date) {
      throw new Error("Pending check cannot have a cashing date");
    }
    if (!company_name) {
      throw new Error("لازم تدخل اسم شركة ");
    }
    return true;
  }),
]);

const updateCheckValidation = validate([
  body("bank_name")
    .optional()
    .isLength({ min: 2 })
    .withMessage("Bank name must be at least 2 characters"),

  body("check_number")
    .optional()
    .isLength({ min: 3 })
    .withMessage("Check number must be valid"),

  body("amount")
    .optional()
    .isFloat({ gt: 0 })
    .withMessage("Amount must be greater than 0"),

  body("issue_date")
    .optional()
    .isDate()
    .withMessage("Issue date must be valid"),

  //body("company_name").optional().withMessage("Company name is required"),

  body("cashing_date")
    .optional({ nullable: true })
    .custom((value, { req }) => {
      if (value === null) {
        return true;
      }

      const issueDate = req.body.issue_date;

      const isValidDate = !isNaN(Date.parse(value));
      if (!isValidDate) {
        throw new Error("Cashing date must be valid");
      }

      if (issueDate && value < issueDate) {
        throw new Error("Cashing date cannot be before issue date");
      }

      return true;
    }),

  body("type")
    .optional()
    .isIn(["incoming", "outgoing"])
    .withMessage("Type must be incoming or outgoing"),

  body("status")
    .optional()
    .isIn(["pending", "cashed", "bounced"])
    .withMessage("Invalid status value"),

  body().custom((_, { req }) => {
    const { status, cashing_date, company_name } = req.body;

    if (status === "cashed" && !cashing_date) {
      throw new Error("Cashing date is required when status is cashed");
    }

    if (status === "pending" && cashing_date && cashing_date !== null) {
      throw new Error("Pending check cannot have a cashing date");
    }
    if (company_name === undefined) {
      return true;
    }

    // ❌ ولا واحد
    if (!company_name) {
      throw new Error("لازم يكون في اسم شركة أو اسم عميل");
    }

    return true;
  }),
]);

const createTransactionValidation = validate([
  body("type")
    .notEmpty()
    .withMessage("Type is required")
    .isIn(["income", "expense"])
    .withMessage("Type must be income or expense"),

  body("category")
    .notEmpty()
    .withMessage("Category is required")
    .isIn([
      "sale",
      "purchase",
      "rent",
      "salary",
      "check_in",
      "check_out",
      "other",
    ])
    .withMessage("Invalid category"),

  body("amount")
    .notEmpty()
    .withMessage("Amount is required")
    .isFloat({ gt: 0 })
    .withMessage("Amount must be greater than 0"),

  body("description")
    .optional()
    .isString()
    .withMessage("Description must be text")
    .isLength({ max: 255 })
    .withMessage("Description is too long"),

  body("transaction_date")
    .notEmpty()
    .withMessage("Transaction date is required")
    .isDate()
    .withMessage("Transaction date must be valid"),

  body("reference_type")
    .optional()
    .isIn(["check", "storage", "manual"])
    .withMessage("Reference type must be check, storage, or manual"),

  body("reference_id")
    .optional()
    .isInt({ gt: 0 })
    .withMessage("Reference id must be a positive integer"),

  body().custom((_, { req }) => {
    const { reference_type, reference_id } = req.body;

    if (reference_type && !reference_id) {
      throw new Error("Reference id is required when reference type exists");
    }

    if (!reference_type && reference_id) {
      throw new Error("Reference type is required when reference id exists");
    }

    return true;
  }),
]);

const updateTransactionValidation = validate([
  body("type")
    .optional()
    .isIn(["income", "expense"])
    .withMessage("Type must be income or expense"),

  body("category")
    .optional()
    .isIn([
      "sale",
      "purchase",
      "rent",
      "salary",
      "check_in",
      "check_out",
      "other",
    ])
    .withMessage("Invalid category"),

  body("amount")
    .optional()
    .isFloat({ gt: 0 })
    .withMessage("Amount must be greater than 0"),

  body("description")
    .optional()
    .isString()
    .withMessage("Description must be text")
    .isLength({ max: 255 })
    .withMessage("Description is too long"),

  body("transaction_date")
    .optional()
    .isDate()
    .withMessage("Transaction date must be valid"),

  body("reference_type")
    .optional()
    .isIn(["check", "storage", "manual"])
    .withMessage("Reference type must be check, storage, or manual"),

  body("reference_id")
    .optional()
    .isInt({ gt: 0 })
    .withMessage("Reference id must be a positive integer"),

  body().custom((_, { req }) => {
    const { reference_type, reference_id } = req.body;

    if (reference_type && !reference_id) {
      throw new Error("Reference id is required when reference type exists");
    }

    if (!reference_type && reference_id) {
      throw new Error("Reference type is required when reference id exists");
    }

    return true;
  }),
]);

module.exports = {
  signUpValidation,
  loginValidation,
  forgotPasswordValidation,
  resetPasswordValidation,

  createWarehouseValidation,
  updateWarehouseValidation,
  warehouseIdValidation,
  createStorageValidation,
  updateStorageValidation,

  partnerIdValidation,
  createPartnerValidation,
  updatePartnerValidation,

  createCheckValidation,
  updateCheckValidation,

  createTransactionValidation,
  updateTransactionValidation,
};
