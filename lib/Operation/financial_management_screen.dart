import 'package:flutter/material.dart';

class FinancialManagementScreen extends StatefulWidget {
  const FinancialManagementScreen({super.key});

  @override
  State<FinancialManagementScreen> createState() =>
      _FinancialManagementScreenState();
}

class _FinancialManagementScreenState extends State<FinancialManagementScreen> {
  final Color primaryColor = const Color(0xFF446BC0);

  // البيانات الخاصة بمستودع الأخشاب
  final List<Map<String, dynamic>> obligations = [
    {
      'title': 'شحنة خشب سويد (مورد فنلندا)',
      'amount': '12,500',
      'date': '25-04-2026',
      'type': 'شيك مستحق',
      'isUrgent': true,
    },
    {
      'title': 'رسوم تخليص جمركي - ميناء العقبة',
      'amount': '3,400',
      'date': '20-04-2026',
      'type': 'دفعة نقدية',
      'isUrgent': true,
    },
    {
      'title': 'شركة النقل البري (توزيع محلي)',
      'amount': '850',
      'date': '02-05-2026',
      'type': 'دفعة نقدية',
      'isUrgent': false,
    },
    {
      'title': 'مورد خشب لاتيه (الشركة العربية)',
      'amount': '4,200',
      'date': '10-05-2026',
      'type': 'شيك مستحق',
      'isUrgent': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'الالتزامات المالية',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // تم حذف _buildFinancialSummary() بالكامل من هنا لرفع القائمة مباشرة
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                children: [
                  Icon(Icons.list_alt_rounded, color: Colors.black54, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'قائمة الالتزامات القادمة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: obligations.length,
                itemBuilder: (context, index) {
                  return _buildObligationCard(obligations[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  // ويدجت بطاقة الالتزام (بقيت كما هي)
  Widget _buildObligationCard(Map<String, dynamic> item) {
    bool isUrgent = item['isUrgent'];
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['type']} • ${item['date']}',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${item['amount']}',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    if (isUrgent) ...[
                      const SizedBox(width: 8),
                      const Text(
                        'مستعجل!',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUrgent
                  ? Colors.red.withOpacity(0.05)
                  : primaryColor.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item['type'] == 'شيك مستحق'
                  ? Icons.confirmation_number_outlined
                  : Icons.account_balance_wallet_outlined,
              color: isUrgent ? Colors.red : primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
