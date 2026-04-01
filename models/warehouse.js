"use strict";
const { Model, ForeignKeyConstraintError } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Warehouse extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Warehouse.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      }); // Define the association with the User model
      Warehouse.hasMany(models.Storage, {
        foreignKey: "warehouse_id",
        onDelete: "CASCADE",
      }); // Define the association with the Storage model
      // define association here
    }
  }
  Warehouse.init(
    {
      user_id: { type: DataTypes.INTEGER, allowNull: false },
      name: { type: DataTypes.STRING, allowNull: false },
      location: { type: DataTypes.STRING },
      created_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
    },
    {
      sequelize,
      modelName: "Warehouse",
      tableName: "Warehouses",
      timestamps: false,
    },
  );
  return Warehouse;
};
