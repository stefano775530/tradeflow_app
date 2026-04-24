// import 'package:flutter/material.dart';
// import 'package:tradeflow_app/pages/Operation_screen.dart';
// import 'warehouses_screen.dart';
// import 'partners_screen.dart';
// import 'checks_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final Color primaryBlue = const Color(0xFF3D5EAB);
//   final Color scaffoldBg = const Color(0xFFF8FAFF);

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> pages = [
//       _buildEnhancedHomeContent(),
//       const PartnersScreen(),
//       const OperationScreen(),
//       const WarehousesScreen(),
//       const ChecksScreen(),
//     ];

//     return Scaffold(
//       backgroundColor: scaffoldBg,
//       body: IndexedStack(index: _selectedIndex, children: pages),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }

//   Widget _buildEnhancedHomeContent() {
//     return Column(
//       children: [
//         // ===== الهيدر (كما هو في الكود الذي أعجبك) =====
//         Container(
//           width: double.infinity,
//           height: 145,
//           decoration: BoxDecoration(
//             color: primaryBlue,
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(45),
//               bottomRight: Radius.circular(45),
//             ),
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.menu_rounded,
//                         color: Colors.white,
//                         size: 32,
//                       ),
//                       const SizedBox(width: 15),
//                       _buildNotificationBadge(),
//                     ],
//                   ),
//                   const Text(
//                     " اهلا العميل  ",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       fontWeight: FontWeight.w900,
//                       fontFamily: 'Cairo',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         Expanded(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 const SizedBox(height: 20),
//                 // ===== كروت القائمة الرئيسية (كما هي بدون تغيير) =====
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: GridView.count(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 15,
//                     mainAxisSpacing: 15,
//                     childAspectRatio: 1.3,
//                     children: [
//                       _buildMainGridCard(
//                         "الشيكات",
//                         "2 شيكات معلقة",
//                         Icons.account_balance_wallet_outlined,
//                         4,
//                       ),
//                       _buildMainGridCard(
//                         "المستودعات",
//                         "3 مستودعات نشطة",
//                         Icons.inventory_2_outlined,
//                         3,
//                       ),
//                       _buildMainGridCard(
//                         "الشركاء",
//                         "12 شريك تجاري",
//                         Icons.people_outline_rounded,
//                         1,
//                       ),
//                       _buildMainGridCard(
//                         "العمليات",
//                         "7 عمليات اليوم",
//                         Icons.swap_horiz_rounded,
//                         2,
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       _buildLabel("الأكثر مبيعاً"),
//                       const SizedBox(height: 15),

//                       // ✅ التعديل المقصود: بطاقة أصغر وأرشق
//                       _buildFeaturedCard("خشب ديكور خارجي", "المنتج الأول"),

//                       const SizedBox(height: 35),

//                       _buildLabel("آخر المبيعات"),
//                       const SizedBox(height: 15),
//                       _buildTransactionCard(
//                         "خشب زان أفريقي",
//                         "2026-03-20",
//                         "₪ 1,200 +",
//                       ),
//                       _buildTransactionCard(
//                         "بيع 20 لوح خشب سويد",
//                         "2026-03-20",
//                         "₪ 2,000 +",
//                       ),
//                       const SizedBox(height: 50),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // الكرت الرئيسي (بدون أي تعديل)
//   Widget _buildMainGridCard(
//     String title,
//     String sub,
//     IconData icon,
//     int index,
//   ) {
//     return InkWell(
//       onTap: () => setState(() => _selectedIndex = index),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(28),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: primaryBlue.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(icon, color: primaryBlue, size: 30),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w900,
//                 fontSize: 18,
//                 fontFamily: 'Cairo',
//                 color: Color(0xFF2D3243),
//               ),
//             ),
//             Text(
//               sub,
//               style: TextStyle(
//                 color: Colors.grey[500],
//                 fontSize: 13,
//                 fontFamily: 'Cairo',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ✅ كرت المنتج الأكثر مبيعاً (تم تصغيره فقط)
//   Widget _buildFeaturedCard(String name, String rank) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 15,
//       ), // تقليل الـ padding
//       decoration: BoxDecoration(
//         color: primaryBlue,
//         borderRadius: BorderRadius.circular(
//           25,
//         ), // انحناء أنعم يتناسب مع الحجم الجديد
//         boxShadow: [
//           BoxShadow(
//             color: primaryBlue.withOpacity(0.25),
//             blurRadius: 15,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Icon(
//             Icons.star_rounded,
//             color: Colors.white,
//             size: 35,
//           ), // تصغير الأيقونة قليلاً
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 rank,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.7),
//                   fontSize: 12,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//               Text(
//                 name,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 18, // تصغير الخط ليناسب الحجم الجديد
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionCard(String title, String date, String price) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: Colors.grey.withOpacity(0.1)),
//       ),
//       child: Row(
//         children: [
//           Text(
//             price,
//             style: const TextStyle(
//               color: Colors.blueAccent,
//               fontWeight: FontWeight.w900,
//               fontSize: 20,
//               fontFamily: 'Cairo',
//             ),
//           ),
//           const Spacer(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 17,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//               Text(
//                 date,
//                 style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 13,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLabel(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 22,
//         fontWeight: FontWeight.w900,
//         fontFamily: 'Cairo',
//         color: Color(0xFF1A1A1A),
//       ),
//     );
//   }

//   Widget _buildNotificationBadge() {
//     return Stack(
//       children: [
//         const Icon(
//           Icons.notifications_none_rounded,
//           color: Colors.white,
//           size: 32,
//         ),
//         Positioned(
//           right: 4,
//           top: 4,
//           child: Container(
//             width: 10,
//             height: 10,
//             decoration: const BoxDecoration(
//               color: Colors.redAccent,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomNav() {
//     return Container(
//       height: 85,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30),
//         ],
//       ),
//       child: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (i) => setState(() => _selectedIndex = i),
//         type: BottomNavigationBarType.fixed,
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: const Color(0xFF94A3B8),
//         selectedLabelStyle: const TextStyle(
//           fontFamily: 'Cairo',
//           fontWeight: FontWeight.bold,
//           fontSize: 12,
//         ),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.grid_view_rounded, size: 28),
//             label: "الرئيسية",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people_outline_rounded, size: 28),
//             label: "الشركاء",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.swap_horiz_rounded, size: 28),
//             label: "العمليات",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.inventory_2_outlined, size: 28),
//             label: "المستودعات",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.wallet_outlined, size: 28),
//             label: "الشيكات",
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:tradeflow_app/pages/Operation_screen.dart';
import 'warehouses_screen.dart';
import 'partners_screen.dart';
import 'checks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Color primaryBlue = const Color(0xFF3D5EAB);
  final Color scaffoldBg = const Color(0xFFF8FAFF);

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildEnhancedHomeContent(),
      const PartnersScreen(),
      const OperationScreen(),
      const WarehousesScreen(),
      const ChecksScreen(),
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildEnhancedHomeContent() {
    return Column(
      children: [
        // ===== الهيدر =====
        Container(
          width: double.infinity,
          height: 145,
          decoration: BoxDecoration(
            color: primaryBlue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(45),
              bottomRight: Radius.circular(45),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 15),
                      _buildNotificationBadge(),
                    ],
                  ),
                  const Text(
                    " اهلا العميل  ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 20),
                // ===== كروت القائمة الرئيسية (تمت إضافة الديون والتقارير) =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.3,
                    children: [
                      _buildMainGridCard(
                        "الشيكات",
                        "2 شيكات معلقة",
                        Icons.account_balance_wallet_outlined,
                        4,
                      ),
                      _buildMainGridCard(
                        "المستودعات",
                        "3 مستودعات نشطة",
                        Icons.inventory_2_outlined,
                        3,
                      ),
                      _buildMainGridCard(
                        "الشركاء",
                        "12 شريك تجاري",
                        Icons.people_outline_rounded,
                        1,
                      ),
                      _buildMainGridCard(
                        "العمليات",
                        "7 عمليات اليوم",
                        Icons.swap_horiz_rounded,
                        2,
                      ),
                      // الكرت الجديد الأول: الديون
                      _buildMainGridCard(
                        "الديون",
                        "متابعة المبالغ",
                        Icons.monetization_on_outlined,
                        0,
                      ),
                      // الكرت الجديد الثاني: التقارير
                      _buildMainGridCard(
                        "التقارير",
                        "إحصائيات عامة",
                        Icons.bar_chart_rounded,
                        0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildLabel("الأكثر مبيعاً"),
                      const SizedBox(height: 15),

                      _buildFeaturedCard("خشب ديكور خارجي", "المنتج الأول"),

                      const SizedBox(height: 35),

                      _buildLabel("آخر المبيعات"),
                      const SizedBox(height: 15),
                      _buildTransactionCard(
                        "خشب زان أفريقي",
                        "2026-03-20",
                        "₪ 1,200 +",
                      ),
                      _buildTransactionCard(
                        "بيع 20 لوح خشب سويد",
                        "2026-03-20",
                        "₪ 2,000 +",
                      ),
                      const SizedBox(height: 50),
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

  // الكرت الرئيسي (نفس تصميمك الأصلي)
  Widget _buildMainGridCard(
    String title,
    String sub,
    IconData icon,
    int index,
  ) {
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryBlue, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                fontFamily: 'Cairo',
                color: Color(0xFF2D3243),
              ),
            ),
            Text(
              sub,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(String name, String rank) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 35),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rank,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(String title, String date, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(
            price,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w900,
              fontSize: 20,
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
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        fontFamily: 'Cairo',
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildNotificationBadge() {
    return Stack(
      children: [
        const Icon(
          Icons.notifications_none_rounded,
          color: Colors.white,
          size: 32,
        ),
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: primaryBlue,
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded, size: 28),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded, size: 28),
            label: "الشركاء",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_rounded, size: 28),
            label: "العمليات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined, size: 28),
            label: "المستودعات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined, size: 28),
            label: "الشيكات",
          ),
        ],
      ),
    );
  }
}
