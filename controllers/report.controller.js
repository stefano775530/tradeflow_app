const reportService = require("../services/report.service");

async function getMonthlyReport(req, res) {
  const report = await reportService.getMonthlyReportForUser(
    req.userData.userId,
    req.query,
  );

  res.status(200).json(report);
}

async function getDashboardSummary(req, res) {
  const report = await reportService.getDashboardSummaryForUser(
    req.userData.userId,
  );

  res.status(200).json(report);
}

async function getCategoryReport(req, res) {
  const report = await reportService.getCategoryReportForUser(
    req.userData.userId,
    req.query,
  );

  res.status(200).json(report);
}

async function getYearlyReport(req, res) {
  const report = await reportService.getYearlyReportForUser(
    req.userData.userId,
    req.query,
  );

  res.status(200).json(report);
}

async function getInventoryValuation(req, res) {
  const report = await reportService.getInventoryValuationForUser(
    req.userData.userId,
  );

  res.status(200).json(report);
}

async function getZakatReport(req, res) {
  const report = await reportService.getZakatReportForUser(req.userData.userId);

  res.status(200).json(report);
}

module.exports = {
  getMonthlyReport,
  getDashboardSummary,
  getCategoryReport,
  getYearlyReport,
  getInventoryValuation,
  getZakatReport,
};
