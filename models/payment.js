"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Payment extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Payment.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });

      Payment.belongsTo(models.Sale, {
        foreignKey: "sale_id",
        onDelete: "CASCADE",
      });

      Payment.belongsTo(models.Purchase, {
        foreignKey: "purchase_id",
        onDelete: "CASCADE",
      });

      Payment.belongsTo(models.Check, {
        foreignKey: "check_id",
        onDelete: "RESTRICT",
      });
    }
  }
  Payment.init(
    {
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },

      sale_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },

      purchase_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },

      payment_method: {
        type: DataTypes.STRING,
        allowNull: false,
      },

      amount: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
      },

      payment_date: {
        type: DataTypes.DATEONLY,
        allowNull: false,
      },

      check_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
        unique: true,
      },

      notes: {
        type: DataTypes.TEXT,
        allowNull: true,
      },

      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: "Payment",
      tableName: "Payments",
      timestamps: false,
    },
  );
  return Payment;
};
