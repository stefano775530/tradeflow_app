const saleService = require("../services/sale.service");

async function createSale(req, res) {
  const sale = await saleService.createSaleForUser(
    req.userData.userId,
    req.body,
  );

  res.status(201).json({
    message: "Sale created successfully",
    sale,
  });
}
async function addSalePayment(req, res) {
  const sale = await saleService.addPaymentToSaleForUser(
    req.userData.userId,
    req.params.id,
    req.body,
  );

  res.status(201).json({
    message: "Payment added successfully",
    sale,
  });
}

module.exports = {
  createSale,
  addSalePayment,
};
