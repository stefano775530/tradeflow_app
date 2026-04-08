"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Check extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Check.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
    }
  }
  Check.init(
    {
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      bank_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      check_number: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      amount: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      issue_date: {
        type: DataTypes.DATEONLY,
        allowNull: false,
      },
      cashing_date: {
        type: DataTypes.DATEONLY,
        allowNull: true,
      },
      status: {
        type: DataTypes.ENUM("pending", "cashed", "bounced"),
        defaultValue: "pending",
      },
      type: {
        type: DataTypes.ENUM("incoming", "outgoing"),
        allowNull: false,
        defaultValue: "incoming",
      },
      company_name: {
        allowNull: false,
        type: DataTypes.STRING,
      },
    },
    {
      sequelize,
      modelName: "Check",
      tableName: "Checks",
      timestamps: true,
    },
  );
  return Check;
};
