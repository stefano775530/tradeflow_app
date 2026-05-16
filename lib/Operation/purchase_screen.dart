// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:tradeflow_app/pages/link.dart';

// // // class PurchaseScreen extends StatefulWidget {
// // //   const PurchaseScreen({super.key});

// // //   @override
// // //   State<PurchaseScreen> createState() => _PurchaseScreenState();
// // // }

// // // class _PurchaseScreenState extends State<PurchaseScreen> {
// // //   final Color primaryBlue = const Color(0xFF4A72C2);
// // //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// // //   // المتحكمات الأساسية للبضاعة المشتراة
// // //   final TextEditingController _totalQuantityController = TextEditingController(
// // //     text: "0",
// // //   );
// // //   final TextEditingController _purchasePriceController = TextEditingController(
// // //     text: "0",
// // //   );
// // //   final TextEditingController _salePriceController = TextEditingController(
// // //     text: "0",
// // //   );
// // //   Map? _selectedProduct;
// // //   List _allProducts = [];

// // //   // بيانات التوزيع على المستودعات
// // //   List<Map?> _selectedWarehouses = [null];
// // //   List<TextEditingController> _distributionControllers = [
// // //     TextEditingController(text: "0"),
// // //   ];

// // //   final TextEditingController _depositController = TextEditingController(
// // //     text: "0",
// // //   );
// // //   List partners = [];
// // //   List warehouses = [];
// // //   Map? selectedPartner;

// // //   String paymentMethod = "cash";
// // //   List<Map<String, TextEditingController>> checks = [];

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchPartners();
// // //     fetchWarehouses();
// // //     fetchAllProducts(); // جلب كل المنتجات لاختيار الصنف المشتري
// // //   }

// // //   // --- Functions ---

// // //   Future<Map<String, String>> getHeaders() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return {
// // //       "Authorization": "Bearer ${prefs.getString("token")}",
// // //       "Content-Type": "application/json",
// // //       "Accept": "application/json",
// // //     };
// // //   }

// // //   Future fetchPartners() async {
// // //     final res = await http.get(
// // //       Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
// // //       headers: await getHeaders(),
// // //     );
// // //     if (res.statusCode == 200)
// // //       setState(
// // //         () => partners =
// // //             (jsonDecode(res.body) is List
// // //                 ? jsonDecode(res.body)
// // //                 : jsonDecode(res.body)['data']) ??
// // //             [],
// // //       );
// // //   }

// // //   Future fetchWarehouses() async {
// // //     final res = await http.get(
// // //       Uri.parse(ApiEndpoints.getWarehouses),
// // //       headers: await getHeaders(),
// // //     );
// // //     if (res.statusCode == 200)
// // //       setState(
// // //         () => warehouses =
// // //             (jsonDecode(res.body) is List
// // //                 ? jsonDecode(res.body)
// // //                 : jsonDecode(res.body)['data']) ??
// // //             [],
// // //       );
// // //   }

// // //   Future fetchAllProducts() async {
// // //     // جلب المنتجات لتعريف الصنف الذي سنشتريه
// // //     final res = await http.get(
// // //       Uri.parse("${ApiEndpoints.baseUrl}/products"),
// // //       headers: await getHeaders(),
// // //     );
// // //     if (res.statusCode == 200)
// // //       setState(() => _allProducts = jsonDecode(res.body));
// // //   }

// // //   Future<void> submitTransaction() async {
// // //     try {
// // //       if (selectedPartner == null || _selectedProduct == null)
// // //         throw Exception("أكمل بيانات المورد والبضاعة");

// // //       double totalQty = double.tryParse(_totalQuantityController.text) ?? 0;
// // //       double distributedQty = 0;
// // //       List allocations = [];

// // //       for (int i = 0; i < _selectedWarehouses.length; i++) {
// // //         double qty = double.tryParse(_distributionControllers[i].text) ?? 0;
// // //         if (_selectedWarehouses[i] != null && qty > 0) {
// // //           distributedQty += qty;
// // //           allocations.add({
// // //             "warehouse_id": _selectedWarehouses[i]!['id'],
// // //             "quantity": qty,
// // //           });
// // //         }
// // //       }

// // //       if (distributedQty != totalQty)
// // //         throw Exception(
// // //           "مجموع الكميات الموزعة ($distributedQty) لا يساوي الكمية المشتراة ($totalQty)",
// // //         );

// // //       final body = {
// // //         "partner_id": selectedPartner!['id'],
// // //         "purchase_date": DateTime.now().toString().substring(0, 10),
// // //         "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
// // //         "items": [
// // //           {
// // //             "product_id": _selectedProduct!['id'],
// // //             "quantity": totalQty,
// // //             "unit_price": double.tryParse(_purchasePriceController.text) ?? 0,
// // //             "sale_price": double.tryParse(_salePriceController.text) ?? 0,
// // //             "allocations": allocations,
// // //           },
// // //         ],
// // //       };

// // //       final response = await http.post(
// // //         Uri.parse(ApiEndpoints.addpurchase),
// // //         headers: await getHeaders(),
// // //         body: jsonEncode(body),
// // //       );

// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         Navigator.pop(context);
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text("تم الشراء والتوزيع بنجاح")),
// // //         );
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(
// // //         context,
// // //       ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         backgroundColor: primaryBlue,
// // //         title: const Text(
// // //           "شراء وتوزيع بضاعة",
// // //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // //         ),
// // //         centerTitle: true,
// // //       ),
// // //       body: Directionality(
// // //         textDirection: TextDirection.rtl,
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.all(20),
// // //           child: Column(
// // //             children: [
// // //               // 1. المورد
// // //               _buildSectionCard(
// // //                 title: "بيانات المورد",
// // //                 icon: Icons.person_outline,
// // //                 child: Row(
// // //                   children: [
// // //                     Expanded(
// // //                       child: _customDropdown(
// // //                         "اختر المورد",
// // //                         partners,
// // //                         selectedPartner,
// // //                         (v) => setState(() => selectedPartner = v),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 10),
// // //                     _buildAddButton(
// // //                       Icons.person_add_alt_1,
// // //                       () {},
// // //                     ), // دالة إضافة المورد موجودة سابقاً
// // //                   ],
// // //                 ),
// // //               ),

// // //               // 2. تفاصيل البضاعة المشتراة
// // //               _buildSectionCard(
// // //                 title: "تفاصيل البضاعة المشتراة",
// // //                 icon: Icons.shopping_bag_outlined,
// // //                 child: Column(
// // //                   children: [
// // //                     _customDropdown(
// // //                       "اختر المنتج المشتري",
// // //                       _allProducts,
// // //                       _selectedProduct,
// // //                       (v) => setState(() => _selectedProduct = v),
// // //                     ),
// // //                     const SizedBox(height: 15),
// // //                     _customTextField(
// // //                       "الكمية الكلية المشتراة",
// // //                       _totalQuantityController,
// // //                       Icons.production_quantity_limits,
// // //                     ),
// // //                     const SizedBox(height: 15),
// // //                     Row(
// // //                       children: [
// // //                         Expanded(
// // //                           child: _customTextField(
// // //                             "سعر الشراء",
// // //                             _purchasePriceController,
// // //                             Icons.download,
// // //                           ),
// // //                         ),
// // //                         const SizedBox(width: 10),
// // //                         Expanded(
// // //                           child: _customTextField(
// // //                             "سعر البيع",
// // //                             _salePriceController,
// // //                             Icons.upload,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),

// // //               // 3. توزيع الكمية على المستودعات
// // //               _buildSectionCard(
// // //                 title: "توزيع البضاعة على المستودعات",
// // //                 icon: Icons.warehouse_outlined,
// // //                 child: Column(
// // //                   children: [
// // //                     ...List.generate(_selectedWarehouses.length, (index) {
// // //                       return Padding(
// // //                         padding: const EdgeInsets.only(bottom: 12),
// // //                         child: Row(
// // //                           children: [
// // //                             Expanded(
// // //                               flex: 2,
// // //                               child: _customDropdown(
// // //                                 "المستودع",
// // //                                 warehouses,
// // //                                 _selectedWarehouses[index],
// // //                                 (v) => setState(
// // //                                   () => _selectedWarehouses[index] = v,
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                             const SizedBox(width: 8),
// // //                             Expanded(
// // //                               flex: 1,
// // //                               child: _customTextField(
// // //                                 "الكمية",
// // //                                 _distributionControllers[index],
// // //                                 Icons.pie_chart_outline,
// // //                               ),
// // //                             ),
// // //                             IconButton(
// // //                               icon: Icon(
// // //                                 index == 0
// // //                                     ? Icons.add_circle
// // //                                     : Icons.remove_circle,
// // //                                 color: primaryBlue,
// // //                               ),
// // //                               onPressed: () {
// // //                                 setState(() {
// // //                                   if (index == 0) {
// // //                                     _selectedWarehouses.add(null);
// // //                                     _distributionControllers.add(
// // //                                       TextEditingController(text: "0"),
// // //                                     );
// // //                                   } else {
// // //                                     _selectedWarehouses.removeAt(index);
// // //                                     _distributionControllers.removeAt(index);
// // //                                   }
// // //                                 });
// // //                               },
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       );
// // //                     }),
// // //                   ],
// // //                 ),
// // //               ),

// // //               // 4. الملخص المالي والدفع
// // //               _buildSectionCard(
// // //                 title: "طريقة الدفع",
// // //                 icon: Icons.payment,
// // //                 child: Column(
// // //                   children: [
// // //                     Row(
// // //                       children: [
// // //                         _payBtn("نقداً", "cash"),
// // //                         _payBtn("شيكات", "check"),
// // //                       ],
// // //                     ),
// // //                     if (paymentMethod == "cash") ...[
// // //                       const SizedBox(height: 15),
// // //                       _customTextField(
// // //                         "المبلغ المدفوع",
// // //                         _depositController,
// // //                         Icons.money,
// // //                       ),
// // //                     ],
// // //                     const SizedBox(height: 20),
// // //                     _buildSubmitButton(),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // --- المكونات المساعدة (نفس التصميم الخاص بك) ---
// // //   Widget _buildSectionCard({
// // //     required String title,
// // //     required IconData icon,
// // //     required Widget child,
// // //   }) {
// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       margin: const EdgeInsets.only(bottom: 20),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(20),
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Icon(icon, color: primaryBlue, size: 22),
// // //               const SizedBox(width: 8),
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(
// // //                   fontWeight: FontWeight.bold,
// // //                   fontSize: 18,
// // //                   color: primaryBlue,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //           const Divider(height: 20),
// // //           child,
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _customDropdown(
// // //     String hint,
// // //     List data,
// // //     dynamic value,
// // //     Function onChanged,
// // //   ) {
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade50,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.grey.shade200),
// // //       ),
// // //       child: DropdownButtonFormField(
// // //         value: value,
// // //         isExpanded: true,
// // //         hint: Text(hint),
// // //         items: data
// // //             .map(
// // //               (e) => DropdownMenuItem(
// // //                 value: e,
// // //                 child: Text(
// // //                   e['name'] ?? e['company_name'] ?? e['product_name'] ?? "",
// // //                 ),
// // //               ),
// // //             )
// // //             .toList(),
// // //         onChanged: (v) => onChanged(v),
// // //         decoration: const InputDecoration(border: InputBorder.none),
// // //       ),
// // //     );
// // //   }

// // //   Widget _customTextField(
// // //     String hint,
// // //     TextEditingController controller,
// // //     IconData icon,
// // //   ) {
// // //     return TextField(
// // //       controller: controller,
// // //       keyboardType: TextInputType.number,
// // //       decoration: InputDecoration(
// // //         prefixIcon: Icon(icon, color: primaryBlue),
// // //         hintText: hint,
// // //         filled: true,
// // //         fillColor: Colors.grey.shade50,
// // //         enabledBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: Colors.grey.shade200),
// // //         ),
// // //         focusedBorder: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(12),
// // //           borderSide: BorderSide(color: primaryBlue),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _payBtn(String text, String type) {
// // //     bool isSelected = paymentMethod == type;
// // //     return Expanded(
// // //       child: GestureDetector(
// // //         onTap: () => setState(() => paymentMethod = type),
// // //         child: Container(
// // //           margin: const EdgeInsets.all(4),
// // //           padding: const EdgeInsets.symmetric(vertical: 14),
// // //           decoration: BoxDecoration(
// // //             color: isSelected ? primaryBlue : Colors.white,
// // //             borderRadius: BorderRadius.circular(12),
// // //             border: Border.all(
// // //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// // //             ),
// // //           ),
// // //           child: Center(
// // //             child: Text(
// // //               text,
// // //               style: TextStyle(
// // //                 color: isSelected ? Colors.white : Colors.black87,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildSubmitButton() {
// // //     return SizedBox(
// // //       width: double.infinity,
// // //       height: 60,
// // //       child: ElevatedButton(
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: primaryBlue,
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(15),
// // //           ),
// // //         ),
// // //         onPressed: submitTransaction,
// // //         child: const Text(
// // //           "إتمام الشراء وتوزيع الكميات",
// // //           style: TextStyle(
// // //             fontSize: 18,
// // //             color: Colors.white,
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
// // //     return Container(
// // //       height: 50,
// // //       width: 50,
// // //       decoration: BoxDecoration(
// // //         color: primaryBlue,
// // //         borderRadius: BorderRadius.circular(12),
// // //       ),
// // //       child: IconButton(
// // //         icon: Icon(icon, color: Colors.white),
// // //         onPressed: onPressed,
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:intl/intl.dart' show DateFormat;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:tradeflow_app/pages/link.dart';

// // class PurchaseScreen extends StatefulWidget {
// //   const PurchaseScreen({super.key});

// //   @override
// //   State<PurchaseScreen> createState() => _PurchaseScreenState();
// // }

// // class _PurchaseScreenState extends State<PurchaseScreen> {
// //   final Color primaryBlue = const Color(0xFF4A72C2);
// //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// //   // بيانات المورد
// //   List partners = [];
// //   Map? selectedPartner;

// //   // بيانات المستودعات والمنتجات (لجلب القوائم)
// //   List warehouses = [];
// //   List _allProducts = [];

// //   // نظام تعدد المنتجات وكل منتج له توزيعاته
// //   List<Map<String, dynamic>> _purchaseItems = [
// //     {
// //       "product": null,
// //       "total_qty": TextEditingController(text: "0"),
// //       "purchase_price": TextEditingController(text: "0"),
// //       "sale_price": TextEditingController(text: "0"),
// //       "distributions": [
// //         {"warehouse": null, "qty": TextEditingController(text: "0")},
// //       ],
// //     },
// //   ];

// //   // بيانات الدفع
// //   String paymentMethod = "cash";
// //   final TextEditingController _depositController = TextEditingController(
// //     text: "0",
// //   );
// //   List<Map<String, TextEditingController>> checks = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchPartners();
// //     fetchWarehouses();
// //     fetchAllProducts();
// //   }

// //   // --- Functions ---

// //   Future<Map<String, String>> getHeaders() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return {
// //       "Authorization": "Bearer ${prefs.getString("token")}",
// //       "Content-Type": "application/json",
// //       "Accept": "application/json",
// //     };
// //   }

// //   Future fetchPartners() async {
// //     final res = await http.get(
// //       Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200)
// //       setState(
// //         () => partners =
// //             (jsonDecode(res.body) is List
// //                 ? jsonDecode(res.body)
// //                 : jsonDecode(res.body)['data']) ??
// //             [],
// //       );
// //   }

// //   Future fetchWarehouses() async {
// //     final res = await http.get(
// //       Uri.parse(ApiEndpoints.getWarehouses),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200)
// //       setState(
// //         () => warehouses =
// //             (jsonDecode(res.body) is List
// //                 ? jsonDecode(res.body)
// //                 : jsonDecode(res.body)['data']) ??
// //             [],
// //       );
// //   }

// //   Future fetchAllProducts() async {
// //     final res = await http.get(
// //       Uri.parse("${ApiEndpoints.baseUrl}/products"),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200)
// //       setState(() => _allProducts = jsonDecode(res.body));
// //   }

// //   Future addPartner(String name, String phone) async {
// //     final res = await http.post(
// //       Uri.parse(ApiEndpoints.addPartner),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "company_name": name,
// //         "phone_number": phone,
// //         "partner_type": "supplier",
// //       }),
// //     );
// //     if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
// //   }

// //   Future<void> submitTransaction() async {
// //     try {
// //       if (selectedPartner == null) throw Exception("الرجاء اختيار المورد");

// //       List itemsData = [];
// //       for (var item in _purchaseItems) {
// //         if (item['product'] == null) continue;

// //         double totalQty = double.tryParse(item['total_qty'].text) ?? 0;
// //         double distributedQty = 0;
// //         List allocations = [];

// //         for (var dist in item['distributions']) {
// //           double q = double.tryParse(dist['qty'].text) ?? 0;
// //           if (dist['warehouse'] != null && q > 0) {
// //             distributedQty += q;
// //             allocations.add({
// //               "warehouse_id": dist['warehouse']['id'],
// //               "quantity": q,
// //             });
// //           }
// //         }

// //         if (distributedQty != totalQty) {
// //           throw Exception(
// //             "خطأ في منتج ${item['product']['name']}: الكمية الموزعة لا تساوي الإجمالية",
// //           );
// //         }

// //         itemsData.add({
// //           "product_id": item['product']['id'],
// //           "quantity": totalQty,
// //           "unit_price": double.tryParse(item['purchase_price'].text) ?? 0,
// //           "sale_price": double.tryParse(item['sale_price'].text) ?? 0,
// //           "allocations": allocations,
// //         });
// //       }

// //       final body = {
// //         "partner_id": selectedPartner!['id'],
// //         "purchase_date": DateTime.now().toString().substring(0, 10),
// //         "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
// //         "items": itemsData,
// //       };

// //       final response = await http.post(
// //         Uri.parse(ApiEndpoints.addpurchase),
// //         headers: await getHeaders(),
// //         body: jsonEncode(body),
// //       );

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         Navigator.pop(context);
// //         ScaffoldMessenger.of(
// //           context,
// //         ).showSnackBar(const SnackBar(content: Text("تم الحفظ بنجاح")));
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(
// //         context,
// //       ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
// //     }
// //   }

// //   // --- UI Widgets ---

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: primaryBlue,
// //         title: const Text(
// //           "شراء وتوزيع بضاعة",
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             children: [
// //               // 1. المورد
// //               _buildSectionCard(
// //                 title: "بيانات المورد",
// //                 icon: Icons.person_outline,
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: _customDropdown(
// //                         "اختر المورد",
// //                         partners,
// //                         selectedPartner,
// //                         (v) => setState(() => selectedPartner = v),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     _buildAddButton(
// //                       Icons.person_add_alt_1,
// //                       () => showAddPartnerDialog(),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               // 2. قائمة المنتجات (نظام تعدد المنتجات)
// //               ..._purchaseItems.asMap().entries.map((entry) {
// //                 int itemIndex = entry.key;
// //                 var item = entry.value;
// //                 return _buildSectionCard(
// //                   title: "المنتج ${itemIndex + 1}",
// //                   icon: Icons.shopping_bag_outlined,
// //                   child: Column(
// //                     children: [
// //                       _customDropdown(
// //                         "اختر المنتج",
// //                         _allProducts,
// //                         item['product'],
// //                         (v) => setState(() => item['product'] = v),
// //                       ),
// //                       const SizedBox(height: 15),
// //                       _customTextField(
// //                         "الكمية الكلية",
// //                         item['total_qty'],
// //                         Icons.production_quantity_limits,
// //                       ),
// //                       const SizedBox(height: 15),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: _customTextField(
// //                               "سعر شراء",
// //                               item['purchase_price'],
// //                               Icons.download,
// //                             ),
// //                           ),
// //                           const SizedBox(width: 10),
// //                           Expanded(
// //                             child: _customTextField(
// //                               "سعر بيع",
// //                               item['sale_price'],
// //                               Icons.upload,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const Divider(height: 30),
// //                       const Text(
// //                         "توزيع الكمية على المستودعات:",
// //                         style: TextStyle(fontWeight: FontWeight.bold),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       ...List.generate(item['distributions'].length, (
// //                         distIndex,
// //                       ) {
// //                         var dist = item['distributions'][distIndex];
// //                         return Padding(
// //                           padding: const EdgeInsets.only(bottom: 8),
// //                           child: Row(
// //                             children: [
// //                               Expanded(
// //                                 flex: 2,
// //                                 child: _customDropdown(
// //                                   "المستودع",
// //                                   warehouses,
// //                                   dist['warehouse'],
// //                                   (v) => setState(() => dist['warehouse'] = v),
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 flex: 1,
// //                                 child: _customTextField(
// //                                   "الكمية",
// //                                   dist['qty'],
// //                                   Icons.pie_chart_outline,
// //                                 ),
// //                               ),
// //                               IconButton(
// //                                 icon: Icon(
// //                                   distIndex == 0
// //                                       ? Icons.add_circle_outline
// //                                       : Icons.remove_circle_outline,
// //                                   color: primaryBlue,
// //                                 ),
// //                                 onPressed: () {
// //                                   setState(() {
// //                                     if (distIndex == 0) {
// //                                       item['distributions'].add({
// //                                         "warehouse": null,
// //                                         "qty": TextEditingController(text: "0"),
// //                                       });
// //                                     } else {
// //                                       item['distributions'].removeAt(distIndex);
// //                                     }
// //                                   });
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                         );
// //                       }),
// //                       if (itemIndex > 0)
// //                         TextButton.icon(
// //                           onPressed: () => setState(
// //                             () => _purchaseItems.removeAt(itemIndex),
// //                           ),
// //                           icon: const Icon(Icons.delete, color: Colors.red),
// //                           label: const Text(
// //                             "حذف هذا المنتج",
// //                             style: TextStyle(color: Colors.red),
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 );
// //               }),

// //               // زر إضافة منتج جديد
// //               ElevatedButton.icon(
// //                 onPressed: () => setState(
// //                   () => _purchaseItems.add({
// //                     "product": null,
// //                     "total_qty": TextEditingController(text: "0"),
// //                     "purchase_price": TextEditingController(text: "0"),
// //                     "sale_price": TextEditingController(text: "0"),
// //                     "distributions": [
// //                       {
// //                         "warehouse": null,
// //                         "qty": TextEditingController(text: "0"),
// //                       },
// //                     ],
// //                   }),
// //                 ),
// //                 icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
// //                 label: const Text(
// //                   "إضافة منتج آخر للفاتورة",
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.green,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 20),

// //               // 3. طريقة الدفع والشيكات (تم إعادتها كما كانت)
// //               _buildSectionCard(
// //                 title: "طريقة الدفع",
// //                 icon: Icons.payment_outlined,
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       children: [
// //                         _payBtn("نقداً", "cash"),
// //                         _payBtn("شيكات", "check"),
// //                       ],
// //                     ),
// //                     if (paymentMethod == "cash") ...[
// //                       const SizedBox(height: 15),
// //                       _customTextField(
// //                         "المبلغ المدفوع",
// //                         _depositController,
// //                         Icons.money,
// //                       ),
// //                     ],
// //                     if (paymentMethod == "check") _buildChecksSection(),
// //                     const SizedBox(height: 20),
// //                     _buildSubmitButton(),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // --- Helpers ---
// //   Widget _buildSectionCard({
// //     required String title,
// //     required IconData icon,
// //     required Widget child,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       margin: const EdgeInsets.only(bottom: 20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, color: primaryBlue, size: 22),
// //               const SizedBox(width: 8),
// //               Text(
// //                 title,
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 18,
// //                   color: primaryBlue,
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const Divider(height: 20),
// //           child,
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _customDropdown(
// //     String hint,
// //     List data,
// //     dynamic value,
// //     Function onChanged,
// //   ) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: DropdownButtonFormField(
// //         value: value,
// //         isExpanded: true,
// //         hint: Text(hint),
// //         items: data
// //             .map(
// //               (e) => DropdownMenuItem(
// //                 value: e,
// //                 child: Text(
// //                   e['name'] ?? e['company_name'] ?? e['product_name'] ?? "",
// //                 ),
// //               ),
// //             )
// //             .toList(),
// //         onChanged: (v) => onChanged(v),
// //         decoration: const InputDecoration(border: InputBorder.none),
// //       ),
// //     );
// //   }

// //   Widget _customTextField(
// //     String hint,
// //     TextEditingController controller,
// //     IconData icon,
// //   ) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: TextInputType.number,
// //       style: const TextStyle(fontWeight: FontWeight.bold),
// //       decoration: InputDecoration(
// //         prefixIcon: Icon(icon, color: primaryBlue),
// //         hintText: hint,
// //         filled: true,
// //         fillColor: Colors.grey.shade50,
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: Colors.grey.shade200),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(12),
// //           borderSide: BorderSide(color: primaryBlue),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _payBtn(String text, String type) {
// //     bool isSelected = paymentMethod == type;
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: () => setState(() => paymentMethod = type),
// //         child: Container(
// //           margin: const EdgeInsets.all(4),
// //           padding: const EdgeInsets.symmetric(vertical: 14),
// //           decoration: BoxDecoration(
// //             color: isSelected ? primaryBlue : Colors.white,
// //             borderRadius: BorderRadius.circular(12),
// //             border: Border.all(
// //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// //             ),
// //           ),
// //           child: Center(
// //             child: Text(
// //               text,
// //               style: TextStyle(
// //                 color: isSelected ? Colors.white : Colors.black87,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildChecksSection() {
// //     return Column(
// //       children: [
// //         ...checks.asMap().entries.map((entry) {
// //           int index = entry.key;
// //           var c = entry.value;
// //           return Container(
// //             margin: const EdgeInsets.only(top: 10),
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               border: Border.all(color: primaryBlue),
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: _customTextField(
// //                         "البنك",
// //                         c['bank']!,
// //                         Icons.account_balance,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       child: _customTextField(
// //                         "رقم الشيك",
// //                         c['number']!,
// //                         Icons.numbers,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: _customTextField(
// //                         "القيمة",
// //                         c['amount']!,
// //                         Icons.attach_money,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       child: _customTextField(
// //                         "التاريخ",
// //                         c['date']!,
// //                         Icons.date_range,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 IconButton(
// //                   icon: const Icon(Icons.delete, color: Colors.red),
// //                   onPressed: () => setState(() => checks.removeAt(index)),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }),
// //         TextButton.icon(
// //           onPressed: () => setState(
// //             () => checks.add({
// //               "bank": TextEditingController(),
// //               "number": TextEditingController(),
// //               "amount": TextEditingController(),
// //               "date": TextEditingController(),
// //             }),
// //           ),
// //           icon: const Icon(Icons.add),
// //           label: const Text("إضافة شيك"),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _buildSubmitButton() {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 60,
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: primaryBlue,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(15),
// //           ),
// //         ),
// //         onPressed: submitTransaction,
// //         child: const Text(
// //           "حفظ فاتورة الشراء والتوزيع",
// //           style: TextStyle(
// //             fontSize: 18,
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
// //     return Container(
// //       height: 50,
// //       width: 50,
// //       decoration: BoxDecoration(
// //         color: primaryBlue,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: IconButton(
// //         icon: Icon(icon, color: Colors.white),
// //         onPressed: onPressed,
// //       ),
// //     );
// //   }

// //   void showAddPartnerDialog() {
// //     TextEditingController name = TextEditingController();
// //     TextEditingController phone = TextEditingController();
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: const Text("إضافة مورد جديد"),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             _customTextField("اسم المورد", name, Icons.business),
// //             const SizedBox(height: 10),
// //             _customTextField("رقم الهاتف", phone, Icons.phone),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("إلغاء"),
// //           ),
// //           ElevatedButton(
// //             onPressed: () async {
// //               await addPartner(name.text, phone.text);
// //               Navigator.pop(context);
// //             },
// //             child: const Text("حفظ"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart' show DateFormat;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/link.dart';

// class PurchaseScreen extends StatefulWidget {
//   const PurchaseScreen({super.key});

//   @override
//   State<PurchaseScreen> createState() => _PurchaseScreenState();
// }

// class _PurchaseScreenState extends State<PurchaseScreen> {
//   final Color primaryBlue = const Color(0xFF4A72C2);
//   final Color bgGradientStart = const Color(0xFFF0F4F8);

//   List partners = [];
//   Map? selectedPartner;
//   List warehouses = [];
//   List _allProducts = [];

//   List<Map<String, dynamic>> _purchaseItems = [
//     {
//       "product": null,
//       "is_new": false, // متغير لتحديد ما إذا كان المنتج جديداً يدوياً
//       "new_product_name":
//           TextEditingController(), // وحدة تحكم لاسم المنتج الجديد
//       "total_qty": TextEditingController(text: "0"),
//       "purchase_price": TextEditingController(text: "0"),
//       "sale_price": TextEditingController(text: "0"),
//       "distributions": [
//         {"warehouse": null, "qty": TextEditingController(text: "0")},
//       ],
//     },
//   ];

//   String paymentMethod = "cash";
//   final TextEditingController _depositController = TextEditingController(
//     text: "0",
//   );
//   List<Map<String, TextEditingController>> checks = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPartners();
//     fetchWarehouses();
//     fetchAllProducts();
//   }

//   Future<Map<String, String>> getHeaders() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       "Authorization": "Bearer ${prefs.getString("token")}",
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };
//   }

//   Future fetchPartners() async {
//     final res = await http.get(
//       Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
//       headers: await getHeaders(),
//     );
//     if (res.statusCode == 200)
//       setState(
//         () => partners =
//             (jsonDecode(res.body) is List
//                 ? jsonDecode(res.body)
//                 : jsonDecode(res.body)['data']) ??
//             [],
//       );
//   }

//   Future fetchWarehouses() async {
//     final res = await http.get(
//       Uri.parse(ApiEndpoints.getWarehouses),
//       headers: await getHeaders(),
//     );
//     if (res.statusCode == 200)
//       setState(
//         () => warehouses =
//             (jsonDecode(res.body) is List
//                 ? jsonDecode(res.body)
//                 : jsonDecode(res.body)['data']) ??
//             [],
//       );
//   }

//   Future fetchAllProducts() async {
//     final res = await http.get(
//       Uri.parse("${ApiEndpoints.baseUrl}/products"),
//       headers: await getHeaders(),
//     );
//     if (res.statusCode == 200)
//       setState(() => _allProducts = jsonDecode(res.body));
//   }

//   Future addPartner(String name, String phone) async {
//     final res = await http.post(
//       Uri.parse(ApiEndpoints.addPartner),
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "company_name": name,
//         "phone_number": phone,
//         "partner_type": "supplier",
//       }),
//     );
//     if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
//   }

//   Future<void> submitTransaction() async {
//     try {
//       if (selectedPartner == null) throw Exception("الرجاء اختيار المورد");

//       List itemsData = [];
//       for (var item in _purchaseItems) {
//         if (item['product'] == null && item['new_product_name'].text.isEmpty)
//           continue;

//         double totalQty = double.tryParse(item['total_qty'].text) ?? 0;
//         double distributedQty = 0;
//         List allocations = [];

//         for (var dist in item['distributions']) {
//           double q = double.tryParse(dist['qty'].text) ?? 0;
//           if (dist['warehouse'] != null && q > 0) {
//             distributedQty += q;
//             allocations.add({
//               "warehouse_id": dist['warehouse']['id'],
//               "quantity": q,
//             });
//           }
//         }

//         if (distributedQty != totalQty) {
//           throw Exception(
//             "خطأ في الكمية الموزعة لمنتج ${item['is_new'] ? item['new_product_name'].text : item['product']['name']}",
//           );
//         }

//         itemsData.add({
//           "product_id": item['is_new'] ? null : item['product']['id'],
//           "new_product_name": item['is_new']
//               ? item['new_product_name'].text
//               : null,
//           "quantity": totalQty,
//           "unit_price": double.tryParse(item['purchase_price'].text) ?? 0,
//           "sale_price": double.tryParse(item['sale_price'].text) ?? 0,
//           "allocations": allocations,
//         });
//       }

//       final body = {
//         "partner_id": selectedPartner!['id'],
//         "purchase_date": DateTime.now().toString().substring(0, 10),
//         "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
//         "items": itemsData,
//       };

//       final response = await http.post(
//         Uri.parse(ApiEndpoints.addpurchase),
//         headers: await getHeaders(),
//         body: jsonEncode(body),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Navigator.pop(context);
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("تم الحفظ بنجاح")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         title: const Text(
//           "شراء وتوزيع بضاعة",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               _buildSectionCard(
//                 title: "بيانات المورد",
//                 icon: Icons.person_outline,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: _customDropdown(
//                         "اختر المورد",
//                         partners,
//                         selectedPartner,
//                         (v) => setState(() => selectedPartner = v),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     _buildAddButton(
//                       Icons.person_add_alt_1,
//                       () => showAddPartnerDialog(),
//                     ),
//                   ],
//                 ),
//               ),

//               ..._purchaseItems.asMap().entries.map((entry) {
//                 int itemIndex = entry.key;
//                 var item = entry.value;
//                 return _buildSectionCard(
//                   title: "المنتج ${itemIndex + 1}",
//                   icon: Icons.shopping_bag_outlined,
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: item['is_new']
//                                 ? _customTextFieldGeneral(
//                                     "اسم المنتج الجديد",
//                                     item['new_product_name'],
//                                     Icons.edit_note,
//                                     isNumeric: false,
//                                   )
//                                 : _customDropdown(
//                                     "اختر المنتج",
//                                     _allProducts,
//                                     item['product'],
//                                     (v) => setState(() => item['product'] = v),
//                                   ),
//                           ),
//                           const SizedBox(width: 10),
//                           _buildAddButton(
//                             item['is_new'] ? Icons.list : Icons.add_box,
//                             () => setState(
//                               () => item['is_new'] = !item['is_new'],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 15),
//                       _customTextFieldGeneral(
//                         "الكمية الكلية",
//                         item['total_qty'],
//                         Icons.production_quantity_limits,
//                       ),
//                       const SizedBox(height: 15),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: _customTextFieldGeneral(
//                               "سعر شراء",
//                               item['purchase_price'],
//                               Icons.download,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: _customTextFieldGeneral(
//                               "سعر بيع",
//                               item['sale_price'],
//                               Icons.text_fields,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 30),
//                       const Text(
//                         "توزيع الكمية على المستودعات:",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10),
//                       ...List.generate(item['distributions'].length, (
//                         distIndex,
//                       ) {
//                         var dist = item['distributions'][distIndex];
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 8),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: _customDropdown(
//                                   "المستودع",
//                                   warehouses,
//                                   dist['warehouse'],
//                                   (v) => setState(() => dist['warehouse'] = v),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 flex: 1,
//                                 child: _customTextFieldGeneral(
//                                   "الكمية",
//                                   dist['qty'],
//                                   Icons.pie_chart_outline,
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(
//                                   distIndex == 0
//                                       ? Icons.add_circle_outline
//                                       : Icons.remove_circle_outline,
//                                   color: primaryBlue,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     if (distIndex == 0) {
//                                       item['distributions'].add({
//                                         "warehouse": null,
//                                         "qty": TextEditingController(text: "0"),
//                                       });
//                                     } else {
//                                       item['distributions'].removeAt(distIndex);
//                                     }
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                       if (itemIndex > 0)
//                         TextButton.icon(
//                           onPressed: () => setState(
//                             () => _purchaseItems.removeAt(itemIndex),
//                           ),
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           label: const Text(
//                             "حذف هذا المنتج",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               }),

//               ElevatedButton.icon(
//                 onPressed: () => setState(
//                   () => _purchaseItems.add({
//                     "product": null,
//                     "is_new": false,
//                     "new_product_name": TextEditingController(),
//                     "total_qty": TextEditingController(text: "0"),
//                     "purchase_price": TextEditingController(text: "0"),
//                     "sale_price": TextEditingController(text: "0"),
//                     "distributions": [
//                       {
//                         "warehouse": null,
//                         "qty": TextEditingController(text: "0"),
//                       },
//                     ],
//                   }),
//                 ),
//                 icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
//                 label: const Text(
//                   "إضافة منتج آخر للفاتورة",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               _buildSectionCard(
//                 title: "طريقة الدفع",
//                 icon: Icons.payment_outlined,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         _payBtn("نقداً", "cash"),
//                         _payBtn("شيكات", "check"),
//                       ],
//                     ),
//                     if (paymentMethod == "cash") ...[
//                       const SizedBox(height: 15),
//                       _customTextFieldGeneral(
//                         "المبلغ المدفوع",
//                         _depositController,
//                         Icons.money,
//                       ),
//                     ],
//                     if (paymentMethod == "check") _buildChecksSection(),
//                     const SizedBox(height: 20),
//                     _buildSubmitButton(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- Widgets ---

//   // تم تعديل هذه الدالة لتكون عامة وتدعم النصوص أيضاً
//   Widget _customTextFieldGeneral(
//     String hint,
//     TextEditingController controller,
//     IconData icon, {
//     bool isNumeric = true,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
//       style: const TextStyle(fontWeight: FontWeight.bold),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: primaryBlue),
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.grey.shade50,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade200),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: primaryBlue),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionCard({
//     required String title,
//     required IconData icon,
//     required Widget child,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: primaryBlue, size: 22),
//               const SizedBox(width: 8),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                   color: primaryBlue,
//                 ),
//               ),
//             ],
//           ),
//           const Divider(height: 20),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget _customDropdown(
//     String hint,
//     List data,
//     dynamic value,
//     Function onChanged,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: DropdownButtonFormField(
//         value: value,
//         isExpanded: true,
//         hint: Text(hint),
//         items: data
//             .map(
//               (e) => DropdownMenuItem(
//                 value: e,
//                 child: Text(
//                   e['name'] ?? e['company_name'] ?? e['product_name'] ?? "",
//                 ),
//               ),
//             )
//             .toList(),
//         onChanged: (v) => onChanged(v),
//         decoration: const InputDecoration(border: InputBorder.none),
//       ),
//     );
//   }

//   Widget _payBtn(String text, String type) {
//     bool isSelected = paymentMethod == type;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => paymentMethod = type),
//         child: Container(
//           margin: const EdgeInsets.all(4),
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           decoration: BoxDecoration(
//             color: isSelected ? primaryBlue : Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isSelected ? primaryBlue : Colors.grey.shade300,
//             ),
//           ),
//           child: Center(
//             child: Text(
//               text,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.black87,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChecksSection() {
//     return Column(
//       children: [
//         ...checks.asMap().entries.map((entry) {
//           int index = entry.key;
//           var c = entry.value;
//           return Container(
//             margin: const EdgeInsets.only(top: 10),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               border: Border.all(color: primaryBlue),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _customTextFieldGeneral(
//                         "البنك",
//                         c['bank']!,
//                         Icons.account_balance,
//                         isNumeric: false,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _customTextFieldGeneral(
//                         "رقم الشيك",
//                         c['number']!,
//                         Icons.numbers,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _customTextFieldGeneral(
//                         "القيمة",
//                         c['amount']!,
//                         Icons.attach_money,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: _customTextFieldGeneral(
//                         "التاريخ",
//                         c['date']!,
//                         Icons.date_range,
//                         isNumeric: false,
//                       ),
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => setState(() => checks.removeAt(index)),
//                 ),
//               ],
//             ),
//           );
//         }),
//         TextButton.icon(
//           onPressed: () => setState(
//             () => checks.add({
//               "bank": TextEditingController(),
//               "number": TextEditingController(),
//               "amount": TextEditingController(),
//               "date": TextEditingController(),
//             }),
//           ),
//           icon: const Icon(Icons.add),
//           label: const Text("إضافة شيك"),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 60,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryBlue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         onPressed: submitTransaction,
//         child: const Text(
//           "حفظ فاتورة الشراء والتوزيع",
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
//     return Container(
//       height: 50,
//       width: 50,
//       decoration: BoxDecoration(
//         color: primaryBlue,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white),
//         onPressed: onPressed,
//       ),
//     );
//   }

//   void showAddPartnerDialog() {
//     TextEditingController name = TextEditingController();
//     TextEditingController phone = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("إضافة مورد جديد"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _customTextFieldGeneral(
//               "اسم المورد",
//               name,
//               Icons.business,
//               isNumeric: false,
//             ),
//             const SizedBox(height: 10),
//             _customTextFieldGeneral("رقم الهاتف", phone, Icons.phone),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("إلغاء"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await addPartner(name.text, phone.text);
//               Navigator.pop(context);
//             },
//             child: const Text("حفظ"),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final Color primaryBlue = const Color(0xFF4A72C2);
  final Color bgGradientStart = const Color(0xFFF0F4F8);

  List partners = [];
  Map? selectedPartner;
  List warehouses = [];
  List _allProducts = [];

  List<Map<String, dynamic>> _purchaseItems = [
    {
      "product": null,
      "is_new": false, // متغير لتحديد ما إذا كان المنتج جديداً يدوياً
      "new_product_name":
          TextEditingController(), // وحدة تحكم لاسم المنتج الجديد
      "total_qty": TextEditingController(text: "0"),
      "purchase_price": TextEditingController(text: "0"),
      "sale_price": TextEditingController(text: "0"),
      "distributions": [
        {"warehouse": null, "qty": TextEditingController(text: "0")},
      ],
    },
  ];

  String paymentMethod = "cash";
  final TextEditingController _depositController = TextEditingController(
    text: "0",
  );
  List<Map<String, TextEditingController>> checks = [];

  @override
  void initState() {
    super.initState();
    fetchPartners();
    fetchWarehouses();
    fetchAllProducts();
  }

  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "Authorization": "Bearer ${prefs.getString("token")}",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  Future fetchPartners() async {
    final res = await http.get(
      Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200)
      setState(
        () => partners =
            (jsonDecode(res.body) is List
                ? jsonDecode(res.body)
                : jsonDecode(res.body)['data']) ??
            [],
      );
  }

  Future fetchWarehouses() async {
    final res = await http.get(
      Uri.parse(ApiEndpoints.getWarehouses),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200)
      setState(
        () => warehouses =
            (jsonDecode(res.body) is List
                ? jsonDecode(res.body)
                : jsonDecode(res.body)['data']) ??
            [],
      );
  }

  Future fetchAllProducts() async {
    final res = await http.get(
      Uri.parse("${ApiEndpoints.baseUrl}/products"),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200)
      setState(() => _allProducts = jsonDecode(res.body));
  }

  Future addPartner(String name, String phone) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.addPartner),
      headers: await getHeaders(),
      body: jsonEncode({
        "company_name": name,
        "phone_number": phone,
        "partner_type": "supplier",
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
  }

  Future<void> submitTransaction() async {
    try {
      if (selectedPartner == null) throw Exception("الرجاء اختيار المورد");

      List itemsData = [];
      for (var item in _purchaseItems) {
        if (item['product'] == null && item['new_product_name'].text.isEmpty)
          continue;

        double totalQty = double.tryParse(item['total_qty'].text) ?? 0;
        double distributedQty = 0;
        List allocations = [];

        for (var dist in item['distributions']) {
          double q = double.tryParse(dist['qty'].text) ?? 0;
          if (dist['warehouse'] != null && q > 0) {
            distributedQty += q;
            allocations.add({
              "warehouse_id": dist['warehouse']['id'],
              "quantity": q,
            });
          }
        }

        if (distributedQty != totalQty) {
          throw Exception(
            "خطأ في الكمية الموزعة لمنتج ${item['is_new'] ? item['new_product_name'].text : item['product']['name']}",
          );
        }

        itemsData.add({
          "product_id": item['is_new'] ? null : item['product']['id'],
          "new_product_name": item['is_new']
              ? item['new_product_name'].text
              : null,
          "quantity": totalQty,
          "unit_price": double.tryParse(item['purchase_price'].text) ?? 0,
          "sale_price": double.tryParse(item['sale_price'].text) ?? 0,
          "allocations": allocations,
        });
      }

      final body = {
        "partner_id": selectedPartner!['id'],
        "purchase_date": DateTime.now().toString().substring(0, 10),
        "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
        "items": itemsData,
      };

      final response = await http.post(
        Uri.parse(ApiEndpoints.addpurchase),
        headers: await getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم الحفظ بنجاح")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          "شراء وتوزيع بضاعة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSectionCard(
                title: "بيانات المورد",
                icon: Icons.person_outline,
                child: Row(
                  children: [
                    Expanded(
                      child: _customDropdown(
                        "اختر المورد",
                        partners,
                        selectedPartner,
                        (v) => setState(() => selectedPartner = v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildAddButton(
                      Icons.person_add_alt_1,
                      () => showAddPartnerDialog(),
                    ),
                  ],
                ),
              ),

              ..._purchaseItems.asMap().entries.map((entry) {
                int itemIndex = entry.key;
                var item = entry.value;
                return _buildSectionCard(
                  title: "المنتج ${itemIndex + 1}",
                  icon: Icons.shopping_bag_outlined,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: item['is_new']
                                ? _customTextFieldGeneral(
                                    "اسم المنتج الجديد",
                                    item['new_product_name'],
                                    Icons.edit_note,
                                    isNumeric: false,
                                  )
                                : _customDropdown(
                                    "اختر المنتج",
                                    _allProducts,
                                    item['product'],
                                    (v) => setState(() => item['product'] = v),
                                  ),
                          ),
                          const SizedBox(width: 10),
                          _buildAddButton(
                            item['is_new'] ? Icons.list : Icons.add_box,
                            () => setState(
                              () => item['is_new'] = !item['is_new'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _customTextFieldGeneral(
                        "الكمية الكلية",
                        item['total_qty'],
                        Icons.production_quantity_limits,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          // تعديل خاص لحقل سعر الشراء ليظهر بدون أيقونة ونص علوي ثابت
                          Expanded(
                            child: _priceTextFieldCustom(
                              "سعر شراء",
                              item['purchase_price'],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // تعديل خاص لحقل سعر البيع ليظهر بدون أيقونة ونص علوي ثابت
                          Expanded(
                            child: _priceTextFieldCustom(
                              "سعر بيع",
                              item['sale_price'],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      const Text(
                        "توزيع الكمية على المستودعات:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...List.generate(item['distributions'].length, (
                        distIndex,
                      ) {
                        var dist = item['distributions'][distIndex];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _customDropdown(
                                  "المستودع",
                                  warehouses,
                                  dist['warehouse'],
                                  (v) => setState(() => dist['warehouse'] = v),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: _customTextFieldGeneral(
                                  "الكمية",
                                  dist['qty'],
                                  Icons.pie_chart_outline,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  distIndex == 0
                                      ? Icons.add_circle_outline
                                      : Icons.remove_circle_outline,
                                  color: primaryBlue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (distIndex == 0) {
                                      item['distributions'].add({
                                        "warehouse": null,
                                        "qty": TextEditingController(text: "0"),
                                      });
                                    } else {
                                      item['distributions'].removeAt(distIndex);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      if (itemIndex > 0)
                        TextButton.icon(
                          onPressed: () => setState(
                            () => _purchaseItems.removeAt(itemIndex),
                          ),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            "حذف هذا المنتج",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                );
              }),

              ElevatedButton.icon(
                onPressed: () => setState(
                  () => _purchaseItems.add({
                    "product": null,
                    "is_new": false,
                    "new_product_name": TextEditingController(),
                    "total_qty": TextEditingController(text: "0"),
                    "purchase_price": TextEditingController(text: "0"),
                    "sale_price": TextEditingController(text: "0"),
                    "distributions": [
                      {
                        "warehouse": null,
                        "qty": TextEditingController(text: "0"),
                      },
                    ],
                  }),
                ),
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: const Text(
                  "إضافة منتج آخر للفاتورة",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionCard(
                title: "طريقة الدفع",
                icon: Icons.payment_outlined,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _payBtn("نقداً", "cash"),
                        _payBtn("شيكات", "check"),
                      ],
                    ),
                    if (paymentMethod == "cash") ...[
                      const SizedBox(height: 15),
                      _customTextFieldGeneral(
                        "المبلغ المدفوع",
                        _depositController,
                        Icons.money,
                      ),
                    ],
                    if (paymentMethod == "check") _buildChecksSection(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---

  // حقول الأسعار الخاصة (سعر البيع والشراء) فقط تظهر بدون أيقونة ونص علوي ثابت صغبر
  Widget _priceTextFieldCustom(
    String labelText,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue),
        ),
      ),
    );
  }

  // الدالة الافتراضية كما هي لم تتغير وتحافظ على الأيقونات لباقي الحقول العامة
  Widget _customTextFieldGeneral(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isNumeric = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _customDropdown(
    String hint,
    List data,
    dynamic value,
    Function onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField(
        value: value,
        isExpanded: true,
        hint: Text(hint),
        items: data
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e['name'] ?? e['company_name'] ?? e['product_name'] ?? "",
                ),
              ),
            )
            .toList(),
        onChanged: (v) => onChanged(v),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _payBtn(String text, String type) {
    bool isSelected = paymentMethod == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => paymentMethod = type),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryBlue : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecksSection() {
    return Column(
      children: [
        ...checks.asMap().entries.map((entry) {
          int index = entry.key;
          var c = entry.value;
          return Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: primaryBlue),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _customTextFieldGeneral(
                        "البنك",
                        c['bank']!,
                        Icons.account_balance,
                        isNumeric: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _customTextFieldGeneral(
                        "رقم الشيك",
                        c['number']!,
                        Icons.numbers,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _customTextFieldGeneral(
                        "القيمة",
                        c['amount']!,
                        Icons.attach_money,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _customTextFieldGeneral(
                        "التاريخ",
                        c['date']!,
                        Icons.date_range,
                        isNumeric: false,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => checks.removeAt(index)),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => setState(
            () => checks.add({
              "bank": TextEditingController(),
              "number": TextEditingController(),
              "amount": TextEditingController(),
              "date": TextEditingController(),
            }),
          ),
          icon: const Icon(Icons.add),
          label: const Text("إضافة شيك"),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: submitTransaction,
        child: const Text(
          "حفظ فاتورة الشراء والتوزيع",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  void showAddPartnerDialog() {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("إضافة مورد جديد"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _customTextFieldGeneral(
              "اسم المورد",
              name,
              Icons.business,
              isNumeric: false,
            ),
            const SizedBox(height: 10),
            _customTextFieldGeneral("رقم الهاتف", phone, Icons.phone),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () async {
              await addPartner(name.text, phone.text);
              Navigator.pop(context);
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }
}
