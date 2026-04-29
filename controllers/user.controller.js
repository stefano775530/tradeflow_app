const models = require("../models");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const { env } = require("../config/env");
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
      env.JWT_KEY,
      { expiresIn: env.JWT_EXPIRES_IN },
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
    const genericMessage =
      "If an account with that email exists, a reset link has been sent.";
    const user = await models.User.findOne({ where: { email } });
    if (!user) {
      return res.json({ message: genericMessage });
    }

    await models.PasswordReset.destroy({
      where: { user_id: user.id },
    });

    const rawToken = crypto.randomBytes(32).toString("hex");
    const hashedToken = crypto
      .createHash("sha256")
      .update(rawToken)
      .digest("hex");

    const expires_at = new Date(Date.now() + 15 * 60 * 1000);

    await models.PasswordReset.create({
      user_id: user.id,
      token: hashedToken,
      expires_at,
    });

    const resetBaseUrl =
      process.env.RESET_PASSWORD_URL_BASE ||
      "http://localhost:3000/api/user/reset-password";

    const link = `${resetBaseUrl}/${rawToken}`;

    if (env.NODE_ENV !== "production") {
      if (process.env.SHOW_RESET_LINK_IN_LOGS === "true") {
        console.log("RESET LINK:", link);
      }
    }

    return res.status(200).json({ message: genericMessage });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong!" });
  }
}
async function resetPassword(req, res) {
  try {
    const { token } = req.params;
    const { password } = req.body;

    const hashedToken = crypto.createHash("sha256").update(token).digest("hex");

    const resetRecord = await models.PasswordReset.findOne({
      where: { token: hashedToken },
    });
    if (!resetRecord || resetRecord.expires_at < new Date()) {
      return res.status(400).json({ message: "Invalid or expired token" });
    }

    const hash = await bcryptjs.hash(password, 10);

    const user = await models.User.findByPk(resetRecord.user_id);
    if (!user) {
      return res.status(400).json({ message: "Invalid or expired token" });
    }
    user.password = hash;
    await user.save();

    await models.PasswordReset.destroy({
      where: { user_id: user.id },
    });

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
