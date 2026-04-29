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
      { name: "Sales", description: "Sales workflow endpoints" },
      { name: "Purchases", description: "Purchase workflow endpoints" },
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
            created_at: {
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
            minimum_quantity: {
              type: "integer",
              example: 10,
            },
            thickness: {
              type: "string",
              example: "6",
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
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },

        StorageCreateRequest: {
          type: "object",
          required: [
            "name",
            "quantity",
            "purchase_price",
            "sale_price",
            "thickness",
          ],
          properties: {
            name: { type: "string", example: "wood" },
            quantity: { type: "integer", example: 100 },
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
            thickness: {
              type: "string",
              example: "6",
            },
          },
        },

        StorageUpdateRequest: {
          type: "object",
          properties: {
            name: { type: "string", example: "Premium wood" },
            quantity: { type: "integer", example: 120 },
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
            thickness: {
              type: "string",
              example: "6",
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
            company_name: { type: "string", example: "abo ali" },
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
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },

        CheckListResponse: {
          type: "object",
          properties: {
            page: { type: "integer", example: 1 },
            limit: { type: "integer", example: 10 },
            totalItems: { type: "integer", example: 25 },
            totalPages: { type: "integer", example: 3 },
            hasNextPage: { type: "boolean", example: true },
            hasPrevPage: { type: "boolean", example: false },
            data: {
              type: "array",
              items: {
                $ref: "#/components/schemas/Check",
              },
            },
          },
        },

        CheckCreateRequest: {
          type: "object",
          required: [
            "bank_name",
            "check_number",
            "company_name",
            "amount",
            "issue_date",
            "type",
          ],
          properties: {
            bank_name: { type: "string", example: "ABC Bank" },
            check_number: { type: "string", example: "CHK-1001" },
            company_name: { type: "string", example: "abo ali" },
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
            company_name: { type: "string", example: "abo ehab" },
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

        CheckStatusGuide: {
          type: "object",
          properties: {
            pending: {
              type: "string",
              example: "Check is registered but not finalized by the bank yet.",
            },
            cashed: {
              type: "string",
              example:
                "Check is finalized successfully and linked financial transaction is active.",
            },
            bounced: {
              type: "string",
              example: "Check failed and its effect on linked debt is removed.",
            },
          },
        },

        CheckResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Check processed successfully",
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
            createdAt: {
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
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },

        PartnerCreateRequest: {
          type: "object",
          required: ["company_name", "partner_type"],
          properties: {
            company_name: { type: "string", example: "Supplier One" },
            partner_type: {
              type: "string",
              enum: ["supplier", "customer"],
              example: "supplier",
            },
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
              example: 1,
            },

            totalIncome: {
              type: "number",
              example: 20000,
            },
            totalExpense: {
              type: "number",
              example: 5000,
            },
            netProfit: {
              type: "number",
              example: 15000,
            },

            totalSales: {
              type: "integer",
              example: 12,
            },
            totalPurchases: {
              type: "integer",
              example: 7,
            },

            totalSalesAmount: {
              type: "number",
              example: 120000,
            },
            totalPurchasesAmount: {
              type: "number",
              example: 80000,
            },

            totalReceivedFromSales: {
              type: "number",
              example: 70000,
            },
            totalPaidForPurchases: {
              type: "number",
              example: 30000,
            },

            totalReceivables: {
              type: "number",
              example: 50000,
            },
            totalPayables: {
              type: "number",
              example: 50000,
            },

            totalUnpaidSales: {
              type: "integer",
              example: 2,
            },
            totalPartialSales: {
              type: "integer",
              example: 5,
            },
            totalPaidSales: {
              type: "integer",
              example: 5,
            },

            totalUnpaidPurchases: {
              type: "integer",
              example: 1,
            },
            totalPartialPurchases: {
              type: "integer",
              example: 3,
            },
            totalPaidPurchases: {
              type: "integer",
              example: 3,
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
        SaleCreateAllocationInput: {
          type: "object",
          required: ["storage_id", "quantity"],
          properties: {
            storage_id: {
              type: "integer",
              example: 11,
            },
            quantity: {
              type: "integer",
              example: 100,
            },
          },
        },

        SaleCreateItemInput: {
          type: "object",
          required: ["quantity", "unit_price", "allocations"],
          properties: {
            quantity: {
              type: "integer",
              example: 200,
            },
            unit_price: {
              type: "number",
              example: 500,
            },
            allocations: {
              type: "array",
              items: {
                $ref: "#/components/schemas/SaleCreateAllocationInput",
              },
            },
          },
        },

        SaleCreateCheckInput: {
          type: "object",
          required: ["bank_name", "check_number", "issue_date"],
          properties: {
            bank_name: {
              type: "string",
              example: "ABC Bank",
            },
            check_number: {
              type: "string",
              example: "CHK-1001",
            },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-04-13",
            },
            status: {
              type: "string",
              enum: ["pending", "cashed", "bounced"],
              example: "pending",
            },
            company_name: {
              type: "string",
              nullable: true,
              example: "Customer One",
            },
          },
        },

        SaleCreatePaymentInput: {
          type: "object",
          required: ["payment_method", "amount", "payment_date"],
          properties: {
            payment_method: {
              type: "string",
              enum: ["cash", "check"],
              example: "cash",
            },
            amount: {
              type: "number",
              example: 30000,
            },
            payment_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "cash part",
            },
            check: {
              $ref: "#/components/schemas/SaleCreateCheckInput",
            },
          },
        },

        SaleCreateRequest: {
          type: "object",
          required: ["sale_date", "items"],
          properties: {
            partner_id: {
              type: "integer",
              nullable: true,
              example: 1,
            },
            sale_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            invoice_number: {
              type: "string",
              nullable: true,
              example: "INV-1001",
            },
            status: {
              type: "string",
              enum: ["draft", "completed", "cancelled"],
              example: "completed",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "wood sale",
            },
            items: {
              type: "array",
              items: {
                $ref: "#/components/schemas/SaleCreateItemInput",
              },
            },
            payments: {
              type: "array",
              items: {
                $ref: "#/components/schemas/SaleCreatePaymentInput",
              },
            },
          },
          example: {
            partner_id: 1,
            sale_date: "2026-04-12",
            invoice_number: "INV-1001",
            notes: "wood sale",
            items: [
              {
                quantity: 200,
                unit_price: 500,
                allocations: [
                  { storage_id: 11, quantity: 100 },
                  { storage_id: 27, quantity: 100 },
                ],
              },
            ],
            payments: [
              {
                payment_method: "cash",
                amount: 30000,
                payment_date: "2026-04-12",
                notes: "cash part",
              },
              {
                payment_method: "check",
                amount: 70000,
                payment_date: "2026-04-12",
                notes: "check part",
                check: {
                  bank_name: "ABC Bank",
                  check_number: "CHK-1001",
                  issue_date: "2026-04-12",
                  status: "pending",
                },
              },
            ],
          },
        },

        SaleItemAllocationResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            sale_item_id: { type: "integer", example: 1 },
            storage_id: { type: "integer", example: 11 },
            quantity: { type: "integer", example: 100 },
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },

        SaleItemResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            sale_id: { type: "integer", example: 1 },
            item_name_snapshot: { type: "string", example: "wood" },
            thickness_snapshot: { type: "string", example: "6" },
            quantity: { type: "integer", example: 200 },
            unit_price: { type: "number", example: 500 },
            purchase_price_snapshot: { type: "number", example: 300 },
            line_total: { type: "number", example: 100000 },
            created_at: {
              type: "string",
              format: "date-time",
            },
            SaleItemAllocations: {
              type: "array",
              items: {
                $ref: "#/components/schemas/SaleItemAllocationResponse",
              },
            },
          },
        },

        SalePaymentResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            user_id: { type: "integer", example: 1 },
            sale_id: { type: "integer", nullable: true, example: 1 },
            purchase_id: { type: "integer", nullable: true, example: null },
            payment_method: { type: "string", example: "cash" },
            amount: { type: "number", example: 30000 },
            payment_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            check_id: { type: "integer", nullable: true, example: null },
            notes: { type: "string", nullable: true, example: "cash part" },
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },

        SaleCheckResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            user_id: { type: "integer", example: 1 },
            bank_name: { type: "string", example: "ABC Bank" },
            check_number: { type: "string", example: "CHK-1001" },
            company_name: { type: "string", example: "Customer One" },
            amount: { type: "number", example: 70000 },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: null,
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
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },
        SaleAddPaymentCheckInput: {
          type: "object",
          required: ["bank_name", "check_number", "issue_date"],
          properties: {
            bank_name: {
              type: "string",
              example: "ABC Bank",
            },
            check_number: {
              type: "string",
              example: "CHK-7001",
            },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-13",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-04-14",
            },
            status: {
              type: "string",
              enum: ["pending", "cashed", "bounced"],
              example: "pending",
            },
            company_name: {
              type: "string",
              nullable: true,
              example: "Customer One",
            },
          },
        },

        SaleAddPaymentRequest: {
          type: "object",
          required: ["payment_method", "amount", "payment_date"],
          properties: {
            payment_method: {
              type: "string",
              enum: ["cash", "check"],
              example: "cash",
            },
            amount: {
              type: "number",
              example: 20000,
            },
            payment_date: {
              type: "string",
              format: "date",
              example: "2026-04-13",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "second payment",
            },
            check: {
              $ref: "#/components/schemas/SaleAddPaymentCheckInput",
            },
          },
        },

        SaleAddPaymentResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Payment added successfully",
            },
            sale: {
              $ref: "#/components/schemas/SaleResponse",
            },
          },
        },

        SaleResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            user_id: { type: "integer", example: 1 },
            partner_id: { type: "integer", nullable: true, example: 1 },
            sale_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            invoice_number: {
              type: "string",
              nullable: true,
              example: "INV-1001",
            },
            status: {
              type: "string",
              enum: ["draft", "completed", "cancelled"],
              example: "completed",
            },
            total_amount: {
              type: "number",
              example: 100000,
            },
            paid_amount: {
              type: "number",
              example: 50000,
            },
            remaining_amount: {
              type: "number",
              example: 50000,
            },
            payment_status: {
              type: "string",
              enum: ["unpaid", "partial", "paid"],
              example: "partial",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "wood sale",
            },
            created_at: {
              type: "string",
              format: "date-time",
            },
            SaleItems: {
              type: "array",
              items: {
                $ref: "#/components/schemas/SaleItemResponse",
              },
            },
            Payments: {
              type: "array",
              items: {
                $ref: "#/components/schemas/SalePaymentResponse",
              },
            },
            Partner: {
              type: "object",
              nullable: true,
              properties: {
                id: { type: "integer", example: 1 },
                company_name: { type: "string", example: "Customer One" },
                partner_type: { type: "string", example: "customer" },
                phone_number: { type: "string", example: "+14155550999" },
              },
            },
          },
        },

        SaleCreateResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Sale created successfully",
            },
            sale: {
              $ref: "#/components/schemas/SaleResponse",
            },
          },
        },
        PurchaseCreateAllocationInput: {
          type: "object",
          required: ["warehouse_id", "quantity"],
          properties: {
            warehouse_id: {
              type: "integer",
              example: 1,
            },
            storage_id: {
              type: "integer",
              nullable: true,
              example: 10,
            },
            quantity: {
              type: "integer",
              example: 200,
            },
          },
        },

        PurchaseCreateItemInput: {
          type: "object",
          required: [
            "item_name",
            "thickness",
            "quantity",
            "unit_cost",
            "sale_price",
            "allocations",
          ],
          properties: {
            item_name: {
              type: "string",
              example: "wood",
            },
            thickness: {
              type: "string",
              example: "6",
            },
            quantity: {
              type: "integer",
              example: 500,
            },
            unit_cost: {
              type: "number",
              example: 300,
            },
            sale_price: {
              type: "number",
              example: 500,
            },
            expiration_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: null,
            },
            minimum_quantity: {
              type: "integer",
              example: 10,
            },
            allocations: {
              type: "array",
              items: {
                $ref: "#/components/schemas/PurchaseCreateAllocationInput",
              },
            },
          },
        },

        PurchaseCreateCheckInput: {
          type: "object",
          required: ["bank_name", "check_number", "issue_date"],
          properties: {
            bank_name: {
              type: "string",
              example: "ABC Bank",
            },
            check_number: {
              type: "string",
              example: "OUT-1001",
            },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-04-13",
            },
            status: {
              type: "string",
              enum: ["pending", "cashed", "bounced"],
              example: "pending",
            },
            company_name: {
              type: "string",
              nullable: true,
              example: "Supplier One",
            },
          },
        },
        PurchaseAddPaymentCheckInput: {
          type: "object",
          required: ["bank_name", "check_number", "issue_date"],
          properties: {
            bank_name: {
              type: "string",
              example: "ABC Bank",
            },
            check_number: {
              type: "string",
              example: "OUT-7001",
            },
            issue_date: {
              type: "string",
              format: "date",
              example: "2026-04-14",
            },
            cashing_date: {
              type: "string",
              format: "date",
              nullable: true,
              example: "2026-04-15",
            },
            status: {
              type: "string",
              enum: ["pending", "cashed", "bounced"],
              example: "pending",
            },
            company_name: {
              type: "string",
              nullable: true,
              example: "Supplier One",
            },
          },
        },

        PurchaseAddPaymentRequest: {
          type: "object",
          required: ["payment_method", "amount", "payment_date"],
          properties: {
            payment_method: {
              type: "string",
              enum: ["cash", "check"],
              example: "cash",
            },
            amount: {
              type: "number",
              example: 20000,
            },
            payment_date: {
              type: "string",
              format: "date",
              example: "2026-04-13",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "second purchase payment",
            },
            check: {
              $ref: "#/components/schemas/PurchaseAddPaymentCheckInput",
            },
          },
        },

        PurchaseAddPaymentResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Payment added successfully",
            },
            purchase: {
              $ref: "#/components/schemas/PurchaseResponse",
            },
          },
        },

        PurchaseCreatePaymentInput: {
          type: "object",
          required: ["payment_method", "amount", "payment_date"],
          properties: {
            payment_method: {
              type: "string",
              enum: ["cash", "check"],
              example: "cash",
            },
            amount: {
              type: "number",
              example: 50000,
            },
            payment_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "cash part",
            },
            check: {
              $ref: "#/components/schemas/PurchaseCreateCheckInput",
            },
          },
        },

        PurchaseCreateRequest: {
          type: "object",
          required: ["purchase_date", "items"],
          properties: {
            partner_id: {
              type: "integer",
              nullable: true,
              example: 1,
            },
            purchase_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            invoice_number: {
              type: "string",
              nullable: true,
              example: "PUR-1001",
            },
            status: {
              type: "string",
              enum: ["draft", "completed", "cancelled"],
              example: "completed",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "wood purchase",
            },
            items: {
              type: "array",
              items: {
                $ref: "#/components/schemas/PurchaseCreateItemInput",
              },
            },
            payments: {
              type: "array",
              items: {
                $ref: "#/components/schemas/PurchaseCreatePaymentInput",
              },
            },
          },
          example: {
            partner_id: 1,
            purchase_date: "2026-04-12",
            invoice_number: "PUR-1001",
            notes: "wood purchase",
            items: [
              {
                item_name: "wood",
                thickness: "6",
                quantity: 500,
                unit_cost: 300,
                sale_price: 500,
                expiration_date: null,
                minimum_quantity: 10,
                allocations: [
                  { warehouse_id: 1, quantity: 200 },
                  { warehouse_id: 2, quantity: 300 },
                ],
              },
            ],
            payments: [
              {
                payment_method: "cash",
                amount: 50000,
                payment_date: "2026-04-12",
                notes: "cash part",
              },
              {
                payment_method: "check",
                amount: 100000,
                payment_date: "2026-04-12",
                notes: "check part",
                check: {
                  bank_name: "ABC Bank",
                  check_number: "OUT-1001",
                  issue_date: "2026-04-12",
                  status: "pending",
                },
              },
            ],
          },
        },

        PurchaseItemAllocationResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            purchase_item_id: { type: "integer", example: 1 },
            storage_id: { type: "integer", example: 10 },
            quantity: { type: "integer", example: 200 },
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },

        PurchaseItemResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            purchase_id: { type: "integer", example: 1 },
            item_name_snapshot: { type: "string", example: "wood" },
            thickness_snapshot: { type: "string", example: "6" },
            quantity: { type: "integer", example: 500 },
            unit_cost: { type: "number", example: 300 },
            sale_price_snapshot: { type: "number", example: 500 },
            expiration_date_snapshot: {
              type: "string",
              format: "date-time",
              nullable: true,
              example: null,
            },
            line_total: { type: "number", example: 150000 },
            created_at: {
              type: "string",
              format: "date-time",
            },
            PurchaseItemAllocations: {
              type: "array",
              items: {
                $ref: "#/components/schemas/PurchaseItemAllocationResponse",
              },
            },
          },
        },

        PurchasePaymentResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            user_id: { type: "integer", example: 1 },
            sale_id: { type: "integer", nullable: true, example: null },
            purchase_id: { type: "integer", nullable: true, example: 1 },
            payment_method: { type: "string", example: "cash" },
            amount: { type: "number", example: 50000 },
            payment_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            check_id: { type: "integer", nullable: true, example: null },
            notes: { type: "string", nullable: true, example: "cash part" },
            created_at: {
              type: "string",
              format: "date-time",
            },
          },
        },

        PurchaseResponse: {
          type: "object",
          properties: {
            id: { type: "integer", example: 1 },
            user_id: { type: "integer", example: 1 },
            partner_id: { type: "integer", nullable: true, example: 1 },
            purchase_date: {
              type: "string",
              format: "date",
              example: "2026-04-12",
            },
            invoice_number: {
              type: "string",
              nullable: true,
              example: "PUR-1001",
            },
            status: {
              type: "string",
              enum: ["draft", "completed", "cancelled"],
              example: "completed",
            },
            total_amount: {
              type: "number",
              example: 150000,
            },
            paid_amount: {
              type: "number",
              example: 80000,
            },
            remaining_amount: {
              type: "number",
              example: 70000,
            },
            payment_status: {
              type: "string",
              enum: ["unpaid", "partial", "paid"],
              example: "partial",
            },
            notes: {
              type: "string",
              nullable: true,
              example: "wood purchase",
            },
            created_at: {
              type: "string",
              format: "date-time",
            },
            PurchaseItems: {
              type: "array",
              items: {
                $ref: "#/components/schemas/PurchaseItemResponse",
              },
            },
            Payments: {
              type: "array",
              items: {
                $ref: "#/components/schemas/PurchasePaymentResponse",
              },
            },
            Partner: {
              type: "object",
              nullable: true,
              properties: {
                id: { type: "integer", example: 1 },
                company_name: { type: "string", example: "Supplier One" },
                partner_type: { type: "string", example: "supplier" },
                phone_number: { type: "string", example: "+14155550998" },
              },
            },
          },
        },

        PurchaseCreateResponse: {
          type: "object",
          properties: {
            message: {
              type: "string",
              example: "Purchase created successfully",
            },
            purchase: {
              $ref: "#/components/schemas/PurchaseResponse",
            },
          },
        },

        TransactionListResponse: {
          type: "object",
          properties: {
            page: { type: "integer", example: 1 },
            limit: { type: "integer", example: 10 },
            totalItems: { type: "integer", example: 25 },
            totalPages: { type: "integer", example: 3 },
            hasNextPage: { type: "boolean", example: true },
            hasPrevPage: { type: "boolean", example: false },
            data: {
              type: "array",
              items: {
                $ref: "#/components/schemas/Transaction",
              },
            },
          },
        },

        PartnerListResponse: {
          type: "object",
          properties: {
            page: { type: "integer", example: 1 },
            limit: { type: "integer", example: 10 },
            totalItems: { type: "integer", example: 25 },
            totalPages: { type: "integer", example: 3 },
            hasNextPage: { type: "boolean", example: true },
            hasPrevPage: { type: "boolean", example: false },
            data: {
              type: "array",
              items: {
                $ref: "#/components/schemas/Partner",
              },
            },
          },
        },

        WarehouseListResponse: {
          type: "object",
          properties: {
            page: { type: "integer", example: 1 },
            limit: { type: "integer", example: 10 },
            totalItems: { type: "integer", example: 25 },
            totalPages: { type: "integer", example: 3 },
            hasNextPage: { type: "boolean", example: true },
            hasPrevPage: { type: "boolean", example: false },
            data: {
              type: "array",
              items: {
                $ref: "#/components/schemas/Warehouse",
              },
            },
          },
        },

        StorageListResponse: {
          type: "object",
          properties: {
            page: { type: "integer", example: 1 },
            limit: { type: "integer", example: 10 },
            totalItems: { type: "integer", example: 25 },
            totalPages: { type: "integer", example: 3 },
            hasNextPage: { type: "boolean", example: true },
            hasPrevPage: { type: "boolean", example: false },
            data: {
              type: "array",
              items: {
                $ref: "#/components/schemas/Storage",
              },
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
