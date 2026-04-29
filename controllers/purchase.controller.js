const purchaseService = require("../services/purchase.service");

async function createPurchase(req, res) {
  const purchase = await purchaseService.createPurchaseForUser(
    req.userData.userId,
    req.body,
  );

  res.status(201).json({
    message: "Purchase created successfully",
    purchase,
  });
}

async function addPurchasePayment(req, res) {
  const purchase = await purchaseService.addPaymentToPurchaseForUser(
    req.userData.userId,
    req.params.id,
    req.body,
  );

  res.status(201).json({
    message: "Payment added successfully",
    purchase,
  });
}

module.exports = {
  createPurchase,
  addPurchasePayment,
};
