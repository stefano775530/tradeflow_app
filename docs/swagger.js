const swaggerJSDoc = require("swagger-jsdoc");

const options = {
  definition: {
    openapi: "3.0.4",
    info: {
      title: "warehouse Management API",
      version: "1.0.0",
      description:
        "REST API for authentication, warehouses, storage, checks, transactions, reports, partners, and alerts.",
    },
    servers: [
      {
        url: "http://localhost:3000",
        description: "Local development server",
      },
    ],
    tags: [
      { name: "Auth", description: "Authentication endpoints" },
      { name: "Warehouses", description: "Warehouse management endpoints" },
      { name: "Storage", description: "Storage item endpoints" },
      { name: "Checks", description: "Check management endpoints" },
      { name: "Transactions", description: "Transaction endpoints" },
      { name: "Partners", description: "Partner endpoints" },
      { name: "Reports", description: "Reporting endpoints" },
      { name: "Alerts", description: "Alert endpoints" },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: "http",
          scheme: "bearer",
          bearerFormat: "JWT",
        },
      },
      schemas: {
        ErrorResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Something went wrong",
            },
          },
        },

        UnauthorizedResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Invalid or expired token",
            },
          },
        },

        TooManyRequestsResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Too many login attempts, please try again later.",
            },
          },
        },

        ValidationErrorItem: {
          type: "object",
          properties: {
            type: { type: "string", example: "field" },
            value: { example: "bad-value" },
            msg: { type: "string", example: "Name is required" },
            path: { type: "string", example: "name" },
            location: { type: "string", example: "body" },
          },
        },

        ValidationErrorResponse: {
          type: "object",
          properties: {
            errors: {
              type: "array",
              items: {
                $ref: "#/components/schemas/ValidationErrorItem",
              },
            },
          },
        },

        AuthTokenResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Authentication successful!",
            },
            token: {
              type: "string",
              example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
            },
          },
        },

        SignupSuccessResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "User created successfully",
            },
            userId: {
              type: "integer",
              example: 1,
            },
          },
        },

        ForgotPasswordRequest: {
          type: "object",
          required: ["email"],
          properties: {
            email: {
              type: "string",
              format: "email",
              example: "adnan@test.com",
            },
          },
        },

        ForgotPasswordSuccessResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example:
                "If an account with that email exists, a reset link has been sent.",
            },
          },
        },

        ResetPasswordRequest: {
          type: "object",
          required: ["password"],
          properties: {
            password: {
              type: "string",
              format: "password",
              example: "newpassword123",
            },
          },
        },

        ResetPasswordSuccessResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Password reset successfully",
            },
          },
        },

        UserSignupRequest: {
          type: "object",
          required: ["name", "email", "password"],
          properties: {
            name: {
              type: "string",
              example: "Adnan",
            },
            email: {
              type: "string",
              format: "email",
              example: "adnan@test.com",
            },
            password: {
              type: "string",
              format: "password",
              example: "123456",
            },
            phone_number: {
              type: "string",
              example: "+14155550111",
            },
          },
        },

        UserLoginRequest: {
          type: "object",
          required: ["email", "password"],
          properties: {
            email: {
              type: "string",
              format: "email",
              example: "adnan@test.com",
            },
            password: {
              type: "string",
              format: "password",
              example: "123456",
            },
          },
        },

        User: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            name: { type: "string", example: "Adnan" },
            email: {
              type: "string",
              format: "email",
              example: "adnan@test.com",
            },
            phone_number: {
              type: "string",
              example: "+14155550111",
            },
            createdAt: {
              type: "string",
              format: "date-time",
            },
            updatedAt: {
              type: "string",
              format: "date-time",
            },
          },
        },

        Warehouse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            name: { type: "string", example: "Main Warehouse" },
            location: { type: "string", example: "Seattle" },
            user_id: { type: "integer", example: 1 },
            createdAt: {
              type: "string",
              format: "date-time",
            },
            updatedAt: {
              type: "string",
              format: "date-time",
            },
          },
        },

        WarehouseCreateRequest: {
          type: "object",
          required: ["name"],
          properties: {
            name: { type: "string", example: "Main Warehouse" },
            location: { type: "string", example: "Seattle" },
          },
        },

        WarehouseUpdateRequest: {
          type: "object",
          properties: {
            name: { type: "string", example: "Updated Warehouse" },
            location: { type: "string", example: "New York" },
          },
        },

        WarehouseCreateResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Warehouse created successfully",
            },
            warehouse: {
              $ref: "#/components/schemas/Warehouse",
            },
          },
        },

        WarehouseUpdateResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Warehouse updated successfully",
            },
            warehouse: {
              $ref: "#/components/schemas/Warehouse",
            },
          },
        },

        Storage: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            name: { type: "string", example: "Rice" },
            quantity: { type: "integer", example: 100 },
            expiration_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-12-31",
            },
            minimum_quantity: {
              type: "integer",
              example: 10,
            },
            purchase_price: {
              type: "number",
              example: 5,
            },
            sale_price: {
              type: "number",
              example: 8,
            },
            warehouse_id: {
              type: "integer",
              example: 1,
            },
            createdAt: {
              type: "string",
              format: "date-time",
            },
            updatedAt: {
              type: "string",
              format: "date-time",
            },
          },
        },

        StorageCreateRequest: {
          type: "object",
          required: ["name", "quantity", "purchase_price", "sale_price"],
          properties: {
            name: { type: "string", example: "Rice" },
            quantity: { type: "integer", example: 100 },
            expiration_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-12-31",
            },
            minimum_quantity: {
              type: "integer",
              example: 10,
            },
            purchase_price: {
              type: "number",
              example: 5,
            },
            sale_price: {
              type: "number",
              example: 8,
            },
          },
        },

        StorageUpdateRequest: {
          type: "object",
          properties: {
            name: { type: "string", example: "Premium Rice" },
            quantity: { type: "integer", example: 120 },
            expiration_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2027-01-15",
            },
            minimum_quantity: {
              type: "integer",
              example: 15,
            },
            purchase_price: {
              type: "number",
              example: 6,
            },
            sale_price: {
              type: "number",
              example: 9,
            },
          },
        },

        StorageCreateResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Storage created successfully",
            },
            storage: {
              $ref: "#/components/schemas/Storage",
            },
          },
        },

        StorageUpdateResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Storage updated successfully",
            },
            storage: {
              $ref: "#/components/schemas/Storage",
            },
          },
        },

        Check: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            bank_name: { type: "string", example: "ABC Bank" },
            check_number: { type: "string", example: "CHK-1001" },
            amount: { type: "number", example: 500 },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-01",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-04-05",
            },
            status: {
              type: "string",
              enum: ["pending", "cashed", "bounced"],
              example: "pending",
            },
            type: {
              type: "string",
              enum: ["incoming", "outgoing"],
              example: "incoming",
            },
            user_id: { type: "integer", example: 1 },
            createdAt: {
              type: "string",
              format: "date-time",
            },
            updatedAt: {
              type: "string",
              format: "date-time",
            },
          },
        },

        CheckCreateRequest: {
          type: "object",
          required: [
            "bank_name",
            "check_number",
            "amount",
            "issue_date",
            "type",
          ],
          properties: {
            bank_name: { type: "string", example: "ABC Bank" },
            check_number: { type: "string", example: "CHK-1001" },
            amount: { type: "number", example: 500 },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-01",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-04-05",
            },
            status: {
              type: "string",
              enum: ["pending", "cashed", "bounced"],
              example: "pending",
            },
            type: {
              type: "string",
              enum: ["incoming", "outgoing"],
              example: "incoming",
            },
          },
        },

        CheckUpdateRequest: {
          type: "object",
          properties: {
            bank_name: { type: "string", example: "XYZ Bank" },
            check_number: { type: "string", example: "CHK-2001" },
            amount: { type: "number", example: 900 },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-01",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-04-08",
            },
            status: {
              type: "string",
              enum: ["pending", "cashed", "bounced"],
              example: "cashed",
            },
            type: {
              type: "string",
              enum: ["incoming", "outgoing"],
              example: "outgoing",
            },
          },
        },

        CheckResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Check created",
            },
            check: {
              $ref: "#/components/schemas/Check",
            },
          },
        },

        Transaction: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            type: {
              type: "string",
              enum: ["income", "expense"],
              example: "income",
            },
            category: {
              type: "string",
              example: "sale",
            },
            amount: {
              type: "number",
              example: 150,
            },
            description: {
              type: "string",
              example: "Sale income",
            },
            transaction_date: {
              type: "string",
              format: "date",
              example: "2026-04-05",
            },
            reference_type: {
              type: "string",
              nullable: true,
              example: "check",
            },
            reference_id: {
              type: "integer",
              nullable: true,
              example: 3,
            },
            user_id: { type: "integer", example: 1 },
            createdAt: {
              type: "string",
              format: "date-time",
            },
            updatedAt: {
              type: "string",
              format: "date-time",
            },
          },
        },

        TransactionCreateRequest: {
          type: "object",
          required: ["type", "category", "amount", "transaction_date"],
          properties: {
            type: {
              type: "string",
              enum: ["income", "expense"],
              example: "income",
            },
            category: {
              type: "string",
              example: "sale",
            },
            amount: {
              type: "number",
              example: 150,
            },
            description: {
              type: "string",
              example: "Sale income",
            },
            transaction_date: {
              type: "string",
              format: "date",
              example: "2026-04-05",
            },
            reference_type: {
              type: "string",
              nullable: true,
              example: "check",
            },
            reference_id: {
              type: "integer",
              nullable: true,
              example: 1,
            },
          },
        },

        TransactionUpdateRequest: {
          type: "object",
          properties: {
            type: {
              type: "string",
              enum: ["income", "expense"],
              example: "expense",
            },
            category: {
              type: "string",
              example: "rent",
            },
            amount: {
              type: "number",
              example: 250,
            },
            description: {
              type: "string",
              example: "Office rent",
            },
            transaction_date: {
              type: "string",
              format: "date",
              example: "2026-04-06",
            },
          },
        },

        TransactionResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Transaction created successfully",
            },
            transaction: {
              $ref: "#/components/schemas/Transaction",
            },
          },
        },

        Partner: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            company_name: { type: "string", example: "Supplier One" },
            phone_number: { type: "string", example: "+14155550190" },
            partner_type: { type: "string", example: "supplier" },
            user_id: { type: "integer", example: 1 },
            createdAt: {
              type: "string",
              format: "date-time",
            },
            updatedAt: {
              type: "string",
              format: "date-time",
            },
          },
        },

        PartnerCreateRequest: {
          type: "object",
          required: ["name"],
          properties: {
            company_name: { type: "string", example: "Supplier One" },
            phone_number: { type: "string", example: "+14155550190" },
          },
        },

        PartnerUpdateRequest: {
          type: "object",
          properties: {
            company_name: { type: "string", example: "Updated Supplier" },
            phone_number: { type: "string", example: "+14155550191" },
          },
        },

        Alert: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            message: {
              type: "string",
              example: "Storage item is below minimum quantity",
            },
            type: {
              type: "string",
              example: "low_stock",
            },
            is_read: {
              type: "boolean",
              example: false,
            },
            user_id: {
              type: "integer",
              example: 1,
            },
            createdAt: {
              type: "string",
              format: "date-time",
            },
            updatedAt: {
              type: "string",
              format: "date-time",
            },
          },
        },

        LowStockAlert: {
          type: "object",
          properties: {
            storage_id: { type: "integer", example: 1 },
            name: { type: "string", example: "Rice" },
            quantity: { type: "integer", example: 3 },
            minimum_quantity: { type: "integer", example: 10 },
            warehouse_id: { type: "integer", example: 1 },
            warehouse_name: { type: "string", example: "Main Warehouse" },
          },
        },

        ExpiringItemAlert: {
          type: "object",
          properties: {
            storage_id: { type: "integer", example: 2 },
            name: { type: "string", example: "Milk" },
            expiration_date: {
              type: "string",
              format: "date",
              example: "2026-04-15",
            },
            warehouse_id: { type: "integer", example: 1 },
            warehouse_name: { type: "string", example: "Main Warehouse" },
          },
        },

        MonthlyReportResponse: {
          type: "object",
          properties: {
            month: {
              type: "string",
              example: "2026-04",
            },
            totalIncome: {
              type: "number",
              example: 5000,
            },
            totalExpense: {
              type: "number",
              example: 3200,
            },
            netProfit: {
              type: "number",
              example: 1800,
            },
          },
        },

        CategoryReportItem: {
          type: "object",
          properties: {
            category: {
              type: "string",
              example: "sale",
            },
            total: {
              type: "number",
              example: 1500,
            },
          },
        },

        DashboardSummaryResponse: {
          type: "object",
          properties: {
            totalWarehouses: {
              type: "integer",
              example: 3,
            },
            totalStorageItems: {
              type: "integer",
              example: 25,
            },
            totalTransactions: {
              type: "integer",
              example: 42,
            },
            totalChecks: {
              type: "integer",
              example: 8,
            },
            totalPendingChecks: {
              type: "integer",
              example: 2,
            },
            totalCashedChecks: {
              type: "integer",
              example: 5,
            },
            totalBouncedChecks: {
              type: "integer",
              example: 0,
            },
            totalIncome: {
              type: "integer",
              example: 9000,
            },
            totalExpense: {
              type: "integer",
              example: 1200,
            },
            netProfit: {
              type: "integer",
              example: 7800,
            },
          },
        },

        YearlyMonthlyBreakdownItem: {
          type: "object",
          properties: {
            month: {
              type: "integer",
              example: 1,
            },
            income: {
              type: "number",
              example: 0,
            },
            expense: {
              type: "number",
              example: 0,
            },
            netProfit: {
              type: "number",
              example: 0,
            },
          },
        },

        YearlyReportResponse: {
          type: "object",
          properties: {
            year: {
              type: "integer",
              example: 2026,
            },
            totalIncome: {
              type: "number",
              example: 0,
            },
            totalExpense: {
              type: "number",
              example: 0,
            },
            netProfit: {
              type: "number",
              example: 0,
            },
            monthlyBreakdown: {
              type: "array",
              items: {
                $ref: "#/components/schemas/YearlyMonthlyBreakdownItem",
              },
            },
          },
        },

        InventoryValuationWarehouse: {
          type: "object",
          properties: {
            id: {
              type: "integer",
              example: 2,
            },
            name: {
              type: "string",
              example: "samsr warehouse",
            },
            location: {
              type: "string",
              example: "syria",
            },
          },
        },

        InventoryValuationItem: {
          type: "object",
          properties: {
            id: {
              type: "integer",
              example: 3,
            },
            name: {
              type: "string",
              example: "potato",
            },
            quantity: {
              type: "integer",
              example: 500,
            },
            minimum_quantity: {
              type: "integer",
              example: 40,
            },
            purchase_price: {
              type: "number",
              example: 20,
            },
            sale_price: {
              type: "number",
              example: 40,
            },
            purchaseValue: {
              type: "number",
              example: 10000,
            },
            saleValue: {
              type: "number",
              example: 20000,
            },
            expectedProfit: {
              type: "number",
              example: 10000,
            },
            expiration_date: {
              type: "string",
              format: "date-time",
              example: "2026-06-20T00:00:00.000Z",
            },
            warehouse: {
              $ref: "#/components/schemas/InventoryValuationWarehouse",
            },
          },
        },

        InventoryValuationResponse: {
          type: "object",
          properties: {
            totalItems: {
              type: "integer",
              example: 2,
            },
            totalPurchaseValue: {
              type: "number",
              example: 10200,
            },
            totalSaleValue: {
              type: "number",
              example: 20300,
            },
            totalExpectedProfit: {
              type: "number",
              example: 10100,
            },
            items: {
              type: "array",
              items: {
                $ref: "#/components/schemas/InventoryValuationItem",
              },
            },
          },
        },

        ZakatReportResponse: {
          type: "object",
          properties: {
            totalIncome: {
              type: "number",
              example: 25000,
            },
            totalExpense: {
              type: "number",
              example: 625,
            },
            netCash: {
              type: "number",
              example: 0.025,
            },
            inventoryValue: {
              type: "number",
              example: 4000,
            },
            zakatBase: {
              type: "number",
              example: 20400,
            },
            zakatRate: {
              type: "number",
              example: 0.025,
            },
            zakatDue: {
              type: "number",
              example: 507.5,
            },
          },
        },
      },
    },
    security: [{ bearerAuth: [] }],
  },
  apis: ["./routes/*.js"],
};

module.exports = swaggerJSDoc(options);
