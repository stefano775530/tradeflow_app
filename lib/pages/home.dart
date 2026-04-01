import 'package:flutter/material.dart';
import 'add_warehouse_screen.dart';
import 'partners_screen.dart';
import 'transactions_screen.dart'; // تم إضافة الاستيراد هنا

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Color activeBlue = const Color(0xFF4A80F0);
  String clientName = "العميل";

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(), // مؤشر 0
      const PartnersScreen(), // مؤشر 1 (شاشة الشركاء فعالة الآن)
      const TransactionsScreen(), // مؤشر 2 (شاشة العمليات فعالة الآن)
      const Center(
        child: Text("صفحة المخزون", style: TextStyle(fontFamily: 'Cairo')),
      ),
      const Center(
        child: Text("صفحة الشيكات", style: TextStyle(fontFamily: 'Cairo')),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(),
      // يظهر AppBar فقط في الصفحة الرئيسية لأن الصفحات الأخرى لها تصميمها الخاص
      appBar: _selectedIndex == 0 ? _buildHomeAppBar() : null,

      // استخدام IndexedStack يحافظ على حالة الصفحات عند التنقل
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // --- محتوى الصفحة الرئيسية (Home Content) ---
  Widget _buildHomeContent() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _buildAddWarehouseButton(),
            const SizedBox(height: 15),
            _buildSectionBox(
              context: context,
              title: "العمليات التجارية",
              color: activeBlue,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildFeatureCard(
                    "الشيكات",
                    "22",
                    Icons.confirmation_number_outlined,
                  ),
                  _buildFeatureCard(
                    "الشركاء المتعاقدين",
                    "10",
                    Icons.handshake_outlined,
                  ),
                  _buildFeatureCard(
                    "التقارير",
                    "استعلام: 1",
                    Icons.assessment_outlined,
                  ),
                  _buildFeatureCard(
                    "قائمة البضاعة",
                    "متوفر: 30",
                    Icons.inventory_2_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSimpleTextHeader("الاكثر مبيعا"),
            _buildLargeButton("خشب ديكور خارجي"),
            const SizedBox(height: 20),
            _buildSimpleTextHeader("اخر المبيعات"),
            _buildSaleItem(
              "خشب زان أفريقي",
              "2026-03-20",
              "1,200 +",
              Icons.show_chart,
            ),
            const SizedBox(height: 10),
            _buildSaleItem(
              "بيع 20 لوح خشب سويد",
              "2026-03-20",
              "2,000 +",
              Icons.build,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 120,
      leading: Builder(
        builder: (context) => Row(
          children: [
            const SizedBox(width: 15),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black, size: 30),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.notifications_none, color: Colors.black, size: 30),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            Text(
              'مرحباً، $clientName',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.account_circle_outlined,
              color: Colors.black,
              size: 40,
            ),
          ],
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      selectedItemColor: activeBlue,
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "الشركاء",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz),
          label: "العمليات",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: "المخزون",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payments_outlined),
          label: "الشيكات",
        ),
      ],
    );
  }

  // الدوال المساعدة للرسم (Helper Widgets)...
  // (أبقِ باقي الدوال مثل _buildFeatureCard و _buildDrawer كما هي في كودك الأصلي)

  Widget _buildFeatureCard(String title, String val, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: activeBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 1,
                ),
                Text(
                  val,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: activeBlue,
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "TF",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                "TradeFlow",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 40),
              _buildDrawerItem(Icons.person_outline, "الملف الشخصي"),
              _buildDrawerItem(Icons.settings_outlined, "الإعدادات"),
              const Spacer(),
              _buildDrawerItem(Icons.logout, "تسجيل الخروج", isExit: true),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {bool isExit = false}) {
    return ListTile(
      leading: Icon(icon, color: isExit ? Colors.red[300] : Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: isExit ? Colors.red[100] : Colors.white,
          fontFamily: 'Cairo',
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  Widget _buildSectionBox({
    required BuildContext context,
    required String title,
    required Widget child,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildSimpleTextHeader(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, right: 10),
        child: Text(
          text,
          style: TextStyle(
            color: activeBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  Widget _buildLargeButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: activeBlue,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  Widget _buildSaleItem(
    String title,
    String date,
    String price,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: activeBlue,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: activeBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddWarehouseButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _navigateToEmptyAddScreen(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: activeBlue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add_circle_outline, color: Colors.white, size: 26),
              SizedBox(width: 8),
              Text(
                "انقر لاضافة مستودع جديد",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEmptyAddScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWarehouseScreen()),
    );
    if (result != null && result is Map)
      setState(() => clientName = result['name']);
  }
}
