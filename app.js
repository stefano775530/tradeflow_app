const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const userRoute = require("./routes/user");

//const postsRoute = require("./routes/posts");

app.use(bodyParser.json());

//app.use("/posts", postsRoute);
app.use(cors());

app.use("/user", userRoute);

module.exports = app;
dsa;
