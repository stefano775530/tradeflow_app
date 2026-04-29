"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("Purchases", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },

      user_id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: "Users",
          key: "id",
        },
        onDelete: "CASCADE",
        onUpdate: "CASCADE",
      },

      partner_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: "Partners",
          key: "id",
        },
        onDelete: "SET NULL",
        onUpdate: "CASCADE",
      },

      purchase_date: {
        type: Sequelize.DATEONLY,
        allowNull: false,
      },

      invoice_number: {
        type: Sequelize.STRING,
        allowNull: true,
      },

      status: {
        type: Sequelize.STRING,
        allowNull: false,
        defaultValue: "completed",
      },

      total_amount: {
        type: Sequelize.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },
      paid_amount: {
        type: Sequelize.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },
      remaining_amount: {
        type: Sequelize.DECIMAL(12, 2),
        allowNull: false,
        defaultValue: 0,
      },
      payment_status: {
        type: Sequelize.STRING,
        allowNull: false,
        defaultValue: "unpaid",
      },

      notes: {
        type: Sequelize.TEXT,
        allowNull: true,
      },

      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
        defaultValue: Sequelize.NOW,
      },
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable("Purchases");
  },
};
