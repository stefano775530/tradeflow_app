class ApiEndpoints {
  static const String baseUrl =
      "https://roger-unimplored-luella.ngrok-free.dev/api";

  static const String login = "$baseUrl/user/login";
  static const String signup = "$baseUrl/user/sign-up";

  static const String forgotPassword = "$baseUrl/user/forgot-password";
  static const String resetPassword = "$baseUrl/user/reset-password";

  static const String addWarehouse =
      "$baseUrl/warehouse"; // تأكد إذا كانت /warehouse/add

  // تعديل رابط الشركاء بناءً على الـ JSON اللي بعتته سابقاً
  static const String addPartner = "$baseUrl/partners/add";
}
