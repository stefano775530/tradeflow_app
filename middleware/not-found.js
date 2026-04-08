const { AppError } = require("../utils/app-error");

function notFound(req, res, next) {
  next(new AppError(404, `Route not found: ${req.method} ${req.originalUrl}`));
}

module.exports = { notFound };
