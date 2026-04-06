import 'package:flutter/material.dart';
import 'package:tradeflow_app/pages/home.dart'; // استيراد شاشة الرئيسية
import 'package:tradeflow_app/pages/login_screen.dart'; // استيراد شاشة الدخول

void main() {
  runApp(const TradeFlowApp());
}

class TradeFlowApp extends StatelessWidget {
  const TradeFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TradeFlow',
      theme: ThemeData(
        // تفعيل الخط الجديد لكل التطبيق
        fontFamily: 'Cairo',

        // الحفاظ على الألوان والنمط الذي تفضله
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A80F0),
          primary: const Color(0xFF4A80F0),
        ),

        useMaterial3: true,
      ),
      // تشغيل التطبيق مباشرة على شاشتنا المصممة
      home: const LoginScreen(),
    );
  }
}
