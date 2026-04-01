const models = require("../models");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
require("dotenv").config();
async function signUp(req, res) {
  try {
    const { name, email, password, phone_number } = req.body;

    const existingUser = await models.User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(409).json({ message: "Email already exists" });
    }

    const hash = await bcryptjs.hash(password, 10);

    const user = await models.User.create({
      name,
      email,
      password: hash,
      phone_number,
    });

    res
      .status(201)
      .json({ message: "User created successfully", userId: user.id });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong!" });
  }
}

async function login(req, res) {
  try {
    const { email, password } = req.body;
    const user = await models.User.findOne({ where: { email } });
    if (!user) {
      return res.status(401).json({ message: "Invalid credentials!" });
    }

    const match = await bcryptjs.compare(password, user.password);
    if (!match) {
      return res.status(401).json({ message: "Invalid credentials!" });
    }

    const token = jwt.sign(
      { email: user.email, userId: user.id },
      process.env.JWT_KEY,
      { expiresIn: "1h" },
    );

    res.status(200).json({ message: "Authentication successful!", token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong!" });
  }
}
async function forgotPassword(req, res) {
  try {
    const { email } = req.body;
    const user = await models.User.findOne({ where: { email } });
    if (!user) {
      return res.json({ message: "If email exists, link sent" });
    }

    const token = crypto.randomBytes(32).toString("hex");
    const expires_at = new Date(Date.now() + 900000); // 15 minute

    await models.PasswordReset.create({
      user_id: user.id,
      token,
      expires_at,
    });

    const link = `http://localhost:3000/api/user/reset-password/${token}`;
    console.log("RESET LINK:", link);

    res.json({ message: "Check console for reset link" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong!" });
  }
}
async function resetPassword(req, res) {
  try {
    const { token } = req.params;
    const { password } = req.body;

    const resetRecord = await models.PasswordReset.findOne({
      where: { token },
    });
    if (!resetRecord) return res.json({ message: "Invalid token" });

    if (resetRecord.expires_at < new Date())
      return res.json({ message: "Token expired" });

    const hash = await bcryptjs.hash(password, 10);

    const user = await models.User.findByPk(resetRecord.user_id);
    user.password = hash;
    await user.save();

    await resetRecord.destroy();

    res.json({ message: "Password updated!" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong!" });
  }
}
module.exports = {
  signUp: signUp,
  login: login,
  forgotPassword: forgotPassword,
  resetPassword: resetPassword,
};
