"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Purchase extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Purchase.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });

      Purchase.belongsTo(models.Partner, {
        foreignKey: "partner_id",
        onDelete: "SET NULL",
      });

      Purchase.hasMany(models.PurchaseItem, {
        foreignKey: "purchase_id",
        onDelete: "CASCADE",
      });

      Purchase.hasMany(models.Payment, {
        foreignKey: "purchase_id",
        onDelete: "CASCADE",
      });
    }
  }
  Purchase.init(
    {
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },

      partner_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },

      purchase_date: {
        type: DataTypes.DATEONLY,
        allowNull: false,
      },

      invoice_number: {
        type: DataTypes.STRING,
        allowNull: true,
      },

      status: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: "completed",
      },

      total_amount: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },

      paid_amount: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },
      remaining_amount: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },
      payment_status: {
        type: DataTypes.STRING,
        allowNull: false,
        defaultValue: "unpaid",
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
      modelName: "Purchase",
      tableName: "Purchases",
      timestamps: false,
    },
  );
  return Purchase;
};
