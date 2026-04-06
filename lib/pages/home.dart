import 'package:flutter/material.dart';
import 'warehouses_screen.dart';
import 'partners_screen.dart';
import 'transactions_screen.dart';
import 'package:tradeflow_app/pages/checks_screen.dart'; // تأكد أن المسار صحيح

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Color activeBlue = const Color(0xFF3D5EAB);
  final Color headerBlue = const Color(0xFF3D5DB8);

  // حذفنا late و List<Widget> من هنا لنقوم بتعريفها داخل الـ build مباشرة
  // لضمان تحديث الصفحة بشكل صحيح عند الربط

  @override
  Widget build(BuildContext context) {
    // نضع القائمة هنا لضمان أن التغييرات في ChecksScreen تظهر فوراً
    final List<Widget> pages = [
      _buildModernHomeContent(),
      const PartnersScreen(),
      const TransactionsScreen(),
      const WarehousesScreen(),
      const ChecksScreen(), // تم التعديل هنا: استبدلنا النص بالكلاس الحقيقي
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      // استخدمنا pages المحلية هنا
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildModernHomeContent() {
    return Column(
      children: [
        // ===== الهيدر =====
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: headerBlue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 100,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                      child: CustomPaint(painter: _TopoPainter()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "مرحباً ، العميل",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Icon(Icons.menu, color: Colors.white, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ===== المحتوى =====
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.55,
                    children: [
                      _buildGridCard("المستودعات", Icons.home_outlined, 3),
                      _buildGridCard(
                        "الشيكات",
                        Icons.account_balance_wallet_outlined,
                        4,
                      ), // تم تعديل الأيقونة والاندكس
                      _buildGridCard("العمليات", Icons.swap_horiz_rounded, 2),
                      _buildGridCard(
                        "التقارير",
                        Icons.manage_search_rounded,
                        1,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "الأكثر مبيعاً",
                        style: TextStyle(
                          color: Color(0xFF3D5EAB),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildActionStrip("خشب ديكور خارجي"),
                      const SizedBox(height: 22),
                      const Text(
                        "آخر المبيعات",
                        style: TextStyle(
                          color: Color(0xFF3D5EAB),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSaleCard("خشب زان أفريقي", "2026-03-20", "1,200 +"),
                      const SizedBox(height: 10),
                      _buildSaleCard(
                        "بيع 20 لوح خشب سويد",
                        "2026-03-20",
                        "2,000 +",
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridCard(String title, IconData icon, int index) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: activeBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 14),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: activeBlue, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionStrip(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: activeBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        title,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildSaleCard(String title, String date, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: activeBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 3),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.trending_up, color: activeBlue, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3D5EAB),
        unselectedItemColor: Colors.black45,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: "الشركاء",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded),
            label: "العمليات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: "المستودعات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: "الشيكات",
          ),
        ],
      ),
    );
  }
}

// الرسام التوبوغرافي يبقى كما هو
class _TopoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final List<List<double>> curves = [
      [0.0, 0.25, 0.15, 0.05, 0.4, 0.35, 0.65, 0.15, 0.85, 0.28, 1.0, 0.18],
      [0.0, 0.42, 0.2, 0.22, 0.45, 0.52, 0.7, 0.32, 0.88, 0.45, 1.0, 0.35],
      [0.0, 0.58, 0.25, 0.38, 0.5, 0.68, 0.72, 0.48, 0.9, 0.6, 1.0, 0.52],
      [0.0, 0.72, 0.3, 0.55, 0.55, 0.82, 0.75, 0.62, 0.92, 0.75, 1.0, 0.68],
      [0.0, 0.88, 0.35, 0.70, 7.6, 0.95, 0.78, 0.78, 0.94, 0.88, 1.0, 0.85],
      [0.0, 0.12, 0.1, 0.02, 0.3, 0.22, 0.55, 0.08, 0.78, 0.18, 1.0, 0.08],
      [0.0, 1.0, 0.4, 0.85, 0.65, 1.1, 0.82, 0.92, 0.96, 1.0, 1.0, 0.98],
    ];

    for (final c in curves) {
      final path = Path();
      path.moveTo(c[0] * size.width, c[1] * size.height);
      path.cubicTo(
        c[2] * size.width,
        c[3] * size.height,
        c[4] * size.width,
        c[5] * size.height,
        c[6] * size.width,
        c[7] * size.height,
      );
      path.cubicTo(
        c[8] * size.width,
        c[9] * size.height,
        c[10] * size.width,
        c[11] * size.height,
        size.width,
        c[11] * size.height,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
