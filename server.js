require("dotenv").config();
const { env } = require("./config/env");

const http = require("http");
const app = require("./app");

const server = http.createServer(app);

server.listen(env.PORT, () => {
  console.log(`Server running on port ${env.PORT}`);
});
