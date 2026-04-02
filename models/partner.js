"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Partner extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Partner.belongsTo(models.User, {
        foreignKey: "user_id",
        onDelete: "CASCADE",
      });
      // define association here
    }
  }
  Partner.init(
    {
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      company_name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      partner_type: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      phone_number: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      createdAt: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
      updatedAt: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      sequelize,
      modelName: "Partner",
      tableName: "Partners",
    },
  );
  return Partner;
};
