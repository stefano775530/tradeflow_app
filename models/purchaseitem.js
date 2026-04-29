"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class PurchaseItem extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      PurchaseItem.belongsTo(models.Purchase, {
        foreignKey: "purchase_id",
        onDelete: "CASCADE",
      });

      PurchaseItem.hasMany(models.PurchaseItemAllocation, {
        foreignKey: "purchase_item_id",
        onDelete: "CASCADE",
      });
    }
  }
  PurchaseItem.init(
    {
      purchase_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },

      item_name_snapshot: {
        type: DataTypes.STRING,
        allowNull: false,
      },

      thickness_snapshot: {
        type: DataTypes.STRING,
        allowNull: false,
      },

      quantity: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },

      unit_cost: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
      },

      sale_price_snapshot: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },

      expiration_date_snapshot: {
        type: DataTypes.DATE,
        allowNull: true,
      },

      line_total: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
      },

      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: "PurchaseItem",
      tableName: "PurchaseItems",
      timestamps: false,
    },
  );
  return PurchaseItem;
};
