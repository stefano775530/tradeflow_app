// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:tradeflow_app/pages/home.dart';
// // // import 'package:tradeflow_app/pages/link.dart';
// // // import 'signup_screen.dart';
// // // import 'forgot_password_screen.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';

// // // class LoginScreen extends StatefulWidget {
// // //   const LoginScreen({super.key});

// // //   @override
// // //   State<LoginScreen> createState() => _LoginScreenState();
// // // }

// // // class _LoginScreenState extends State<LoginScreen> {
// // //   bool _rememberMe = false;

// // //   final TextEditingController emailController = TextEditingController();
// // //   final TextEditingController passwordController = TextEditingController();

// // //   Future<void> loginUser() async {
// // //     try {
// // //       final url = Uri.parse(ApiEndpoints.login);

// // //       final response = await http.post(
// // //         url,
// // //         headers: {
// // //           'Content-Type': 'application/json',
// // //           'ngrok-skip-browser-warning': 'true',
// // //         },
// // //         body: jsonEncode({
// // //           "email": emailController.text,
// // //           "password": passwordController.text,
// // //         }),
// // //       );

// // //       if (response.statusCode == 200) {
// // //         final data = jsonDecode(response.body);

// // //         print("✅ Login success");
// // //         print(data);
// // //         final token = data["token"]; // تأكدي من اسمه من الباك

// // //         // 🔥 تخزين التوكن
// // //         final prefs = await SharedPreferences.getInstance();
// // //         await prefs.setString("token", token);

// // //         print("💾 Token saved: $token");

// // //         Navigator.push(
// // //           context,
// // //           MaterialPageRoute(builder: (_) => HomeScreen()),
// // //         );
// // //       } else {
// // //         print("❌ Login failed");
// // //         print(response.body);
// // //       }
// // //     } catch (e) {
// // //       print("🔥 Error: $e");
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       body: SafeArea(
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.symmetric(horizontal: 30.0),
// // //           child: Column(
// // //             children: [
// // //               const SizedBox(height: 80),

// // //               const Icon(Icons.person_outline, size: 90, color: Colors.black),

// // //               RichText(
// // //                 text: const TextSpan(
// // //                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
// // //                   children: [
// // //                     TextSpan(
// // //                       text: 'T',
// // //                       style: TextStyle(color: Color(0xFF2979FF)),
// // //                     ),
// // //                     TextSpan(
// // //                       text: 'radeFlow',
// // //                       style: TextStyle(color: Colors.black),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),

// // //               const SizedBox(height: 60),

// // //               // الحقول
// // //               _buildField("Email", controller: emailController),
// // //               const SizedBox(height: 20),
// // //               _buildField(
// // //                 "Password",
// // //                 isPassword: true,
// // //                 controller: passwordController,
// // //               ),

// // //               const SizedBox(height: 15),

// // //               // Remember + Forgot
// // //               Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Row(
// // //                     children: [
// // //                       Checkbox(
// // //                         value: _rememberMe,
// // //                         onChanged: (value) =>
// // //                             setState(() => _rememberMe = value!),
// // //                         activeColor: const Color(0xFF2979FF),
// // //                       ),
// // //                       const Text(
// // //                         "Remember me?",
// // //                         style: TextStyle(color: Colors.grey),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   TextButton(
// // //                     onPressed: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(
// // //                           builder: (context) => const ForgotPasswordScreen(),
// // //                         ),
// // //                       );
// // //                     },
// // //                     child: const Text(
// // //                       "forgot password?",
// // //                       style: TextStyle(color: Colors.grey),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),

// // //               const SizedBox(height: 30),

// // //               // زر Login
// // //               _buildButton(
// // //                 context,
// // //                 "Login",
// // //                 const Color(0xFF2979FF),
// // //                 Colors.white,
// // //                 null,
// // //                 onPressed: loginUser,
// // //               ),

// // //               const SizedBox(height: 15),

// // //               // زر Create Account
// // //               _buildButton(
// // //                 context,
// // //                 "Create account",
// // //                 const Color(0xFF2979FF),
// // //                 Colors.white,
// // //                 const SignUpScreen(),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // 🔹 TextField
// // //   Widget _buildField(
// // //     String hint, {
// // //     bool isPassword = false,
// // //     TextEditingController? controller,
// // //   }) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         borderRadius: BorderRadius.circular(8),
// // //         border: Border.all(color: Colors.black87),
// // //       ),
// // //       child: TextField(
// // //         controller: controller,
// // //         obscureText: isPassword,
// // //         decoration: InputDecoration(
// // //           hintText: hint,
// // //           contentPadding: const EdgeInsets.symmetric(horizontal: 15),
// // //           border: InputBorder.none,
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // 🔹 Button
// // //   Widget _buildButton(
// // //     BuildContext context,
// // //     String title,
// // //     Color bgColor,
// // //     Color textColor,
// // //     Widget? targetScreen, {
// // //     VoidCallback? onPressed,
// // //   }) {
// // //     return SizedBox(
// // //       width: double.infinity,
// // //       height: 55,
// // //       child: ElevatedButton(
// // //         onPressed: () {
// // //           if (onPressed != null) {
// // //             onPressed();
// // //           } else if (targetScreen != null) {
// // //             Navigator.push(
// // //               context,
// // //               MaterialPageRoute(builder: (context) => targetScreen),
// // //             );
// // //           }
// // //         },
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: bgColor,
// // //           foregroundColor: textColor,
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //           ),
// // //           elevation: 0,
// // //         ),
// // //         child: Text(
// // //           title,
// // //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:tradeflow_app/pages/home.dart';
// // import 'package:tradeflow_app/pages/link.dart';
// // import 'signup_screen.dart';
// // import 'forgot_password_screen.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen> {
// //   bool _rememberMe = false;

// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   Future<void> loginUser() async {
// //     try {
// //       final url = Uri.parse(ApiEndpoints.login);

// //       final response = await http.post(
// //         url,
// //         headers: {
// //           'Content-Type': 'application/json',
// //           'ngrok-skip-browser-warning': 'true',
// //         },
// //         body: jsonEncode({
// //           "email": emailController.text,
// //           "password": passwordController.text,
// //         }),
// //       );

// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);

// //         print("✅ Login success");
// //         print(data);
// //         final token = data["token"]; // تأكدي من اسمه من الباك

// //         // 🔥 تخزين التوكن
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setString("token", token);

// //         print("💾 Token saved: $token");

// //         Navigator.push(
// //           context,
// //           MaterialPageRoute(builder: (_) => HomeScreen()),
// //         );
// //       } else {
// //         print("❌ Login failed");
// //         print(response.body);
// //       }
// //     } catch (e) {
// //       print("🔥 Error: $e");
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // 🎨 درجة اللون الأزرق المأخوذة من الصورة
// //     const Color brandBlue = Color(0xFF3A62B6);

// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.symmetric(horizontal: 30.0),
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 80),

// //               const Icon(Icons.person_outline, size: 90, color: Colors.black),

// //               RichText(
// //                 text: const TextSpan(
// //                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
// //                   children: [
// //                     TextSpan(
// //                       text: 'T',
// //                       style: TextStyle(
// //                         color: Color(0xFF3A62B6),
// //                       ), // تم تحديث اللون هنا
// //                     ),
// //                     TextSpan(
// //                       text: 'radeFlow',
// //                       style: TextStyle(color: Colors.black),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               const SizedBox(height: 60),

// //               // الحقول
// //               _buildField("Email", controller: emailController),
// //               const SizedBox(height: 20),
// //               _buildField(
// //                 "Password",
// //                 isPassword: true,
// //                 controller: passwordController,
// //               ),

// //               const SizedBox(height: 15),

// //               // Remember + Forgot
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Checkbox(
// //                         value: _rememberMe,
// //                         onChanged: (value) =>
// //                             setState(() => _rememberMe = value!),
// //                         activeColor: brandBlue, // تم تحديث اللون هنا
// //                       ),
// //                       const Text(
// //                         "Remember me?",
// //                         style: TextStyle(color: Colors.grey),
// //                       ),
// //                     ],
// //                   ),
// //                   TextButton(
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(
// //                           builder: (context) => const ForgotPasswordScreen(),
// //                         ),
// //                       );
// //                     },
// //                     child: const Text(
// //                       "forgot password?",
// //                       style: TextStyle(color: Colors.grey),
// //                     ),
// //                   ),
// //                 ],
// //               ),

// //               const SizedBox(height: 30),

// //               // زر Login
// //               _buildButton(
// //                 context,
// //                 "Login",
// //                 brandBlue, // تم تحديث اللون هنا
// //                 Colors.white,
// //                 null,
// //                 onPressed: loginUser,
// //               ),

// //               const SizedBox(height: 15),

// //               // زر Create Account
// //               _buildButton(
// //                 context,
// //                 "Create account",
// //                 brandBlue, // تم تحديث اللون هنا
// //                 Colors.white,
// //                 const SignUpScreen(),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // 🔹 TextField
// //   Widget _buildField(
// //     String hint, {
// //     bool isPassword = false,
// //     TextEditingController? controller,
// //   }) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.black87),
// //       ),
// //       child: TextField(
// //         controller: controller,
// //         obscureText: isPassword,
// //         decoration: InputDecoration(
// //           hintText: hint,
// //           contentPadding: const EdgeInsets.symmetric(horizontal: 15),
// //           border: InputBorder.none,
// //         ),
// //       ),
// //     );
// //   }

// //   // 🔹 Button
// //   Widget _buildButton(
// //     BuildContext context,
// //     String title,
// //     Color bgColor,
// //     Color textColor,
// //     Widget? targetScreen, {
// //     VoidCallback? onPressed,
// //   }) {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 55,
// //       child: ElevatedButton(
// //         onPressed: () {
// //           if (onPressed != null) {
// //             onPressed();
// //           } else if (targetScreen != null) {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => targetScreen),
// //             );
// //           }
// //         },
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: bgColor,
// //           foregroundColor: textColor,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           elevation: 0,
// //         ),
// //         child: Text(
// //           title,
// //           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/home.dart';
// import 'package:tradeflow_app/pages/link.dart';
// import 'signup_screen.dart';
// import 'forgot_password_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:math';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with TickerProviderStateMixin {
//   bool _rememberMe = false;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // Animations controllers
//   late AnimationController _fadeController;
//   late Animation<double> _fadeAnimation;
//   late AnimationController _slideController;
//   late Animation<Offset> _slideAnimation;
//   late AnimationController _glowController;
//   late Animation<double> _glowAnimation;
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   Future<void> loginUser() async {
//     try {
//       final url = Uri.parse(ApiEndpoints.login);

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//         },
//         body: jsonEncode({
//           "email": emailController.text,
//           "password": passwordController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         print("✅ Login success");
//         print(data);
//         final token = data["token"];

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString("token", token);

//         print("💾 Token saved: $token");

//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => HomeScreen()),
//         );
//       } else {
//         print("❌ Login failed");
//         print(response.body);
//       }
//     } catch (e) {
//       print("🔥 Error: $e");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     // Fade animation
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = CurvedAnimation(
//       parent: _fadeController,
//       curve: Curves.easeIn,
//     );
//     _fadeController.forward();

//     // Slide up animation
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
//           CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//         );
//     _slideController.forward();

//     // Glow effect for button
//     _glowController = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat(reverse: true);
//     _glowAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
//       CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
//     );

//     // Pulse for logo
//     _pulseController = AnimationController(
//       duration: const Duration(seconds: 3),
//       vsync: this,
//     )..repeat(reverse: true);
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     _glowController.dispose();
//     _pulseController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     const Color brandBlue = Color(0xFF3A62B6);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 30.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 60),

//               // Logo with pulse animation
//               AnimatedBuilder(
//                 animation: _pulseAnimation,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _pulseAnimation.value,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: brandBlue.withOpacity(0.2),
//                             blurRadius: 30,
//                             spreadRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.trending_up_rounded,
//                         size: 80,
//                         color: brandBlue.withOpacity(0.9),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 16),

//               // Title
//               AnimatedBuilder(
//                 animation: _fadeAnimation,
//                 builder: (context, child) {
//                   return FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: RichText(
//                       text: TextSpan(
//                         style: const TextStyle(
//                           fontSize: 38,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: 'T',
//                             style: TextStyle(
//                               color: brandBlue,
//                               shadows: [
//                                 Shadow(
//                                   color: brandBlue.withOpacity(0.5),
//                                   blurRadius: 8,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const TextSpan(
//                             text: 'radeFlow',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 12),

//               // Decorative line
//               AnimatedBuilder(
//                 animation: _fadeAnimation,
//                 builder: (context, child) {
//                   return FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Container(
//                       width: 60,
//                       height: 3,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [brandBlue, brandBlue.withOpacity(0.3)],
//                         ),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//               const SizedBox(height: 60),

//               // Form with slide animation
//               SlideTransition(
//                 position: _slideAnimation,
//                 child: Column(
//                   children: [
//                     _buildField("Email", controller: emailController),
//                     const SizedBox(height: 20),
//                     _buildField(
//                       "Password",
//                       isPassword: true,
//                       controller: passwordController,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 15),

//               // Remember + Forgot
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: _rememberMe,
//                         onChanged: (value) =>
//                             setState(() => _rememberMe = value!),
//                         activeColor: brandBlue,
//                         side: BorderSide(color: Colors.grey.withOpacity(0.5)),
//                       ),
//                       const Text(
//                         "Remember me?",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ForgotPasswordScreen(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       "Forgot password?",
//                       style: TextStyle(
//                         color: brandBlue.withOpacity(0.8),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 30),

//               // Login Button
//               _buildButton(
//                 context,
//                 "Login",
//                 brandBlue,
//                 Colors.white,
//                 null,
//                 onPressed: loginUser,
//               ),

//               const SizedBox(height: 12),

//               // Create Account Button
//               _buildButton(
//                 context,
//                 "Create account",
//                 brandBlue,
//                 Colors.white,
//                 const SignUpScreen(),
//               ),

//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // احترافية TextField
//   Widget _buildField(
//     String hint, {
//     bool isPassword = false,
//     TextEditingController? controller,
//   }) {
//     bool isEmail = hint == "Email";
//     return AnimatedBuilder(
//       animation: _fadeAnimation,
//       builder: (context, child) {
//         return FadeTransition(
//           opacity: _fadeAnimation,
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.white.withOpacity(0.08),
//                   Colors.white.withOpacity(0.03),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: Colors.grey.withOpacity(0.3),
//                 width: 1.2,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF3A62B6).withOpacity(0.05),
//                   blurRadius: 10,
//                   spreadRadius: 0,
//                 ),
//               ],
//             ),
//             child: TextField(
//               controller: controller,
//               obscureText: isPassword,
//               style: const TextStyle(color: Colors.black87, fontSize: 16),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
//                 prefixIcon: Icon(
//                   isEmail ? Icons.email_outlined : Icons.lock_outline,
//                   color: const Color(0xFF3A62B6).withOpacity(0.7),
//                   size: 22,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 18,
//                 ),
//                 border: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // احترافية Button مع glow effect
//   Widget _buildButton(
//     BuildContext context,
//     String title,
//     Color bgColor,
//     Color textColor,
//     Widget? targetScreen, {
//     VoidCallback? onPressed,
//   }) {
//     return AnimatedBuilder(
//       animation: _glowAnimation,
//       builder: (context, child) {
//         return Container(
//           width: double.infinity,
//           height: 55,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: title == "Login"
//                   ? [bgColor, bgColor.withOpacity(0.8)]
//                   : [Colors.white, Colors.white],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: title == "Login"
//                 ? [
//                     BoxShadow(
//                       color: bgColor.withOpacity(0.4 * _glowAnimation.value),
//                       blurRadius: 15,
//                       spreadRadius: 2,
//                     ),
//                   ]
//                 : [],
//           ),
//           child: ElevatedButton(
//             onPressed: () {
//               if (onPressed != null) {
//                 onPressed();
//               } else if (targetScreen != null) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => targetScreen),
//                 );
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: title == "Login"
//                   ? Colors.transparent
//                   : Colors.white,
//               foregroundColor: title == "Login" ? textColor : bgColor,
//               shadowColor: Colors.transparent,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 side: title == "Create account"
//                     ? BorderSide(color: bgColor.withOpacity(0.5), width: 1.5)
//                     : BorderSide.none,
//               ),
//             ),
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5,
//                 color: title == "Login" ? textColor : bgColor,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/home.dart';
import 'package:tradeflow_app/pages/link.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _rememberMe = false;
  bool _obscurePassword = true; // ✅ إضافة

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
        final token = data["token"];
        final username = data["name"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setString("name", username);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
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
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _slideController.forward();

    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF3A62B6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 60),

              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: brandBlue.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        size: 80,
                        color: brandBlue.withOpacity(0.9),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'T',
                            style: TextStyle(
                              color: brandBlue,
                              shadows: [
                                Shadow(
                                  color: brandBlue.withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          const TextSpan(
                            text: 'radeFlow',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: 60,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [brandBlue, brandBlue.withOpacity(0.3)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildField("Email", controller: emailController),
                    const SizedBox(height: 20),
                    _buildField(
                      "Password",
                      isPassword: true,
                      controller: passwordController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) =>
                            setState(() => _rememberMe = value!),
                        activeColor: brandBlue,
                        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
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
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: brandBlue.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _buildButton(
                context,
                "Login",
                brandBlue,
                Colors.white,
                null,
                onPressed: loginUser,
              ),

              const SizedBox(height: 12),

              _buildButton(
                context,
                "Create account",
                brandBlue,
                Colors.white,
                const SignUpScreen(),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    bool isEmail = hint == "Email";
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3A62B6).withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword ? _obscurePassword : false,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                prefixIcon: Icon(
                  isEmail ? Icons.email_outlined : Icons.lock_outline,
                  color: const Color(0xFF3A62B6).withOpacity(0.7),
                  size: 22,
                ),
                // ✅ زر العين للباسوورد فقط
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey.withOpacity(0.6),
                          size: 22,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButton(
    BuildContext context,
    String title,
    Color bgColor,
    Color textColor,
    Widget? targetScreen, {
    VoidCallback? onPressed,
  }) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: title == "Login"
                  ? [bgColor, bgColor.withOpacity(0.8)]
                  : [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: title == "Login"
                ? [
                    BoxShadow(
                      color: bgColor.withOpacity(0.4 * _glowAnimation.value),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
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
              backgroundColor: title == "Login"
                  ? Colors.transparent
                  : Colors.white,
              foregroundColor: title == "Login" ? textColor : bgColor,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: title == "Create account"
                    ? BorderSide(color: bgColor.withOpacity(0.5), width: 1.5)
                    : BorderSide.none,
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: title == "Login" ? textColor : bgColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
