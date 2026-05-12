import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  final Color primaryBlue = const Color(0xFF3D5EAB);
  final Color scaffoldBg = const Color(0xFFF8FAFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "التقارير والإحصائيات",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildSectionTitle("ملخص الأداء"),
            const SizedBox(height: 15),
            _buildStatCard(
              "إجمالي المبيعات",
              "₪ 45,200",
              Icons.trending_up,
              Colors.green,
            ),
            _buildStatCard(
              "الديون المستحقة",
              "₪ 12,850",
              Icons.money_off,
              Colors.redAccent,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("الأكثر مبيعاً هذا الشهر"),
            const SizedBox(height: 15),
            // هنا يمكنك مستقبلاً إضافة Chart أو قائمة
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.bar_chart_rounded, size: 50, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "سيتم عرض الرسوم البيانية هنا قريباً",
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
        color: Color(0xFF2D3243),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D3243),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
