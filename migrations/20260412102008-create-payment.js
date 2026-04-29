"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("Payments", {
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

      sale_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: "Sales",
          key: "id",
        },
        onDelete: "CASCADE",
        onUpdate: "CASCADE",
      },

      purchase_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        references: {
          model: "Purchases",
          key: "id",
        },
        onDelete: "CASCADE",
        onUpdate: "CASCADE",
      },

      payment_method: {
        type: Sequelize.STRING,
        allowNull: false,
      },

      amount: {
        type: Sequelize.DECIMAL(12, 2),
        allowNull: false,
      },

      payment_date: {
        type: Sequelize.DATEONLY,
        allowNull: false,
      },

      check_id: {
        type: Sequelize.INTEGER,
        allowNull: true,
        unique: true,
        references: {
          model: "Checks",
          key: "id",
        },
        onDelete: "RESTRICT",
        onUpdate: "CASCADE",
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
    await queryInterface.dropTable("Payments");
  },
};
