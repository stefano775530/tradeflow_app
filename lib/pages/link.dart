class ApiEndpoints {
  static const String baseUrl =
      "https://roger-unimplored-luella.ngrok-free.dev/api";

  static const String login = "$baseUrl/user/login";
  static const String signup = "$baseUrl/user/signup";

  static const String lowStockAlerts = "$baseUrl/alerts/low-stock";

  static const String forgotPassword = "$baseUrl/user/forgot-password";
  static const String resetPassword = "$baseUrl/user/reset-password";

  static const String addWarehouse = "$baseUrl/warehouse";
  static const String getWarehouses = "$baseUrl/warehouse";
  static const String goodsWarehouse = "$baseUrl/warehouse";
  static const String addsale = "$baseUrl/sales";

  static const String addPartner = "$baseUrl/partners/add";
  static const String getPartners = "$baseUrl/partners/all";
  static const String deletePartner = "$baseUrl/partners/delete";
  static const String updatePartner = "$baseUrl/partners/update";

  static const String addCheck = "$baseUrl/checks";
  static const String getChecks = "$baseUrl/checks";

  static const String pur = "$baseUrl/purchases";
  static String get transferWarehouse => "$baseUrl/warehouse/transfer";
  static String get getWarehouseProducts => "$baseUrl/warehouse/products";
  static const String allproducts = "$baseUrl/reports/storage-valuation";
  static String get getDebts => "$baseUrl/sales";

  static const String addpurchase =
      "$baseUrl/purchases"; // تأكد أن المسار مطابق للباك إند عندك

  static const String getSuppliersDebts =
      "$baseUrl/purchases"; // تأكد أن المسار مطابق للباك إند عندكr

  static const String getChecksApi =
      "$baseUrl/checks?type=وارد&page=1&limit=100&sortBy=issue_date&sortOrder=DESC&status=pending";

  static const String getDebtsToUs = "$baseUrl/debts/to-us";
  static const String getDebtsFromUs = "$baseUrl/debts/from-us";
  static const String getCustomerDetails = "$baseUrl/debts/details";
  static const String addPayment = "$baseUrl/debts/add-payment";

  static const String getMonthlyReport = "$baseUrl/reports/monthly";
  static const String getYearlyReport = "$baseUrl/reports/yearly";
  static const String getMonthlyChecks =
      "$baseUrl/reports/incoming-checks-monthly";

  static const String logout = "$baseUrl/user/logout";

  static const String getZakatReport = "$baseUrl/reports/zakat";
}
