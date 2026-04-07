import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_check_screen.dart';

class ChecksScreen extends StatefulWidget {
  const ChecksScreen({super.key});

  @override
  State<ChecksScreen> createState() => _ChecksScreenState();
}

class _ChecksScreenState extends State<ChecksScreen> {
  // البيانات التجريبية
  List<Map<String, dynamic>> checks = [
    {
      "company": "شركة المنار للمواد الغذائية",
      "amount": 1200.0,
      "date": "2026-03-20",
      "type": "وارد",
      "status": "قيد الانتظار",
    },
    {
      "company": "شركة الأمانة للتوريد",
      "amount": 3100.0,
      "date": "2026-04-15",
      "type": "صادر",
      "status": "قيد الانتظار",
    },
    {
      "company": "شركة الاحسان للاستيراد والتصدير",
      "amount": 1800.0,
      "date": "2026-04-20",
      "type": "صادر",
      "status": "قيد الانتظار",
    },
    {
      "company": "شركة عمر ورشدي العالول",
      "amount": 2200.0,
      "date": "2026-04-30",
      "type": "صادر",
      "status": "قيد الانتظار",
    },
  ];

  final Color greenColor = const Color(0xFF20E070);
  final Color redColor = const Color(0xFFFF2020);
  final Color statusBgColor = const Color(0xFFFFEB9B);
  final Color statusTextColor = const Color(0xFFC0A000);

  double get totalOutgoing => checks
      .where((c) => c["type"] == "صادر")
      .fold(0.0, (sum, c) => sum + (c["amount"] ?? 0.0));

  double get totalIncoming => checks
      .where((c) => c["type"] == "وارد")
      .fold(0.0, (sum, c) => sum + (c["amount"] ?? 0.0));

  void _addCheck() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCheckScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        checks.add({
          "company": result["name"] ?? "شركة غير معروفة",
          "amount": double.tryParse(result["amount"]?.toString() ?? '0') ?? 0.0,
          "date":
              result["date"] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "type": result["type"] ?? "وارد",
          "status": "قيد الانتظار",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          "إدارة الشيكات",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        // --- التعديل هنا لإلغاء سهم العودة ---
        automaticallyImplyLeading: false,
        // ----------------------------------
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: "شيكات صادرة",
                    amount: NumberFormat('#,###').format(totalOutgoing),
                    color: redColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    title: "شيكات واردة",
                    amount: NumberFormat('#,###').format(totalIncoming),
                    color: greenColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: checks.isEmpty
                ? const Center(
                    child: Text(
                      "لا يوجد شيكات",
                      style: TextStyle(fontFamily: 'Cairo'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: checks.length,
                    itemBuilder: (context, index) {
                      final check = checks[index];
                      final bool isOutgoing = check["type"] == "صادر";
                      return _buildCheckCard(
                        check: check,
                        isOutgoing: isOutgoing,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCheck,
        backgroundColor: const Color(0xFF3D5EAB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12, width: 1),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckCard({
    required Map<String, dynamic> check,
    required bool isOutgoing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: isOutgoing ? redColor : greenColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: isOutgoing ? redColor : greenColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                check["type"] ?? "",
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        check["company"] ?? "غير معروف",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "\$ ${NumberFormat('#,###').format(check["amount"] ?? 0.0)}",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        check["status"] ?? "معلق",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: statusTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          check["date"] ?? "",
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.date_range_outlined,
                          color: Colors.black54,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
