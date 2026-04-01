const express = require("express");
const userController = require("../controllers/user.controller");
const {
  signUpValidation,
  loginValidation,
  forgotPasswordValidation,
  resetPasswordValidation,
} = require("../middleware/validators");
const {
  loginLimiter,
  forgotPasswordLimiter,
} = require("../middleware/ratelimiter");

const router = express.Router();

router.post("/signup", signUpValidation, userController.signUp);
router.post("/login", loginLimiter, loginValidation, userController.login);
router.post(
  "/forgot-password",
  forgotPasswordLimiter,
  forgotPasswordValidation,
  userController.forgotPassword,
);
router.post(
  "/reset-password/:token",
  resetPasswordValidation,
  userController.resetPassword,
);
module.exports = router;
