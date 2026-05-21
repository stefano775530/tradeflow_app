// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({super.key});

//   final Color primaryBlue = const Color(0xFF3D5EAB);
//   final Color scaffoldBg = const Color(0xFFF8FAFF);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: scaffoldBg,
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "التقارير والإحصائيات",
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             _buildSectionTitle("ملخص الأداء"),
//             const SizedBox(height: 15),
//             _buildStatCard(
//               "إجمالي المبيعات",
//               "₪ 45,200",
//               Icons.trending_up,
//               Colors.green,
//             ),
//             _buildStatCard(
//               "الديون المستحقة",
//               "₪ 12,850",
//               Icons.money_off,
//               Colors.redAccent,
//             ),
//             const SizedBox(height: 30),
//             _buildSectionTitle("الأكثر مبيعاً هذا الشهر"),
//             const SizedBox(height: 15),
//             // هنا يمكنك مستقبلاً إضافة Chart أو قائمة
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.grey.withOpacity(0.1)),
//               ),
//               child: const Column(
//                 children: [
//                   Icon(Icons.bar_chart_rounded, size: 50, color: Colors.grey),
//                   SizedBox(height: 10),
//                   Text(
//                     "سيتم عرض الرسوم البيانية هنا قريباً",
//                     style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         fontFamily: 'Cairo',
//         color: Color(0xFF2D3243),
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(icon, color: color, size: 30),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 22,
//                   fontWeight: FontWeight.w900,
//                   color: Color(0xFF2D3243),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D5EAB),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildSectionTitle("الإحصائيات المالية"),
            const SizedBox(height: 12),
            _buildStatCard(
              title: "إجمالي المبيعات",
              value: "₪ 45,200",
              icon: Icons.trending_up_rounded,
              iconBg: const Color(0xFFE8F0FE),
              iconColor: const Color(0xFF3D5EAB),
              valueColor: const Color(0xFF3D5EAB),
            ),
            _buildStatCard(
              title: "الديون على التاجر",
              value: "₪ 12,850",
              icon: Icons.receipt_long_rounded,
              iconBg: const Color(0xFFFFF0F0),
              iconColor: const Color(0xFFD32F2F),
              valueColor: const Color(0xFFD32F2F),
            ),
            _buildStatCard(
              title: "مجموع الشيكات",
              value: "₪ 28,400",
              icon: Icons.edit_document,
              iconBg: const Color(0xFFF0EDFF),
              iconColor: const Color(0xFF534AB7),
              valueColor: const Color(0xFF534AB7),
            ),
            _buildStatCard(
              title: "إجمالي المبالغ",
              value: "₪ 86,450",
              icon: Icons.account_balance_wallet_rounded,
              iconBg: const Color(0xFFFDF3E0),
              iconColor: const Color(0xFF854F0B),
              valueColor: const Color(0xFF854F0B),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle("الزكاة السنوية"),
            const SizedBox(height: 12),
            _buildZakatCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
        color: Color(0xFF2D3243),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZakatCard() {
    const double totalAmount = 86450;
    const double nisab = 5000;
    const double zakatAmount = totalAmount * 0.025;
    final bool nisabReached = totalAmount >= nisab;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: nisabReached
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: nisabReached
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE65100),
                  ),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "الزكاة السنوية",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: Color(0xFF2E7D32),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFDCEDC8), height: 1),
          const SizedBox(height: 16),
          _buildZakatRow("إجمالي المبالغ", "₪ 86,450"),
          const SizedBox(height: 10),
          _buildZakatRow("نسبة الزكاة", "2.5%"),
          const SizedBox(height: 10),
          _buildZakatRow("النصاب المطلوب", "₪ 5,000"),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  "مبلغ الزكاة المستحقة",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₪ ${zakatAmount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "لم يتم الدفع بعد",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Color(0xFF888888),
                ),
              ),
              Text(
                "آخر دفعة: لم تُحدد",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Color(0xFF888888),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZakatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E7D32),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
