import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/home.dart';
import 'package:tradeflow_app/pages/link.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      final url = Uri.parse(ApiEndpoints.login);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("✅ Login success");
        print(data);
        final token = data["token"]; // تأكدي من اسمه من الباك

        // 🔥 تخزين التوكن
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        print("💾 Token saved: $token");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        print("❌ Login failed");
        print(response.body);
      }
    } catch (e) {
      print("🔥 Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 80),

              const Icon(Icons.person_outline, size: 90, color: Colors.black),

              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'T',
                      style: TextStyle(color: Color(0xFF2979FF)),
                    ),
                    TextSpan(
                      text: 'radeFlow',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // الحقول
              _buildField("Email", controller: emailController),
              const SizedBox(height: 20),
              _buildField(
                "Password",
                isPassword: true,
                controller: passwordController,
              ),

              const SizedBox(height: 15),

              // Remember + Forgot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value!),
                        activeColor: const Color(0xFF2979FF),
                      ),
                      const Text(
                        "Remember me?",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "forgot password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // زر Login
              _buildButton(
                context,
                "Login",
                const Color(0xFF2979FF),
                Colors.white,
                null,
                onPressed: loginUser,
              ),

              const SizedBox(height: 15),

              // زر Create Account
              _buildButton(
                context,
                "Create account",
                const Color(0xFF2979FF),
                Colors.white,
                const SignUpScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 TextField
  Widget _buildField(
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black87),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // 🔹 Button
  Widget _buildButton(
    BuildContext context,
    String title,
    Color bgColor,
    Color textColor,
    Widget? targetScreen, {
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          } else if (targetScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
