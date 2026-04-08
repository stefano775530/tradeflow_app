"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Storage extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Storage.belongsTo(models.Warehouse, {
        foreignKey: "warehouse_id",
        onDelete: "CASCADE",
      });
    }
  }
  Storage.init(
    {
      warehouse_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: { model: "Warehouses", key: "id" },
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },

      thickness: {
        type: DataTypes.FLOAT,
        allowNull: true,
      },
      quantity: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      minimum_quantity: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 10,
      },
      purchase_price: {
        type: DataTypes.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      sale_price: {
        type: DataTypes.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      expiration_date: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      created_at: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: "Storage",
      tableName: "Storages",
      timestamps: false,
    },
  );
  return Storage;
};
