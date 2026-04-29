"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class PurchaseItemAllocation extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      PurchaseItemAllocation.belongsTo(models.PurchaseItem, {
        foreignKey: "purchase_item_id",
        onDelete: "CASCADE",
      });

      PurchaseItemAllocation.belongsTo(models.Storage, {
        foreignKey: "storage_id",
        onDelete: "CASCADE",
      });
    }
  }
  PurchaseItemAllocation.init(
    {
      purchase_item_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },

      storage_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },

      quantity: {
        type: DataTypes.INTEGER,
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
      modelName: "PurchaseItemAllocation",
      tableName: "PurchaseItemAllocations",
      timestamps: false,
    },
  );
  return PurchaseItemAllocation;
};
