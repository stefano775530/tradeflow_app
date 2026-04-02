"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      User.hasMany(models.Warehouse, { foreignKey: "user_id" });

      User.hasMany(models.Partner, { foreignKey: "user_id" });

      User.hasMany(models.PasswordReset, { foreignKey: "user_id" });
    }
  }
  User.init(
    {
      name: { type: DataTypes.STRING, allowNull: false },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: { isEmail: true },
      },
      password: { type: DataTypes.STRING },
      phone_number: { type: DataTypes.STRING },
      created_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
    },
    {
      sequelize,
      modelName: "User",
      tableName: "Users",
      timestamps: false,
    },
  );
  return User;
};
