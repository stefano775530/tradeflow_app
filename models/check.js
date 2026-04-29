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
      Check.hasOne(models.Payment, {
        foreignKey: "check_id",
        onDelete: "RESTRICT",
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
      company_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      check_number: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      amount: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
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
        allowNull: false,
        defaultValue: "pending",
      },
      type: {
        type: DataTypes.ENUM("وارد", "صادر"),
        allowNull: false,
        defaultValue: "وارد",
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      note: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
    },
    {
      sequelize,
      modelName: "Check",
      tableName: "Checks",
      timestamps: false,
    },
  );
  return Check;
};
