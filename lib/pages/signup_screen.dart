// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // import 'package:tradeflow_app/pages/link.dart';

// // class SignUpScreen extends StatefulWidget {
// //   const SignUpScreen({super.key});

// //   @override
// //   State<SignUpScreen> createState() => _SignUpScreenState();
// // }

// // class _SignUpScreenState extends State<SignUpScreen> {
// //   // Controllers
// //   final TextEditingController firstNameController = TextEditingController();
// //   final TextEditingController lastNameController = TextEditingController();
// //   final TextEditingController usernameController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   // 🔥 Signup Function
// //   Future<void> signUpUser() async {
// //     try {
// //       final url = Uri.parse(ApiEndpoints.signup);

// //       final response = await http.post(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'ngrok-skip-browser-warning': 'true',
// //         },
// //         body: jsonEncode({
// //           "name":
// //               "${firstNameController.text} ${lastNameController.text}", // دمج الاسم
// //           "email": emailController.text,
// //           "password": passwordController.text,
// //           "phone_number": phoneController.text,
// //           "warehouses": 1, // مؤقت (حسب الباك عندك)
// //         }),
// //       );

// //       if (response.statusCode == 201) {
// //         print("✅ Account created");

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Account created successfully")),
// //         );

// //         Navigator.pop(context); // يرجع للوغ ان
// //       } else {
// //         print("❌ Failed");
// //         print(response.body);

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Failed to create account")),
// //         );
// //       }
// //     } catch (e) {
// //       print("🔥 Error: $e");

// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back, color: Colors.black),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(24.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               "let’s create your account",
// //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 30),

// //             Row(
// //               children: [
// //                 Expanded(
// //                   child: _buildField(
// //                     Icons.person_outline,
// //                     "First name",
// //                     controller: firstNameController,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 10),
// //                 Expanded(
// //                   child: _buildField(
// //                     Icons.person_outline,
// //                     "Last name",
// //                     controller: lastNameController,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 15),

// //             _buildField(
// //               Icons.person_outline,
// //               "Username",
// //               controller: usernameController,
// //             ),
// //             const SizedBox(height: 15),

// //             _buildField(
// //               Icons.email_outlined,
// //               "e-mail",
// //               controller: emailController,
// //             ),
// //             const SizedBox(height: 15),

// //             _buildField(
// //               Icons.phone_outlined,
// //               "phone number",
// //               controller: phoneController,
// //             ),
// //             const SizedBox(height: 15),

// //             _buildField(
// //               Icons.lock,
// //               "password",
// //               isPassword: true,
// //               controller: passwordController,
// //             ),

// //             const SizedBox(height: 40),

// //             // زر Create Account
// //             SizedBox(
// //               width: double.infinity,
// //               height: 55,
// //               child: ElevatedButton(
// //                 onPressed: signUpUser,
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: const Color.fromARGB(255, 31, 80, 165),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(8),
// //                   ),
// //                 ),
// //                 child: const Text(
// //                   "Create account",
// //                   style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // 🔹 Field
// //   Widget _buildField(
// //     IconData icon,
// //     String hint, {
// //     bool isPassword = false,
// //     TextEditingController? controller,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.black54),
// //       ),
// //       child: TextField(
// //         controller: controller,
// //         obscureText: isPassword,
// //         decoration: InputDecoration(
// //           prefixIcon: Icon(icon, color: Colors.black87),
// //           hintText: hint,
// //           border: InputBorder.none,
// //           contentPadding: const EdgeInsets.symmetric(vertical: 15),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math' as math;

// import 'package:tradeflow_app/pages/link.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen>
//     with TickerProviderStateMixin {
//   final TextEditingController firstNameController = TextEditingController();
//   final TextEditingController lastNameController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _isLoading = false;

//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

//   @override
//   void initState() {
//     super.initState();

//     _fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     _slideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );
//     _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
//     _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
//         .animate(
//           CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//         );

//     _fadeController.forward();
//     _slideController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     firstNameController.dispose();
//     lastNameController.dispose();
//     usernameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> signUpUser() async {
//     setState(() => _isLoading = true);
//     try {
//       final url = Uri.parse(ApiEndpoints.signup);
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//         },
//         body: jsonEncode({
//           "name": "${firstNameController.text} ${lastNameController.text}",
//           "email": emailController.text,
//           "password": passwordController.text,
//           "phone_number": phoneController.text,
//           "warehouses": 1,
//         }),
//       );

//       if (response.statusCode == 201) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text("Account created successfully"),
//               backgroundColor: const Color(0xFF1F50A5),
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//           Navigator.pop(context);
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text("Failed to create account"),
//               backgroundColor: Colors.redAccent,
//               behavior: SnackBarBehavior.floating,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text("Something went wrong"),
//             backgroundColor: Colors.redAccent,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // ── Background glow (same as login) ──
//           Positioned(
//             top: -60,
//             left: -40,
//             child: Container(
//               width: 220,
//               height: 220,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFF1F50A5).withOpacity(0.07),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 30,
//             right: -30,
//             child: Container(
//               width: 140,
//               height: 140,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: const Color(0xFF1F50A5).withOpacity(0.05),
//               ),
//             ),
//           ),

//           SafeArea(
//             child: FadeTransition(
//               opacity: _fadeAnim,
//               child: SlideTransition(
//                 position: _slideAnim,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 28,
//                     vertical: 16,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ── Back button ──
//                       GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF2F5FC),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.arrow_back_ios_new_rounded,
//                             size: 18,
//                             color: Color(0xFF1F50A5),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 24),

//                       // ── Title ──
//                       const Text(
//                         "Let's create your account",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black87,
//                           letterSpacing: 0.2,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         "Fill in the details below to get started",
//                         style: TextStyle(fontSize: 13, color: Colors.black45),
//                       ),

//                       const SizedBox(height: 24),

//                       // ── First & Last name row ──
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _AnimatedField(
//                               delay: 100,
//                               child: _buildField(
//                                 Icons.person_outline_rounded,
//                                 "First name",
//                                 controller: firstNameController,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: _AnimatedField(
//                               delay: 180,
//                               child: _buildField(
//                                 Icons.person_outline_rounded,
//                                 "Last name",
//                                 controller: lastNameController,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 14),

//                       _AnimatedField(
//                         delay: 260,
//                         child: _buildField(
//                           Icons.alternate_email_rounded,
//                           "Username",
//                           controller: usernameController,
//                         ),
//                       ),
//                       const SizedBox(height: 14),

//                       _AnimatedField(
//                         delay: 340,
//                         child: _buildField(
//                           Icons.email_outlined,
//                           "E-mail",
//                           controller: emailController,
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                       ),
//                       const SizedBox(height: 14),

//                       _AnimatedField(
//                         delay: 420,
//                         child: _buildField(
//                           Icons.phone_outlined,
//                           "Phone number",
//                           controller: phoneController,
//                           keyboardType: TextInputType.phone,
//                         ),
//                       ),
//                       const SizedBox(height: 14),

//                       _AnimatedField(delay: 500, child: _buildPasswordField()),

//                       const SizedBox(height: 32),

//                       // ── Create Account Button ──
//                       _AnimatedField(
//                         delay: 580,
//                         child: SizedBox(
//                           width: double.infinity,
//                           height: 54,
//                           child: ElevatedButton(
//                             onPressed: _isLoading ? null : signUpUser,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF1F50A5),
//                               disabledBackgroundColor: const Color(
//                                 0xFF1F50A5,
//                               ).withOpacity(0.6),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                             ),
//                             child: _isLoading
//                                 ? const SizedBox(
//                                     width: 22,
//                                     height: 22,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2.5,
//                                     ),
//                                   )
//                                 : const Text(
//                                     "Create account",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       letterSpacing: 0.3,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // ── Already have account ──
//                       Center(
//                         child: GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: RichText(
//                             text: const TextSpan(
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.black45,
//                               ),
//                               children: [
//                                 TextSpan(text: "Already have an account? "),
//                                 TextSpan(
//                                   text: "Sign in",
//                                   style: TextStyle(
//                                     color: Color(0xFF1F50A5),
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),

//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Input field builder ──
//   Widget _buildField(
//     IconData icon,
//     String hint, {
//     TextEditingController? controller,
//     TextInputType? keyboardType,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7F9FF),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFDDE4F0), width: 1),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: const TextStyle(fontSize: 14, color: Colors.black87),
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: const Color(0xFF1F50A5), size: 20),
//           hintText: hint,
//           hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//         ),
//       ),
//     );
//   }

//   // ── Password field with show/hide ──
//   Widget _buildPasswordField() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFFF7F9FF),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: const Color(0xFFDDE4F0), width: 1),
//       ),
//       child: TextField(
//         controller: passwordController,
//         obscureText: _obscurePassword,
//         style: const TextStyle(fontSize: 14, color: Colors.black87),
//         decoration: InputDecoration(
//           prefixIcon: const Icon(
//             Icons.lock_outline_rounded,
//             color: Color(0xFF1F50A5),
//             size: 20,
//           ),
//           hintText: "Password",
//           hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 16),
//           suffixIcon: IconButton(
//             icon: Icon(
//               _obscurePassword
//                   ? Icons.visibility_off_outlined
//                   : Icons.visibility_outlined,
//               color: Colors.black38,
//               size: 20,
//             ),
//             onPressed: () {
//               setState(() => _obscurePassword = !_obscurePassword);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Staggered slide-in animation wrapper ──
// class _AnimatedField extends StatefulWidget {
//   final Widget child;
//   final int delay;

//   const _AnimatedField({required this.child, required this.delay});

//   @override
//   State<_AnimatedField> createState() => _AnimatedFieldState();
// }

// class _AnimatedFieldState extends State<_AnimatedField>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<Offset> _slide;
//   late Animation<double> _fade;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _slide = Tween<Offset>(
//       begin: const Offset(0, 0.25),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
//     _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

//     Future.delayed(Duration(milliseconds: widget.delay), () {
//       if (mounted) _ctrl.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _fade,
//       child: SlideTransition(position: _slide, child: widget.child),
//     );
//   }
// }

// // ── Trend arrow painter (same as login logo) ──
// class _TrendArrowPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = const Color(0xFF1F50A5)
//       ..strokeWidth = 3.2
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round
//       ..style = PaintingStyle.stroke;

//     final path = Path()
//       ..moveTo(0, size.height * 0.75)
//       ..lineTo(size.width * 0.3, size.height * 0.45)
//       ..lineTo(size.width * 0.55, size.height * 0.62)
//       ..lineTo(size.width, size.height * 0.1);

//     canvas.drawPath(path, paint);

//     // Arrow head
//     final arrowPaint = Paint()
//       ..color = const Color(0xFF1F50A5)
//       ..strokeWidth = 3.2
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;

//     canvas.drawLine(
//       Offset(size.width, size.height * 0.1),
//       Offset(size.width * 0.72, size.height * 0.1),
//       arrowPaint,
//     );
//     canvas.drawLine(
//       Offset(size.width, size.height * 0.1),
//       Offset(size.width, size.height * 0.38),
//       arrowPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tradeflow_app/pages/link.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();

    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> signUpUser() async {
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(ApiEndpoints.signup);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "name": "${firstNameController.text} ${lastNameController.text}",
          "email": emailController.text,
          "password": passwordController.text,
          "phone_number": phoneController.text,
          "warehouses": 1,
        }),
      );

      if (response.statusCode == 201) {
        // حفظ اسم المستخدم
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
          "name",
          "${firstNameController.text} ${lastNameController.text}",
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Account created successfully"),
              backgroundColor: const Color(0xFF1F50A5),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Failed to create account"),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Something went wrong"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(child: Text("Signup Screen")),
    );
  }
}
