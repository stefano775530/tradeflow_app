import 'package:flutter/material.dart';

class ChecksScreen extends StatelessWidget {
  const ChecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  const Text(
                    'إدارة الشيكات',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Cairo', // تأكد من إضافة الخط في pubspec.yaml
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildSummaryCard("شيكات واردة", "2,000", Colors.green),
                  const SizedBox(width: 15),
                  _buildSummaryCard("شيكات صادرة", "3,500", Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Checks List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCheckCard(
                    "شركة المنار للمواد الغذائية",
                    "1,200",
                    "20-03-2026",
                    "وارد",
                    true,
                  ),
                  _buildCheckCard(
                    "شركة الأمانة للتوريد",
                    "3,100",
                    "15-04-2026",
                    "صادر",
                    false,
                  ),
                  _buildCheckCard(
                    "شركة الاحسان للاستيراد والتصدير",
                    "1,800",
                    "20-04-2026",
                    "صادر",
                    false,
                  ),
                  _buildCheckCard(
                    "شركة عمر ورشدي العالول",
                    "2,200",
                    "31-04-2026",
                    "صادر",
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckCard(
    String name,
    String amount,
    String date,
    String type,
    bool isIncoming,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          right: BorderSide(
            color: isIncoming ? Colors.green : Colors.red,
            width: 5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$ $amount",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isIncoming ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "قيد الانتظار",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.calendar_month,
                    size: 16,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
