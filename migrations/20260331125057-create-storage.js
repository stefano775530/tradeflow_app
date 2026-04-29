"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("Storages", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      warehouse_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: { model: "Warehouses", key: "id" },
        onDelete: "CASCADE",
        onUpdate: "CASCADE",
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      quantity: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      minimum_quantity: {
        type: Sequelize.INTEGER,
        allowNull: false,
        defaultValue: 10,
      },
      thickness: {
        type: Sequelize.FLOAT,
        allowNull: false,
      },
      purchase_price: {
        type: Sequelize.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      sale_price: {
        type: Sequelize.FLOAT,
        allowNull: false,
        defaultValue: 0,
      },
      expiration_date: {
        type: Sequelize.DATE,
      },
      created_at: {
        type: Sequelize.DATE,
        defaultValue: Sequelize.NOW,
      },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable("Storages");
  },
};
