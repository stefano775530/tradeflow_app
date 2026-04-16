import 'package:flutter/material.dart';
import '../Operation/Transaction_details_screen.dart';
import '../Operation/financial_management_screen.dart';
import '../Operation/warehouse_distribution_screen.dart';

class OperationScreen extends StatelessWidget {
  const OperationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'العمليات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A72C2),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // الكرت الأول: تم تعديل الـ onTap لاستدعاء القائمة المنبثقة
            _buildOperationCard(
              context: context,
              title: 'تفاصيل العملية',
              subtitle:
                  'اختر نوع العملية (بيع أو شراء) لمتابعة تفاصيل العميل والمستودع.',
              imagePath: 'images/image 17.png',
              onTap: () => _showSelectionSheet(context),
            ),
            const SizedBox(height: 16),
            _buildOperationCard(
              context: context,
              title: 'توزيع المستودعات',
              subtitle:
                  'إدارة مخزونك، تحديد الكميات المطلوبة، واختيار المستودعات.',
              imagePath: 'images/10826967 1.png',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WarehouseDistributionScreen(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildOperationCard(
              context: context,
              title: 'الالتزامات',
              subtitle:
                  'متابعة الدفعات المالية، الشيكات المستحقة، والمدفوعات المتأخرة.',
              imagePath: 'images/11683826 1.png',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FinancialManagementScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لإظهار قائمة "بيع أو شراء" من الأسفل
  void _showSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "ما نوع العملية التي تود إجراءها؟",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  _buildSelectionTile(
                    context,
                    title: "عملية بيع",
                    icon: Icons.shopping_cart_outlined,
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildSelectionTile(
                    context,
                    title: "عملية شراء",
                    icon: Icons.add_business_outlined,
                    color: const Color(0xFFE91E63),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TransactionDetailsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // تصميم الزر داخل القائمة المنبثقة
  Widget _buildSelectionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F7FF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF4A4A4A),
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Color(0xFF4A72C2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Image.asset(
              imagePath,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
