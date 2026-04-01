import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tradeflow_app/pages/link.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  // 🔥 إرسال الإيميل للباك
  Future<void> _handleSendRequest() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your email")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.forgotPassword),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({"email": email}),
      );

      final data = jsonDecode(response.body);

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        String token = data["token"];

        // 🔥 فتح إدخال الباسورد الجديد
        _showResetPasswordSheet(token);
      } else {
        throw Exception("failed");
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔥 Bottom Sheet لإدخال الباسورد
  void _showResetPasswordSheet(String token) {
    final TextEditingController newPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Enter New Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // حقل الباسورد
              TextField(
                controller: newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "New Password",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),

              // زر التحديث
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await _resetPassword(token, newPasswordController.text);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password updated successfully"),
                      ),
                    );
                  },
                  child: const Text("Update Password"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔥 إرسال الباسورد الجديد
  Future<void> _resetPassword(String token, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/user/reset-password/$token'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({"password": password}),
      );

      print(response.body);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1E1E1E);
    const darkBlue = Color(0xFF1B3E7A);
    const lightGrey = Color(0xFF9E9E9E);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            children: [
              Icon(
                Icons.lock_outline,
                size: 100,
                color: const Color(0xFF5D84C7).withOpacity(0.8),
              ),
              const SizedBox(height: 30),
              const Text(
                "Forgot your password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Enter your email address and we will send you a link to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(color: lightGrey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // حقل الإيميل
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: lightGrey.withOpacity(0.5)),
                ),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "user@email.com",
                    hintStyle: TextStyle(color: lightGrey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // زر الإرسال
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendRequest,
                  style: ElevatedButton.styleFrom(backgroundColor: darkBlue),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Send Reset Link",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
