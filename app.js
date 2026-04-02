const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const partnerRoutes = require("./routes/partner.routes");

const app = express();
const userRoute = require("./routes/user");

const warehouseRoute = require("./routes/warehouse");

app.use(bodyParser.json());

app.use(cors());

app.use("/api/partners", partnerRoutes);

app.use("/api/user", userRoute);
app.use("/api/warehouse", warehouseRoute);

module.exports = app;
