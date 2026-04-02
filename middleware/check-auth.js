const jwt = require("jsonwebtoken");

function checkAuth(req, res, next) {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      return res
        .status(401)
        .json({ message: "No authorization header provided" });
    }

    const parts = authHeader.split(" ");
    if (parts.length !== 2 || parts[0] !== "Bearer") {
      return res.status(401).json({ message: "Invalid authorization format" });
    }

    const token = parts[1];

    const decodedToken = jwt.verify(token, process.env.JWT_KEY);

    req.userData = decodedToken;

    next();
  } catch (error) {
    return res.status(401).json({
      message: "Invalid or expired token provided!",
      error: error.message,
    });
  }
}

module.exports = { checkAuth };
