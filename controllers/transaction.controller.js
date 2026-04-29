const transactionService = require("../services/transaction.service");

async function createTransaction(req, res) {
  const transaction = await transactionService.createTransactionForUser(
    req.userData.userId,
    req.body,
  );

  res.status(201).json({
    message: "Transaction created",
    transaction,
  });
}

async function getTransactions(req, res) {
  const result = await transactionService.getTransactionsForUser(
    req.userData.userId,
    req.query,
  );

  res.status(200).json(result);
}

async function getTransaction(req, res) {
  const transaction = await transactionService.findOwnedTransactionOrThrow(
    req.userData.userId,
    req.params.id,
  );

  res.status(200).json(transaction);
}

async function updateTransaction(req, res) {
  const transaction = await transactionService.updateTransactionForUser(
    req.userData.userId,
    req.params.id,
    req.body,
  );

  res.status(200).json({
    message: "Transaction updated",
    transaction,
  });
}

async function deleteTransaction(req, res) {
  await transactionService.deleteTransactionForUser(
    req.userData.userId,
    req.params.id,
  );

  res.status(200).json({ message: "Transaction deleted" });
}

module.exports = {
  createTransaction,
  getTransactions,
  getTransaction,
  updateTransaction,
  deleteTransaction,
};
