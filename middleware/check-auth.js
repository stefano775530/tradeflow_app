const jwt = require("jsonwebtoken");
const { AppError } = require("../utils/app-error");

function checkAuth(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return next(new AppError(401, "No authorization header provided"));
  }

  const parts = authHeader.split(" ");

  if (parts.length !== 2 || parts[0] !== "Bearer") {
    return next(new AppError(401, "Invalid authorization format"));
  }

  try {
    const token = parts[1];
    const decodedToken = jwt.verify(token, process.env.JWT_KEY);
    req.userData = decodedToken;
    next();
  } catch (error) {
    next(new AppError(401, "Invalid or expired token"));
  }
}

module.exports = { checkAuth };
