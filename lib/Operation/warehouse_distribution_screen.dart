// // import 'package:flutter/material.dart';

// // class WarehouseDistributionScreen extends StatefulWidget {
// //   const WarehouseDistributionScreen({super.key});

// //   @override
// //   State<WarehouseDistributionScreen> createState() =>
// //       _WarehouseDistributionScreenState();
// // }

// // class _WarehouseDistributionScreenState
// //     extends State<WarehouseDistributionScreen> {
// //   // الهوية البصرية لمشروع TradeFlow
// //   final Color primaryColor = const Color(0xFF446BC0);
// //   final Color secondaryColor = const Color(0xFF1E3A8A);
// //   final Color bgGray = const Color(0xFFF8FAFC);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: bgGray,
// //       body: Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: CustomScrollView(
// //           physics: const BouncingScrollPhysics(),
// //           slivers: [
// //             // AppBar مع السهم في جهة الشمال (اليسار)
// //             SliverAppBar(
// //               expandedHeight: 90,
// //               pinned: true,
// //               elevation: 0,
// //               backgroundColor: primaryColor,
// //               // تم إلغاء خاصية leading التلقائية لنضع السهم في جهة اليسار يدوياً عبر actions
// //               automaticallyImplyLeading: false,
// //               actions: [
// //                 Padding(
// //                   padding: const EdgeInsets.only(
// //                     left: 10,
// //                   ), // مسافة بسيطة من الحافة اليسرى
// //                   child: IconButton(
// //                     // استخدام أيقونة تشير لليسار (شمال) وباللون الأبيض
// //                     icon: const Icon(
// //                       Icons.arrow_back_ios,
// //                       color: Colors.white,
// //                       size: 22,
// //                     ),
// //                     onPressed: () => Navigator.pop(context),
// //                   ),
// //                 ),
// //               ],
// //               flexibleSpace: FlexibleSpaceBar(
// //                 title: const Text(
// //                   'توزيع المستودعات',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.bold,
// //                     fontSize: 18,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //                 centerTitle: true,
// //                 background: Container(
// //                   decoration: BoxDecoration(
// //                     gradient: LinearGradient(
// //                       colors: [secondaryColor, primaryColor],
// //                       begin: Alignment.topRight,
// //                       end: Alignment.bottomLeft,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             // محتوى الصفحة المرفوع للأعلى
// //             SliverPadding(
// //               padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
// //               sliver: SliverList(
// //                 delegate: SliverChildListDelegate([
// //                   const Text(
// //                     'الخيارات الأساسية',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Color(0xFF1E293B),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 15),

// //                   _buildModernTile(
// //                     icon: Icons.add_business_rounded,
// //                     title: 'إضافة كمية لمستودع',
// //                     subtitle: 'تزويد المخازن ببضاعة واردة جديدة',
// //                     color: primaryColor,
// //                     onTap: () => _showSheet(context, 'إضافة كمية جديدة', [
// //                       'المستودع',
// //                       'الكمية',
// //                     ]),
// //                   ),

// //                   _buildModernTile(
// //                     icon: Icons.swap_horizontal_circle_outlined,
// //                     title: 'نقل مخزون داخلي',
// //                     subtitle: 'تحويل سريع للبضائع بين الفروع',
// //                     color: Colors.orange.shade700,
// //                     onTap: () => _showSheet(context, 'نقل مخزون داخلي', [
// //                       'من مستودع',
// //                       'إلى مستودع',
// //                       'الكمية',
// //                     ]),
// //                   ),

// //                   _buildModernTile(
// //                     icon: Icons.assignment_rounded,
// //                     title: 'سجل التوزيعات الأخيرة',
// //                     subtitle: 'مراجعة حركة المستودعات والعمليات',
// //                     color: Colors.teal.shade600,
// //                     onTap: () => _showLogsSheet(context),
// //                   ),

// //                   const SizedBox(height: 10),

// //                   // كرت الحالة البسيط
// //                   _buildSimpleStatus(),
// //                 ]),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // نفس الـ Widgets السابقة للحفاظ على الشكل الاحترافي
// //   Widget _buildSimpleStatus() {
// //     return Container(
// //       padding: const EdgeInsets.all(15),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(15),
// //         border: Border.all(color: primaryColor.withOpacity(0.1)),
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(
// //             Icons.check_circle_outline,
// //             color: Colors.green.shade600,
// //             size: 20,
// //           ),
// //           const SizedBox(width: 10),
// //           const Text(
// //             "جميع المستودعات متصلة ومحدثة الآن",
// //             style: TextStyle(fontSize: 12, color: Colors.blueGrey),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildModernTile({
// //     required IconData icon,
// //     required String title,
// //     required String subtitle,
// //     required Color color,
// //     required VoidCallback onTap,
// //   }) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 18),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(22),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.02),
// //             blurRadius: 15,
// //             offset: const Offset(0, 5),
// //           ),
// //         ],
// //       ),
// //       child: ListTile(
// //         contentPadding: const EdgeInsets.symmetric(
// //           horizontal: 20,
// //           vertical: 10,
// //         ),
// //         onTap: onTap,
// //         leading: Container(
// //           padding: const EdgeInsets.all(12),
// //           decoration: BoxDecoration(
// //             color: color.withOpacity(0.1),
// //             borderRadius: BorderRadius.circular(15),
// //           ),
// //           child: Icon(icon, color: color, size: 28),
// //         ),
// //         title: Text(
// //           title,
// //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //         ),
// //         subtitle: Text(
// //           subtitle,
// //           style: const TextStyle(fontSize: 12, color: Colors.grey),
// //         ),
// //         trailing: const Icon(
// //           Icons.arrow_back_ios_new_rounded,
// //           size: 14,
// //           color: Colors.grey,
// //         ),
// //       ),
// //     );
// //   }

// //   // توابع الـ Sheets والـ Logic بقيت كما هي لضمان عمل الصفحة بالكامل
// //   void _showSheet(BuildContext context, String title, List<String> fields) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: Container(
// //           padding: EdgeInsets.only(
// //             bottom: MediaQuery.of(context).viewInsets.bottom + 30,
// //             left: 25,
// //             right: 25,
// //             top: 15,
// //           ),
// //           decoration: const BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Container(
// //                 width: 40,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey.shade300,
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ),
// //               const SizedBox(height: 25),
// //               Text(
// //                 title,
// //                 style: const TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               const SizedBox(height: 10),
// //               ...fields
// //                   .map(
// //                     (field) => Padding(
// //                       padding: const EdgeInsets.only(top: 20),
// //                       child: TextField(
// //                         decoration: InputDecoration(
// //                           labelText: field,
// //                           labelStyle: TextStyle(color: secondaryColor),
// //                           filled: true,
// //                           fillColor: bgGray,
// //                           border: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(15),
// //                             borderSide: BorderSide.none,
// //                           ),
// //                           focusedBorder: OutlineInputBorder(
// //                             borderRadius: BorderRadius.circular(15),
// //                             borderSide: BorderSide(color: primaryColor),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   )
// //                   .toList(),
// //               const SizedBox(height: 30),
// //               SizedBox(
// //                 width: double.infinity,
// //                 height: 55,
// //                 child: ElevatedButton(
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: primaryColor,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(18),
// //                     ),
// //                     elevation: 0,
// //                   ),
// //                   onPressed: () => Navigator.pop(context),
// //                   child: const Text(
// //                     'تأكيد وحفظ',
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.bold,
// //                       fontSize: 16,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void _showLogsSheet(BuildContext context) {
// //     showModalBottomSheet(
// //       context: context,
// //       isScrollControlled: true,
// //       backgroundColor: Colors.transparent,
// //       builder: (context) => Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: Container(
// //           height: MediaQuery.of(context).size.height * 0.75,
// //           padding: const EdgeInsets.all(25),
// //           decoration: const BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
// //           ),
// //           child: Column(
// //             children: [
// //               const Text(
// //                 'سجل العمليات الأخير',
// //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //               ),
// //               const Divider(height: 40),
// //               Expanded(
// //                 child: ListView.builder(
// //                   itemCount: 10,
// //                   itemBuilder: (context, index) => Container(
// //                     margin: const EdgeInsets.only(bottom: 15),
// //                     decoration: BoxDecoration(
// //                       color: bgGray,
// //                       borderRadius: BorderRadius.circular(15),
// //                     ),
// //                     child: ListTile(
// //                       leading: CircleAvatar(
// //                         backgroundColor: primaryColor.withOpacity(0.1),
// //                         child: Icon(
// //                           Icons.history,
// //                           color: primaryColor,
// //                           size: 20,
// //                         ),
// //                       ),
// //                       title: Text(
// //                         'عملية توزيع #$index',
// //                         style: const TextStyle(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                       subtitle: const Text(
// //                         'تم تحديث المخزون بنجاح',
// //                         style: TextStyle(fontSize: 12),
// //                       ),
// //                       trailing: const Text(
// //                         'اليوم',
// //                         style: TextStyle(fontSize: 10, color: Colors.grey),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// // تأكد من المسار الصحيح لملف الروابط
// import 'package:tradeflow_app/pages/link.dart';

// class WarehouseDistributionScreen extends StatefulWidget {
//   const WarehouseDistributionScreen({super.key});

//   @override
//   State<WarehouseDistributionScreen> createState() =>
//       _WarehouseDistributionScreenState();
// }

// class _WarehouseDistributionScreenState
//     extends State<WarehouseDistributionScreen> {
//   final Color primaryBlue = const Color(0xFF4A72C2);

//   List warehouses = [];
//   Map? selectedWarehouse;
//   final TextEditingController _quantityController = TextEditingController();
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchWarehouses(); // استدعاء الجلب عند التشغيل
//   }

//   // --- دوال الـ API (منقولة من كود العمليات الناجح) ---

//   List parseListResponse(String body) {
//     final data = jsonDecode(body);
//     return data is List ? data : data['data'] ?? [];
//   }

//   Future<Map<String, String>> getHeaders() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");
//     return {
//       "Authorization": "Bearer $token",
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//   }

//   Future fetchWarehouses() async {
//     try {
//       final res = await http.get(
//         Uri.parse(ApiEndpoints.getWarehouses),
//         headers: await getHeaders(), // إضافة الـ Headers مع الـ Token
//       );
//       if (res.statusCode == 200) {
//         setState(() {
//           warehouses = parseListResponse(res.body);
//         });
//         print("تم جلب المستودعات بنجاح: ${warehouses.length}");
//       } else {
//         print("فشل الجلب: ${res.statusCode}");
//       }
//     } catch (e) {
//       print("خطأ في الاتصال: $e");
//     }
//   }

//   Future updateStock() async {
//     if (selectedWarehouse == null || _quantityController.text.isEmpty) return;

//     setState(() => isLoading = true);
//     try {
//       final res = await http.post(
//         Uri.parse(ApiEndpoints.addWarehouse),
//         headers: await getHeaders(),
//         body: jsonEncode({
//           "warehouse_id": selectedWarehouse!['id'],
//           "quantity": _quantityController.text,
//         }),
//       );

//       if (res.statusCode == 200 || res.statusCode == 201) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("تمت العملية بنجاح")));
//       }
//     } catch (e) {
//       print("خطأ أثناء الحفظ: $e");
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4F8),
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         title: const Text(
//           "توزيع المستودعات",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               _buildOptionCard(
//                 title: "إضافة كمية لمستودع",
//                 icon: Icons.add_business_rounded,
//                 onTap: () => _showAddSheet(context),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showAddSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setModalState) => Directionality(
//           textDirection: TextDirection.rtl,
//           child: Container(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom + 30,
//               left: 25,
//               right: 25,
//               top: 20,
//             ),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "توزيع كمية على مستودع",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 25),

//                 // Dropdown المستودعات
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: DropdownButtonFormField<Map>(
//                     value: selectedWarehouse,
//                     isExpanded: true,
//                     hint: Text(
//                       warehouses.isEmpty ? "جاري التحميل..." : "اختر المستودع",
//                     ),
//                     items: warehouses.map((e) {
//                       return DropdownMenuItem<Map>(
//                         value: e,
//                         child: Text(e['name'] ?? "بدون اسم"),
//                       );
//                     }).toList(),
//                     onChanged: (v) {
//                       setModalState(() => selectedWarehouse = v);
//                     },
//                     decoration: const InputDecoration(border: InputBorder.none),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // حقل الكمية
//                 TextField(
//                   controller: _quantityController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     hintText: "الكمية",
//                     filled: true,
//                     fillColor: Colors.grey.shade50,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 SizedBox(
//                   width: double.infinity,
//                   height: 55,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryBlue,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                     ),
//                     onPressed: isLoading ? null : updateStock,
//                     child: isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text(
//                             "حفظ البيانات",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOptionCard({
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: primaryBlue, size: 30),
//             const SizedBox(width: 15),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const Spacer(),
//             const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

class WarehouseDistributionScreen extends StatefulWidget {
  const WarehouseDistributionScreen({super.key});

  @override
  State<WarehouseDistributionScreen> createState() =>
      _WarehouseDistributionScreenState();
}

class _WarehouseDistributionScreenState
    extends State<WarehouseDistributionScreen> {
  final Color primaryBlue = const Color(0xFF4A72C2);

  List warehouses = [];
  List products = [];

  Map? selectedWarehouse;
  Map? fromWarehouse;
  Map? toWarehouse;
  Map? selectedProduct;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _transferQuantityController =
      TextEditingController();

  bool isLoading = false;
  bool isProductsLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWarehouses();
  }

  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  Future fetchWarehouses() async {
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.getWarehouses),
        headers: await getHeaders(),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (mounted) {
          setState(() {
            warehouses = data is List ? data : data['data'] ?? [];
          });
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future fetchProductsInWarehouse(
    String warehouseId,
    StateSetter setModalState,
  ) async {
    setModalState(() {
      isProductsLoading = true;
      products = [];
      selectedProduct = null;
    });

    try {
      final res = await http.get(
        Uri.parse("${ApiEndpoints.getWarehouseProducts}/$warehouseId"),
        headers: await getHeaders(),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setModalState(() {
          products = data is List ? data : data['data'] ?? [];
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setModalState(() => isProductsLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          "توزيع المستودعات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildOptionCard(
                "إضافة كمية لمستودع",
                Icons.add_business_rounded,
                () => _showAddSheet(context),
              ),
              const SizedBox(height: 15),
              _buildOptionCard(
                "نقل بين المستودعات",
                Icons.move_up_rounded,
                () => _showTransferSheet(context),
              ),
              const SizedBox(height: 15),
              _buildOptionCard("سجل الحركات ", Icons.history_rounded, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WarehouseHistoryScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryBlue, size: 30),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _buildSheetLayout("إضافة كمية خشب", [
        _buildDropdown(
          "اختر المستودع",
          selectedWarehouse,
          warehouses,
          (v) => setState(() => selectedWarehouse = v),
        ),
        const SizedBox(height: 20),
        _buildTextField(_quantityController, "الكمية (باللوح أو المتر)"),
        const SizedBox(height: 30),
        _buildSubmitButton(() => Navigator.pop(ctx), "حفظ العملية"),
      ]),
    );
  }

  void _showTransferSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => _buildSheetLayout("نقل أخشاب", [
          _buildDropdown("من مستودع (المصدر)", fromWarehouse, warehouses, (v) {
            setModalState(() => fromWarehouse = v);
            if (v != null)
              fetchProductsInWarehouse(v['id'].toString(), setModalState);
          }),
          const SizedBox(height: 15),
          _buildDropdown(
            isProductsLoading ? "جاري جلب الأصناف..." : "اختر نوع الخشب",
            selectedProduct,
            products,
            (v) => setModalState(() => selectedProduct = v),
          ),
          const Icon(Icons.arrow_downward, color: Colors.grey, size: 20),
          _buildDropdown(
            "إلى مستودع (الوجهة)",
            toWarehouse,
            warehouses,
            (v) => setModalState(() => toWarehouse = v),
          ),
          const SizedBox(height: 20),
          _buildTextField(_transferQuantityController, "الكمية المنقولة"),
          const SizedBox(height: 30),
          _buildSubmitButton(() => Navigator.pop(ctx), "تأكيد النقل"),
        ]),
      ),
    );
  }

  Widget _buildSheetLayout(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
        left: 25,
        right: 25,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    Map? value,
    List items,
    Function(Map?) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<Map>(
        value: value,
        isExpanded: true,
        hint: Text(hint, style: const TextStyle(fontSize: 14)),
        items: items
            .map(
              (e) =>
                  DropdownMenuItem<Map>(value: e, child: Text(e['name'] ?? "")),
            )
            .toList(),
        onChanged: onChanged,
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(VoidCallback? onPressed, String label) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class WarehouseHistoryScreen extends StatelessWidget {
  const WarehouseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List dummyHistory = [
      {
        "type": "إضافة",
        "product": "خشب سويدي - 4 متر",
        "qty": "200 لوح",
        "store": "مستودع الأخشاب الخام",
        "date": "2024-04-20",
      },
      {
        "type": "نقل",
        "product": "خشب زان روماني",
        "qty": "50 قطعة",
        "store": "من المستودع الرئيسي إلى ورشة القص",
        "date": "2024-04-19",
      },
      {
        "type": "إضافة",
        "product": "خشب MDF مغلف",
        "qty": "150 لوح",
        "store": "مستودع المنطقة الصناعية",
        "date": "2024-04-18",
      },
      {
        "type": "نقل",
        "product": "خشب ميرانتي (أحمر)",
        "qty": "30 متر مكعب",
        "store": "من الميناء إلى المستودع الرئيسي",
        "date": "2024-04-17",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A72C2),
        title: const Text("سجل الحركات", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: dummyHistory.length,
          itemBuilder: (context, index) {
            final item = dummyHistory[index];
            bool isTransfer = item['type'] == 'نقل';
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border(
                  right: BorderSide(
                    color: isTransfer ? Colors.orange : Colors.green,
                    width: 5,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['product'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item['date'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(
                    "${item['type']}: ${item['store']}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "الكمية: ${item['qty']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
