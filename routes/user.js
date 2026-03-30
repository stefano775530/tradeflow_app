const express = require("express");
const userController = require("../controllers/user.controller");

const router = express.Router();

router.post("/sign-up", userController.signUp);
router.post("/login", userController.login);
router.post("/forgot-password", userController.forgotPassword);
router.post("/reset-password/:token", userController.resetPassword);
module.exports = router;
