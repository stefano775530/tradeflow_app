import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';
import 'package:tradeflow_app/pages/login_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(username: ""),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الصفحة الرئيسية"),
        backgroundColor: const Color(0xFF3D5EAB),
        foregroundColor: Colors.white,
      ),
      drawer: const CustomDrawer(username: "userName"),
      body: const Center(child: Text("أهلاً بك في تطبيق حمزة")),
    );
  }
}

// ==========================================
// القائمة الجانبية
// ==========================================
class CustomDrawer extends StatelessWidget {
  final String username;

  const CustomDrawer({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF3D5EAB);

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // الهيدر
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 25,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3D5EAB), Color(0xFF5B7FD4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 45, color: primaryBlue),
                ),
                const SizedBox(height: 12),
                const Text(
                  'أهلاً بك',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  " $username",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // القائمة
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildDrawerItem(
                  context,
                  Icons.account_circle_outlined,
                  'تفاصيل الحساب',
                  primaryBlue,
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountDetailsScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.support_agent_rounded,
                  'الدعم',
                  primaryBlue,
                  () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SupportScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // زر تسجيل الخروج
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // أغلق الـ Drawer
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.red.shade400,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(context, icon, title, color, onTap) => ListTile(
    leading: Icon(icon, color: color),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    onTap: onTap,
  );
}

// ==========================================
// صفحة تفاصيل الحساب
// ==========================================
class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: const Text("تفاصيل الحساب"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTile(Icons.person, "الاسم", "حمزة محمد"),
              const Divider(),
              _buildTile(Icons.email, "البريد", "hamza@official.com"),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock, color: Color(0xFF3D5EAB)),
                title: const Text(
                  "كلمة المرور",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                subtitle: Text(
                  _isObscure ? "••••••••••••" : "Hamza@123",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(icon, title, sub) => ListTile(
    leading: Icon(icon, color: const Color(0xFF3D5EAB)),
    title: Text(
      title,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
    subtitle: Text(
      sub,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  );
}

// ==========================================
// صفحة الدعم
// ==========================================
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: const Text("مركز الدعم"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _card(Icons.phone, "اتصال هاتفي", "+970 599 000 000", Colors.blue),
            const SizedBox(height: 15),
            _card(
              Icons.email,
              "البريد الإلكتروني",
              "support@app.com",
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(icon, title, sub, color) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(sub, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    ),
  );
}
