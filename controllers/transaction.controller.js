const models = require("../models");
const { Op } = require("sequelize");

async function createTransaction(req, res) {
  try {
    const {
      type,
      category,
      amount,
      description,
      transaction_date,
      reference_type,
      reference_id,
    } = req.body;

    const transaction = await models.Transaction.create({
      user_id: req.userData.userId,
      type,
      category,
      amount,
      description,
      transaction_date,
      reference_type,
      reference_id,
    });

    res.status(201).json({
      message: "Transaction created",
      transaction,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function getTransactions(req, res) {
  try {
    const { type, category, month, year, reference_type } = req.query;

    const where = {
      user_id: req.userData.userId,
    };

    if (type) {
      where.type = type;
    }

    if (category) {
      where.category = category;
    }

    if (reference_type) {
      where.reference_type = reference_type;
    }

    if (month && year) {
      const startDate = `${year}-${String(month).padStart(2, "0")}-01`;

      const nextMonth = Number(month) === 12 ? 1 : Number(month) + 1;
      const nextYear = Number(month) === 12 ? Number(year) + 1 : Number(year);
      const endDate = `${nextYear}-${String(nextMonth).padStart(2, "0")}-01`;

      where.transaction_date = {
        [Op.gte]: startDate,
        [Op.lt]: endDate,
      };
    }

    const transactions = await models.Transaction.findAll({
      where,
      order: [
        ["transaction_date", "DESC"],
        ["id", "DESC"],
      ],
    });

    res.status(200).json(transactions);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function getTransaction(req, res) {
  try {
    const { id } = req.params;

    const transaction = await models.Transaction.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!transaction) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    res.status(200).json(transaction);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function updateTransaction(req, res) {
  try {
    const { id } = req.params;
    const {
      type,
      category,
      amount,
      description,
      transaction_date,
      reference_type,
      reference_id,
    } = req.body;

    const transaction = await models.Transaction.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!transaction) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    transaction.type = type !== undefined ? type : transaction.type;
    transaction.category =
      category !== undefined ? category : transaction.category;
    transaction.amount = amount !== undefined ? amount : transaction.amount;
    transaction.description =
      description !== undefined ? description : transaction.description;
    transaction.transaction_date =
      transaction_date !== undefined
        ? transaction_date
        : transaction.transaction_date;
    transaction.reference_type =
      reference_type !== undefined
        ? reference_type
        : transaction.reference_type;
    transaction.reference_id =
      reference_id !== undefined ? reference_id : transaction.reference_id;

    await transaction.save();

    res.status(200).json({
      message: "Transaction updated",
      transaction,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
}

async function deleteTransaction(req, res) {
  try {
    const { id } = req.params;

    const transaction = await models.Transaction.findOne({
      where: {
        id,
        user_id: req.userData.userId,
      },
    });

    if (!transaction) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    await transaction.destroy();

    res.status(200).json({ message: "Transaction deleted" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Something went wrong" });
  }
}

module.exports = {
  createTransaction: createTransaction,
  getTransactions: getTransactions,
  getTransaction: getTransaction,
  updateTransaction: updateTransaction,
  deleteTransaction: deleteTransaction,
};
