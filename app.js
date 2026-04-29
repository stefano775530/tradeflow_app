const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const app = express();

const swaggerUi = require("swagger-ui-express");
const swaggerSpec = require("./docs/swagger");

const partnerRoutes = require("./routes/partner.routes");
const userRoute = require("./routes/user.routes");
const warehouseRoute = require("./routes/warehouse.routes");
const checkRoute = require("./routes/check.routes");
const transactionRoute = require("./routes/transaction.routes");
const reportRoute = require("./routes/report.routes");
const alertRoute = require("./routes/alert.routes");
const saleRoute = require("./routes/sale.route");
const purchaseRoute = require("./routes/purchase.routes");

const { errorHandler } = require("./middleware/error-handler");
const { notFound } = require("./middleware/not-found");
const { env } = require("./config/env");
app.disable("x-powered-by");

if (env.TRUST_PROXY) {
  app.set("trust proxy", 1);
}
app.use(
  helmet({
    contentSecurityPolicy: false,
    crossOriginResourcePolicy: { policy: "cross-origin" },
  }),
);

const corsOptions = {
  origin(origin, callback) {
    // اسمح للأدوات غير المتصفحية أو الطلبات بدون Origin
    if (!origin) {
      return callback(null, true);
    }

    if (env.NODE_ENV !== "production" || env.allowedOrigins.includes(origin)) {
      return callback(null, true);
    }

    return callback(new Error("CORS origin not allowed"));
  },
  credentials: true,
  optionsSuccessStatus: 200,
};
app.use(cors(corsOptions));
app.use(express.json());

app.use("/api/partners", partnerRoutes);
app.use("/api/user", userRoute);
app.use("/api/warehouse", warehouseRoute);
app.use("/api/checks", checkRoute);
app.use("/api/transactions", transactionRoute);
app.use("/api/reports", reportRoute);
app.use("/api/alerts", alertRoute);
app.use("/api/sales", saleRoute);
app.use("/api/purchases", purchaseRoute);
app.use("/api/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.use(notFound);
app.use(errorHandler);

module.exports = app;
