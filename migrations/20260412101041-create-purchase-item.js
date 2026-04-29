"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("PurchaseItems", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },

      purchase_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "Purchases",
          key: "id",
        },
        onDelete: "CASCADE",
        onUpdate: "CASCADE",
      },

      item_name_snapshot: {
        type: Sequelize.STRING,
        allowNull: false,
      },

      thickness_snapshot: {
        type: Sequelize.STRING,
        allowNull: false,
      },

      quantity: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },

      unit_cost: {
        type: Sequelize.DECIMAL(12, 2),
        allowNull: false,
      },

      sale_price_snapshot: {
        type: Sequelize.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },

      expiration_date_snapshot: {
        type: Sequelize.DATE,
        allowNull: true,
      },

      line_total: {
        type: Sequelize.DECIMAL(12, 2),
        allowNull: false,
      },

      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW,
      },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable("PurchaseItems");
  },
};
