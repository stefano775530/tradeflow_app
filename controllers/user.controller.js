const models = require("../models");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
require("dotenv").config();
function signUp(req, res) {
  //Sign up
  models.User.findOne({ where: { email: req.body.email } })
    .then((result) => {
      if (result) {
        res.status(409).json({
          message: "email already exists",
        });
      } else {
        bcryptjs.genSalt(10, function (err, salt) {
          bcryptjs.hash(req.body.password, salt, function (err, hash) {
            const user = {
              name: req.body.name,
              email: req.body.email,
              password: hash,
              phone_number: req.body.phone_number,
              warehouses: req.body.warehouses, //بنوخذ الid من اليوزر وبندخله عل ىجدول المستودعات
            };

            models.User.create(user)
              .then((result) => {
                res.status(201).json({
                  message: "User created successfully",
                });
              })
              // take the user id created and store it in a variable and use it to create a warehouse for the user in the warehouse table
              .catch((error) => {
                res.status(500).json({
                  message: "Something went wrong!",
                });
              });
          });
        });
      }
    })
    .catch((error) => {
      res.status(500).json({
        message: "Something went wrong!",
      });
    });
}

function login(req, res) {
  models.User.findOne({ where: { email: req.body.email } })
    .then((user) => {
      if (!user) {
        return res.status(401).json({
          message: "Invalid credentials!",
        });
      }

      bcryptjs.compare(req.body.password, user.password, (err, result) => {
        if (result) {
          const token = jwt.sign(
            {
              email: user.email,
              userId: user.id,
            },
            process.env.JWT_KEY,
          );

          return res.status(200).json({
            message: "Authentication successful!",
            token,
          });
        } else {
          return res.status(401).json({
            message: "Invalid credentials!",
          });
        }
      });
    })
    .catch(() => {
      res.status(500).json({
        message: "Something went wrong!",
      });
    });
}
function forgotPassword(req, res) {
  const email = req.body.email;

  models.User.findOne({ where: { email: email } })
    .then((user) => {
      if (!user) {
        return res.json({
          message: "If email exists, link sent",
        });
      }

      const token = crypto.randomBytes(32).toString("hex");

      user.resetToken = token;
      user.resetTokenExpire = Date.now() + 3600000; // ساعة

      user.save().then(() => {
        const link = `http://localhost:3000/reset-password/${token}`;

        console.log("RESET LINK:", link); //  هون أهم إشي

        res.json({
          message: "Check console for reset link",
        });
      });
    })
    .catch(() => {
      res.status(500).json({
        message: "Something went wrong!",
      });
    });
}
function resetPassword(req, res) {
  const token = req.params.token;
  const password = req.body.password;

  models.User.findOne({ where: { resetToken: token } })
    .then((user) => {
      if (!user) {
        return res.json({ message: "Invalid token" });
      }

      if (user.resetTokenExpire < Date.now()) {
        return res.json({ message: "Token expired" });
      }

      bcryptjs.genSalt(10, function (err, salt) {
        bcryptjs.hash(password, salt, function (err, hash) {
          user.password = hash;
          user.resetToken = null;
          user.resetTokenExpire = null;

          user.save().then(() => {
            res.json({ message: "Password updated!" });
          });
        });
      });
    })
    .catch(() => {
      res.status(500).json({
        message: "Something went wrong!",
      });
    });
}
module.exports = {
  signUp: signUp,
  login: login,
  forgotPassword: forgotPassword,
  resetPassword: resetPassword,
};
