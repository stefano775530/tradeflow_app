// // // // // // import 'dart:convert';
// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // import 'package:tradeflow_app/pages/link.dart';

// // // // // // class ReportsScreen extends StatefulWidget {
// // // // // //   const ReportsScreen({super.key});

// // // // // //   @override
// // // // // //   State<ReportsScreen> createState() => _ReportsScreenState();
// // // // // // }

// // // // // // class _ReportsScreenState extends State<ReportsScreen> {
// // // // // //   // نوع الفلترة: true للسنوي، false للشهري
// // // // // //   bool _isAnnual = false;

// // // // // //   // المتغيرات الافتراضية للتاريخ الحالي
// // // // // //   int _selectedYear = 2026;
// // // // // //   int _selectedMonth = 5;

// // // // // //   // قوائم السنوات والأشهر للفلترة
// // // // // //   final List<int> _years = [2024, 2025, 2026, 2027];
// // // // // //   final List<String> _months = [
// // // // // //     "يناير",
// // // // // //     "فبراير",
// // // // // //     "مارس",
// // // // // //     "أبريل",
// // // // // //     "مايو",
// // // // // //     "يونيو",
// // // // // //     "يوليو",
// // // // // //     "أغسطس",
// // // // // //     "سبتمبر",
// // // // // //     "أكتوبر",
// // // // // //     "نوفمبر",
// // // // // //     "ديسمبر",
// // // // // //   ];

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return Scaffold(
// // // // // //       backgroundColor: const Color(0xFFF8FAFF),
// // // // // //       appBar: AppBar(
// // // // // //         backgroundColor: const Color(0xFF3D5EAB),
// // // // // //         elevation: 0,
// // // // // //         centerTitle: true,
// // // // // //         title: const Text(
// // // // // //           "التقارير والإحصائيات",
// // // // // //           style: TextStyle(
// // // // // //             fontFamily: 'Cairo',
// // // // // //             fontWeight: FontWeight.bold,
// // // // // //             color: Colors.white,
// // // // // //           ),
// // // // // //         ),
// // // // // //         leading: IconButton(
// // // // // //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
// // // // // //           onPressed: () => Navigator.pop(context),
// // // // // //         ),
// // // // // //       ),
// // // // // //       body: SingleChildScrollView(
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // // // // //         child: Column(
// // // // // //           crossAxisAlignment: CrossAxisAlignment.end,
// // // // // //           children: [
// // // // // //             // قسم الفلترة المطور في الأعلى
// // // // // //             _buildModernFilterSection(),
// // // // // //             const SizedBox(height: 16),

// // // // // //             // البطاقة الأولى: صافي الربح (شهري / سنوي)
// // // // // //             _buildStatCard(
// // // // // //               title: _isAnnual ? "صافي أرباح السنة" : "صافي أرباح الشهر",
// // // // // //               value: "₪ 45,200",
// // // // // //               icon: Icons.trending_up_rounded,
// // // // // //               iconBg: const Color(0xFFE8F5E9),
// // // // // //               iconColor: const Color(0xFF2E7D32),
// // // // // //               valueColor: const Color(0xFF2E7D32),
// // // // // //             ),
// // // // // //             // البطاقة الثانية: إجمالي مجموع الشيكات الواردة
// // // // // //             _buildStatCard(
// // // // // //               title: "إجمالي الشيكات الواردة",
// // // // // //               value: "₪ 28,400",
// // // // // //               icon: Icons.edit_document,
// // // // // //               iconBg: const Color(0xFFF0EDFF),
// // // // // //               iconColor: const Color(0xFF534AB7),
// // // // // //               valueColor: const Color(0xFF534AB7),
// // // // // //             ),
// // // // // //             // البطاقة الثالثة: إجمالي المبلغ الكامل
// // // // // //             _buildStatCard(
// // // // // //               title: "إجمالي رأس المال الكامل",
// // // // // //               value: "₪ 86,450",
// // // // // //               icon: Icons.account_balance_wallet_rounded,
// // // // // //               iconBg: const Color(0xFFFDF3E0),
// // // // // //               iconColor: const Color(0xFF854F0B),
// // // // // //               valueColor: const Color(0xFF854F0B),
// // // // // //             ),
// // // // // //             const SizedBox(height: 24),

// // // // // //             // عنوان قسم الزكاة
// // // // // //             const Text(
// // // // // //               "الزكاة السنوية",
// // // // // //               style: TextStyle(
// // // // // //                 fontSize: 18,
// // // // // //                 fontWeight: FontWeight.bold,
// // // // // //                 fontFamily: 'Cairo',
// // // // // //                 color: Color(0xFF2D3243),
// // // // // //               ),
// // // // // //             ),
// // // // // //             const SizedBox(height: 12),
// // // // // //             _buildZakatCard(),
// // // // // //             const SizedBox(height: 20),
// // // // // //           ],
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // الودجت المخصصة للفلترة بتصميم عصري مدمج في سطر واحد
// // // // // //   Widget _buildModernFilterSection() {
// // // // // //     return Row(
// // // // // //       children: [
// // // // // //         // قسم اختيار التاريخ (Dropdowns) على اليسار
// // // // // //         Expanded(
// // // // // //           child: Row(
// // // // // //             mainAxisAlignment: MainAxisAlignment.start,
// // // // // //             children: [
// // // // // //               // حقل اختيار السنة
// // // // // //               _buildDropdownContainer(
// // // // // //                 child: DropdownButtonHideUnderline(
// // // // // //                   child: DropdownButton<int>(
// // // // // //                     value: _selectedYear,
// // // // // //                     icon: const Icon(
// // // // // //                       Icons.arrow_drop_down,
// // // // // //                       color: Color(0xFF3D5EAB),
// // // // // //                     ),
// // // // // //                     style: const TextStyle(
// // // // // //                       fontFamily: 'Cairo',
// // // // // //                       color: Color(0xFF2D3243),
// // // // // //                       fontSize: 13,
// // // // // //                     ),
// // // // // //                     items: _years.map((int year) {
// // // // // //                       return DropdownMenuItem<int>(
// // // // // //                         value: year,
// // // // // //                         child: Text(year.toString()),
// // // // // //                       );
// // // // // //                     }).toList(),
// // // // // //                     onChanged: (value) {
// // // // // //                       setState(() {
// // // // // //                         if (value != null) _selectedYear = value;
// // // // // //                       });
// // // // // //                     },
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),

// // // // // //               // حقل اختيار الشهر (يظهر فقط في الفلترة الشهرية)
// // // // // //               if (!_isAnnual) ...[
// // // // // //                 const SizedBox(width: 8),
// // // // // //                 _buildDropdownContainer(
// // // // // //                   child: DropdownButtonHideUnderline(
// // // // // //                     child: DropdownButton<int>(
// // // // // //                       value: _selectedMonth,
// // // // // //                       icon: const Icon(
// // // // // //                         Icons.arrow_drop_down,
// // // // // //                         color: Color(0xFF3D5EAB),
// // // // // //                       ),
// // // // // //                       style: const TextStyle(
// // // // // //                         fontFamily: 'Cairo',
// // // // // //                         color: Color(0xFF2D3243),
// // // // // //                         fontSize: 13,
// // // // // //                       ),
// // // // // //                       items: List.generate(_months.length, (index) {
// // // // // //                         return DropdownMenuItem<int>(
// // // // // //                           value: index + 1,
// // // // // //                           child: Text(_months[index]),
// // // // // //                         );
// // // // // //                       }),
// // // // // //                       onChanged: (value) {
// // // // // //                         setState(() {
// // // // // //                           if (value != null) _selectedMonth = value;
// // // // // //                         });
// // // // // //                       },
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),

// // // // // //         // أزرار التبديل المخصصة (شهري / سنوي) على اليمين بتصميم احترافي كبسولة
// // // // // //         Container(
// // // // // //           height: 40,
// // // // // //           padding: const EdgeInsets.all(4),
// // // // // //           decoration: BoxDecoration(
// // // // // //             color: const Color(0xFFEFEFF4),
// // // // // //             borderRadius: BorderRadius.circular(12),
// // // // // //           ),
// // // // // //           child: Row(
// // // // // //             children: [
// // // // // //               _buildFilterToggleButton(
// // // // // //                 title: "سنوي",
// // // // // //                 isSelected: _isAnnual,
// // // // // //                 onTap: () => setState(() => _isAnnual = true),
// // // // // //               ),
// // // // // //               _buildFilterToggleButton(
// // // // // //                 title: "شهري",
// // // // // //                 isSelected: !_isAnnual,
// // // // // //                 onTap: () => setState(() => _isAnnual = false),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }

// // // // // //   // تابع مساعد لبناء حاويات الـ Dropdown بشكل موحد وأنيق
// // // // // //   Widget _buildDropdownContainer({required Widget child}) {
// // // // // //     return Container(
// // // // // //       height: 40,
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // //         border: Border.all(color: Colors.grey.withOpacity(0.15)),
// // // // // //         boxShadow: [
// // // // // //           BoxShadow(
// // // // // //             color: Colors.black.withOpacity(0.02),
// // // // // //             blurRadius: 4,
// // // // // //             offset: const Offset(0, 2),
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         mainAxisSize: MainAxisSize.min,
// // // // // //         children: [
// // // // // //           const Icon(
// // // // // //             Icons.calendar_month_rounded,
// // // // // //             size: 16,
// // // // // //             color: Color(0xFF3D5EAB),
// // // // // //           ),
// // // // // //           const SizedBox(width: 6),
// // // // // //           child,
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   // تابع مساعد لبناء أزرار التبديل التفاعلية داخل الكبسولة
// // // // // //   Widget _buildFilterToggleButton({
// // // // // //     required String title,
// // // // // //     required bool isSelected,
// // // // // //     required VoidCallback onTap,
// // // // // //   }) {
// // // // // //     return GestureDetector(
// // // // // //       onTap: onTap,
// // // // // //       child: AnimatedContainer(
// // // // // //         duration: const Duration(milliseconds: 200),
// // // // // //         padding: const EdgeInsets.symmetric(horizontal: 16),
// // // // // //         alignment: Alignment.center,
// // // // // //         decoration: BoxDecoration(
// // // // // //           color: isSelected ? Colors.white : Colors.transparent,
// // // // // //           borderRadius: BorderRadius.circular(8),
// // // // // //           boxShadow: isSelected
// // // // // //               ? [
// // // // // //                   BoxShadow(
// // // // // //                     color: Colors.black.withOpacity(0.05),
// // // // // //                     blurRadius: 4,
// // // // // //                     offset: const Offset(0, 2),
// // // // // //                   ),
// // // // // //                 ]
// // // // // //               : [],
// // // // // //         ),
// // // // // //         child: Text(
// // // // // //           title,
// // // // // //           style: TextStyle(
// // // // // //             fontFamily: 'Cairo',
// // // // // //             fontSize: 13,
// // // // // //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// // // // // //             color: isSelected ? const Color(0xFF3D5EAB) : Colors.grey[600],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildStatCard({
// // // // // //     required String title,
// // // // // //     required String value,
// // // // // //     required IconData icon,
// // // // // //     required Color iconBg,
// // // // // //     required Color iconColor,
// // // // // //     required Color valueColor,
// // // // // //   }) {
// // // // // //     return Container(
// // // // // //       margin: const EdgeInsets.only(bottom: 12),
// // // // // //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: Colors.white,
// // // // // //         borderRadius: BorderRadius.circular(16),
// // // // // //         border: Border.all(color: Colors.grey.withOpacity(0.1)),
// // // // // //       ),
// // // // // //       child: Row(
// // // // // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //         children: [
// // // // // //           Container(
// // // // // //             width: 44,
// // // // // //             height: 44,
// // // // // //             decoration: BoxDecoration(
// // // // // //               color: iconBg,
// // // // // //               borderRadius: BorderRadius.circular(12),
// // // // // //             ),
// // // // // //             child: Icon(icon, color: iconColor, size: 22),
// // // // // //           ),
// // // // // //           Column(
// // // // // //             crossAxisAlignment: CrossAxisAlignment.end,
// // // // // //             children: [
// // // // // //               Text(
// // // // // //                 title,
// // // // // //                 style: TextStyle(
// // // // // //                   fontFamily: 'Cairo',
// // // // // //                   fontSize: 13,
// // // // // //                   color: Colors.grey[600],
// // // // // //                 ),
// // // // // //               ),
// // // // // //               const SizedBox(height: 4),
// // // // // //               Text(
// // // // // //                 value,
// // // // // //                 style: TextStyle(
// // // // // //                   fontFamily: 'Cairo',
// // // // // //                   fontSize: 22,
// // // // // //                   fontWeight: FontWeight.w800,
// // // // // //                   color: valueColor,
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildZakatCard() {
// // // // // //     const double totalAmount = 86450;
// // // // // //     const double nisab = 5000;
// // // // // //     const double zakatAmount = totalAmount * 0.025;
// // // // // //     final bool nisabReached = totalAmount >= nisab;

// // // // // //     return Container(
// // // // // //       padding: const EdgeInsets.all(20),
// // // // // //       decoration: BoxDecoration(
// // // // // //         color: const Color(0xFFF0FFF6),
// // // // // //         borderRadius: BorderRadius.circular(16),
// // // // // //         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
// // // // // //       ),
// // // // // //       child: Column(
// // // // // //         crossAxisAlignment: CrossAxisAlignment.end,
// // // // // //         children: [
// // // // // //           Row(
// // // // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //             children: [
// // // // // //               Container(
// // // // // //                 padding: const EdgeInsets.symmetric(
// // // // // //                   horizontal: 10,
// // // // // //                   vertical: 4,
// // // // // //                 ),
// // // // // //                 decoration: BoxDecoration(
// // // // // //                   color: nisabReached
// // // // // //                       ? const Color(0xFFE8F5E9)
// // // // // //                       : const Color(0xFFFFF3E0),
// // // // // //                   borderRadius: BorderRadius.circular(20),
// // // // // //                 ),
// // // // // //                 child: Text(
// // // // // //                   nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
// // // // // //                   style: TextStyle(
// // // // // //                     fontFamily: 'Cairo',
// // // // // //                     fontSize: 12,
// // // // // //                     color: nisabReached
// // // // // //                         ? const Color(0xFF2E7D32)
// // // // // //                         : const Color(0xFFE65100),
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               Row(
// // // // // //                 children: [
// // // // // //                   const Text(
// // // // // //                     "الزكاة السنوية",
// // // // // //                     style: TextStyle(
// // // // // //                       fontFamily: 'Cairo',
// // // // // //                       fontSize: 15,
// // // // // //                       fontWeight: FontWeight.bold,
// // // // // //                       color: Color(0xFF2D3243),
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                   const SizedBox(width: 8),
// // // // // //                   Container(
// // // // // //                     width: 36,
// // // // // //                     height: 36,
// // // // // //                     decoration: BoxDecoration(
// // // // // //                       color: const Color(0xFFE8F5E9),
// // // // // //                       borderRadius: BorderRadius.circular(10),
// // // // // //                     ),
// // // // // //                     child: const Icon(
// // // // // //                       Icons.mosque_rounded,
// // // // // //                       color: Color(0xFF2E7D32),
// // // // // //                       size: 20,
// // // // // //                     ),
// // // // // //                   ),
// // // // // //                 ],
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //           const SizedBox(height: 16),
// // // // // //           const Divider(color: Color(0xFFDCEDC8), height: 1),
// // // // // //           const SizedBox(height: 16),
// // // // // //           _buildZakatRow("إجمالي المبالغ", "₪ 86,450"),
// // // // // //           const SizedBox(height: 10),
// // // // // //           _buildZakatRow("نسبة الزكاة", "2.5%"),
// // // // // //           const SizedBox(height: 10),
// // // // // //           _buildZakatRow("النصاب المطلوب", "₪ 5,000"),
// // // // // //           const SizedBox(height: 16),
// // // // // //           Container(
// // // // // //             width: double.infinity,
// // // // // //             padding: const EdgeInsets.symmetric(vertical: 14),
// // // // // //             decoration: BoxDecoration(
// // // // // //               color: const Color(0xFF2E7D32),
// // // // // //               borderRadius: BorderRadius.circular(12),
// // // // // //             ),
// // // // // //             child: Column(
// // // // // //               children: [
// // // // // //                 const Text(
// // // // // //                   "مبلغ الزكاة المستحقة",
// // // // // //                   style: TextStyle(
// // // // // //                     fontFamily: 'Cairo',
// // // // // //                     fontSize: 12,
// // // // // //                     color: Colors.white70,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //                 const SizedBox(height: 4),
// // // // // //                 Text(
// // // // // //                   "₪ ${zakatAmount.toStringAsFixed(0)}",
// // // // // //                   style: const TextStyle(
// // // // // //                     fontFamily: 'Cairo',
// // // // // //                     fontSize: 26,
// // // // // //                     fontWeight: FontWeight.w800,
// // // // // //                     color: Colors.white,
// // // // // //                   ),
// // // // // //                 ),
// // // // // //               ],
// // // // // //             ),
// // // // // //           ),
// // // // // //           const SizedBox(height: 12),
// // // // // //           const Row(
// // // // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //             children: [
// // // // // //               Text(
// // // // // //                 "لم يتم الدفع بعد",
// // // // // //                 style: TextStyle(
// // // // // //                   fontFamily: 'Cairo',
// // // // // //                   fontSize: 12,
// // // // // //                   color: Color(0xFF888888),
// // // // // //                 ),
// // // // // //               ),
// // // // // //               Text(
// // // // // //                 "آخر دفعة: لم تُحدد",
// // // // // //                 style: TextStyle(
// // // // // //                   fontFamily: 'Cairo',
// // // // // //                   fontSize: 12,
// // // // // //                   color: Color(0xFF888888),
// // // // // //                 ),
// // // // // //               ),
// // // // // //             ],
// // // // // //           ),
// // // // // //         ],
// // // // // //       ),
// // // // // //     );
// // // // // //   }

// // // // // //   Widget _buildZakatRow(String label, String value) {
// // // // // //     return Row(
// // // // // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // //       children: [
// // // // // //         Text(
// // // // // //           value,
// // // // // //           style: const TextStyle(
// // // // // //             fontFamily: 'Cairo',
// // // // // //             fontSize: 14,
// // // // // //             fontWeight: FontWeight.w700,
// // // // // //             color: Color(0xFF2E7D32),
// // // // // //           ),
// // // // // //         ),
// // // // // //         Text(
// // // // // //           label,
// // // // // //           style: TextStyle(
// // // // // //             fontFamily: 'Cairo',
// // // // // //             fontSize: 13,
// // // // // //             color: Colors.grey[600],
// // // // // //           ),
// // // // // //         ),
// // // // // //       ],
// // // // // //     );
// // // // // //   }
// // // // // // }
// // // // // import 'dart:convert';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:tradeflow_app/pages/link.dart';

// // // // // class ReportsScreen extends StatefulWidget {
// // // // //   const ReportsScreen({super.key});

// // // // //   @override
// // // // //   State<ReportsScreen> createState() => _ReportsScreenState();
// // // // // }

// // // // // class _ReportsScreenState extends State<ReportsScreen> {
// // // // //   bool _isAnnual = false;
// // // // //   int _selectedYear = 2026;
// // // // //   int _selectedMonth = 5;

// // // // //   final List<int> _years = [2024, 2025, 2026, 2027];
// // // // //   final List<String> _months = [
// // // // //     "يناير",
// // // // //     "فبراير",
// // // // //     "مارس",
// // // // //     "أبريل",
// // // // //     "مايو",
// // // // //     "يونيو",
// // // // //     "يوليو",
// // // // //     "أغسطس",
// // // // //     "سبتمبر",
// // // // //     "أكتوبر",
// // // // //     "نوفمبر",
// // // // //     "ديسمبر",
// // // // //   ];

// // // // //   // ── بيانات التقرير ──────────────────────────────────────
// // // // //   double _netProfit = 0;
// // // // //   double _totalIncome = 0;
// // // // //   bool _isLoading = false;
// // // // //   String? _errorMessage;

// // // // //   // ============================================================
// // // // //   //  جلب التقرير - نفس طريقة DebtsScreen بالضبط
// // // // //   // ============================================================
// // // // //   Future<void> _fetchReport() async {
// // // // //     print("======= FETCH REPORT CALLED =======");
// // // // //     setState(() {
// // // // //       _isLoading = true;
// // // // //       _errorMessage = null;
// // // // //     });

// // // // //     try {
// // // // //       SharedPreferences prefs = await SharedPreferences.getInstance();
// // // // //       String? token = prefs.getString("token");

// // // // //       final String targetUrl = _isAnnual
// // // // //           ? "${ApiEndpoints.getYearlyReport}?year=$_selectedYear"
// // // // //           : "${ApiEndpoints.getMonthlyReport}?year=$_selectedYear&month=$_selectedMonth";

// // // // //       final response = await http.get(
// // // // //         Uri.parse(targetUrl),
// // // // //         headers: {
// // // // //           "Authorization": "Bearer $token",
// // // // //           "Accept": "application/json",
// // // // //         },
// // // // //       );

// // // // //       print("============= REPORT DATA =============");
// // // // //       print("URL: $targetUrl");
// // // // //       print("STATUS: ${response.statusCode}");
// // // // //       print("RESPONSE: ${response.body}");
// // // // //       print("=======================================");

// // // // //       if (response.statusCode == 200) {
// // // // //         var rawData = jsonDecode(response.body);

// // // // //         setState(() {
// // // // //           _netProfit = ((rawData['netProfit'] ?? rawData['net_profit'] ?? 0))
// // // // //               .toDouble();
// // // // //           _totalIncome =
// // // // //               ((rawData['totalIncome'] ?? rawData['total_income'] ?? 0))
// // // // //                   .toDouble();
// // // // //         });
// // // // //       } else {
// // // // //         setState(
// // // // //           () => _errorMessage = "فشل تحميل التقرير (${response.statusCode})",
// // // // //         );
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print("Error fetching report: $e");
// // // // //       setState(() => _errorMessage = "تعذّر الاتصال بالخادم");
// // // // //     } finally {
// // // // //       setState(() => _isLoading = false);
// // // // //     }
// // // // //   }

// // // // //   String _fmt(double v) => v
// // // // //       .toStringAsFixed(0)
// // // // //       .replaceAllMapped(
// // // // //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
// // // // //         (m) => '${m[1]},',
// // // // //       );

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     _fetchReport();
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       backgroundColor: const Color(0xFFF8FAFF),
// // // // //       appBar: AppBar(
// // // // //         backgroundColor: const Color(0xFF3D5EAB),
// // // // //         elevation: 0,
// // // // //         centerTitle: true,
// // // // //         title: const Text(
// // // // //           "التقارير والإحصائيات",
// // // // //           style: TextStyle(
// // // // //             fontFamily: 'Cairo',
// // // // //             fontWeight: FontWeight.bold,
// // // // //             color: Colors.white,
// // // // //           ),
// // // // //         ),
// // // // //         leading: IconButton(
// // // // //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
// // // // //           onPressed: () => Navigator.pop(context),
// // // // //         ),
// // // // //       ),
// // // // //       body: _errorMessage != null
// // // // //           ? _buildErrorState()
// // // // //           : _isLoading
// // // // //           ? const Center(
// // // // //               child: CircularProgressIndicator(color: Color(0xFF3D5EAB)),
// // // // //             )
// // // // //           : SingleChildScrollView(
// // // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // // // //               child: Column(
// // // // //                 crossAxisAlignment: CrossAxisAlignment.end,
// // // // //                 children: [
// // // // //                   _buildModernFilterSection(),
// // // // //                   const SizedBox(height: 16),
// // // // //                   _buildStatCard(
// // // // //                     title: _isAnnual ? "صافي أرباح السنة" : "صافي أرباح الشهر",
// // // // //                     value: "₪ ${_fmt(_netProfit)}",
// // // // //                     icon: Icons.trending_up_rounded,
// // // // //                     iconBg: const Color(0xFFE8F5E9),
// // // // //                     iconColor: const Color(0xFF2E7D32),
// // // // //                     valueColor: const Color(0xFF2E7D32),
// // // // //                   ),
// // // // //                   _buildStatCard(
// // // // //                     title: "إجمالي الشيكات الواردة",
// // // // //                     value: "₪ ${_fmt(_totalIncome)}",
// // // // //                     icon: Icons.edit_document,
// // // // //                     iconBg: const Color(0xFFF0EDFF),
// // // // //                     iconColor: const Color(0xFF534AB7),
// // // // //                     valueColor: const Color(0xFF534AB7),
// // // // //                   ),
// // // // //                   _buildStatCard(
// // // // //                     title: "إجمالي رأس المال الكامل",
// // // // //                     value: "₪ ${_fmt(_totalIncome)}",
// // // // //                     icon: Icons.account_balance_wallet_rounded,
// // // // //                     iconBg: const Color(0xFFFDF3E0),
// // // // //                     iconColor: const Color(0xFF854F0B),
// // // // //                     valueColor: const Color(0xFF854F0B),
// // // // //                   ),
// // // // //                   const SizedBox(height: 24),
// // // // //                   const Text(
// // // // //                     "الزكاة السنوية",
// // // // //                     style: TextStyle(
// // // // //                       fontSize: 18,
// // // // //                       fontWeight: FontWeight.bold,
// // // // //                       fontFamily: 'Cairo',
// // // // //                       color: Color(0xFF2D3243),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(height: 12),
// // // // //                   _buildZakatCard(),
// // // // //                   const SizedBox(height: 20),
// // // // //                 ],
// // // // //               ),
// // // // //             ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildErrorState() {
// // // // //     return Center(
// // // // //       child: Column(
// // // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // // //         children: [
// // // // //           const Icon(
// // // // //             Icons.wifi_off_rounded,
// // // // //             size: 56,
// // // // //             color: Color(0xFFB0B8CC),
// // // // //           ),
// // // // //           const SizedBox(height: 16),
// // // // //           Text(
// // // // //             _errorMessage!,
// // // // //             style: const TextStyle(
// // // // //               fontFamily: 'Cairo',
// // // // //               fontSize: 15,
// // // // //               color: Color(0xFF888888),
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 20),
// // // // //           ElevatedButton.icon(
// // // // //             style: ElevatedButton.styleFrom(
// // // // //               backgroundColor: const Color(0xFF3D5EAB),
// // // // //               shape: RoundedRectangleBorder(
// // // // //                 borderRadius: BorderRadius.circular(12),
// // // // //               ),
// // // // //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// // // // //             ),
// // // // //             onPressed: _fetchReport,
// // // // //             icon: const Icon(Icons.refresh_rounded, color: Colors.white),
// // // // //             label: const Text(
// // // // //               "إعادة المحاولة",
// // // // //               style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildModernFilterSection() {
// // // // //     return Row(
// // // // //       children: [
// // // // //         Expanded(
// // // // //           child: Row(
// // // // //             mainAxisAlignment: MainAxisAlignment.start,
// // // // //             children: [
// // // // //               _buildDropdownContainer(
// // // // //                 child: DropdownButtonHideUnderline(
// // // // //                   child: DropdownButton<int>(
// // // // //                     value: _selectedYear,
// // // // //                     icon: const Icon(
// // // // //                       Icons.arrow_drop_down,
// // // // //                       color: Color(0xFF3D5EAB),
// // // // //                     ),
// // // // //                     style: const TextStyle(
// // // // //                       fontFamily: 'Cairo',
// // // // //                       color: Color(0xFF2D3243),
// // // // //                       fontSize: 13,
// // // // //                     ),
// // // // //                     items: _years
// // // // //                         .map(
// // // // //                           (y) => DropdownMenuItem(
// // // // //                             value: y,
// // // // //                             child: Text(y.toString()),
// // // // //                           ),
// // // // //                         )
// // // // //                         .toList(),
// // // // //                     onChanged: (value) {
// // // // //                       if (value != null) {
// // // // //                         setState(() => _selectedYear = value);
// // // // //                         _fetchReport();
// // // // //                       }
// // // // //                     },
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //               if (!_isAnnual) ...[
// // // // //                 const SizedBox(width: 8),
// // // // //                 _buildDropdownContainer(
// // // // //                   child: DropdownButtonHideUnderline(
// // // // //                     child: DropdownButton<int>(
// // // // //                       value: _selectedMonth,
// // // // //                       icon: const Icon(
// // // // //                         Icons.arrow_drop_down,
// // // // //                         color: Color(0xFF3D5EAB),
// // // // //                       ),
// // // // //                       style: const TextStyle(
// // // // //                         fontFamily: 'Cairo',
// // // // //                         color: Color(0xFF2D3243),
// // // // //                         fontSize: 13,
// // // // //                       ),
// // // // //                       items: List.generate(
// // // // //                         _months.length,
// // // // //                         (i) => DropdownMenuItem(
// // // // //                           value: i + 1,
// // // // //                           child: Text(_months[i]),
// // // // //                         ),
// // // // //                       ),
// // // // //                       onChanged: (value) {
// // // // //                         if (value != null) {
// // // // //                           setState(() => _selectedMonth = value);
// // // // //                           _fetchReport();
// // // // //                         }
// // // // //                       },
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //         Container(
// // // // //           height: 40,
// // // // //           padding: const EdgeInsets.all(4),
// // // // //           decoration: BoxDecoration(
// // // // //             color: const Color(0xFFEFEFF4),
// // // // //             borderRadius: BorderRadius.circular(12),
// // // // //           ),
// // // // //           child: Row(
// // // // //             children: [
// // // // //               _buildFilterToggleButton(
// // // // //                 title: "سنوي",
// // // // //                 isSelected: _isAnnual,
// // // // //                 onTap: () {
// // // // //                   setState(() => _isAnnual = true);
// // // // //                   _fetchReport();
// // // // //                 },
// // // // //               ),
// // // // //               _buildFilterToggleButton(
// // // // //                 title: "شهري",
// // // // //                 isSelected: !_isAnnual,
// // // // //                 onTap: () {
// // // // //                   setState(() => _isAnnual = false);
// // // // //                   _fetchReport();
// // // // //                 },
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget _buildDropdownContainer({required Widget child}) {
// // // // //     return Container(
// // // // //       height: 40,
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         border: Border.all(color: Colors.grey.withOpacity(0.15)),
// // // // //         boxShadow: [
// // // // //           BoxShadow(
// // // // //             color: Colors.black.withOpacity(0.02),
// // // // //             blurRadius: 4,
// // // // //             offset: const Offset(0, 2),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //       child: Row(
// // // // //         mainAxisSize: MainAxisSize.min,
// // // // //         children: [
// // // // //           const Icon(
// // // // //             Icons.calendar_month_rounded,
// // // // //             size: 16,
// // // // //             color: Color(0xFF3D5EAB),
// // // // //           ),
// // // // //           const SizedBox(width: 6),
// // // // //           child,
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildFilterToggleButton({
// // // // //     required String title,
// // // // //     required bool isSelected,
// // // // //     required VoidCallback onTap,
// // // // //   }) {
// // // // //     return GestureDetector(
// // // // //       onTap: onTap,
// // // // //       child: AnimatedContainer(
// // // // //         duration: const Duration(milliseconds: 200),
// // // // //         padding: const EdgeInsets.symmetric(horizontal: 16),
// // // // //         alignment: Alignment.center,
// // // // //         decoration: BoxDecoration(
// // // // //           color: isSelected ? Colors.white : Colors.transparent,
// // // // //           borderRadius: BorderRadius.circular(8),
// // // // //           boxShadow: isSelected
// // // // //               ? [
// // // // //                   BoxShadow(
// // // // //                     color: Colors.black.withOpacity(0.05),
// // // // //                     blurRadius: 4,
// // // // //                     offset: const Offset(0, 2),
// // // // //                   ),
// // // // //                 ]
// // // // //               : [],
// // // // //         ),
// // // // //         child: Text(
// // // // //           title,
// // // // //           style: TextStyle(
// // // // //             fontFamily: 'Cairo',
// // // // //             fontSize: 13,
// // // // //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// // // // //             color: isSelected ? const Color(0xFF3D5EAB) : Colors.grey[600],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildStatCard({
// // // // //     required String title,
// // // // //     required String value,
// // // // //     required IconData icon,
// // // // //     required Color iconBg,
// // // // //     required Color iconColor,
// // // // //     required Color valueColor,
// // // // //   }) {
// // // // //     return Container(
// // // // //       margin: const EdgeInsets.only(bottom: 12),
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(16),
// // // // //         border: Border.all(color: Colors.grey.withOpacity(0.1)),
// // // // //       ),
// // // // //       child: Row(
// // // // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //         children: [
// // // // //           Container(
// // // // //             width: 44,
// // // // //             height: 44,
// // // // //             decoration: BoxDecoration(
// // // // //               color: iconBg,
// // // // //               borderRadius: BorderRadius.circular(12),
// // // // //             ),
// // // // //             child: Icon(icon, color: iconColor, size: 22),
// // // // //           ),
// // // // //           Column(
// // // // //             crossAxisAlignment: CrossAxisAlignment.end,
// // // // //             children: [
// // // // //               Text(
// // // // //                 title,
// // // // //                 style: TextStyle(
// // // // //                   fontFamily: 'Cairo',
// // // // //                   fontSize: 13,
// // // // //                   color: Colors.grey[600],
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 4),
// // // // //               Text(
// // // // //                 value,
// // // // //                 style: TextStyle(
// // // // //                   fontFamily: 'Cairo',
// // // // //                   fontSize: 22,
// // // // //                   fontWeight: FontWeight.w800,
// // // // //                   color: valueColor,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildZakatCard() {
// // // // //     const double nisab = 5000;
// // // // //     final double zakatAmount = _totalIncome >= nisab ? _totalIncome * 0.025 : 0;
// // // // //     final bool nisabReached = _totalIncome >= nisab;

// // // // //     return Container(
// // // // //       padding: const EdgeInsets.all(20),
// // // // //       decoration: BoxDecoration(
// // // // //         color: const Color(0xFFF0FFF6),
// // // // //         borderRadius: BorderRadius.circular(16),
// // // // //         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.end,
// // // // //         children: [
// // // // //           Row(
// // // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //             children: [
// // // // //               Container(
// // // // //                 padding: const EdgeInsets.symmetric(
// // // // //                   horizontal: 10,
// // // // //                   vertical: 4,
// // // // //                 ),
// // // // //                 decoration: BoxDecoration(
// // // // //                   color: nisabReached
// // // // //                       ? const Color(0xFFE8F5E9)
// // // // //                       : const Color(0xFFFFF3E0),
// // // // //                   borderRadius: BorderRadius.circular(20),
// // // // //                 ),
// // // // //                 child: Text(
// // // // //                   nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
// // // // //                   style: TextStyle(
// // // // //                     fontFamily: 'Cairo',
// // // // //                     fontSize: 12,
// // // // //                     color: nisabReached
// // // // //                         ? const Color(0xFF2E7D32)
// // // // //                         : const Color(0xFFE65100),
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //               Row(
// // // // //                 children: [
// // // // //                   const Text(
// // // // //                     "الزكاة السنوية",
// // // // //                     style: TextStyle(
// // // // //                       fontFamily: 'Cairo',
// // // // //                       fontSize: 15,
// // // // //                       fontWeight: FontWeight.bold,
// // // // //                       color: Color(0xFF2D3243),
// // // // //                     ),
// // // // //                   ),
// // // // //                   const SizedBox(width: 8),
// // // // //                   Container(
// // // // //                     width: 36,
// // // // //                     height: 36,
// // // // //                     decoration: BoxDecoration(
// // // // //                       color: const Color(0xFFE8F5E9),
// // // // //                       borderRadius: BorderRadius.circular(10),
// // // // //                     ),
// // // // //                     child: const Icon(
// // // // //                       Icons.mosque_rounded,
// // // // //                       color: Color(0xFF2E7D32),
// // // // //                       size: 20,
// // // // //                     ),
// // // // //                   ),
// // // // //                 ],
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const SizedBox(height: 16),
// // // // //           const Divider(color: Color(0xFFDCEDC8), height: 1),
// // // // //           const SizedBox(height: 16),
// // // // //           _buildZakatRow("إجمالي المبالغ", "₪ ${_fmt(_totalIncome)}"),
// // // // //           const SizedBox(height: 10),
// // // // //           _buildZakatRow("نسبة الزكاة", "2.5%"),
// // // // //           const SizedBox(height: 10),
// // // // //           _buildZakatRow("النصاب المطلوب", "₪ ${_fmt(nisab)}"),
// // // // //           const SizedBox(height: 16),
// // // // //           Container(
// // // // //             width: double.infinity,
// // // // //             padding: const EdgeInsets.symmetric(vertical: 14),
// // // // //             decoration: BoxDecoration(
// // // // //               color: const Color(0xFF2E7D32),
// // // // //               borderRadius: BorderRadius.circular(12),
// // // // //             ),
// // // // //             child: Column(
// // // // //               children: [
// // // // //                 const Text(
// // // // //                   "مبلغ الزكاة المستحقة",
// // // // //                   style: TextStyle(
// // // // //                     fontFamily: 'Cairo',
// // // // //                     fontSize: 12,
// // // // //                     color: Colors.white70,
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 4),
// // // // //                 Text(
// // // // //                   "₪ ${_fmt(zakatAmount)}",
// // // // //                   style: const TextStyle(
// // // // //                     fontFamily: 'Cairo',
// // // // //                     fontSize: 26,
// // // // //                     fontWeight: FontWeight.w800,
// // // // //                     color: Colors.white,
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(height: 12),
// // // // //           const Row(
// // // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //             children: [
// // // // //               Text(
// // // // //                 "لم يتم الدفع بعد",
// // // // //                 style: TextStyle(
// // // // //                   fontFamily: 'Cairo',
// // // // //                   fontSize: 12,
// // // // //                   color: Color(0xFF888888),
// // // // //                 ),
// // // // //               ),
// // // // //               Text(
// // // // //                 "آخر دفعة: لم تُحدد",
// // // // //                 style: TextStyle(
// // // // //                   fontFamily: 'Cairo',
// // // // //                   fontSize: 12,
// // // // //                   color: Color(0xFF888888),
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildZakatRow(String label, String value) {
// // // // //     return Row(
// // // // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //       children: [
// // // // //         Text(
// // // // //           value,
// // // // //           style: const TextStyle(
// // // // //             fontFamily: 'Cairo',
// // // // //             fontSize: 14,
// // // // //             fontWeight: FontWeight.w700,
// // // // //             color: Color(0xFF2E7D32),
// // // // //           ),
// // // // //         ),
// // // // //         Text(
// // // // //           label,
// // // // //           style: TextStyle(
// // // // //             fontFamily: 'Cairo',
// // // // //             fontSize: 13,
// // // // //             color: Colors.grey[600],
// // // // //           ),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }
// // // // // }
// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:tradeflow_app/pages/link.dart';

// // // // class ReportsScreen extends StatefulWidget {
// // // //   const ReportsScreen({super.key});

// // // //   @override
// // // //   State<ReportsScreen> createState() => _ReportsScreenState();
// // // // }

// // // // class _ReportsScreenState extends State<ReportsScreen> {
// // // //   bool _isAnnual = false;
// // // //   int _selectedYear = 2026;
// // // //   int _selectedMonth = 5;

// // // //   final List<int> _years = [2024, 2025, 2026, 2027];
// // // //   final List<String> _months = [
// // // //     "يناير",
// // // //     "فبراير",
// // // //     "مارس",
// // // //     "أبريل",
// // // //     "مايو",
// // // //     "يونيو",
// // // //     "يوليو",
// // // //     "أغسطس",
// // // //     "سبتمبر",
// // // //     "أكتوبر",
// // // //     "نوفمبر",
// // // //     "ديسمبر",
// // // //   ];

// // // //   // ── بيانات التقرير ──────────────────────────────────────
// // // //   double _netProfit = 0;
// // // //   double _totalIncome = 0;
// // // //   double _totalChecks = 0; // ← إجمالي الشيكات الواردة
// // // //   bool _isLoading = false;
// // // //   String? _errorMessage;

// // // //   // ============================================================
// // // //   //  جلب التقرير (سنوي / شهري)
// // // //   // ============================================================
// // // //   Future<void> _fetchReport() async {
// // // //     print("======= FETCH REPORT CALLED =======");
// // // //     setState(() {
// // // //       _isLoading = true;
// // // //       _errorMessage = null;
// // // //     });

// // // //     try {
// // // //       SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //       String? token = prefs.getString("token");

// // // //       final String targetUrl = _isAnnual
// // // //           ? "${ApiEndpoints.getYearlyReport}?year=$_selectedYear"
// // // //           : "${ApiEndpoints.getMonthlyReport}?year=$_selectedYear&month=$_selectedMonth";

// // // //       final response = await http.get(
// // // //         Uri.parse(targetUrl),
// // // //         headers: {
// // // //           "Authorization": "Bearer $token",
// // // //           "Accept": "application/json",
// // // //         },
// // // //       );

// // // //       print("============= REPORT DATA =============");
// // // //       print("URL: $targetUrl");
// // // //       print("STATUS: ${response.statusCode}");
// // // //       print("RESPONSE: ${response.body}");
// // // //       print("=======================================");

// // // //       if (response.statusCode == 200) {
// // // //         var rawData = jsonDecode(response.body);
// // // //         setState(() {
// // // //           _netProfit = (rawData['netProfit'] ?? rawData['net_profit'] ?? 0)
// // // //               .toDouble();
// // // //           _totalIncome =
// // // //               (rawData['totalIncome'] ?? rawData['total_income'] ?? 0)
// // // //                   .toDouble();
// // // //         });
// // // //       } else {
// // // //         setState(
// // // //           () => _errorMessage = "فشل تحميل التقرير (${response.statusCode})",
// // // //         );
// // // //       }
// // // //     } catch (e) {
// // // //       print("Error fetching report: $e");
// // // //       setState(() => _errorMessage = "تعذّر الاتصال بالخادم");
// // // //     } finally {
// // // //       setState(() => _isLoading = false);
// // // //     }

// // // //     // جلب الشيكات بعد التقرير
// // // //     await _fetchChecks();
// // // //   }

// // // //   // ============================================================
// // // //   //  جلب الشيكات الواردة
// // // //   //  - شهري: يجيب الشهر المحدد من monthlyBreakdown
// // // //   //  - سنوي: يجمع كل الشهور
// // // //   // ============================================================
// // // //   Future<void> _fetchChecks() async {
// // // //     try {
// // // //       SharedPreferences prefs = await SharedPreferences.getInstance();
// // // //       String? token = prefs.getString("token");

// // // //       // الرابط دايماً نفسه، بس نمرر السنة
// // // //       final String checksUrl =
// // // //           "${ApiEndpoints.getMonthlyChecks}?year=$_selectedYear";

// // // //       final response = await http.get(
// // // //         Uri.parse(checksUrl),
// // // //         headers: {
// // // //           "Authorization": "Bearer $token",
// // // //           "Accept": "application/json",
// // // //         },
// // // //       );

// // // //       print("============= CHECKS DATA =============");
// // // //       print("URL: $checksUrl");
// // // //       print("STATUS: ${response.statusCode}");
// // // //       print("RESPONSE: ${response.body}");
// // // //       print("=======================================");

// // // //       if (response.statusCode == 200) {
// // // //         var rawData = jsonDecode(response.body);
// // // //         List<dynamic> breakdown = rawData['monthlyBreakdown'] ?? [];

// // // //         double total = 0;

// // // //         if (_isAnnual) {
// // // //           // سنوي: نجمع كل الشهور
// // // //           for (var item in breakdown) {
// // // //             total += (item['totalIncomingAmount'] ?? 0).toDouble();
// // // //           }
// // // //         } else {
// // // //           // شهري: نجيب الشهر المحدد فقط
// // // //           var monthData = breakdown.firstWhere(
// // // //             (item) => item['month'] == _selectedMonth,
// // // //             orElse: () => null,
// // // //           );
// // // //           total = (monthData?['totalIncomingAmount'] ?? 0).toDouble();
// // // //         }

// // // //         setState(() => _totalChecks = total);
// // // //       }
// // // //     } catch (e) {
// // // //       print("Error fetching checks: $e");
// // // //     }
// // // //   }

// // // //   String _fmt(double v) => v
// // // //       .toStringAsFixed(0)
// // // //       .replaceAllMapped(
// // // //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
// // // //         (m) => '${m[1]},',
// // // //       );

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     _fetchReport();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       backgroundColor: const Color(0xFFF8FAFF),
// // // //       appBar: AppBar(
// // // //         backgroundColor: const Color(0xFF3D5EAB),
// // // //         elevation: 0,
// // // //         centerTitle: true,
// // // //         title: const Text(
// // // //           "التقارير والإحصائيات",
// // // //           style: TextStyle(
// // // //             fontFamily: 'Cairo',
// // // //             fontWeight: FontWeight.bold,
// // // //             color: Colors.white,
// // // //           ),
// // // //         ),
// // // //         leading: IconButton(
// // // //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
// // // //           onPressed: () => Navigator.pop(context),
// // // //         ),
// // // //       ),
// // // //       body: _errorMessage != null
// // // //           ? _buildErrorState()
// // // //           : _isLoading
// // // //           ? const Center(
// // // //               child: CircularProgressIndicator(color: Color(0xFF3D5EAB)),
// // // //             )
// // // //           : SingleChildScrollView(
// // // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.end,
// // // //                 children: [
// // // //                   _buildModernFilterSection(),
// // // //                   const SizedBox(height: 16),

// // // //                   // بطاقة صافي الربح
// // // //                   _buildStatCard(
// // // //                     title: _isAnnual ? "صافي أرباح السنة" : "صافي أرباح الشهر",
// // // //                     value: "₪ ${_fmt(_netProfit)}",
// // // //                     icon: Icons.trending_up_rounded,
// // // //                     iconBg: const Color(0xFFE8F5E9),
// // // //                     iconColor: const Color(0xFF2E7D32),
// // // //                     valueColor: const Color(0xFF2E7D32),
// // // //                   ),

// // // //                   // بطاقة الشيكات الواردة
// // // //                   _buildStatCard(
// // // //                     title: _isAnnual
// // // //                         ? "إجمالي الشيكات الواردة للسنة"
// // // //                         : "إجمالي الشيكات الواردة للشهر",
// // // //                     value: "₪ ${_fmt(_totalChecks)}",
// // // //                     icon: Icons.edit_document,
// // // //                     iconBg: const Color(0xFFF0EDFF),
// // // //                     iconColor: const Color(0xFF534AB7),
// // // //                     valueColor: const Color(0xFF534AB7),
// // // //                   ),

// // // //                   // بطاقة رأس المال
// // // //                   _buildStatCard(
// // // //                     title: "إجمالي رأس المال الكامل",
// // // //                     value: "₪ ${_fmt(_totalIncome)}",
// // // //                     icon: Icons.account_balance_wallet_rounded,
// // // //                     iconBg: const Color(0xFFFDF3E0),
// // // //                     iconColor: const Color(0xFF854F0B),
// // // //                     valueColor: const Color(0xFF854F0B),
// // // //                   ),

// // // //                   // الزكاة فقط في السنوي
// // // //                   if (_isAnnual) ...[
// // // //                     const SizedBox(height: 24),
// // // //                     const Text(
// // // //                       "الزكاة السنوية",
// // // //                       style: TextStyle(
// // // //                         fontSize: 18,
// // // //                         fontWeight: FontWeight.bold,
// // // //                         fontFamily: 'Cairo',
// // // //                         color: Color(0xFF2D3243),
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(height: 12),
// // // //                     _buildZakatCard(),
// // // //                   ],

// // // //                   const SizedBox(height: 20),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //     );
// // // //   }

// // // //   Widget _buildErrorState() {
// // // //     return Center(
// // // //       child: Column(
// // // //         mainAxisAlignment: MainAxisAlignment.center,
// // // //         children: [
// // // //           const Icon(
// // // //             Icons.wifi_off_rounded,
// // // //             size: 56,
// // // //             color: Color(0xFFB0B8CC),
// // // //           ),
// // // //           const SizedBox(height: 16),
// // // //           Text(
// // // //             _errorMessage!,
// // // //             style: const TextStyle(
// // // //               fontFamily: 'Cairo',
// // // //               fontSize: 15,
// // // //               color: Color(0xFF888888),
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 20),
// // // //           ElevatedButton.icon(
// // // //             style: ElevatedButton.styleFrom(
// // // //               backgroundColor: const Color(0xFF3D5EAB),
// // // //               shape: RoundedRectangleBorder(
// // // //                 borderRadius: BorderRadius.circular(12),
// // // //               ),
// // // //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// // // //             ),
// // // //             onPressed: _fetchReport,
// // // //             icon: const Icon(Icons.refresh_rounded, color: Colors.white),
// // // //             label: const Text(
// // // //               "إعادة المحاولة",
// // // //               style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildModernFilterSection() {
// // // //     return Row(
// // // //       children: [
// // // //         Expanded(
// // // //           child: Row(
// // // //             mainAxisAlignment: MainAxisAlignment.start,
// // // //             children: [
// // // //               _buildDropdownContainer(
// // // //                 child: DropdownButtonHideUnderline(
// // // //                   child: DropdownButton<int>(
// // // //                     value: _selectedYear,
// // // //                     icon: const Icon(
// // // //                       Icons.arrow_drop_down,
// // // //                       color: Color(0xFF3D5EAB),
// // // //                     ),
// // // //                     style: const TextStyle(
// // // //                       fontFamily: 'Cairo',
// // // //                       color: Color(0xFF2D3243),
// // // //                       fontSize: 13,
// // // //                     ),
// // // //                     items: _years
// // // //                         .map(
// // // //                           (y) => DropdownMenuItem(
// // // //                             value: y,
// // // //                             child: Text(y.toString()),
// // // //                           ),
// // // //                         )
// // // //                         .toList(),
// // // //                     onChanged: (value) {
// // // //                       if (value != null) {
// // // //                         setState(() => _selectedYear = value);
// // // //                         _fetchReport();
// // // //                       }
// // // //                     },
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               if (!_isAnnual) ...[
// // // //                 const SizedBox(width: 8),
// // // //                 _buildDropdownContainer(
// // // //                   child: DropdownButtonHideUnderline(
// // // //                     child: DropdownButton<int>(
// // // //                       value: _selectedMonth,
// // // //                       icon: const Icon(
// // // //                         Icons.arrow_drop_down,
// // // //                         color: Color(0xFF3D5EAB),
// // // //                       ),
// // // //                       style: const TextStyle(
// // // //                         fontFamily: 'Cairo',
// // // //                         color: Color(0xFF2D3243),
// // // //                         fontSize: 13,
// // // //                       ),
// // // //                       items: List.generate(
// // // //                         _months.length,
// // // //                         (i) => DropdownMenuItem(
// // // //                           value: i + 1,
// // // //                           child: Text(_months[i]),
// // // //                         ),
// // // //                       ),
// // // //                       onChanged: (value) {
// // // //                         if (value != null) {
// // // //                           setState(() => _selectedMonth = value);
// // // //                           _fetchReport();
// // // //                         }
// // // //                       },
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ],
// // // //           ),
// // // //         ),
// // // //         Container(
// // // //           height: 40,
// // // //           padding: const EdgeInsets.all(4),
// // // //           decoration: BoxDecoration(
// // // //             color: const Color(0xFFEFEFF4),
// // // //             borderRadius: BorderRadius.circular(12),
// // // //           ),
// // // //           child: Row(
// // // //             children: [
// // // //               _buildFilterToggleButton(
// // // //                 title: "سنوي",
// // // //                 isSelected: _isAnnual,
// // // //                 onTap: () {
// // // //                   setState(() => _isAnnual = true);
// // // //                   _fetchReport();
// // // //                 },
// // // //               ),
// // // //               _buildFilterToggleButton(
// // // //                 title: "شهري",
// // // //                 isSelected: !_isAnnual,
// // // //                 onTap: () {
// // // //                   setState(() => _isAnnual = false);
// // // //                   _fetchReport();
// // // //                 },
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildDropdownContainer({required Widget child}) {
// // // //     return Container(
// // // //       height: 40,
// // // //       padding: const EdgeInsets.symmetric(horizontal: 10),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: Colors.grey.withOpacity(0.15)),
// // // //         boxShadow: [
// // // //           BoxShadow(
// // // //             color: Colors.black.withOpacity(0.02),
// // // //             blurRadius: 4,
// // // //             offset: const Offset(0, 2),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       child: Row(
// // // //         mainAxisSize: MainAxisSize.min,
// // // //         children: [
// // // //           const Icon(
// // // //             Icons.calendar_month_rounded,
// // // //             size: 16,
// // // //             color: Color(0xFF3D5EAB),
// // // //           ),
// // // //           const SizedBox(width: 6),
// // // //           child,
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildFilterToggleButton({
// // // //     required String title,
// // // //     required bool isSelected,
// // // //     required VoidCallback onTap,
// // // //   }) {
// // // //     return GestureDetector(
// // // //       onTap: onTap,
// // // //       child: AnimatedContainer(
// // // //         duration: const Duration(milliseconds: 200),
// // // //         padding: const EdgeInsets.symmetric(horizontal: 16),
// // // //         alignment: Alignment.center,
// // // //         decoration: BoxDecoration(
// // // //           color: isSelected ? Colors.white : Colors.transparent,
// // // //           borderRadius: BorderRadius.circular(8),
// // // //           boxShadow: isSelected
// // // //               ? [
// // // //                   BoxShadow(
// // // //                     color: Colors.black.withOpacity(0.05),
// // // //                     blurRadius: 4,
// // // //                     offset: const Offset(0, 2),
// // // //                   ),
// // // //                 ]
// // // //               : [],
// // // //         ),
// // // //         child: Text(
// // // //           title,
// // // //           style: TextStyle(
// // // //             fontFamily: 'Cairo',
// // // //             fontSize: 13,
// // // //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// // // //             color: isSelected ? const Color(0xFF3D5EAB) : Colors.grey[600],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildStatCard({
// // // //     required String title,
// // // //     required String value,
// // // //     required IconData icon,
// // // //     required Color iconBg,
// // // //     required Color iconColor,
// // // //     required Color valueColor,
// // // //   }) {
// // // //     return Container(
// // // //       margin: const EdgeInsets.only(bottom: 12),
// // // //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         border: Border.all(color: Colors.grey.withOpacity(0.1)),
// // // //       ),
// // // //       child: Row(
// // // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //         children: [
// // // //           Container(
// // // //             width: 44,
// // // //             height: 44,
// // // //             decoration: BoxDecoration(
// // // //               color: iconBg,
// // // //               borderRadius: BorderRadius.circular(12),
// // // //             ),
// // // //             child: Icon(icon, color: iconColor, size: 22),
// // // //           ),
// // // //           Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.end,
// // // //             children: [
// // // //               Text(
// // // //                 title,
// // // //                 style: TextStyle(
// // // //                   fontFamily: 'Cairo',
// // // //                   fontSize: 13,
// // // //                   color: Colors.grey[600],
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 4),
// // // //               Text(
// // // //                 value,
// // // //                 style: TextStyle(
// // // //                   fontFamily: 'Cairo',
// // // //                   fontSize: 22,
// // // //                   fontWeight: FontWeight.w800,
// // // //                   color: valueColor,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildZakatCard() {
// // // //     const double nisab = 5000;
// // // //     final double zakatAmount = _totalIncome >= nisab ? _totalIncome * 0.025 : 0;
// // // //     final bool nisabReached = _totalIncome >= nisab;

// // // //     return Container(
// // // //       padding: const EdgeInsets.all(20),
// // // //       decoration: BoxDecoration(
// // // //         color: const Color(0xFFF0FFF6),
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.end,
// // // //         children: [
// // // //           Row(
// // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //             children: [
// // // //               Container(
// // // //                 padding: const EdgeInsets.symmetric(
// // // //                   horizontal: 10,
// // // //                   vertical: 4,
// // // //                 ),
// // // //                 decoration: BoxDecoration(
// // // //                   color: nisabReached
// // // //                       ? const Color(0xFFE8F5E9)
// // // //                       : const Color(0xFFFFF3E0),
// // // //                   borderRadius: BorderRadius.circular(20),
// // // //                 ),
// // // //                 child: Text(
// // // //                   nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
// // // //                   style: TextStyle(
// // // //                     fontFamily: 'Cairo',
// // // //                     fontSize: 12,
// // // //                     color: nisabReached
// // // //                         ? const Color(0xFF2E7D32)
// // // //                         : const Color(0xFFE65100),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               Row(
// // // //                 children: [
// // // //                   const Text(
// // // //                     "الزكاة السنوية",
// // // //                     style: TextStyle(
// // // //                       fontFamily: 'Cairo',
// // // //                       fontSize: 15,
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Color(0xFF2D3243),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 8),
// // // //                   Container(
// // // //                     width: 36,
// // // //                     height: 36,
// // // //                     decoration: BoxDecoration(
// // // //                       color: const Color(0xFFE8F5E9),
// // // //                       borderRadius: BorderRadius.circular(10),
// // // //                     ),
// // // //                     child: const Icon(
// // // //                       Icons.mosque_rounded,
// // // //                       color: Color(0xFF2E7D32),
// // // //                       size: 20,
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const SizedBox(height: 16),
// // // //           const Divider(color: Color(0xFFDCEDC8), height: 1),
// // // //           const SizedBox(height: 16),
// // // //           _buildZakatRow("إجمالي المبالغ", "₪ ${_fmt(_totalIncome)}"),
// // // //           const SizedBox(height: 10),
// // // //           _buildZakatRow("نسبة الزكاة", "2.5%"),
// // // //           const SizedBox(height: 10),
// // // //           _buildZakatRow("النصاب المطلوب", "₪ ${_fmt(nisab)}"),
// // // //           const SizedBox(height: 16),
// // // //           Container(
// // // //             width: double.infinity,
// // // //             padding: const EdgeInsets.symmetric(vertical: 14),
// // // //             decoration: BoxDecoration(
// // // //               color: const Color(0xFF2E7D32),
// // // //               borderRadius: BorderRadius.circular(12),
// // // //             ),
// // // //             child: Column(
// // // //               children: [
// // // //                 const Text(
// // // //                   "مبلغ الزكاة المستحقة",
// // // //                   style: TextStyle(
// // // //                     fontFamily: 'Cairo',
// // // //                     fontSize: 12,
// // // //                     color: Colors.white70,
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 4),
// // // //                 Text(
// // // //                   "₪ ${_fmt(zakatAmount)}",
// // // //                   style: const TextStyle(
// // // //                     fontFamily: 'Cairo',
// // // //                     fontSize: 26,
// // // //                     fontWeight: FontWeight.w800,
// // // //                     color: Colors.white,
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           const SizedBox(height: 12),
// // // //           const Row(
// // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //             children: [
// // // //               Text(
// // // //                 "لم يتم الدفع بعد",
// // // //                 style: TextStyle(
// // // //                   fontFamily: 'Cairo',
// // // //                   fontSize: 12,
// // // //                   color: Color(0xFF888888),
// // // //                 ),
// // // //               ),
// // // //               Text(
// // // //                 "آخر دفعة: لم تُحدد",
// // // //                 style: TextStyle(
// // // //                   fontFamily: 'Cairo',
// // // //                   fontSize: 12,
// // // //                   color: Color(0xFF888888),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildZakatRow(String label, String value) {
// // // //     return Row(
// // // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //       children: [
// // // //         Text(
// // // //           value,
// // // //           style: const TextStyle(
// // // //             fontFamily: 'Cairo',
// // // //             fontSize: 14,
// // // //             fontWeight: FontWeight.w700,
// // // //             color: Color(0xFF2E7D32),
// // // //           ),
// // // //         ),
// // // //         Text(
// // // //           label,
// // // //           style: TextStyle(
// // // //             fontFamily: 'Cairo',
// // // //             fontSize: 13,
// // // //             color: Colors.grey[600],
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }
// // // // }
// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:tradeflow_app/pages/link.dart';

// // // class ReportsScreen extends StatefulWidget {
// // //   const ReportsScreen({super.key});

// // //   @override
// // //   State<ReportsScreen> createState() => _ReportsScreenState();
// // // }

// // // class _ReportsScreenState extends State<ReportsScreen> {
// // //   // 0 = شهري ، 1 = سنوي ، 2 = زكاة
// // //   int _reportMode = 0;

// // //   int _selectedYear = 2026;
// // //   int _selectedMonth = 5;

// // //   final List<int> _years = [2024, 2025, 2026, 2027];
// // //   final List<String> _months = [
// // //     "يناير",
// // //     "فبراير",
// // //     "مارس",
// // //     "أبريل",
// // //     "مايو",
// // //     "يونيو",
// // //     "يوليو",
// // //     "أغسطس",
// // //     "سبتمبر",
// // //     "أكتوبر",
// // //     "نوفمبر",
// // //     "ديسمبر",
// // //   ];

// // //   // ── بيانات التقرير ──────────────────────────────────────
// // //   double _netProfit = 0;
// // //   double _totalIncome = 0;
// // //   double _totalChecks = 0;
// // //   bool _isLoading = false;
// // //   String? _errorMessage;

// // //   // ============================================================
// // //   //  جلب التقرير (سنوي / شهري / زكاة)
// // //   // ============================================================
// // //   Future<void> _fetchReport() async {
// // //     print("======= FETCH REPORT CALLED =======");
// // //     setState(() {
// // //       _isLoading = true;
// // //       _errorMessage = null;
// // //     });

// // //     try {
// // //       SharedPreferences prefs = await SharedPreferences.getInstance();
// // //       String? token = prefs.getString("token");

// // //       // الزكاة والسنوي كلاهما يجلب بيانات سنوية
// // //       final bool isYearly = _reportMode == 1 || _reportMode == 2;

// // //       final String targetUrl = isYearly
// // //           ? "${ApiEndpoints.getYearlyReport}?year=$_selectedYear"
// // //           : "${ApiEndpoints.getMonthlyReport}?year=$_selectedYear&month=$_selectedMonth";

// // //       final response = await http.get(
// // //         Uri.parse(targetUrl),
// // //         headers: {
// // //           "Authorization": "Bearer $token",
// // //           "Accept": "application/json",
// // //         },
// // //       );

// // //       print("============= REPORT DATA =============");
// // //       print("URL: $targetUrl");
// // //       print("STATUS: ${response.statusCode}");
// // //       print("RESPONSE: ${response.body}");
// // //       print("=======================================");

// // //       if (response.statusCode == 200) {
// // //         var rawData = jsonDecode(response.body);
// // //         setState(() {
// // //           _netProfit = (rawData['netProfit'] ?? rawData['net_profit'] ?? 0)
// // //               .toDouble();
// // //           _totalIncome =
// // //               (rawData['totalIncome'] ?? rawData['total_income'] ?? 0)
// // //                   .toDouble();
// // //         });
// // //       } else {
// // //         setState(
// // //           () => _errorMessage = "فشل تحميل التقرير (${response.statusCode})",
// // //         );
// // //       }
// // //     } catch (e) {
// // //       print("Error fetching report: $e");
// // //       setState(() => _errorMessage = "تعذّر الاتصال بالخادم");
// // //     } finally {
// // //       setState(() => _isLoading = false);
// // //     }

// // //     await _fetchChecks();
// // //   }

// // //   // ============================================================
// // //   //  جلب الشيكات الواردة
// // //   // ============================================================
// // //   Future<void> _fetchChecks() async {
// // //     try {
// // //       SharedPreferences prefs = await SharedPreferences.getInstance();
// // //       String? token = prefs.getString("token");

// // //       final String checksUrl =
// // //           "${ApiEndpoints.getMonthlyChecks}?year=$_selectedYear";

// // //       final response = await http.get(
// // //         Uri.parse(checksUrl),
// // //         headers: {
// // //           "Authorization": "Bearer $token",
// // //           "Accept": "application/json",
// // //         },
// // //       );

// // //       print("============= CHECKS DATA =============");
// // //       print("URL: $checksUrl");
// // //       print("STATUS: ${response.statusCode}");
// // //       print("RESPONSE: ${response.body}");
// // //       print("=======================================");

// // //       if (response.statusCode == 200) {
// // //         var rawData = jsonDecode(response.body);
// // //         List<dynamic> breakdown = rawData['monthlyBreakdown'] ?? [];

// // //         double total = 0;

// // //         // السنوي والزكاة: نجمع كل الشهور
// // //         if (_reportMode == 1 || _reportMode == 2) {
// // //           for (var item in breakdown) {
// // //             total += (item['totalIncomingAmount'] ?? 0).toDouble();
// // //           }
// // //         } else {
// // //           // شهري: الشهر المحدد فقط
// // //           var monthData = breakdown.firstWhere(
// // //             (item) => item['month'] == _selectedMonth,
// // //             orElse: () => null,
// // //           );
// // //           total = (monthData?['totalIncomingAmount'] ?? 0).toDouble();
// // //         }

// // //         setState(() => _totalChecks = total);
// // //       }
// // //     } catch (e) {
// // //       print("Error fetching checks: $e");
// // //     }
// // //   }

// // //   String _fmt(double v) => v
// // //       .toStringAsFixed(0)
// // //       .replaceAllMapped(
// // //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
// // //         (m) => '${m[1]},',
// // //       );

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _fetchReport();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: const Color(0xFFF8FAFF),
// // //       appBar: AppBar(
// // //         backgroundColor: const Color(0xFF3D5EAB),
// // //         elevation: 0,
// // //         centerTitle: true,
// // //         title: const Text(
// // //           "التقارير والإحصائيات",
// // //           style: TextStyle(
// // //             fontFamily: 'Cairo',
// // //             fontWeight: FontWeight.bold,
// // //             color: Colors.white,
// // //           ),
// // //         ),
// // //         leading: IconButton(
// // //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
// // //           onPressed: () => Navigator.pop(context),
// // //         ),
// // //       ),
// // //       body: _errorMessage != null
// // //           ? _buildErrorState()
// // //           : _isLoading
// // //           ? const Center(
// // //               child: CircularProgressIndicator(color: Color(0xFF3D5EAB)),
// // //             )
// // //           : SingleChildScrollView(
// // //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.end,
// // //                 children: [
// // //                   _buildModernFilterSection(),
// // //                   const SizedBox(height: 16),

// // //                   // ── وضع الزكاة: يعرض بطاقة الزكاة فقط ──
// // //                   if (_reportMode == 2) ...[
// // //                     const SizedBox(height: 8),
// // //                     const Text(
// // //                       "الزكاة السنوية",
// // //                       style: TextStyle(
// // //                         fontSize: 18,
// // //                         fontWeight: FontWeight.bold,
// // //                         fontFamily: 'Cairo',
// // //                         color: Color(0xFF2D3243),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 12),
// // //                     _buildZakatCard(),
// // //                   ],

// // //                   // ── وضع الشهري أو السنوي: يعرض البطاقات الإحصائية ──
// // //                   if (_reportMode != 2) ...[
// // //                     _buildStatCard(
// // //                       title: _reportMode == 1
// // //                           ? "صافي أرباح السنة"
// // //                           : "صافي أرباح الشهر",
// // //                       value: "₪ ${_fmt(_netProfit)}",
// // //                       icon: Icons.trending_up_rounded,
// // //                       iconBg: const Color(0xFFE8F5E9),
// // //                       iconColor: const Color(0xFF2E7D32),
// // //                       valueColor: const Color(0xFF2E7D32),
// // //                     ),
// // //                     _buildStatCard(
// // //                       title: _reportMode == 1
// // //                           ? "إجمالي الشيكات الواردة للسنة"
// // //                           : "إجمالي الشيكات الواردة للشهر",
// // //                       value: "₪ ${_fmt(_totalChecks)}",
// // //                       icon: Icons.edit_document,
// // //                       iconBg: const Color(0xFFF0EDFF),
// // //                       iconColor: const Color(0xFF534AB7),
// // //                       valueColor: const Color(0xFF534AB7),
// // //                     ),
// // //                     _buildStatCard(
// // //                       title: "إجمالي رأس المال الكامل",
// // //                       value: "₪ ${_fmt(_totalIncome)}",
// // //                       icon: Icons.account_balance_wallet_rounded,
// // //                       iconBg: const Color(0xFFFDF3E0),
// // //                       iconColor: const Color(0xFF854F0B),
// // //                       valueColor: const Color(0xFF854F0B),
// // //                     ),
// // //                   ],

// // //                   const SizedBox(height: 20),
// // //                 ],
// // //               ),
// // //             ),
// // //     );
// // //   }

// // //   Widget _buildErrorState() {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           const Icon(
// // //             Icons.wifi_off_rounded,
// // //             size: 56,
// // //             color: Color(0xFFB0B8CC),
// // //           ),
// // //           const SizedBox(height: 16),
// // //           Text(
// // //             _errorMessage!,
// // //             style: const TextStyle(
// // //               fontFamily: 'Cairo',
// // //               fontSize: 15,
// // //               color: Color(0xFF888888),
// // //             ),
// // //           ),
// // //           const SizedBox(height: 20),
// // //           ElevatedButton.icon(
// // //             style: ElevatedButton.styleFrom(
// // //               backgroundColor: const Color(0xFF3D5EAB),
// // //               shape: RoundedRectangleBorder(
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// // //             ),
// // //             onPressed: _fetchReport,
// // //             icon: const Icon(Icons.refresh_rounded, color: Colors.white),
// // //             label: const Text(
// // //               "إعادة المحاولة",
// // //               style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildModernFilterSection() {
// // //     return Row(
// // //       children: [
// // //         // ── Dropdowns (السنة والشهر) ──
// // //         Expanded(
// // //           child: Row(
// // //             mainAxisAlignment: MainAxisAlignment.start,
// // //             children: [
// // //               _buildDropdownContainer(
// // //                 child: DropdownButtonHideUnderline(
// // //                   child: DropdownButton<int>(
// // //                     value: _selectedYear,
// // //                     icon: const Icon(
// // //                       Icons.arrow_drop_down,
// // //                       color: Color(0xFF3D5EAB),
// // //                     ),
// // //                     style: const TextStyle(
// // //                       fontFamily: 'Cairo',
// // //                       color: Color(0xFF2D3243),
// // //                       fontSize: 13,
// // //                     ),
// // //                     items: _years
// // //                         .map(
// // //                           (y) => DropdownMenuItem(
// // //                             value: y,
// // //                             child: Text(y.toString()),
// // //                           ),
// // //                         )
// // //                         .toList(),
// // //                     onChanged: (value) {
// // //                       if (value != null) {
// // //                         setState(() => _selectedYear = value);
// // //                         _fetchReport();
// // //                       }
// // //                     },
// // //                   ),
// // //                 ),
// // //               ),
// // //               // ── الشهر يظهر فقط في وضع الشهري ──
// // //               if (_reportMode == 0) ...[
// // //                 const SizedBox(width: 8),
// // //                 _buildDropdownContainer(
// // //                   child: DropdownButtonHideUnderline(
// // //                     child: DropdownButton<int>(
// // //                       value: _selectedMonth,
// // //                       icon: const Icon(
// // //                         Icons.arrow_drop_down,
// // //                         color: Color(0xFF3D5EAB),
// // //                       ),
// // //                       style: const TextStyle(
// // //                         fontFamily: 'Cairo',
// // //                         color: Color(0xFF2D3243),
// // //                         fontSize: 13,
// // //                       ),
// // //                       items: List.generate(
// // //                         _months.length,
// // //                         (i) => DropdownMenuItem(
// // //                           value: i + 1,
// // //                           child: Text(_months[i]),
// // //                         ),
// // //                       ),
// // //                       onChanged: (value) {
// // //                         if (value != null) {
// // //                           setState(() => _selectedMonth = value);
// // //                           _fetchReport();
// // //                         }
// // //                       },
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ],
// // //           ),
// // //         ),

// // //         // ── أزرار التبديل الثلاثة ──
// // //         Container(
// // //           height: 40,
// // //           padding: const EdgeInsets.all(4),
// // //           decoration: BoxDecoration(
// // //             color: const Color(0xFFEFEFF4),
// // //             borderRadius: BorderRadius.circular(12),
// // //           ),
// // //           child: Row(
// // //             children: [
// // //               _buildFilterToggleButton(
// // //                 title: "الزكاة",
// // //                 isSelected: _reportMode == 2,
// // //                 onTap: () {
// // //                   setState(() => _reportMode = 2);
// // //                   _fetchReport();
// // //                 },
// // //               ),
// // //               _buildFilterToggleButton(
// // //                 title: "سنوي",
// // //                 isSelected: _reportMode == 1,
// // //                 onTap: () {
// // //                   setState(() => _reportMode = 1);
// // //                   _fetchReport();
// // //                 },
// // //               ),
// // //               _buildFilterToggleButton(
// // //                 title: "شهري",
// // //                 isSelected: _reportMode == 0,
// // //                 onTap: () {
// // //                   setState(() => _reportMode = 0);
// // //                   _fetchReport();
// // //                 },
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _buildDropdownContainer({required Widget child}) {
// // //     return Container(
// // //       height: 40,
// // //       padding: const EdgeInsets.symmetric(horizontal: 10),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.grey.withOpacity(0.15)),
// // //         boxShadow: [
// // //           BoxShadow(
// // //             color: Colors.black.withOpacity(0.02),
// // //             blurRadius: 4,
// // //             offset: const Offset(0, 2),
// // //           ),
// // //         ],
// // //       ),
// // //       child: Row(
// // //         mainAxisSize: MainAxisSize.min,
// // //         children: [
// // //           const Icon(
// // //             Icons.calendar_month_rounded,
// // //             size: 16,
// // //             color: Color(0xFF3D5EAB),
// // //           ),
// // //           const SizedBox(width: 6),
// // //           child,
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildFilterToggleButton({
// // //     required String title,
// // //     required bool isSelected,
// // //     required VoidCallback onTap,
// // //   }) {
// // //     return GestureDetector(
// // //       onTap: onTap,
// // //       child: AnimatedContainer(
// // //         duration: const Duration(milliseconds: 200),
// // //         padding: const EdgeInsets.symmetric(horizontal: 12),
// // //         alignment: Alignment.center,
// // //         decoration: BoxDecoration(
// // //           color: isSelected ? Colors.white : Colors.transparent,
// // //           borderRadius: BorderRadius.circular(8),
// // //           boxShadow: isSelected
// // //               ? [
// // //                   BoxShadow(
// // //                     color: Colors.black.withOpacity(0.05),
// // //                     blurRadius: 4,
// // //                     offset: const Offset(0, 2),
// // //                   ),
// // //                 ]
// // //               : [],
// // //         ),
// // //         child: Text(
// // //           title,
// // //           style: TextStyle(
// // //             fontFamily: 'Cairo',
// // //             fontSize: 13,
// // //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// // //             color: isSelected ? const Color(0xFF3D5EAB) : Colors.grey[600],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildStatCard({
// // //     required String title,
// // //     required String value,
// // //     required IconData icon,
// // //     required Color iconBg,
// // //     required Color iconColor,
// // //     required Color valueColor,
// // //   }) {
// // //     return Container(
// // //       margin: const EdgeInsets.only(bottom: 12),
// // //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: Colors.grey.withOpacity(0.1)),
// // //       ),
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //         children: [
// // //           Container(
// // //             width: 44,
// // //             height: 44,
// // //             decoration: BoxDecoration(
// // //               color: iconBg,
// // //               borderRadius: BorderRadius.circular(12),
// // //             ),
// // //             child: Icon(icon, color: iconColor, size: 22),
// // //           ),
// // //           Column(
// // //             crossAxisAlignment: CrossAxisAlignment.end,
// // //             children: [
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(
// // //                   fontFamily: 'Cairo',
// // //                   fontSize: 13,
// // //                   color: Colors.grey[600],
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 4),
// // //               Text(
// // //                 value,
// // //                 style: TextStyle(
// // //                   fontFamily: 'Cairo',
// // //                   fontSize: 22,
// // //                   fontWeight: FontWeight.w800,
// // //                   color: valueColor,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildZakatCard() {
// // //     const double nisab = 5000;
// // //     final double zakatAmount = _totalIncome >= nisab ? _totalIncome * 0.025 : 0;
// // //     final bool nisabReached = _totalIncome >= nisab;

// // //     return Container(
// // //       padding: const EdgeInsets.all(20),
// // //       decoration: BoxDecoration(
// // //         color: const Color(0xFFF0FFF6),
// // //         borderRadius: BorderRadius.circular(16),
// // //         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.end,
// // //         children: [
// // //           Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //             children: [
// // //               Container(
// // //                 padding: const EdgeInsets.symmetric(
// // //                   horizontal: 10,
// // //                   vertical: 4,
// // //                 ),
// // //                 decoration: BoxDecoration(
// // //                   color: nisabReached
// // //                       ? const Color(0xFFE8F5E9)
// // //                       : const Color(0xFFFFF3E0),
// // //                   borderRadius: BorderRadius.circular(20),
// // //                 ),
// // //                 child: Text(
// // //                   nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
// // //                   style: TextStyle(
// // //                     fontFamily: 'Cairo',
// // //                     fontSize: 12,
// // //                     color: nisabReached
// // //                         ? const Color(0xFF2E7D32)
// // //                         : const Color(0xFFE65100),
// // //                   ),
// // //                 ),
// // //               ),
// // //               Row(
// // //                 children: [
// // //                   const Text(
// // //                     "الزكاة السنوية",
// // //                     style: TextStyle(
// // //                       fontFamily: 'Cairo',
// // //                       fontSize: 15,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Color(0xFF2D3243),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 8),
// // //                   Container(
// // //                     width: 36,
// // //                     height: 36,
// // //                     decoration: BoxDecoration(
// // //                       color: const Color(0xFFE8F5E9),
// // //                       borderRadius: BorderRadius.circular(10),
// // //                     ),
// // //                     child: const Icon(
// // //                       Icons.mosque_rounded,
// // //                       color: Color(0xFF2E7D32),
// // //                       size: 20,
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ],
// // //           ),
// // //           const SizedBox(height: 16),
// // //           const Divider(color: Color(0xFFDCEDC8), height: 1),
// // //           const SizedBox(height: 16),
// // //           _buildZakatRow("إجمالي المبالغ", "₪ ${_fmt(_totalIncome)}"),
// // //           const SizedBox(height: 10),
// // //           _buildZakatRow("نسبة الزكاة", "2.5%"),
// // //           const SizedBox(height: 10),
// // //           _buildZakatRow("النصاب المطلوب", "₪ ${_fmt(nisab)}"),
// // //           const SizedBox(height: 16),
// // //           Container(
// // //             width: double.infinity,
// // //             padding: const EdgeInsets.symmetric(vertical: 14),
// // //             decoration: BoxDecoration(
// // //               color: const Color(0xFF2E7D32),
// // //               borderRadius: BorderRadius.circular(12),
// // //             ),
// // //             child: Column(
// // //               children: [
// // //                 const Text(
// // //                   "مبلغ الزكاة المستحقة",
// // //                   style: TextStyle(
// // //                     fontFamily: 'Cairo',
// // //                     fontSize: 12,
// // //                     color: Colors.white70,
// // //                   ),
// // //                 ),
// // //                 const SizedBox(height: 4),
// // //                 Text(
// // //                   "₪ ${_fmt(zakatAmount)}",
// // //                   style: const TextStyle(
// // //                     fontFamily: 'Cairo',
// // //                     fontSize: 26,
// // //                     fontWeight: FontWeight.w800,
// // //                     color: Colors.white,
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //           const SizedBox(height: 12),
// // //           const Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //             children: [
// // //               Text(
// // //                 "لم يتم الدفع بعد",
// // //                 style: TextStyle(
// // //                   fontFamily: 'Cairo',
// // //                   fontSize: 12,
// // //                   color: Color(0xFF888888),
// // //                 ),
// // //               ),
// // //               Text(
// // //                 "آخر دفعة: لم تُحدد",
// // //                 style: TextStyle(
// // //                   fontFamily: 'Cairo',
// // //                   fontSize: 12,
// // //                   color: Color(0xFF888888),
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildZakatRow(String label, String value) {
// // //     return Row(
// // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //       children: [
// // //         Text(
// // //           value,
// // //           style: const TextStyle(
// // //             fontFamily: 'Cairo',
// // //             fontSize: 14,
// // //             fontWeight: FontWeight.w700,
// // //             color: Color(0xFF2E7D32),
// // //           ),
// // //         ),
// // //         Text(
// // //           label,
// // //           style: TextStyle(
// // //             fontFamily: 'Cairo',
// // //             fontSize: 13,
// // //             color: Colors.grey[600],
// // //           ),
// // //         ),
// // //       ],
// // //     );
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:tradeflow_app/pages/link.dart';

// // class ReportsScreen extends StatefulWidget {
// //   const ReportsScreen({super.key});

// //   @override
// //   State<ReportsScreen> createState() => _ReportsScreenState();
// // }

// // class _ReportsScreenState extends State<ReportsScreen> {
// //   // 0 = شهري ، 1 = سنوي ، 2 = زكاة
// //   int _reportMode = 0;

// //   int _selectedYear = 2026;
// //   int _selectedMonth = 5;

// //   final List<int> _years = [2024, 2025, 2026, 2027];
// //   final List<String> _months = [
// //     "يناير",
// //     "فبراير",
// //     "مارس",
// //     "أبريل",
// //     "مايو",
// //     "يونيو",
// //     "يوليو",
// //     "أغسطس",
// //     "سبتمبر",
// //     "أكتوبر",
// //     "نوفمبر",
// //     "ديسمبر",
// //   ];

// //   double _netProfit = 0;
// //   double _totalIncome = 0;
// //   double _totalChecks = 0;
// //   bool _isLoading = false;
// //   String? _errorMessage;

// //   // ============================================================
// //   //  جلب التقرير
// //   // ============================================================
// //   Future<void> _fetchReport() async {
// //     print("======= FETCH REPORT CALLED =======");
// //     setState(() {
// //       _isLoading = true;
// //       _errorMessage = null;
// //     });

// //     try {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       String? token = prefs.getString("token");

// //       // الزكاة والسنوي: نفس الـ endpoint
// //       final String targetUrl = _reportMode == 0
// //           ? "${ApiEndpoints.getMonthlyReport}?year=$_selectedYear&month=$_selectedMonth"
// //           : "${ApiEndpoints.getYearlyReport}?year=$_selectedYear";

// //       final response = await http.get(
// //         Uri.parse(targetUrl),
// //         headers: {
// //           "Authorization": "Bearer $token",
// //           "Accept": "application/json",
// //         },
// //       );

// //       print("============= REPORT DATA =============");
// //       print("URL: $targetUrl");
// //       print("STATUS: ${response.statusCode}");
// //       print("RESPONSE: ${response.body}");
// //       print("=======================================");

// //       if (response.statusCode == 200) {
// //         var rawData = jsonDecode(response.body);
// //         setState(() {
// //           _netProfit = (rawData['netProfit'] ?? rawData['net_profit'] ?? 0)
// //               .toDouble();
// //           _totalIncome =
// //               (rawData['totalIncome'] ?? rawData['total_income'] ?? 0)
// //                   .toDouble();
// //         });
// //       } else {
// //         setState(
// //           () => _errorMessage = "فشل تحميل التقرير (${response.statusCode})",
// //         );
// //       }
// //     } catch (e) {
// //       print("Error fetching report: $e");
// //       setState(() => _errorMessage = "تعذّر الاتصال بالخادم");
// //     } finally {
// //       setState(() => _isLoading = false);
// //     }

// //     await _fetchChecks();
// //   }

// //   // ============================================================
// //   //  جلب الشيكات
// //   // ============================================================
// //   Future<void> _fetchChecks() async {
// //     try {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       String? token = prefs.getString("token");

// //       final String checksUrl =
// //           "${ApiEndpoints.getMonthlyChecks}?year=$_selectedYear";

// //       final response = await http.get(
// //         Uri.parse(checksUrl),
// //         headers: {
// //           "Authorization": "Bearer $token",
// //           "Accept": "application/json",
// //         },
// //       );

// //       print("============= CHECKS DATA =============");
// //       print("URL: $checksUrl");
// //       print("STATUS: ${response.statusCode}");
// //       print("RESPONSE: ${response.body}");
// //       print("=======================================");

// //       if (response.statusCode == 200) {
// //         var rawData = jsonDecode(response.body);
// //         List<dynamic> breakdown = rawData['monthlyBreakdown'] ?? [];

// //         double total = 0;

// //         if (_reportMode == 0) {
// //           // شهري: الشهر المحدد فقط
// //           var monthData = breakdown.firstWhere(
// //             (item) => item['month'] == _selectedMonth,
// //             orElse: () => null,
// //           );
// //           total = (monthData?['totalIncomingAmount'] ?? 0).toDouble();
// //         } else {
// //           // سنوي أو زكاة: نجمع كل الشهور
// //           for (var item in breakdown) {
// //             total += (item['totalIncomingAmount'] ?? 0).toDouble();
// //           }
// //         }

// //         setState(() => _totalChecks = total);
// //       }
// //     } catch (e) {
// //       print("Error fetching checks: $e");
// //     }
// //   }

// //   String _fmt(double v) => v
// //       .toStringAsFixed(0)
// //       .replaceAllMapped(
// //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
// //         (m) => '${m[1]},',
// //       );

// //   @override
// //   void initState() {
// //     super.initState();
// //     _fetchReport();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF8FAFF),
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xFF3D5EAB),
// //         elevation: 0,
// //         centerTitle: true,
// //         title: const Text(
// //           "التقارير والإحصائيات",
// //           style: TextStyle(
// //             fontFamily: 'Cairo',
// //             fontWeight: FontWeight.bold,
// //             color: Colors.white,
// //           ),
// //         ),
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
// //           onPressed: () => Navigator.pop(context),
// //         ),
// //       ),
// //       body: _errorMessage != null
// //           ? _buildErrorState()
// //           : _isLoading
// //           ? const Center(
// //               child: CircularProgressIndicator(color: Color(0xFF3D5EAB)),
// //             )
// //           : SingleChildScrollView(
// //               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: [
// //                   _buildModernFilterSection(),
// //                   const SizedBox(height: 16),

// //                   // ── وضع الزكاة ──
// //                   if (_reportMode == 2) ...[_buildZakatCard()],

// //                   // ── شهري أو سنوي ──
// //                   if (_reportMode != 2) ...[
// //                     _buildStatCard(
// //                       title: _reportMode == 1
// //                           ? "صافي أرباح السنة"
// //                           : "صافي أرباح الشهر",
// //                       value: "₪ ${_fmt(_netProfit)}",
// //                       icon: Icons.trending_up_rounded,
// //                       iconBg: const Color(0xFFE8F5E9),
// //                       iconColor: const Color(0xFF2E7D32),
// //                       valueColor: const Color(0xFF2E7D32),
// //                     ),
// //                     _buildStatCard(
// //                       title: _reportMode == 1
// //                           ? "إجمالي الشيكات الواردة للسنة"
// //                           : "إجمالي الشيكات الواردة للشهر",
// //                       value: "₪ ${_fmt(_totalChecks)}",
// //                       icon: Icons.edit_document,
// //                       iconBg: const Color(0xFFF0EDFF),
// //                       iconColor: const Color(0xFF534AB7),
// //                       valueColor: const Color(0xFF534AB7),
// //                     ),
// //                     _buildStatCard(
// //                       title: "إجمالي رأس المال الكامل",
// //                       value: "₪ ${_fmt(_totalIncome)}",
// //                       icon: Icons.account_balance_wallet_rounded,
// //                       iconBg: const Color(0xFFFDF3E0),
// //                       iconColor: const Color(0xFF854F0B),
// //                       valueColor: const Color(0xFF854F0B),
// //                     ),
// //                   ],

// //                   const SizedBox(height: 20),
// //                 ],
// //               ),
// //             ),
// //     );
// //   }

// //   Widget _buildErrorState() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(
// //             Icons.wifi_off_rounded,
// //             size: 56,
// //             color: Color(0xFFB0B8CC),
// //           ),
// //           const SizedBox(height: 16),
// //           Text(
// //             _errorMessage!,
// //             style: const TextStyle(
// //               fontFamily: 'Cairo',
// //               fontSize: 15,
// //               color: Color(0xFF888888),
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton.icon(
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: const Color(0xFF3D5EAB),
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //             ),
// //             onPressed: _fetchReport,
// //             icon: const Icon(Icons.refresh_rounded, color: Colors.white),
// //             label: const Text(
// //               "إعادة المحاولة",
// //               style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildModernFilterSection() {
// //     return Row(
// //       children: [
// //         Expanded(
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.start,
// //             children: [
// //               // ── dropdown السنة (يظهر دايماً) ──
// //               _buildDropdownContainer(
// //                 child: DropdownButtonHideUnderline(
// //                   child: DropdownButton<int>(
// //                     value: _selectedYear,
// //                     icon: const Icon(
// //                       Icons.arrow_drop_down,
// //                       color: Color(0xFF3D5EAB),
// //                     ),
// //                     style: const TextStyle(
// //                       fontFamily: 'Cairo',
// //                       color: Color(0xFF2D3243),
// //                       fontSize: 13,
// //                     ),
// //                     items: _years
// //                         .map(
// //                           (y) => DropdownMenuItem(
// //                             value: y,
// //                             child: Text(y.toString()),
// //                           ),
// //                         )
// //                         .toList(),
// //                     onChanged: (value) {
// //                       if (value != null) {
// //                         setState(() => _selectedYear = value);
// //                         _fetchReport();
// //                       }
// //                     },
// //                   ),
// //                 ),
// //               ),
// //               // ── dropdown الشهر (شهري فقط) ──
// //               if (_reportMode == 0) ...[
// //                 const SizedBox(width: 8),
// //                 _buildDropdownContainer(
// //                   child: DropdownButtonHideUnderline(
// //                     child: DropdownButton<int>(
// //                       value: _selectedMonth,
// //                       icon: const Icon(
// //                         Icons.arrow_drop_down,
// //                         color: Color(0xFF3D5EAB),
// //                       ),
// //                       style: const TextStyle(
// //                         fontFamily: 'Cairo',
// //                         color: Color(0xFF2D3243),
// //                         fontSize: 13,
// //                       ),
// //                       items: List.generate(
// //                         _months.length,
// //                         (i) => DropdownMenuItem(
// //                           value: i + 1,
// //                           child: Text(_months[i]),
// //                         ),
// //                       ),
// //                       onChanged: (value) {
// //                         if (value != null) {
// //                           setState(() => _selectedMonth = value);
// //                           _fetchReport();
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ],
// //           ),
// //         ),

// //         // ── الأزرار الثلاثة ──
// //         Container(
// //           height: 40,
// //           padding: const EdgeInsets.all(4),
// //           decoration: BoxDecoration(
// //             color: const Color(0xFFEFEFF4),
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //           child: Row(
// //             children: [
// //               _buildFilterToggleButton(
// //                 title: "الزكاة",
// //                 isSelected: _reportMode == 2,
// //                 onTap: () {
// //                   setState(() => _reportMode = 2);
// //                   _fetchReport();
// //                 },
// //               ),
// //               _buildFilterToggleButton(
// //                 title: "سنوي",
// //                 isSelected: _reportMode == 1,
// //                 onTap: () {
// //                   setState(() => _reportMode = 1);
// //                   _fetchReport();
// //                 },
// //               ),
// //               _buildFilterToggleButton(
// //                 title: "شهري",
// //                 isSelected: _reportMode == 0,
// //                 onTap: () {
// //                   setState(() => _reportMode = 0);
// //                   _fetchReport();
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildDropdownContainer({required Widget child}) {
// //     return Container(
// //       height: 40,
// //       padding: const EdgeInsets.symmetric(horizontal: 10),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey.withOpacity(0.15)),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.02),
// //             blurRadius: 4,
// //             offset: const Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           const Icon(
// //             Icons.calendar_month_rounded,
// //             size: 16,
// //             color: Color(0xFF3D5EAB),
// //           ),
// //           const SizedBox(width: 6),
// //           child,
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildFilterToggleButton({
// //     required String title,
// //     required bool isSelected,
// //     required VoidCallback onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 200),
// //         padding: const EdgeInsets.symmetric(horizontal: 12),
// //         alignment: Alignment.center,
// //         decoration: BoxDecoration(
// //           color: isSelected ? Colors.white : Colors.transparent,
// //           borderRadius: BorderRadius.circular(8),
// //           boxShadow: isSelected
// //               ? [
// //                   BoxShadow(
// //                     color: Colors.black.withOpacity(0.05),
// //                     blurRadius: 4,
// //                     offset: const Offset(0, 2),
// //                   ),
// //                 ]
// //               : [],
// //         ),
// //         child: Text(
// //           title,
// //           style: TextStyle(
// //             fontFamily: 'Cairo',
// //             fontSize: 13,
// //             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// //             color: isSelected ? const Color(0xFF3D5EAB) : Colors.grey[600],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildStatCard({
// //     required String title,
// //     required String value,
// //     required IconData icon,
// //     required Color iconBg,
// //     required Color iconColor,
// //     required Color valueColor,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: Colors.grey.withOpacity(0.1)),
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Container(
// //             width: 44,
// //             height: 44,
// //             decoration: BoxDecoration(
// //               color: iconBg,
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Icon(icon, color: iconColor, size: 22),
// //           ),
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.end,
// //             children: [
// //               Text(
// //                 title,
// //                 style: TextStyle(
// //                   fontFamily: 'Cairo',
// //                   fontSize: 13,
// //                   color: Colors.grey[600],
// //                 ),
// //               ),
// //               const SizedBox(height: 4),
// //               Text(
// //                 value,
// //                 style: TextStyle(
// //                   fontFamily: 'Cairo',
// //                   fontSize: 22,
// //                   fontWeight: FontWeight.w800,
// //                   color: valueColor,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildZakatCard() {
// //     const double nisab = 5000;
// //     final double zakatAmount = _totalIncome >= nisab ? _totalIncome * 0.025 : 0;
// //     final bool nisabReached = _totalIncome >= nisab;

// //     return Container(
// //       padding: const EdgeInsets.all(20),
// //       decoration: BoxDecoration(
// //         color: const Color(0xFFF0FFF6),
// //         borderRadius: BorderRadius.circular(16),
// //         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.end,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Container(
// //                 padding: const EdgeInsets.symmetric(
// //                   horizontal: 10,
// //                   vertical: 4,
// //                 ),
// //                 decoration: BoxDecoration(
// //                   color: nisabReached
// //                       ? const Color(0xFFE8F5E9)
// //                       : const Color(0xFFFFF3E0),
// //                   borderRadius: BorderRadius.circular(20),
// //                 ),
// //                 child: Text(
// //                   nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
// //                   style: TextStyle(
// //                     fontFamily: 'Cairo',
// //                     fontSize: 12,
// //                     color: nisabReached
// //                         ? const Color(0xFF2E7D32)
// //                         : const Color(0xFFE65100),
// //                   ),
// //                 ),
// //               ),
// //               Row(
// //                 children: [
// //                   const Text(
// //                     "الزكاة السنوية",
// //                     style: TextStyle(
// //                       fontFamily: 'Cairo',
// //                       fontSize: 15,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF2D3243),
// //                     ),
// //                   ),
// //                   const SizedBox(width: 8),
// //                   Container(
// //                     width: 36,
// //                     height: 36,
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFE8F5E9),
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     child: const Icon(
// //                       Icons.mosque_rounded,
// //                       color: Color(0xFF2E7D32),
// //                       size: 20,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 16),
// //           const Divider(color: Color(0xFFDCEDC8), height: 1),
// //           const SizedBox(height: 16),
// //           _buildZakatRow("إجمالي المبالغ", "₪ ${_fmt(_totalIncome)}"),
// //           const SizedBox(height: 10),
// //           _buildZakatRow("نسبة الزكاة", "2.5%"),
// //           const SizedBox(height: 10),
// //           _buildZakatRow("النصاب المطلوب", "₪ ${_fmt(nisab)}"),
// //           const SizedBox(height: 16),
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.symmetric(vertical: 14),
// //             decoration: BoxDecoration(
// //               color: const Color(0xFF2E7D32),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Column(
// //               children: [
// //                 const Text(
// //                   "مبلغ الزكاة المستحقة",
// //                   style: TextStyle(
// //                     fontFamily: 'Cairo',
// //                     fontSize: 12,
// //                     color: Colors.white70,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Text(
// //                   "₪ ${_fmt(zakatAmount)}",
// //                   style: const TextStyle(
// //                     fontFamily: 'Cairo',
// //                     fontSize: 26,
// //                     fontWeight: FontWeight.w800,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           const Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 "لم يتم الدفع بعد",
// //                 style: TextStyle(
// //                   fontFamily: 'Cairo',
// //                   fontSize: 12,
// //                   color: Color(0xFF888888),
// //                 ),
// //               ),
// //               Text(
// //                 "آخر دفعة: لم تُحدد",
// //                 style: TextStyle(
// //                   fontFamily: 'Cairo',
// //                   fontSize: 12,
// //                   color: Color(0xFF888888),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildZakatRow(String label, String value) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           value,
// //           style: const TextStyle(
// //             fontFamily: 'Cairo',
// //             fontSize: 14,
// //             fontWeight: FontWeight.w700,
// //             color: Color(0xFF2E7D32),
// //           ),
// //         ),
// //         Text(
// //           label,
// //           style: TextStyle(
// //             fontFamily: 'Cairo',
// //             fontSize: 13,
// //             color: Colors.grey[600],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/link.dart';

// class ReportsScreen extends StatefulWidget {
//   const ReportsScreen({super.key});

//   @override
//   State<ReportsScreen> createState() => _ReportsScreenState();
// }

// class _ReportsScreenState extends State<ReportsScreen> {
//   // 0 = شهري ، 1 = سنوي ، 2 = زكاة
//   int _reportMode = 0;

//   int _selectedYear = 2026;
//   int _selectedMonth = 5;

//   final List<int> _years = [2024, 2025, 2026, 2027];
//   final List<String> _months = [
//     "يناير",
//     "فبراير",
//     "مارس",
//     "أبريل",
//     "مايو",
//     "يونيو",
//     "يوليو",
//     "أغسطس",
//     "سبتمبر",
//     "أكتوبر",
//     "نوفمبر",
//     "ديسمبر",
//   ];

//   // ── بيانات التقرير العادي ──
//   double _netProfit = 0;
//   double _totalIncome = 0;
//   double _totalChecks = 0;

//   // ── بيانات الزكاة ──
//   double _zakatTotalIncome = 0;
//   double _zakatTotalExpense = 0;
//   double _zakatNetCash = 0;
//   double _zakatInventoryValue = 0;
//   double _zakatTotalReceivables = 0;
//   double _zakatTotalIncomingChecks = 0;
//   double _zakatBase = 0;
//   double _zakatRate = 0;
//   double _zakatDue = 0;

//   bool _isLoading = false;
//   String? _errorMessage;

//   // ============================================================
//   //  جلب التقرير
//   // ============================================================
//   Future<void> _fetchReport() async {
//     print("======= FETCH REPORT CALLED =======");
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       if (_reportMode == 2) {
//         await _fetchZakat();
//       } else {
//         await _fetchStatReport();
//         await _fetchChecks();
//       }
//     } catch (e) {
//       print("Error: $e");
//       setState(() => _errorMessage = "تعذّر الاتصال بالخادم");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // ── تقرير شهري / سنوي ──
//   Future<void> _fetchStatReport() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");

//     final String targetUrl = _reportMode == 0
//         ? "${ApiEndpoints.getMonthlyReport}?year=$_selectedYear&month=$_selectedMonth"
//         : "${ApiEndpoints.getYearlyReport}?year=$_selectedYear";

//     final response = await http.get(
//       Uri.parse(targetUrl),
//       headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
//     );

//     print("============= REPORT DATA =============");
//     print("URL: $targetUrl");
//     print("STATUS: ${response.statusCode}");
//     print("RESPONSE: ${response.body}");
//     print("=======================================");

//     if (response.statusCode == 200) {
//       var rawData = jsonDecode(response.body);
//       setState(() {
//         _netProfit = (rawData['netProfit'] ?? rawData['net_profit'] ?? 0)
//             .toDouble();
//         _totalIncome = (rawData['totalIncome'] ?? rawData['total_income'] ?? 0)
//             .toDouble();
//       });
//     } else {
//       setState(
//         () => _errorMessage = "فشل تحميل التقرير (${response.statusCode})",
//       );
//     }
//   }

//   // ── تقرير الزكاة ──
//   Future<void> _fetchZakat() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");

//     final String zakatUrl =
//         "${ApiEndpoints.getZakatReport}?year=$_selectedYear";

//     final response = await http.get(
//       Uri.parse(zakatUrl),
//       headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
//     );

//     print("============= ZAKAT DATA =============");
//     print("URL: $zakatUrl");
//     print("STATUS: ${response.statusCode}");
//     print("RESPONSE: ${response.body}");
//     print("======================================");

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       setState(() {
//         _zakatTotalIncome = (data['totalIncome'] ?? 0).toDouble();
//         _zakatTotalExpense = (data['totalExpense'] ?? 0).toDouble();
//         _zakatNetCash = (data['netCash'] ?? 0).toDouble();
//         _zakatInventoryValue = (data['inventoryValue'] ?? 0).toDouble();
//         _zakatTotalReceivables = (data['totalReceivables'] ?? 0).toDouble();
//         _zakatTotalIncomingChecks = (data['totalIncomingChecks'] ?? 0)
//             .toDouble();
//         _zakatBase = (data['zakatBase'] ?? 0).toDouble();
//         _zakatRate = (data['zakatRate'] ?? 0.025).toDouble();
//         _zakatDue = (data['zakatDue'] ?? 0).toDouble();
//       });
//     } else {
//       setState(
//         () =>
//             _errorMessage = "فشل تحميل بيانات الزكاة (${response.statusCode})",
//       );
//     }
//   }

//   // ── الشيكات ──
//   Future<void> _fetchChecks() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString("token");

//     final String checksUrl =
//         "${ApiEndpoints.getMonthlyChecks}?year=$_selectedYear";

//     final response = await http.get(
//       Uri.parse(checksUrl),
//       headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
//     );

//     print("============= CHECKS DATA =============");
//     print("URL: $checksUrl");
//     print("STATUS: ${response.statusCode}");
//     print("RESPONSE: ${response.body}");
//     print("=======================================");

//     if (response.statusCode == 200) {
//       var rawData = jsonDecode(response.body);
//       List<dynamic> breakdown = rawData['monthlyBreakdown'] ?? [];
//       double total = 0;

//       if (_reportMode == 0) {
//         var monthData = breakdown.firstWhere(
//           (item) => item['month'] == _selectedMonth,
//           orElse: () => null,
//         );
//         total = (monthData?['totalIncomingAmount'] ?? 0).toDouble();
//       } else {
//         for (var item in breakdown) {
//           total += (item['totalIncomingAmount'] ?? 0).toDouble();
//         }
//       }
//       setState(() => _totalChecks = total);
//     }
//   }

//   String _fmt(double v) => v
//       .toStringAsFixed(0)
//       .replaceAllMapped(
//         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//         (m) => '${m[1]},',
//       );

//   @override
//   void initState() {
//     super.initState();
//     _fetchReport();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFF),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF3D5EAB),
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "التقارير والإحصائيات",
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: _errorMessage != null
//           ? _buildErrorState()
//           : _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(color: Color(0xFF3D5EAB)),
//             )
//           : SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   _buildModernFilterSection(),
//                   const SizedBox(height: 16),

//                   if (_reportMode == 2) _buildZakatCard(),

//                   if (_reportMode != 2) ...[
//                     _buildStatCard(
//                       title: _reportMode == 1
//                           ? "صافي أرباح السنة"
//                           : "صافي أرباح الشهر",
//                       value: "₪ ${_fmt(_netProfit)}",
//                       icon: Icons.trending_up_rounded,
//                       iconBg: const Color(0xFFE8F5E9),
//                       iconColor: const Color(0xFF2E7D32),
//                       valueColor: const Color(0xFF2E7D32),
//                     ),
//                     _buildStatCard(
//                       title: _reportMode == 1
//                           ? "إجمالي الشيكات الواردة للسنة"
//                           : "إجمالي الشيكات الواردة للشهر",
//                       value: "₪ ${_fmt(_totalChecks)}",
//                       icon: Icons.edit_document,
//                       iconBg: const Color(0xFFF0EDFF),
//                       iconColor: const Color(0xFF534AB7),
//                       valueColor: const Color(0xFF534AB7),
//                     ),
//                     _buildStatCard(
//                       title: "إجمالي رأس المال الكامل",
//                       value: "₪ ${_fmt(_totalIncome)}",
//                       icon: Icons.account_balance_wallet_rounded,
//                       iconBg: const Color(0xFFFDF3E0),
//                       iconColor: const Color(0xFF854F0B),
//                       valueColor: const Color(0xFF854F0B),
//                     ),
//                   ],

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.wifi_off_rounded,
//             size: 56,
//             color: Color(0xFFB0B8CC),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             _errorMessage!,
//             style: const TextStyle(
//               fontFamily: 'Cairo',
//               fontSize: 15,
//               color: Color(0xFF888888),
//             ),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF3D5EAB),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             ),
//             onPressed: _fetchReport,
//             icon: const Icon(Icons.refresh_rounded, color: Colors.white),
//             label: const Text(
//               "إعادة المحاولة",
//               style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildModernFilterSection() {
//     return Row(
//       children: [
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               _buildDropdownContainer(
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<int>(
//                     value: _selectedYear,
//                     icon: const Icon(
//                       Icons.arrow_drop_down,
//                       color: Color(0xFF3D5EAB),
//                     ),
//                     style: const TextStyle(
//                       fontFamily: 'Cairo',
//                       color: Color(0xFF2D3243),
//                       fontSize: 13,
//                     ),
//                     items: _years
//                         .map(
//                           (y) => DropdownMenuItem(
//                             value: y,
//                             child: Text(y.toString()),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setState(() => _selectedYear = value);
//                         _fetchReport();
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               if (_reportMode == 0) ...[
//                 const SizedBox(width: 8),
//                 _buildDropdownContainer(
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<int>(
//                       value: _selectedMonth,
//                       icon: const Icon(
//                         Icons.arrow_drop_down,
//                         color: Color(0xFF3D5EAB),
//                       ),
//                       style: const TextStyle(
//                         fontFamily: 'Cairo',
//                         color: Color(0xFF2D3243),
//                         fontSize: 13,
//                       ),
//                       items: List.generate(
//                         _months.length,
//                         (i) => DropdownMenuItem(
//                           value: i + 1,
//                           child: Text(_months[i]),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() => _selectedMonth = value);
//                           _fetchReport();
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//         Container(
//           height: 40,
//           padding: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: const Color(0xFFEFEFF4),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Row(
//             children: [
//               _buildFilterToggleButton(
//                 title: "الزكاة",
//                 isSelected: _reportMode == 2,
//                 onTap: () {
//                   setState(() => _reportMode = 2);
//                   _fetchReport();
//                 },
//               ),
//               _buildFilterToggleButton(
//                 title: "سنوي",
//                 isSelected: _reportMode == 1,
//                 onTap: () {
//                   setState(() => _reportMode = 1);
//                   _fetchReport();
//                 },
//               ),
//               _buildFilterToggleButton(
//                 title: "شهري",
//                 isSelected: _reportMode == 0,
//                 onTap: () {
//                   setState(() => _reportMode = 0);
//                   _fetchReport();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdownContainer({required Widget child}) {
//     return Container(
//       height: 40,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.withOpacity(0.15)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.02),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Icon(
//             Icons.calendar_month_rounded,
//             size: 16,
//             color: Color(0xFF3D5EAB),
//           ),
//           const SizedBox(width: 6),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterToggleButton({
//     required String title,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: isSelected
//               ? [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ]
//               : [],
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontSize: 13,
//             fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             color: isSelected ? const Color(0xFF3D5EAB) : Colors.grey[600],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color iconBg,
//     required Color iconColor,
//     required Color valueColor,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey.withOpacity(0.1)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             width: 44,
//             height: 44,
//             decoration: BoxDecoration(
//               color: iconBg,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: iconColor, size: 22),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 13,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                   color: valueColor,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   //  بطاقة الزكاة الكاملة
//   // ============================================================
//   Widget _buildZakatCard() {
//     final bool nisabReached = _zakatBase > 0;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF0FFF6),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           // ── Header ──
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 4,
//                 ),
//                 decoration: BoxDecoration(
//                   color: nisabReached
//                       ? const Color(0xFFE8F5E9)
//                       : const Color(0xFFFFF3E0),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
//                   style: TextStyle(
//                     fontFamily: 'Cairo',
//                     fontSize: 12,
//                     color: nisabReached
//                         ? const Color(0xFF2E7D32)
//                         : const Color(0xFFE65100),
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   const Text(
//                     "الزكاة السنوية",
//                     style: TextStyle(
//                       fontFamily: 'Cairo',
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3243),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     width: 36,
//                     height: 36,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F5E9),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Icon(
//                       Icons.mosque_rounded,
//                       color: Color(0xFF2E7D32),
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),
//           const Divider(color: Color(0xFFDCEDC8), height: 1),
//           const SizedBox(height: 16),

//           // ── تفاصيل الزكاة من الـ API ──
//           _buildZakatRow("إجمالي الإيرادات", "₪ ${_fmt(_zakatTotalIncome)}"),
//           const SizedBox(height: 8),
//           _buildZakatRow("إجمالي المصاريف", "₪ ${_fmt(_zakatTotalExpense)}"),
//           const SizedBox(height: 8),
//           _buildZakatRow("صافي النقد", "₪ ${_fmt(_zakatNetCash)}"),
//           const SizedBox(height: 8),
//           _buildZakatRow("قيمة المخزون", "₪ ${_fmt(_zakatInventoryValue)}"),
//           const SizedBox(height: 8),
//           _buildZakatRow(
//             "إجمالي الذمم المدينة",
//             "₪ ${_fmt(_zakatTotalReceivables)}",
//           ),
//           const SizedBox(height: 8),
//           _buildZakatRow(
//             "إجمالي الشيكات الواردة",
//             "₪ ${_fmt(_zakatTotalIncomingChecks)}",
//           ),

//           const SizedBox(height: 12),
//           const Divider(color: Color(0xFFDCEDC8), height: 1),
//           const SizedBox(height: 12),

//           _buildZakatRow("وعاء الزكاة", "₪ ${_fmt(_zakatBase)}"),
//           const SizedBox(height: 8),
//           _buildZakatRow(
//             "نسبة الزكاة",
//             "${(_zakatRate * 100).toStringAsFixed(1)}%",
//           ),

//           const SizedBox(height: 16),

//           // ── مبلغ الزكاة المستحقة ──
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(vertical: 14),
//             decoration: BoxDecoration(
//               color: const Color(0xFF2E7D32),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 const Text(
//                   "مبلغ الزكاة المستحقة",
//                   style: TextStyle(
//                     fontFamily: 'Cairo',
//                     fontSize: 12,
//                     color: Colors.white70,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "₪ ${_fmt(_zakatDue)}",
//                   style: const TextStyle(
//                     fontFamily: 'Cairo',
//                     fontSize: 26,
//                     fontWeight: FontWeight.w800,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "لم يتم الدفع بعد",
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 12,
//                   color: Color(0xFF888888),
//                 ),
//               ),
//               Text(
//                 "آخر دفعة: لم تُحدد",
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 12,
//                   color: Color(0xFF888888),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildZakatRow(String label, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             fontFamily: 'Cairo',
//             fontSize: 14,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF2E7D32),
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontSize: 13,
//             color: Colors.grey[600],
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // 0 = شهري ، 1 = سنوي ، 2 = زكاة
  int _reportMode = 0;

  int _selectedYear = 2026;
  int _selectedMonth = 5;

  final List<int> _years = [2024, 2025, 2026, 2027];
  final List<String> _months = [
    "يناير",
    "فبراير",
    "مارس",
    "أبريل",
    "مايو",
    "يونيو",
    "يوليو",
    "أغسطس",
    "سبتمبر",
    "أكتوبر",
    "نوفمبر",
    "ديسمبر",
  ];

  // ── بيانات التقرير العادي ──
  double _netProfit = 0;
  double _totalIncome = 0;
  double _totalChecks = 0;

  // ── بيانات الزكاة ──
  double _zakatTotalIncome = 0;
  double _zakatTotalExpense = 0;
  double _zakatNetCash = 0;
  double _zakatInventoryValue = 0;
  double _zakatTotalReceivables = 0;
  double _zakatTotalIncomingChecks = 0;
  double _zakatBase = 0;
  double _zakatRate = 0.025;
  double _zakatDue = 0;

  // ── نسبة الزكاة القابلة للتعديل ──
  double _customZakatRate = 0.025;
  final TextEditingController _zakatRateController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  // ============================================================
  //  جلب التقرير
  // ============================================================
  Future<void> _fetchReport() async {
    print("======= FETCH REPORT CALLED =======");
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_reportMode == 2) {
        await _fetchZakat();
      } else {
        await _fetchStatReport();
        await _fetchChecks();
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _errorMessage = "تعذّر الاتصال بالخادم");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ── تقرير شهري / سنوي ──
  Future<void> _fetchStatReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final String targetUrl = _reportMode == 0
        ? "${ApiEndpoints.getMonthlyReport}?year=$_selectedYear&month=$_selectedMonth"
        : "${ApiEndpoints.getYearlyReport}?year=$_selectedYear";

    final response = await http.get(
      Uri.parse(targetUrl),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("============= REPORT DATA =============");
    print("URL: $targetUrl");
    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.body}");
    print("=======================================");

    if (response.statusCode == 200) {
      var rawData = jsonDecode(response.body);
      setState(() {
        _netProfit = (rawData['netProfit'] ?? rawData['net_profit'] ?? 0)
            .toDouble();
        _totalIncome = (rawData['totalIncome'] ?? rawData['total_income'] ?? 0)
            .toDouble();
      });
    } else {
      setState(
        () => _errorMessage = "فشل تحميل التقرير (${response.statusCode})",
      );
    }
  }

  // ── تقرير الزكاة ──
  Future<void> _fetchZakat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final String zakatUrl =
        "${ApiEndpoints.getZakatReport}?year=$_selectedYear";

    final response = await http.get(
      Uri.parse(zakatUrl),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("============= ZAKAT DATA =============");
    print("URL: $zakatUrl");
    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.body}");
    print("======================================");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _zakatTotalIncome = (data['totalIncome'] ?? 0).toDouble();
        _zakatTotalExpense = (data['totalExpense'] ?? 0).toDouble();
        _zakatNetCash = (data['netCash'] ?? 0).toDouble();
        _zakatInventoryValue = (data['inventoryValue'] ?? 0).toDouble();
        _zakatTotalReceivables = (data['totalReceivables'] ?? 0).toDouble();
        _zakatTotalIncomingChecks = (data['totalIncomingChecks'] ?? 0)
            .toDouble();
        _zakatBase = (data['zakatBase'] ?? 0).toDouble();
        _zakatRate = (data['zakatRate'] ?? 0.025).toDouble();
        _zakatDue = (data['zakatDue'] ?? 0).toDouble();

        // نحدث النسبة المخصصة فقط في أول تحميل (إذا لم يعدّلها المستخدم)
        _customZakatRate = _zakatRate;
        _zakatRateController.text = (_zakatRate * 100).toStringAsFixed(1);
      });
    } else {
      setState(
        () =>
            _errorMessage = "فشل تحميل بيانات الزكاة (${response.statusCode})",
      );
    }
  }

  // ── الشيكات ──
  Future<void> _fetchChecks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final String checksUrl =
        "${ApiEndpoints.getMonthlyChecks}?year=$_selectedYear";

    final response = await http.get(
      Uri.parse(checksUrl),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    print("============= CHECKS DATA =============");
    print("URL: $checksUrl");
    print("STATUS: ${response.statusCode}");
    print("RESPONSE: ${response.body}");
    print("=======================================");

    if (response.statusCode == 200) {
      var rawData = jsonDecode(response.body);
      List<dynamic> breakdown = rawData['monthlyBreakdown'] ?? [];
      double total = 0;

      if (_reportMode == 0) {
        var monthData = breakdown.firstWhere(
          (item) => item['month'] == _selectedMonth,
          orElse: () => null,
        );
        total = (monthData?['totalIncomingAmount'] ?? 0).toDouble();
      } else {
        for (var item in breakdown) {
          total += (item['totalIncomingAmount'] ?? 0).toDouble();
        }
      }
      setState(() => _totalChecks = total);
    }
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  @override
  void initState() {
    super.initState();
    _zakatRateController.text = "2.5";
    _fetchReport();
  }

  @override
  void dispose() {
    _zakatRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D5EAB),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "التقارير والإحصائيات",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _errorMessage != null
          ? _buildErrorState()
          : _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3D5EAB)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildModernFilterSection(),
                  const SizedBox(height: 16),

                  if (_reportMode == 2) _buildZakatCard(),

                  if (_reportMode != 2) ...[
                    _buildStatCard(
                      title: _reportMode == 1
                          ? "صافي أرباح السنة"
                          : "صافي أرباح الشهر",
                      value: "₪ ${_fmt(_netProfit)}",
                      icon: Icons.trending_up_rounded,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF2E7D32),
                      valueColor: const Color(0xFF2E7D32),
                    ),
                    _buildStatCard(
                      title: _reportMode == 1
                          ? "إجمالي الشيكات الواردة للسنة"
                          : "إجمالي الشيكات الواردة للشهر",
                      value: "₪ ${_fmt(_totalChecks)}",
                      icon: Icons.edit_document,
                      iconBg: const Color(0xFFF0EDFF),
                      iconColor: const Color(0xFF534AB7),
                      valueColor: const Color(0xFF534AB7),
                    ),
                    _buildStatCard(
                      title: "إجمالي رأس المال الكامل",
                      value: "₪ ${_fmt(_totalIncome)}",
                      icon: Icons.account_balance_wallet_rounded,
                      iconBg: const Color(0xFFFDF3E0),
                      iconColor: const Color(0xFF854F0B),
                      valueColor: const Color(0xFF854F0B),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 56,
            color: Color(0xFFB0B8CC),
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D5EAB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _fetchReport,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            label: const Text(
              "إعادة المحاولة",
              style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFilterSection() {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDropdownContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selectedYear,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF3D5EAB),
                    ),
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF2D3243),
                      fontSize: 13,
                    ),
                    items: _years
                        .map(
                          (y) => DropdownMenuItem(
                            value: y,
                            child: Text(y.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedYear = value);
                        _fetchReport();
                      }
                    },
                  ),
                ),
              ),
              if (_reportMode == 0) ...[
                const SizedBox(width: 8),
                _buildDropdownContainer(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedMonth,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF3D5EAB),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xFF2D3243),
                        fontSize: 13,
                      ),
                      items: List.generate(
                        _months.length,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text(_months[i]),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedMonth = value);
                          _fetchReport();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFF4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildFilterToggleButton(
                title: "الزكاة",
                isSelected: _reportMode == 2,
                onTap: () {
                  setState(() => _reportMode = 2);
                  _fetchReport();
                },
              ),
              _buildFilterToggleButton(
                title: "سنوي",
                isSelected: _reportMode == 1,
                onTap: () {
                  setState(() => _reportMode = 1);
                  _fetchReport();
                },
              ),
              _buildFilterToggleButton(
                title: "شهري",
                isSelected: _reportMode == 0,
                onTap: () {
                  setState(() => _reportMode = 0);
                  _fetchReport();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownContainer({required Widget child}) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            size: 16,
            color: Color(0xFF3D5EAB),
          ),
          const SizedBox(width: 6),
          child,
        ],
      ),
    );
  }

  Widget _buildFilterToggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF3D5EAB) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required Color valueColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  //  بطاقة الزكاة الكاملة
  // ============================================================
  Widget _buildZakatCard() {
    final bool nisabReached = _zakatBase > 0;
    // احسب الزكاة المستحقة بناءً على النسبة المخصصة
    final double computedZakatDue = _zakatBase * _customZakatRate;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: nisabReached
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  nisabReached ? "بلغ النصاب" : "لم يبلغ النصاب",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: nisabReached
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE65100),
                  ),
                ),
              ),
              Row(
                children: [
                  const Text(
                    "الزكاة السنوية",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3243),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      color: Color(0xFF2E7D32),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFDCEDC8), height: 1),
          const SizedBox(height: 16),

          // ── تفاصيل الزكاة من الـ API ──
          _buildZakatRow("إجمالي الإيرادات", "₪ ${_fmt(_zakatTotalIncome)}"),
          const SizedBox(height: 8),
          _buildZakatRow("إجمالي المصاريف", "₪ ${_fmt(_zakatTotalExpense)}"),
          const SizedBox(height: 8),
          _buildZakatRow("صافي النقد", "₪ ${_fmt(_zakatNetCash)}"),
          const SizedBox(height: 8),
          _buildZakatRow("قيمة المخزون", "₪ ${_fmt(_zakatInventoryValue)}"),
          const SizedBox(height: 8),
          _buildZakatRow(
            "إجمالي الذمم المدينة",
            "₪ ${_fmt(_zakatTotalReceivables)}",
          ),
          const SizedBox(height: 8),
          _buildZakatRow(
            "إجمالي الشيكات الواردة",
            "₪ ${_fmt(_zakatTotalIncomingChecks)}",
          ),

          const SizedBox(height: 12),
          const Divider(color: Color(0xFFDCEDC8), height: 1),
          const SizedBox(height: 12),

          _buildZakatRow("وعاء الزكاة", "₪ ${_fmt(_zakatBase)}"),
          const SizedBox(height: 8),

          // ── نسبة الزكاة القابلة للتعديل ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                height: 38,
                child: TextField(
                  controller: _zakatRateController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                  decoration: InputDecoration(
                    suffixText: '%',
                    suffixStyle: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xFF2E7D32).withOpacity(0.4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF2E7D32),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0 && parsed <= 100) {
                      setState(() {
                        _customZakatRate = parsed / 100;
                      });
                    }
                  },
                ),
              ),
              Text(
                "نسبة الزكاة",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── مبلغ الزكاة المستحقة ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  "مبلغ الزكاة المستحقة",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₪ ${_fmt(computedZakatDue)}",
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "لم يتم الدفع بعد",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Color(0xFF888888),
                ),
              ),
              Text(
                "آخر دفعة: لم تُحدد",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: Color(0xFF888888),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZakatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E7D32),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
