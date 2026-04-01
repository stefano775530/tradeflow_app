import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // حالة ظهور نموذج الإضافة ونوعه
  bool isAdding = false;
  bool isSale = true; // true للبيع (أخضر)، false للتوريد (أحمر)

  final Color greenColor = const Color(0xFF146933);
  final Color redColor = const Color(0xFFD32F2F);
  final Color activeBlue = const Color(0xFF4A80F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "العمليات المالية",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // 1. أزرار التحكم العليا (بيع / توريد)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      title: "بيع +",
                      color: greenColor,
                      onTap: () {
                        setState(() {
                          isAdding = true;
                          isSale = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      title: "توريد +",
                      color: redColor,
                      onTap: () {
                        setState(() {
                          isAdding = true;
                          isSale = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // 2. قائمة العمليات أو نموذج الإضافة
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (isAdding) ...[
                    _buildAddTransactionForm(),
                    const SizedBox(height: 20),
                  ],
                  _buildTransactionCard(
                    title: "مصاريف نقل وتحميل",
                    date: "2026-03-20",
                    amount: "350-",
                    category: "مصاريف",
                    icon: Icons.local_shipping_outlined,
                    isExpense: true,
                    showBorder: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionCard(
                    title: "شراء شحنة خشب زان جديدة",
                    date: "2026-03-20",
                    amount: "8000-",
                    category: "توريد",
                    icon: Icons.inventory_2_outlined,
                    isExpense: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionCard(
                    title: "بيع 20 لوح خشب سويد",
                    date: "2026-03-20",
                    amount: "1200+",
                    category: "بيع",
                    icon: Icons.sell_outlined,
                    isExpense: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نموذج إضافة عملية جديدة (Pixel Perfect حسب الصورة)
  Widget _buildAddTransactionForm() {
    Color themeColor = isSale ? greenColor : redColor;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: themeColor.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isSale ? "إضافة عملية بيع" : "إضافة عملية توريد",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: themeColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildTextField("التاريخ")),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField("المبلغ")),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField("وصف العمليات التي مراد ادخالها(مثلا بيع بضاعة )"),
          const SizedBox(height: 10),
          _buildTextField("اسم المراد ادخاله"),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => isAdding = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "تأكيد العملية",
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => isAdding = false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: themeColor.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "إلغاء",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          color: Colors.grey.shade400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard({
    required String title,
    required String date,
    required String amount,
    required String category,
    required IconData icon,
    required bool isExpense,
    bool showBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: showBorder ? activeBlue : Colors.grey.shade100,
          width: showBorder ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey.shade600, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "$category • $date",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isExpense ? redColor : greenColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isExpense ? redColor : greenColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
