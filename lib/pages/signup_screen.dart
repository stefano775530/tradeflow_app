// import 'package:flutter/material.dart';

// class SignUpScreen extends StatelessWidget {
//   const SignUpScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context), // للعودة للخلف
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "let’s  create your account",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 30),

//             // صف الاسم الأول والأخير
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildField(Icons.person_outline, "First name"),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(child: _buildField(Icons.person_outline, "Last name")),
//               ],
//             ),
//             const SizedBox(height: 15),
//             _buildField(Icons.person_outline, "Username"),
//             const SizedBox(height: 15),
//             _buildField(Icons.email_outlined, "e-mail"),
//             const SizedBox(height: 15),
//             _buildField(Icons.phone_outlined, "phone number"),
//             const SizedBox(height: 15),
//             _buildField(Icons.stars, "password"),

//             const SizedBox(height: 40),

//             // زر إنشاء الحساب
//             SizedBox(
//               width: double.infinity,
//               height: 55,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2979FF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   "Create account",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // دالة بناء الحقول المخصصة
//   Widget _buildField(IconData icon, String hint) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.black54),
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.black87),
//           hintText: hint,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 15),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tradeflow_app/pages/link.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 🔥 Signup Function
  Future<void> signUpUser() async {
    try {
      final url = Uri.parse(ApiEndpoints.signup);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "name":
              "${firstNameController.text} ${lastNameController.text}", // دمج الاسم
          "email": emailController.text,
          "password": passwordController.text,
          "phone_number": phoneController.text,
          "warehouses": 1, // مؤقت (حسب الباك عندك)
        }),
      );

      if (response.statusCode == 201) {
        print("✅ Account created");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );

        Navigator.pop(context); // يرجع للوغ ان
      } else {
        print("❌ Failed");
        print(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create account")),
        );
      }
    } catch (e) {
      print("🔥 Error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "let’s create your account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: _buildField(
                    Icons.person_outline,
                    "First name",
                    controller: firstNameController,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildField(
                    Icons.person_outline,
                    "Last name",
                    controller: lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            _buildField(
              Icons.person_outline,
              "Username",
              controller: usernameController,
            ),
            const SizedBox(height: 15),

            _buildField(
              Icons.email_outlined,
              "e-mail",
              controller: emailController,
            ),
            const SizedBox(height: 15),

            _buildField(
              Icons.phone_outlined,
              "phone number",
              controller: phoneController,
            ),
            const SizedBox(height: 15),

            _buildField(
              Icons.lock,
              "password",
              isPassword: true,
              controller: passwordController,
            ),

            const SizedBox(height: 40),

            // زر Create Account
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: signUpUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2979FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Create account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Field
  Widget _buildField(
    IconData icon,
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black54),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black87),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
