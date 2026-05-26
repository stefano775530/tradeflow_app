// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/link.dart';

// // نوع الفلتر
// enum DebtFilter { all, partial, unpaid }

// class DebtsScreen extends StatefulWidget {
//   const DebtsScreen({super.key});

//   @override
//   State<DebtsScreen> createState() => _DebtsScreenState();
// }

// class _DebtsScreenState extends State<DebtsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final Color primaryBlue = const Color(0xFF3D5EAB);

//   DebtFilter _filterOwedToUs = DebtFilter.all;
//   DebtFilter _filterOwedByUs = DebtFilter.all;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<List<dynamic>> fetchPartnersDebts(bool isOwedToUs) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       final response = await http.get(
//         Uri.parse(ApiEndpoints.getDebts),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       );

//       if (response.statusCode == 200) {
//         var rawData = jsonDecode(response.body);
//         List<dynamic> allPartners =
//             (rawData is Map && rawData.containsKey('data'))
//             ? rawData['data']
//             : (rawData is List ? rawData : []);

//         if (isOwedToUs) {
//           return allPartners
//               .where((p) => p['Partner']['partner_type'] == 'customer')
//               .toList();
//         } else {
//           return allPartners
//               .where((p) => p['Partner']['partner_type'] == 'supplier')
//               .toList();
//         }
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   List<dynamic> _applyFilter(List<dynamic> data, DebtFilter filter) {
//     switch (filter) {
//       case DebtFilter.all:
//         return data;
//       case DebtFilter.partial:
//         return data.where((p) => p['payment_status'] == 'partial').toList();
//       case DebtFilter.unpaid:
//         return data.where((p) => p['payment_status'] == 'unpaid').toList();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFF),
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "إدارة الديون",
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontSize: 20,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(70),
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: Colors.black12,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               indicatorSize: TabBarIndicatorSize.tab,
//               dividerColor: Colors.transparent,
//               indicator: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               labelColor: primaryBlue,
//               unselectedLabelColor: Colors.white,
//               labelStyle: const TextStyle(
//                 fontFamily: 'Cairo',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//               tabs: const [
//                 Tab(text: "ديون لنا"),
//                 Tab(text: "ديون علينا"),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildDebtsList(isOwedToUs: true),
//           _buildDebtsList(isOwedToUs: false),
//         ],
//       ),
//     );
//   }

//   Widget _buildDebtsList({required bool isOwedToUs}) {
//     final currentFilter = isOwedToUs ? _filterOwedToUs : _filterOwedByUs;
//     return FutureBuilder<List<dynamic>>(
//       future: fetchPartnersDebts(isOwedToUs),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final allData = snapshot.data ?? [];
//         final filteredData = _applyFilter(allData, currentFilter);
//         return Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _buildFilterButton(
//                       "الكل",
//                       allData.length,
//                       currentFilter == DebtFilter.all,
//                       primaryBlue,
//                       () => setState(
//                         () => isOwedToUs
//                             ? _filterOwedToUs = DebtFilter.all
//                             : _filterOwedByUs = DebtFilter.all,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: _buildFilterButton(
//                       "جزئي",
//                       _applyFilter(allData, DebtFilter.partial).length,
//                       currentFilter == DebtFilter.partial,
//                       const Color(0xFFB45309),
//                       () => setState(
//                         () => isOwedToUs
//                             ? _filterOwedToUs = DebtFilter.partial
//                             : _filterOwedByUs = DebtFilter.partial,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: _buildFilterButton(
//                       "لم يدفع",
//                       _applyFilter(allData, DebtFilter.unpaid).length,
//                       currentFilter == DebtFilter.unpaid,
//                       const Color(0xFFDC2626),
//                       () => setState(
//                         () => isOwedToUs
//                             ? _filterOwedToUs = DebtFilter.unpaid
//                             : _filterOwedByUs = DebtFilter.unpaid,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: filteredData.length,
//                 itemBuilder: (context, index) {
//                   final item = filteredData[index];
//                   final partner = item['Partner'];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: ListTile(
//                       onTap: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DebtDetailsScreen(
//                             partnerId: partner['id'],
//                             partnerName: partner['company_name'] ?? "بدون اسم",
//                             currentBalance:
//                                 item['remaining_amount']?.toString() ?? "0",
//                             allData: allData,
//                           ),
//                         ),
//                       ).then((value) => setState(() {})),
//                       leading: CircleAvatar(
//                         radius: 25,
//                         backgroundColor: primaryBlue.withOpacity(0.12),
//                         child: Text(
//                           partner['company_name']?[0].toUpperCase() ?? "?",
//                           style: TextStyle(
//                             color: primaryBlue,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       title: Text(
//                         partner['company_name'] ?? "بدون اسم",
//                         style: const TextStyle(
//                           fontFamily: 'Cairo',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       subtitle: Text(
//                         partner['phone_number'] ?? "بدون هاتف",
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       trailing: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             "₪ ${item['remaining_amount']}",
//                             style: TextStyle(
//                               color: isOwedToUs ? Colors.green : Colors.red,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                             ),
//                           ),
//                           const Text(
//                             "المتبقي",
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey,
//                               fontFamily: 'Cairo',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFilterButton(
//     String label,
//     int count,
//     bool selected,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: selected ? color : Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: selected ? color : Colors.grey.shade300),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontFamily: 'Cairo',
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//                 color: selected ? Colors.white : Colors.black87,
//               ),
//             ),
//             const SizedBox(width: 5),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                 color: selected ? Colors.white24 : color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(99),
//               ),
//               child: Text(
//                 "$count",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: selected ? Colors.white : color,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class DebtDetailsScreen extends StatefulWidget {
//   final int partnerId;
//   final String partnerName;
//   final String currentBalance;
//   final List<dynamic> allData;

//   const DebtDetailsScreen({
//     super.key,
//     required this.partnerId,
//     required this.partnerName,
//     required this.currentBalance,
//     required this.allData,
//   });

//   @override
//   State<DebtDetailsScreen> createState() => _DebtDetailsScreenState();
// }

// class _DebtDetailsScreenState extends State<DebtDetailsScreen> {
//   final Color primaryBlue = const Color(0xFF3D5EAB);
//   bool isSaving = false;
//   int? selectedSaleId;
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _bankController = TextEditingController();
//   final TextEditingController _checkNumController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();

//   List<dynamic> fetchTransactions() {
//     List<dynamic> timeline = [];
//     var partnerEntries = widget.allData
//         .where((element) => element['partner_id'] == widget.partnerId)
//         .toList();
//     for (var entry in partnerEntries) {
//       if (entry['SaleItems'] != null) {
//         for (var sale in entry['SaleItems']) {
//           timeline.add({
//             "id": sale['id'],
//             "type": "فاتورة: ${sale['item_name_snapshot']}",
//             "amount": sale['line_total'],
//             "date": entry['sale_date'],
//             "isDebt": true,
//           });
//         }
//       }
//       if (entry['Payments'] != null) {
//         for (var pay in entry['Payments']) {
//           timeline.add({
//             "id": pay['id'],
//             "sale_id": pay['id'],
//             "type": "دفعة ${pay['payment_method'] == 'cash' ? 'نقدية' : 'شيك'}",
//             "amount": pay['amount'],
//             "date": pay['payment_date'],
//             "isDebt": false,
//           });
//         }
//       }
//     }
//     timeline.sort((a, b) => b['date'].compareTo(a['date']));
//     return timeline;
//   }

//   // الوظيفة الأساسية: تنفيذ عملية الحفظ الفعلية بناءً على رابط ApiEndpoints.addPayment
//   // Future<void> _submitPayment(String method) async {
//   //   if (_amountController.text.isEmpty) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text("يرجى إدخال القيمة أولاً")));
//   //     return;
//   //   }

//   //   setState(() => isSaving = true);
//   //   try {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String? token = prefs.getString("token");

//   //     // تجهيز البيانات بدقة للسيرفر
//   //     final Map<String, dynamic> body = {
//   //       "partner_id": widget.partnerId,
//   //       "amount": double.tryParse(_amountController.text) ?? 0.0,
//   //       "payment_method": method,
//   //       "bank_name": method == "check" ? _bankController.text : null,
//   //       "check_number": method == "check" ? _checkNumController.text : null,
//   //       "payment_date": _dateController.text.isNotEmpty
//   //           ? _dateController.text
//   //           : DateTime.now().toIso8601String().split('T')[0],
//   //     };

//   //     print("Request Body: ${jsonEncode(body)}");

//   //     final response = await http.post(
//   //       Uri.parse(ApiEndpoints.addPayment),
//   //       headers: {
//   //         "Authorization": "Bearer $token",
//   //         "Content-Type": "application/json",
//   //         "Accept": "application/json",
//   //       },
//   //       body: jsonEncode(body),
//   //     );

//   //     print("Response Status: ${response.statusCode}");
//   //     print("Response Body: ${response.body}");

//   //     if (response.statusCode == 200 || response.statusCode == 201) {
//   //       Navigator.pop(context); // إغلاق القائمة
//   //       ScaffoldMessenger.of(
//   //         context,
//   //       ).showSnackBar(const SnackBar(content: Text("تم تسجيل العملية بنجاح")));

//   //       _amountController.clear();
//   //       _bankController.clear();
//   //       _checkNumController.clear();
//   //       _dateController.clear();

//   //       setState(() {}); // تحديث الواجهة الخلفية
//   //     } else {
//   //       var errorData = jsonDecode(response.body);
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text("خطأ: ${errorData['message'] ?? 'فشل الحفظ'}"),
//   //         ),
//   //       );
//   //     }
//   //   } catch (e) {
//   //     print("Exception Error: $e");
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(SnackBar(content: Text("حدث خطأ في الاتصال: $e")));
//   //   } finally {
//   //     setState(() => isSaving = false);
//   //   }
//   // }
//   TextEditingController _notesController = TextEditingController();
//   Future<void> _submitPayment(String method) async {
//     if (_amountController.text.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("يرجى إدخال القيمة أولاً")));
//       return;
//     }

//     setState(() => isSaving = true);

//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       // body الأساسي
//       final Map<String, dynamic> body = {
//         "sale_id": selectedSaleId,
//         "payment_method": method,
//         "amount": double.tryParse(_amountController.text) ?? 0.0,
//         "payment_date": _dateController.text.isNotEmpty
//             ? _dateController.text
//             : DateTime.now().toIso8601String().split('T')[0],
//         "notes": _notesController.text,
//       };

//       // إذا كانت الدفعة شيك
//       if (method == "check") {
//         body["check"] = {
//           "bank_name": _bankController.text,
//           "check_number": _checkNumController.text,
//           "issue_date": _dateController.text.isNotEmpty
//               ? _dateController.text
//               : DateTime.now().toIso8601String().split('T')[0],
//           "status": "pending",
//         };
//       }

//       print("Request Body: ${jsonEncode(body)}");

//       final response = await http.post(
//         Uri.parse("${ApiEndpoints.addsale}/$selectedSaleId/payments"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode(body),
//       );

//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Navigator.pop(context);

//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("تم تسجيل العملية بنجاح")));

//         _amountController.clear();
//         _bankController.clear();
//         _checkNumController.clear();
//         _dateController.clear();
//         _notesController.clear();

//         setState(() {});
//       } else {
//         var errorData = jsonDecode(response.body);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("خطأ: ${errorData['message'] ?? 'فشل الحفظ'}"),
//           ),
//         );
//       }
//     } catch (e) {
//       print("Exception Error: $e");

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("حدث خطأ في الاتصال: $e")));
//     } finally {
//       setState(() => isSaving = false);
//     }
//   }

//   Future<void> _selectDate(
//     BuildContext context,
//     StateSetter setModalState,
//     TextEditingController controller,
//   ) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null) {
//       setModalState(() {
//         controller.text =
//             "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
//       });
//     }
//   }

//   void _showPaymentSheet(int saleId) {
//     selectedSaleId = saleId;
//     bool isCash = true;
//     showModalBottomSheet(
//       context: this.context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       builder: (context) => StatefulBuilder(
//         builder: (context, setModalState) => Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "تسجيل دفعة لـ ${widget.partnerName}",
//                 style: const TextStyle(
//                   fontFamily: 'Cairo',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildTypeBtn(
//                       "نقداً",
//                       Icons.money,
//                       isCash,
//                       () => setModalState(() => isCash = true),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: _buildTypeBtn(
//                       "شيك",
//                       Icons.confirmation_num_outlined,
//                       !isCash,
//                       () => setModalState(() => isCash = false),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               if (isCash)
//                 _buildInput(
//                   "المبلغ",
//                   _amountController,
//                   Icons.payments_outlined,
//                   isNum: true,
//                 )
//               else
//                 Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildInput(
//                             "البنك",
//                             _bankController,
//                             Icons.account_balance,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: _buildInput(
//                             "رقم الشيك",
//                             _checkNumController,
//                             Icons.tag,
//                             isNum: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildInput(
//                             "القيمة",
//                             _amountController,
//                             Icons.attach_money,
//                             isNum: true,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () => _selectDate(
//                               context,
//                               setModalState,
//                               _dateController,
//                             ),
//                             child: AbsorbPointer(
//                               child: _buildInput(
//                                 "التاريخ",
//                                 _dateController,
//                                 Icons.calendar_month,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               const SizedBox(height: 25),
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryBlue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   onPressed: isSaving
//                       ? null
//                       : () => _submitPayment(isCash ? "cash" : "check"),
//                   child: isSaving
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Text(
//                           "تأكيد الحفظ",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'Cairo',
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final trans = fetchTransactions();
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFF),
//       body: Column(
//         children: [
//           _buildHeader(),
//           Transform.translate(
//             offset: const Offset(0, -30),
//             child: _buildBalanceCard(),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text(
//                 "سجل العمليات",
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontWeight: FontWeight.bold,
//                   fontSize: 19,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               itemCount: trans.length,
//               itemBuilder: (context, index) {
//                 final t = trans[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.02),
//                         blurRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: ListTile(
//                     leading: Icon(
//                       Icons.circle,
//                       size: 16,
//                       color: t['isDebt'] ? Colors.red : Colors.green,
//                     ),
//                     title: Text(
//                       t['type'],
//                       style: const TextStyle(
//                         fontFamily: 'Cairo',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     subtitle: Text(
//                       t['date'],
//                       style: const TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     trailing: Text(
//                       "₪ ${t['amount']}",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: t['isDebt'] ? Colors.red : Colors.green,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(20),
//             child: SizedBox(
//               width: double.infinity,
//               height: 60,
//               child: ElevatedButton(
//                 onPressed: () {
//                   _showPaymentSheet(trans.first['id']);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryBlue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//                 child: const Text(
//                   "تسجيل دفعة",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontFamily: 'Cairo',
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() => Container(
//     padding: const EdgeInsets.only(top: 55, bottom: 45, right: 20, left: 20),
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: primaryBlue,
//       borderRadius: const BorderRadius.only(
//         bottomLeft: Radius.circular(30),
//         bottomRight: Radius.circular(30),
//       ),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Icon(Icons.more_vert, color: Colors.white, size: 28),
//         Text(
//           widget.partnerName,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Cairo',
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ],
//     ),
//   );

//   Widget _buildBalanceCard() => Container(
//     margin: const EdgeInsets.symmetric(horizontal: 20),
//     padding: const EdgeInsets.all(25),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       boxShadow: [
//         BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15),
//       ],
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Column(
//           children: [
//             const Text(
//               "الرصيد الحالي",
//               style: TextStyle(
//                 fontFamily: 'Cairo',
//                 fontSize: 14,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               "₪ ${widget.currentBalance}",
//               style: TextStyle(
//                 fontFamily: 'Cairo',
//                 fontWeight: FontWeight.bold,
//                 fontSize: 26,
//                 color: primaryBlue,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );

//   Widget _buildTypeBtn(
//     String label,
//     IconData icon,
//     bool selected,
//     VoidCallback onTap,
//   ) => GestureDetector(
//     onTap: onTap,
//     child: Container(
//       padding: const EdgeInsets.symmetric(vertical: 15),
//       decoration: BoxDecoration(
//         color: selected ? primaryBlue : Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: selected ? primaryBlue : Colors.grey.shade300,
//         ),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: selected ? Colors.white : Colors.grey),
//           Text(
//             label,
//             style: TextStyle(
//               color: selected ? Colors.white : Colors.grey,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Cairo',
//             ),
//           ),
//         ],
//       ),
//     ),
//   );

//   Widget _buildInput(
//     String label,
//     TextEditingController ctrl,
//     IconData icon, {
//     bool isNum = false,
//   }) => TextField(
//     controller: ctrl,
//     keyboardType: isNum ? TextInputType.number : TextInputType.text,
//     textAlign: TextAlign.right,
//     decoration: InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon, size: 20, color: primaryBlue),
//       filled: true,
//       fillColor: const Color(0xFFF7F9FC),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//       labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
//     ),
//   );
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

// نوع الفلتر
enum DebtFilter { all, partial, unpaid }

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryBlue = const Color(0xFF3D5EAB);

  DebtFilter _filterOwedToUs = DebtFilter.all;
  DebtFilter _filterOwedByUs = DebtFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Future<List<dynamic>> fetchPartnersDebts(bool isOwedToUs) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString("token");

  //     final response = await http.get(
  //       Uri.parse(ApiEndpoints.getDebts),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       var rawData = jsonDecode(response.body);
  //       List<dynamic> allPartners =
  //           (rawData is Map && rawData.containsKey('data'))
  //           ? rawData['data']
  //           : (rawData is List ? rawData : []);

  //       if (isOwedToUs) {
  //         return allPartners
  //             .where((p) => p['Partner']['partner_type'] == 'customer')
  //             .toList();
  //       } else {
  //         return allPartners
  //             .where((p) => p['Partner']['partner_type'] == 'supplier')
  //             .toList();
  //       }
  //     }
  //     return [];
  //   } catch (e) {
  //     return [];
  //   }
  // }
  Future<List<dynamic>> fetchPartnersDebts(bool isOwedToUs) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      // تحديد الرابط المناسب بناءً على التبويب
      final String targetUrl = isOwedToUs
          ? ApiEndpoints
                .getDebts // الرابط القديم لتبويب ديون لنا (الزبائن)
          : ApiEndpoints
                .getSuppliersDebts; // الرابط الجديد المفلتر لتبويب ديون علينا (الموردين)

      final response = await http.get(
        Uri.parse(targetUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var rawData = jsonDecode(response.body);

        // طباعة البيانات بشكل مميز جداً في الـ Console لمعاينتها ومعرفة الـ Key الخاص بالمبلغ
        print("============= DATA FROM BACKEND =============");
        print("URL: $targetUrl");
        print("RESPONSE: ${jsonEncode(rawData)}");
        print("=============================================");

        List<dynamic> allPartners = [];
        if (rawData is Map) {
          if (rawData.containsKey('data')) {
            allPartners = rawData['data'] is List ? rawData['data'] : [];
          } else if (rawData.containsKey('partners')) {
            allPartners = rawData['partners'] is List
                ? rawData['partners']
                : [];
          } else if (rawData.containsKey('suppliers')) {
            allPartners = rawData['suppliers'] is List
                ? rawData['suppliers']
                : [];
          } else {
            allPartners = [rawData];
          }
        } else if (rawData is List) {
          allPartners = rawData;
        }

        if (isOwedToUs) {
          // فلترة الزبائن يدوياً من الرابط القديم العام
          return allPartners
              .where(
                (p) =>
                    p['Partner'] != null &&
                    p['Partner']['partner_type'] == 'customer',
              )
              .toList();
        } else {
          // الموردون يأتون جاهزين من الباك إند الجديد
          return allPartners;
        }
      }
      return [];
    } catch (e) {
      print("Error fetching debts: $e");
      return [];
    }
  }

  List<dynamic> _applyFilter(List<dynamic> data, DebtFilter filter) {
    switch (filter) {
      case DebtFilter.all:
        return data;
      case DebtFilter.partial:
        return data.where((p) => p['payment_status'] == 'partial').toList();
      case DebtFilter.unpaid:
        return data.where((p) => p['payment_status'] == 'unpaid').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "إدارة الديون",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(15),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: primaryBlue,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              tabs: const [
                Tab(text: "ديون لنا"),
                Tab(text: "ديون علينا"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDebtsList(isOwedToUs: true),
          _buildDebtsList(isOwedToUs: false),
        ],
      ),
    );
  }

  Widget _buildDebtsList({required bool isOwedToUs}) {
    final currentFilter = isOwedToUs ? _filterOwedToUs : _filterOwedByUs;
    return FutureBuilder<List<dynamic>>(
      future: fetchPartnersDebts(isOwedToUs),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final allData = snapshot.data ?? [];
        final filteredData = _applyFilter(allData, currentFilter);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFilterButton(
                      "الكل",
                      allData.length,
                      currentFilter == DebtFilter.all,
                      primaryBlue,
                      () => setState(
                        () => isOwedToUs
                            ? _filterOwedToUs = DebtFilter.all
                            : _filterOwedByUs = DebtFilter.all,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterButton(
                      "جزئي",
                      _applyFilter(allData, DebtFilter.partial).length,
                      currentFilter == DebtFilter.partial,
                      const Color(0xFFB45309),
                      () => setState(
                        () => isOwedToUs
                            ? _filterOwedToUs = DebtFilter.partial
                            : _filterOwedByUs = DebtFilter.partial,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterButton(
                      "لم يدفع",
                      _applyFilter(allData, DebtFilter.unpaid).length,
                      currentFilter == DebtFilter.unpaid,
                      const Color(0xFFDC2626),
                      () => setState(
                        () => isOwedToUs
                            ? _filterOwedToUs = DebtFilter.unpaid
                            : _filterOwedByUs = DebtFilter.unpaid,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredData.isEmpty
                  ? const Center(
                      child: Text(
                        "لا يوجد بيانات لعرضها هنا",
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];

                        // محاولة جلب كائن المورد/الزبون بجميع المسميات المتوقعة
                        final partner =
                            item['Partner'] ??
                            item['supplier'] ??
                            item['Supplier'] ??
                            item['partner'] ??
                            item;

                        // استخراج الاسم بذكاء وفحص كل الاحتمالات الممكنة في مستويات الـ JSON
                        String companyName = "بدون اسم";
                        if (partner != null) {
                          companyName =
                              partner['company_name'] ??
                              partner['name'] ??
                              partner['supplier_name'] ??
                              partner['partner_name'] ??
                              item['company_name'] ??
                              item['name'] ??
                              item['supplier_name'] ??
                              "بدون اسم";
                        }

                        // استخراج رقم الهاتف بجميع المسميات المتوقعة
                        String phoneNumber = "بدون هاتف";
                        if (partner != null) {
                          phoneNumber =
                              partner['phone_number'] ??
                              partner['phone'] ??
                              item['phone_number'] ??
                              item['phone'] ??
                              "بدون هاتف";
                        }

                        final int partnerId = partner != null
                            ? (partner['id'] ??
                                  item['supplier_id'] ??
                                  item['partner_id'] ??
                                  0)
                            : (item['id'] ?? 0);

                        // استخراج المبلغ المتبقي بجميع المسميات الممكنة للـ Keys في الباك إند
                        final balance =
                            item['remaining_amount'] ??
                            item['remaining_balance'] ??
                            item['balance'] ??
                            item['amount'] ??
                            partner['remaining_amount'] ??
                            partner['balance'] ??
                            "0";

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DebtDetailsScreen(
                                  partnerId: partnerId,
                                  partnerName: companyName,
                                  currentBalance: balance.toString(),
                                  allData: allData,
                                ),
                              ),
                            ).then((value) => setState(() {})),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: primaryBlue.withOpacity(0.12),
                              child: Text(
                                companyName.trim().isNotEmpty
                                    ? companyName.trim()[0].toUpperCase()
                                    : "?",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            title: Text(
                              companyName,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              phoneNumber,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₪ $balance",
                                  style: TextStyle(
                                    color: isOwedToUs
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const Text(
                                  "المتبقي",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterButton(
    String label,
    int count,
    bool selected,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: selected ? Colors.white24 : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DebtDetailsScreen extends StatefulWidget {
  final int partnerId;
  final String partnerName;
  final String currentBalance;
  final List<dynamic> allData;

  const DebtDetailsScreen({
    super.key,
    required this.partnerId,
    required this.partnerName,
    required this.currentBalance,
    required this.allData,
  });

  @override
  State<DebtDetailsScreen> createState() => _DebtDetailsScreenState();
}

class _DebtDetailsScreenState extends State<DebtDetailsScreen> {
  final Color primaryBlue = const Color(0xFF3D5EAB);
  bool isSaving = false;
  int? selectedSaleId;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _checkNumController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<dynamic> fetchTransactions() {
    List<dynamic> timeline = [];

    var partnerEntries = widget.allData
        .where(
          (element) =>
              element['partner_id'] == widget.partnerId ||
              element['supplier_id'] == widget.partnerId ||
              (element['Partner'] != null &&
                  element['Partner']['id'] == widget.partnerId) ||
              (element['supplier'] != null &&
                  element['supplier']['id'] == widget.partnerId),
        )
        .toList();

    for (var entry in partnerEntries) {
      if (entry['SaleItems'] != null) {
        for (var sale in entry['SaleItems']) {
          timeline.add({
            "id": sale['id'],
            "type": "فاتورة: ${sale['item_name_snapshot']}",
            "amount": sale['line_total'],
            "date": entry['sale_date'] ?? entry['date'] ?? "",
            "isDebt": true,
          });
        }
      }
      if (entry['PurchaseItems'] != null) {
        for (var purchase in entry['PurchaseItems']) {
          timeline.add({
            "id": purchase['id'],
            "type": "شراء: ${purchase['item_name_snapshot']}",
            "amount": purchase['line_total'],
            "date": entry['purchase_date'] ?? entry['date'] ?? "",
            "isDebt": true,
          });
        }
      }
      if (entry['Payments'] != null) {
        for (var pay in entry['Payments']) {
          timeline.add({
            "id": pay['id'],
            "sale_id": pay['id'],
            "type": "دفعة ${pay['payment_method'] == 'cash' ? 'نقدية' : 'شيك'}",
            "amount": pay['amount'],
            "date": pay['payment_date'] ?? pay['date'] ?? "",
            "isDebt": false,
          });
        }
      }
    }
    timeline.sort((a, b) => b['date'].compareTo(a['date']));
    return timeline;
  }

  Future<void> _submitPayment(String method) async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("يرجى إدخال القيمة أولاً")));
      return;
    }

    setState(() => isSaving = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final Map<String, dynamic> body = {
        "sale_id": selectedSaleId,
        "payment_method": method,
        "amount": double.tryParse(_amountController.text) ?? 0.0,
        "payment_date": _dateController.text.isNotEmpty
            ? _dateController.text
            : DateTime.now().toIso8601String().split('T')[0],
        "notes": _notesController.text,
      };

      if (method == "check") {
        body["check"] = {
          "bank_name": _bankController.text,
          "check_number": _checkNumController.text,
          "issue_date": _dateController.text.isNotEmpty
              ? _dateController.text
              : DateTime.now().toIso8601String().split('T')[0],
          "status": "pending",
        };
      }

      final response = await http.post(
        Uri.parse("${ApiEndpoints.addsale}/$selectedSaleId/payments"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم تسجيل العملية بنجاح")));

        _amountController.clear();
        _bankController.clear();
        _checkNumController.clear();
        _dateController.clear();
        _notesController.clear();

        setState(() {});
      } else {
        var errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ: ${errorData['message'] ?? 'فشل الحفظ'}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ في الاتصال: $e")));
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    StateSetter setModalState,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setModalState(() {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _showPaymentSheet(int saleId) {
    selectedSaleId = saleId;
    bool isCash = true;
    showModalBottomSheet(
      context: this.context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "تسجيل دفعة لـ ${widget.partnerName}",
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeBtn(
                      "نقداً",
                      Icons.money,
                      isCash,
                      () => setModalState(() => isCash = true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTypeBtn(
                      "شيك",
                      Icons.confirmation_num_outlined,
                      !isCash,
                      () => setModalState(() => isCash = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isCash)
                _buildInput(
                  "المبلغ",
                  _amountController,
                  Icons.payments_outlined,
                  isNum: true,
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            "البنك",
                            _bankController,
                            Icons.account_balance,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildInput(
                            "رقم الشيك",
                            _checkNumController,
                            Icons.tag,
                            isNum: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            "القيمة",
                            _amountController,
                            Icons.attach_money,
                            isNum: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(
                              context,
                              setModalState,
                              _dateController,
                            ),
                            child: AbsorbPointer(
                              child: _buildInput(
                                "التاريخ",
                                _dateController,
                                Icons.calendar_month,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: isSaving
                      ? null
                      : () => _submitPayment(isCash ? "cash" : "check"),
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "تأكيد الحفظ",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trans = fetchTransactions();
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        children: [
          _buildHeader(),
          Transform.translate(
            offset: const Offset(0, -30),
            child: _buildBalanceCard(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "سجل العمليات",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
          ),
          Expanded(
            child: trans.isEmpty
                ? const Center(
                    child: Text(
                      "لا يوجد عمليات سابقة",
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: trans.length,
                    itemBuilder: (context, index) {
                      final t = trans[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.circle,
                            size: 16,
                            color: t['isDebt'] ? Colors.red : Colors.green,
                          ),
                          title: Text(
                            t['type'],
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            t['date'],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Text(
                            "₪ ${t['amount']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: t['isDebt'] ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: trans.isEmpty
                    ? null
                    : () {
                        _showPaymentSheet(trans.first['id']);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "تسجيل دفعة",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.only(top: 55, bottom: 45, right: 20, left: 20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: primaryBlue,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.more_vert, color: Colors.white, size: 28),
        Text(
          widget.partnerName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );

  Widget _buildBalanceCard() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text(
              " الرصيد المتبقي",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "₪ ${widget.currentBalance}",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildTypeBtn(
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: selected ? primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: selected ? primaryBlue : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: selected ? Colors.white : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildInput(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    bool isNum = false,
  }) => TextField(
    controller: ctrl,
    keyboardType: isNum ? TextInputType.number : TextInputType.text,
    textAlign: TextAlign.right,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: primaryBlue),
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
    ),
  );
}
