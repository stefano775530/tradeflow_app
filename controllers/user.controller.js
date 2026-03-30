const models = require("../models");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
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
module.exports = {
  signUp: signUp,
  login: login,
};
