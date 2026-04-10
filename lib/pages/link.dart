class ApiEndpoints {
  static const String baseUrl =
      "https://roger-unimplored-luella.ngrok-free.dev/api";

  static const String login = "$baseUrl/user/login";
  static const String signup = "$baseUrl/user/signup";

  static const String forgotPassword = "$baseUrl/user/forgot-password";
  static const String resetPassword = "$baseUrl/user/reset-password";

  static const String addWarehouse = "$baseUrl/warehouse";
  static const String addPartner = "$baseUrl/partners/add";

  static const String getWarehouses = "$baseUrl/warehouse";
  static const String addCheck = "$baseUrl/checks";

  static const String getChecks = "$baseUrl/checks";
}
