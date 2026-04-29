"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class SaleItem extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      SaleItem.belongsTo(models.Sale, {
        foreignKey: "sale_id",
        onDelete: "CASCADE",
      });

      SaleItem.hasMany(models.SaleItemAllocation, {
        foreignKey: "sale_item_id",
        onDelete: "CASCADE",
      });
    }
  }
  SaleItem.init(
    {
      sale_id: {
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

      unit_price: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
      },

      purchase_price_snapshot: {
        type: DataTypes.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
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
      modelName: "SaleItem",
      tableName: "SaleItems",
      timestamps: false,
    },
  );

  return SaleItem;
};
