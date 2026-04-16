import 'package:flutter/material.dart';

class WarehouseDistributionScreen extends StatefulWidget {
  const WarehouseDistributionScreen({super.key});

  @override
  State<WarehouseDistributionScreen> createState() =>
      _WarehouseDistributionScreenState();
}

class _WarehouseDistributionScreenState
    extends State<WarehouseDistributionScreen> {
  // الهوية البصرية لمشروع TradeFlow
  final Color primaryColor = const Color(0xFF446BC0);
  final Color secondaryColor = const Color(0xFF1E3A8A);
  final Color bgGray = const Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGray,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // AppBar مع السهم في جهة الشمال (اليسار)
            SliverAppBar(
              expandedHeight: 90,
              pinned: true,
              elevation: 0,
              backgroundColor: primaryColor,
              // تم إلغاء خاصية leading التلقائية لنضع السهم في جهة اليسار يدوياً عبر actions
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ), // مسافة بسيطة من الحافة اليسرى
                  child: IconButton(
                    // استخدام أيقونة تشير لليسار (شمال) وباللون الأبيض
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'توزيع المستودعات',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [secondaryColor, primaryColor],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),

            // محتوى الصفحة المرفوع للأعلى
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'الخيارات الأساسية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildModernTile(
                    icon: Icons.add_business_rounded,
                    title: 'إضافة كمية لمستودع',
                    subtitle: 'تزويد المخازن ببضاعة واردة جديدة',
                    color: primaryColor,
                    onTap: () => _showSheet(context, 'إضافة كمية جديدة', [
                      'المستودع',
                      'الكمية',
                    ]),
                  ),

                  _buildModernTile(
                    icon: Icons.swap_horizontal_circle_outlined,
                    title: 'نقل مخزون داخلي',
                    subtitle: 'تحويل سريع للبضائع بين الفروع',
                    color: Colors.orange.shade700,
                    onTap: () => _showSheet(context, 'نقل مخزون داخلي', [
                      'من مستودع',
                      'إلى مستودع',
                      'الكمية',
                    ]),
                  ),

                  _buildModernTile(
                    icon: Icons.assignment_rounded,
                    title: 'سجل التوزيعات الأخيرة',
                    subtitle: 'مراجعة حركة المستودعات والعمليات',
                    color: Colors.teal.shade600,
                    onTap: () => _showLogsSheet(context),
                  ),

                  const SizedBox(height: 10),

                  // كرت الحالة البسيط
                  _buildSimpleStatus(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نفس الـ Widgets السابقة للحفاظ على الشكل الاحترافي
  Widget _buildSimpleStatus() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.green.shade600,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            "جميع المستودعات متصلة ومحدثة الآن",
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }

  // توابع الـ Sheets والـ Logic بقيت كما هي لضمان عمل الصفحة بالكامل
  void _showSheet(BuildContext context, String title, List<String> fields) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            left: 25,
            right: 25,
            top: 15,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...fields
                  .map(
                    (field) => Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: field,
                          labelStyle: TextStyle(color: secondaryColor),
                          filled: true,
                          fillColor: bgGray,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'تأكيد وحفظ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            children: [
              const Text(
                'سجل العمليات الأخير',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 40),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: bgGray,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.history,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        'عملية توزيع #$index',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: const Text(
                        'تم تحديث المخزون بنجاح',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: const Text(
                        'اليوم',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
