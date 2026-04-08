const express = require("express");
const cors = require("cors");
const app = express();

const swaggerUi = require("swagger-ui-express");
const swaggerSpec = require("./docs/swagger");

const partnerRoutes = require("./routes/partner");
const userRoute = require("./routes/user");
const warehouseRoute = require("./routes/warehouse");
const checkRoute = require("./routes/check");
const transactionRoute = require("./routes/transaction");
const reportRoute = require("./routes/report");
const alertRoute = require("./routes/alert");

const { errorHandler } = require("./middleware/error-handler");
const { notFound } = require("./middleware/not-found");
app.use(express.json());
app.use(cors());

app.use("/api/partners", partnerRoutes);
app.use("/api/user", userRoute);
app.use("/api/warehouse", warehouseRoute);
app.use("/api/checks", checkRoute);
app.use("/api/transactions", transactionRoute);
app.use("/api/reports", reportRoute);
app.use("/api/alerts", alertRoute);

app.use("/api/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.use(notFound);
app.use(errorHandler);

module.exports = app;
