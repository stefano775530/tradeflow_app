// // // import 'package:flutter/material.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:tradeflow_app/pages/Operation_screen.dart';
// // // import 'warehouses_screen.dart';
// // // import 'partners_screen.dart';
// // // import 'checks_screen.dart';
// // // import 'package:tradeflow_app/debts/debts_screen.dart';
// // // import 'package:tradeflow_app/debts/reports_screen.dart';
// // // import 'custom_drawer.dart';

// // // class HomeScreen extends StatefulWidget {
// // //   final String username;
// // //   const HomeScreen({super.key, required this.username});

// // //   @override
// // //   State<HomeScreen> createState() => _HomeScreenState();
// // // }

// // // class _HomeScreenState extends State<HomeScreen> {
// // //   String userName = "";

// // //   int _selectedIndex = 0;
// // //   final Color primaryBlue = const Color(0xFF3D5EAB);
// // //   final Color scaffoldBg = const Color(0xFFF8FAFF);
// // //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     loadUserName();
// // //   }

// // //   Future<void> loadUserName() async {
// // //     final prefs = await SharedPreferences.getInstance();

// // //     setState(() {
// // //       userName = widget.username.isNotEmpty
// // //           ? widget.username
// // //           : (prefs.getString('username') ?? 'العميل');
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final List<Widget> pages = [
// // //       _buildEnhancedHomeContent(),
// // //       const PartnersScreen(),
// // //       const OperationScreen(),
// // //       const WarehousesScreen(),
// // //       const ChecksScreen(),
// // //     ];

// // //     return Scaffold(
// // //       key: _scaffoldKey,
// // //       backgroundColor: scaffoldBg,
// // //       drawer: CustomDrawer(username: "$userName"),
// // //       body: IndexedStack(index: _selectedIndex, children: pages),
// // //       bottomNavigationBar: _buildBottomNav(),
// // //     );
// // //   }

// // //   Widget _buildEnhancedHomeContent() {
// // //     return Column(
// // //       children: [
// // //         // ===== الهيدر =====
// // //         Container(
// // //           width: double.infinity,
// // //           height: 145,
// // //           decoration: BoxDecoration(
// // //             color: primaryBlue,
// // //             borderRadius: const BorderRadius.only(
// // //               bottomLeft: Radius.circular(45),
// // //               bottomRight: Radius.circular(45),
// // //             ),
// // //           ),
// // //           child: SafeArea(
// // //             child: Padding(
// // //               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
// // //               child: Row(
// // //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                 children: [
// // //                   Row(
// // //                     children: [
// // //                       GestureDetector(
// // //                         onTap: () => _scaffoldKey.currentState?.openDrawer(),
// // //                         child: const Icon(
// // //                           Icons.menu_rounded,
// // //                           color: Colors.white,
// // //                           size: 32,
// // //                         ),
// // //                       ),
// // //                       const SizedBox(width: 15),
// // //                       _buildNotificationBadge(),
// // //                     ],
// // //                   ),
// // //                   Text(
// // //                     " $userName اهلا",
// // //                     style: const TextStyle(
// // //                       color: Colors.white,
// // //                       fontSize: 30,
// // //                       fontWeight: FontWeight.w900,
// // //                       fontFamily: 'Cairo',
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),

// // //         Expanded(
// // //           child: SingleChildScrollView(
// // //             physics: const BouncingScrollPhysics(),
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.end,
// // //               children: [
// // //                 const SizedBox(height: 20),

// // //                 Padding(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                   child: GridView.count(
// // //                     shrinkWrap: true,
// // //                     physics: const NeverScrollableScrollPhysics(),
// // //                     crossAxisCount: 2,
// // //                     crossAxisSpacing: 15,
// // //                     mainAxisSpacing: 15,
// // //                     childAspectRatio: 1.3,
// // //                     children: [
// // //                       _buildMainGridCard(
// // //                         "الشيكات",
// // //                         "إدارة الشيكات",
// // //                         Icons.account_balance_wallet_outlined,
// // //                         4,
// // //                       ),
// // //                       _buildMainGridCard(
// // //                         "المستودعات",
// // //                         "إدارة المخازن",
// // //                         Icons.inventory_2_outlined,
// // //                         3,
// // //                       ),
// // //                       _buildMainGridCard(
// // //                         "الشركاء",
// // //                         "إدارة الشركاء",
// // //                         Icons.people_outline_rounded,
// // //                         1,
// // //                       ),
// // //                       _buildMainGridCard(
// // //                         "العمليات",
// // //                         "سجل العمليات",
// // //                         Icons.swap_horiz_rounded,
// // //                         2,
// // //                       ),
// // //                       _buildMainGridCard(
// // //                         "الديون",
// // //                         "متابعة المبالغ",
// // //                         Icons.monetization_on_outlined,
// // //                         0,
// // //                       ),
// // //                       _buildMainGridCard(
// // //                         "التقارير",
// // //                         "إحصائيات عامة",
// // //                         Icons.bar_chart_rounded,
// // //                         0,
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),

// // //                 const SizedBox(height: 30),

// // //                 Padding(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 20),
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.end,
// // //                     children: [
// // //                       _buildLabel("الأكثر مبيعاً"),
// // //                       const SizedBox(height: 15),

// // //                       _buildFeaturedCard("خشب ديكور خارجي", "المنتج الأول"),

// // //                       const SizedBox(height: 35),

// // //                       // _buildLabel("آخر المبيعات"),
// // //                       // const SizedBox(height: 15),

// // //                       // _buildTransactionCard(
// // //                       //   "خشب زان أفريقي",
// // //                       //   "2026-03-20",
// // //                       //   "₪ 1,200 +",
// // //                       // ),

// // //                       // _buildTransactionCard(
// // //                       //   "بيع 20 لوح خشب سويد",
// // //                       //   "2026-03-20",
// // //                       //   "₪ 2,000 +",
// // //                       // ),
// // //                       const SizedBox(height: 50),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildMainGridCard(
// // //     String title,
// // //     String sub,
// // //     IconData icon,
// // //     int index,
// // //   ) {
// // //     return InkWell(
// // //       onTap: () {
// // //         if (title == "الديون") {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(builder: (context) => const DebtsScreen()),
// // //           );
// // //         } else if (title == "التقارير") {
// // //           Navigator.push(
// // //             context,
// // //             MaterialPageRoute(builder: (context) => const ReportsScreen()),
// // //           );
// // //         } else {
// // //           setState(() => _selectedIndex = index);
// // //         }
// // //       },
// // //       child: Container(
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(28),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.04),
// // //               blurRadius: 20,
// // //               offset: const Offset(0, 10),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: [
// // //             Container(
// // //               padding: const EdgeInsets.all(12),
// // //               decoration: BoxDecoration(
// // //                 color: primaryBlue.withOpacity(0.08),
// // //                 shape: BoxShape.circle,
// // //               ),
// // //               child: Icon(icon, color: primaryBlue, size: 30),
// // //             ),
// // //             const SizedBox(height: 12),
// // //             Text(
// // //               title,
// // //               style: const TextStyle(
// // //                 fontWeight: FontWeight.w900,
// // //                 fontSize: 18,
// // //                 fontFamily: 'Cairo',
// // //                 color: Color(0xFF2D3243),
// // //               ),
// // //             ),
// // //             Text(
// // //               sub,
// // //               style: TextStyle(
// // //                 color: Colors.grey[500],
// // //                 fontSize: 13,
// // //                 fontFamily: 'Cairo',
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFeaturedCard(String name, String rank) {
// // //     return Container(
// // //       width: double.infinity,
// // //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
// // //       decoration: BoxDecoration(
// // //         color: primaryBlue,
// // //         borderRadius: BorderRadius.circular(25),
// // //       ),
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //         children: [
// // //           const Icon(Icons.star_rounded, color: Colors.white, size: 35),
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.end,
// // //             mainAxisSize: MainAxisSize.min,
// // //             children: [
// // //               Text(
// // //                 rank,
// // //                 style: TextStyle(
// // //                   color: Colors.white.withOpacity(0.7),
// // //                   fontSize: 12,
// // //                   fontFamily: 'Cairo',
// // //                 ),
// // //               ),
// // //               Text(
// // //                 name,
// // //                 style: const TextStyle(
// // //                   color: Colors.white,
// // //                   fontSize: 18,
// // //                   fontWeight: FontWeight.bold,
// // //                   fontFamily: 'Cairo',
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildTransactionCard(String title, String date, String price) {
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 15),
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(25),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Text(
// // //             price,
// // //             style: const TextStyle(
// // //               color: Colors.blueAccent,
// // //               fontWeight: FontWeight.w900,
// // //               fontSize: 20,
// // //               fontFamily: 'Cairo',
// // //             ),
// // //           ),
// // //           const Spacer(),
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.end,
// // //             children: [
// // //               Text(
// // //                 title,
// // //                 style: const TextStyle(
// // //                   fontWeight: FontWeight.bold,
// // //                   fontSize: 17,
// // //                   fontFamily: 'Cairo',
// // //                 ),
// // //               ),
// // //               Text(
// // //                 date,
// // //                 style: const TextStyle(
// // //                   color: Colors.grey,
// // //                   fontSize: 13,
// // //                   fontFamily: 'Cairo',
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildLabel(String text) {
// // //     return Text(
// // //       text,
// // //       style: const TextStyle(
// // //         fontSize: 22,
// // //         fontWeight: FontWeight.w900,
// // //         fontFamily: 'Cairo',
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildNotificationBadge() {
// // //     return Stack(
// // //       children: [
// // //         const Icon(
// // //           Icons.notifications_none_rounded,
// // //           color: Colors.white,
// // //           size: 32,
// // //         ),
// // //         Positioned(
// // //           right: 4,
// // //           top: 4,
// // //           child: Container(
// // //             width: 10,
// // //             height: 10,
// // //             decoration: const BoxDecoration(
// // //               color: Colors.redAccent,
// // //               shape: BoxShape.circle,
// // //             ),
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildBottomNav() {
// // //     return Container(
// // //       height: 85,
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 30),
// // //         ],
// // //       ),
// // //       child: BottomNavigationBar(
// // //         currentIndex: _selectedIndex,
// // //         onTap: (i) => setState(() => _selectedIndex = i),
// // //         type: BottomNavigationBarType.fixed,
// // //         elevation: 0,
// // //         selectedItemColor: primaryBlue,
// // //         unselectedItemColor: const Color(0xFF94A3B8),
// // //         items: const [
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.grid_view_rounded),
// // //             label: "الرئيسية",
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.people_outline_rounded),
// // //             label: "الشركاء",
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.swap_horiz_rounded),
// // //             label: "العمليات",
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.inventory_2_outlined),
// // //             label: "المستودعات",
// // //           ),
// // //           BottomNavigationBarItem(
// // //             icon: Icon(Icons.wallet_outlined),
// // //             label: "الشيكات",
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/Operation_screen.dart';
// import 'package:tradeflow_app/pages/link.dart';
// import 'warehouses_screen.dart';
// import 'partners_screen.dart';
// import 'checks_screen.dart';
// import 'package:tradeflow_app/debts/debts_screen.dart';
// import 'package:tradeflow_app/debts/reports_screen.dart';
// import 'custom_drawer.dart';

// class NotificationItem {
//   final String id;
//   final String title;
//   final String message;
//   final IconData icon;
//   final String type;
//   final bool isRead;

//   NotificationItem({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.icon,
//     required this.type,
//     this.isRead = false,
//   });

//   static IconData _iconFromType(String? type) {
//     switch (type) {
//       case 'stock':
//         return Icons.warning_amber_rounded;
//       case 'payment':
//         return Icons.calendar_today_rounded;
//       default:
//         return Icons.notifications_rounded;
//     }
//   }
// }

// class HomeScreen extends StatefulWidget {
//   final String username;
//   const HomeScreen({super.key, required this.username});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String userName = "";
//   int _selectedIndex = 0;
//   bool _isLoadingNotifications = false;
//   final Color primaryBlue = const Color(0xFF3D5EAB);
//   final Color scaffoldBg = const Color(0xFFF8FAFF);
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   List<NotificationItem> notifications = [];

//   int get unreadCount => notifications.where((n) => !n.isRead).length;

//   @override
//   void initState() {
//     super.initState();
//     loadUserName();
//     fetchNotifications();
//   }

//   Future<void> loadUserName() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = widget.username.isNotEmpty
//           ? widget.username
//           : (prefs.getString('username') ?? 'العميل');
//     });
//   }

//   Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   Future<void> fetchNotifications() async {
//     setState(() => _isLoadingNotifications = true);
//     try {
//       final token = await _getToken();
//       final response = await http.get(
//         Uri.parse(ApiEndpoints.lowStockAlerts),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = jsonDecode(response.body);
//         final List items = data['items'];
//         setState(() {
//           notifications = items.map((item) {
//             return NotificationItem(
//               id: item['id'].toString(),
//               title: "نفاذ مخزون",
//               message:
//                   "منتج '${item['name']}' وصل إلى ${item['quantity']} - الحد الأدنى ${item['minimum_quantity']}",
//               icon: Icons.warning_amber_rounded,
//               type: 'stock',
//             );
//           }).toList();
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching notifications: $e');
//     } finally {
//       setState(() => _isLoadingNotifications = false);
//     }
//   }

//   Future<void> deleteNotification(String id) async {
//     setState(() {
//       notifications.removeWhere((n) => n.id == id);
//     });
//   }

//   Future<void> markAsRead(String id) async {
//     setState(() {
//       final index = notifications.indexWhere((n) => n.id == id);
//       if (index != -1) {
//         final old = notifications[index];
//         notifications[index] = NotificationItem(
//           id: old.id,
//           title: old.title,
//           message: old.message,
//           icon: old.icon,
//           type: old.type,
//           isRead: true,
//         );
//       }
//     });
//   }

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
//       key: _scaffoldKey,
//       backgroundColor: scaffoldBg,
//       drawer: CustomDrawer(username: userName),
//       body: IndexedStack(index: _selectedIndex, children: pages),
//       bottomNavigationBar: _buildBottomNav(),
//     );
//   }

//   Widget _buildEnhancedHomeContent() {
//     return Column(
//       children: [
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
//                       GestureDetector(
//                         onTap: () => _scaffoldKey.currentState?.openDrawer(),
//                         child: const Icon(
//                           Icons.menu_rounded,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                       ),
//                       const SizedBox(width: 15),
//                       _buildNotificationBadge(),
//                     ],
//                   ),
//                   Text(
//                     " $userName اهلا",
//                     style: const TextStyle(
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
//                         "إدارة الشيكات",
//                         Icons.account_balance_wallet_outlined,
//                         4,
//                       ),
//                       _buildMainGridCard(
//                         "المستودعات",
//                         "إدارة المخازن",
//                         Icons.inventory_2_outlined,
//                         3,
//                       ),
//                       _buildMainGridCard(
//                         "الشركاء",
//                         "إدارة الشركاء",
//                         Icons.people_outline_rounded,
//                         1,
//                       ),
//                       _buildMainGridCard(
//                         "العمليات",
//                         "سجل العمليات",
//                         Icons.swap_horiz_rounded,
//                         2,
//                       ),
//                       _buildMainGridCard(
//                         "الديون",
//                         "متابعة المبالغ",
//                         Icons.monetization_on_outlined,
//                         0,
//                       ),
//                       _buildMainGridCard(
//                         "التقارير",
//                         "إحصائيات عامة",
//                         Icons.bar_chart_rounded,
//                         0,
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
//                       _buildFeaturedCard("خشب ديكور خارجي", "المنتج الأول"),
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

//   Widget _buildNotificationBadge() {
//     return PopupMenuButton<String>(
//       offset: const Offset(0, 50),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       onSelected: (id) => markAsRead(id),
//       child: Stack(
//         children: [
//           const Icon(
//             Icons.notifications_none_rounded,
//             color: Colors.white,
//             size: 32,
//           ),
//           if (_isLoadingNotifications)
//             Positioned(
//               right: 4,
//               top: 4,
//               child: Container(
//                 width: 14,
//                 height: 14,
//                 padding: const EdgeInsets.all(2),
//                 decoration: const BoxDecoration(
//                   color: Colors.white24,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const CircularProgressIndicator(
//                   strokeWidth: 2,
//                   color: Colors.white,
//                 ),
//               ),
//             )
//           else if (unreadCount > 0)
//             Positioned(
//               right: 4,
//               top: 4,
//               child: Container(
//                 width: 16,
//                 height: 16,
//                 decoration: const BoxDecoration(
//                   color: Colors.redAccent,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Text(
//                     '$unreadCount',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       itemBuilder: (context) => [
//         PopupMenuItem<String>(
//           enabled: false,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               if (notifications.isNotEmpty)
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                     setState(() => notifications.clear());
//                   },
//                   child: Text(
//                     "مسح الكل",
//                     style: TextStyle(
//                       color: Colors.red[400],
//                       fontSize: 13,
//                       fontFamily: 'Cairo',
//                     ),
//                   ),
//                 ),
//               Row(
//                 children: [
//                   if (_isLoadingNotifications) ...[
//                     const SizedBox(
//                       width: 14,
//                       height: 14,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                   ],
//                   const Text(
//                     "التنبيهات",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       fontFamily: 'Cairo',
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const PopupMenuDivider(),
//         if (_isLoadingNotifications)
//           const PopupMenuItem<String>(
//             enabled: false,
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           )
//         else if (notifications.isEmpty)
//           const PopupMenuItem<String>(
//             enabled: false,
//             child: Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 child: Text(
//                   "لا توجد تنبيهات",
//                   style: TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
//                 ),
//               ),
//             ),
//           )
//         else
//           ...notifications.map((notif) {
//             return PopupMenuItem<String>(
//               value: notif.id,
//               child: SizedBox(
//                 width: 260,
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                         deleteNotification(notif.id);
//                       },
//                       child: Icon(
//                         Icons.close_rounded,
//                         color: Colors.grey[400],
//                         size: 18,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Expanded(
//                       child: ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         leading: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: notif.type == 'stock'
//                                 ? Colors.orange.withOpacity(0.1)
//                                 : Colors.blue.withOpacity(0.1),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             notif.icon,
//                             color: notif.type == 'stock'
//                                 ? Colors.orange
//                                 : Colors.blue,
//                             size: 22,
//                           ),
//                         ),
//                         title: Text(
//                           notif.title,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: notif.isRead
//                                 ? FontWeight.normal
//                                 : FontWeight.bold,
//                             fontFamily: 'Cairo',
//                           ),
//                         ),
//                         subtitle: Text(
//                           notif.message,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontFamily: 'Cairo',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }),
//       ],
//     );
//   }

//   Widget _buildMainGridCard(
//     String title,
//     String sub,
//     IconData icon,
//     int index,
//   ) {
//     return InkWell(
//       onTap: () {
//         if (title == "الديون") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const DebtsScreen()),
//           );
//         } else if (title == "التقارير") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ReportsScreen()),
//           );
//         } else {
//           setState(() => _selectedIndex = index);
//         }
//       },
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

//   Widget _buildFeaturedCard(String name, String rank) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         color: primaryBlue,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Icon(Icons.star_rounded, color: Colors.white, size: 35),
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
//                   fontSize: 18,
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

//   Widget _buildLabel(String text) => Text(
//     text,
//     style: const TextStyle(
//       fontSize: 22,
//       fontWeight: FontWeight.w900,
//       fontFamily: 'Cairo',
//     ),
//   );

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
//         selectedItemColor: primaryBlue,
//         unselectedItemColor: const Color(0xFF94A3B8),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.grid_view_rounded),
//             label: "الرئيسية",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people_outline_rounded),
//             label: "الشركاء",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.swap_horiz_rounded),
//             label: "العمليات",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.inventory_2_outlined),
//             label: "المستودعات",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.wallet_outlined),
//             label: "الشيكات",
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/Operation_screen.dart';
import 'package:tradeflow_app/pages/link.dart';
import 'warehouses_screen.dart';
import 'partners_screen.dart';
import 'checks_screen.dart';
import 'package:tradeflow_app/debts/debts_screen.dart';
import 'package:tradeflow_app/debts/reports_screen.dart';
import 'custom_drawer.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final String type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.type,
    this.isRead = false,
  });
}

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  int _selectedIndex = 0;
  bool _isLoadingNotifications = false;
  final Color primaryBlue = const Color(0xFF3D5EAB);
  final Color scaffoldBg = const Color(0xFFF8FAFF);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<NotificationItem> notifications = [];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    loadUserName();
    fetchNotifications();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = widget.username.isNotEmpty
          ? widget.username
          : (prefs.getString('username') ?? 'العميل');
    });
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchNotifications() async {
    setState(() => _isLoadingNotifications = true);
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse(ApiEndpoints.lowStockAlerts),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List items = data['items'];
        setState(() {
          notifications = items.map((item) {
            return NotificationItem(
              id: item['id'].toString(),
              title: "نفاذ مخزون",
              message:
                  "منتج '${item['name']}' — الكمية: ${item['quantity']} / الحد الأدنى: ${item['minimum_quantity']}",
              icon: Icons.warning_amber_rounded,
              type: 'stock',
            );
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
    } finally {
      setState(() => _isLoadingNotifications = false);
    }
  }

  Future<void> deleteNotification(String id) async {
    setState(() => notifications.removeWhere((n) => n.id == id));
  }

  Future<void> markAsRead(String id) async {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final old = notifications[index];
        notifications[index] = NotificationItem(
          id: old.id,
          title: old.title,
          message: old.message,
          icon: old.icon,
          type: old.type,
          isRead: true,
        );
      }
    });
  }

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
      key: _scaffoldKey,
      backgroundColor: scaffoldBg,
      drawer: CustomDrawer(username: userName),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildEnhancedHomeContent() {
    return Column(
      children: [
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
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: const Icon(
                          Icons.menu_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 15),
                      _buildNotificationBadge(),
                    ],
                  ),
                  Text(
                    " $userName اهلا",
                    style: const TextStyle(
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
                        "إدارة الشيكات",
                        Icons.account_balance_wallet_outlined,
                        4,
                      ),
                      _buildMainGridCard(
                        "المستودعات",
                        "إدارة المخازن",
                        Icons.inventory_2_outlined,
                        3,
                      ),
                      _buildMainGridCard(
                        "الشركاء",
                        "إدارة الشركاء",
                        Icons.people_outline_rounded,
                        1,
                      ),
                      _buildMainGridCard(
                        "العمليات",
                        "سجل العمليات",
                        Icons.swap_horiz_rounded,
                        2,
                      ),
                      _buildMainGridCard(
                        "الديون",
                        "متابعة المبالغ",
                        Icons.monetization_on_outlined,
                        0,
                      ),
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

  // ══════════════════════════════════════════════
  //  NOTIFICATION BADGE — بسيط ونظيف
  // ══════════════════════════════════════════════
  Widget _buildNotificationBadge() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 52),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (id) => markAsRead(id),
      child: Stack(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 30,
          ),
          if (_isLoadingNotifications)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            )
          else if (unreadCount > 0)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4D6D),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      itemBuilder: (context) => [
        // ── Header ──────────────────────────────
        PopupMenuItem<String>(
          enabled: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (notifications.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => notifications.clear());
                  },
                  child: const Text(
                    "مسح الكل",
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 13,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                const SizedBox(),
              Row(
                children: [
                  if (unreadCount > 0) ...[
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4D6D),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  const Text(
                    "التنبيهات",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      fontFamily: 'Cairo',
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const PopupMenuDivider(height: 1),

        // ── Items or states ──────────────────────
        if (_isLoadingNotifications)
          PopupMenuItem<String>(
            enabled: false,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (notifications.isEmpty)
          PopupMenuItem<String>(
            enabled: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    color: Colors.grey[300],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "لا توجد تنبيهات",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontFamily: 'Cairo',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...notifications.map(
            (notif) => PopupMenuItem<String>(
              value: notif.id,
              padding: EdgeInsets.zero,
              child: _buildNotifItem(context, notif),
            ),
          ),
      ],
    );
  }

  // ── Notification Item — بسيط ─────────────────
  Widget _buildNotifItem(BuildContext context, NotificationItem notif) {
    return Container(
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: notif.isRead ? Colors.white : const Color(0xFFF5F7FF),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // زر الحذف
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              deleteNotification(notif.id);
            },
            child: Icon(Icons.close_rounded, color: Colors.grey[350], size: 18),
          ),
          const SizedBox(width: 10),

          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!notif.isRead)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      notif.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: notif.isRead
                            ? FontWeight.w600
                            : FontWeight.w900,
                        fontFamily: 'Cairo',
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  notif.message,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontFamily: 'Cairo',
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // أيقونة
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFE65100),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  باقي الدوال — بدون تعديل
  // ══════════════════════════════════════════════
  Widget _buildMainGridCard(
    String title,
    String sub,
    IconData icon,
    int index,
  ) {
    return InkWell(
      onTap: () {
        if (title == "الديون") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DebtsScreen()),
          );
        } else if (title == "التقارير") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportsScreen()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
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

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w900,
      fontFamily: 'Cairo',
    ),
  );

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
        selectedItemColor: primaryBlue,
        unselectedItemColor: const Color(0xFF94A3B8),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
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
            icon: Icon(Icons.wallet_outlined),
            label: "الشيكات",
          ),
        ],
      ),
    );
  }
}
