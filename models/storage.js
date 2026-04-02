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
      quantity: {
        type: DataTypes.INTEGER,
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
