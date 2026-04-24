// // // // // // // // // // // import 'dart:convert';
// // // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // // // // import 'package:tradeflow_app/pages/link.dart';

// // // // // // // // // // // class TransactionDetailsScreen extends StatefulWidget {
// // // // // // // // // // //   const TransactionDetailsScreen({super.key});

// // // // // // // // // // //   @override
// // // // // // // // // // //   State<TransactionDetailsScreen> createState() =>
// // // // // // // // // // //       _TransactionDetailsScreenState();
// // // // // // // // // // // }

// // // // // // // // // // // class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
// // // // // // // // // // //   final Color primaryBlue = const Color(0xFF446BC0);

// // // // // // // // // // //   final TextEditingController _quantityController = TextEditingController(
// // // // // // // // // // //     text: "1",
// // // // // // // // // // //   );
// // // // // // // // // // //   final TextEditingController _depositController = TextEditingController(
// // // // // // // // // // //     text: "0",
// // // // // // // // // // //   );

// // // // // // // // // // //   List partners = [];
// // // // // // // // // // //   List warehouses = [];
// // // // // // // // // // //   List products = [];

// // // // // // // // // // //   Map? selectedPartner;
// // // // // // // // // // //   Map? selectedWarehouse;
// // // // // // // // // // //   Map? selectedProduct;

// // // // // // // // // // //   double price = 0;
// // // // // // // // // // //   int paymentMethod = 0;

// // // // // // // // // // //   List<Map<String, TextEditingController>> checks = [];

// // // // // // // // // // //   @override
// // // // // // // // // // //   void initState() {
// // // // // // // // // // //     super.initState();
// // // // // // // // // // //     fetchCustomers();
// // // // // // // // // // //     fetchWarehouses();
// // // // // // // // // // //   }

// // // // // // // // // // //   // ================= HELPER =================

// // // // // // // // // // //   List parseListResponse(String body) {
// // // // // // // // // // //     final data = jsonDecode(body);
// // // // // // // // // // //     return data is List ? data : data['data'] ?? [];
// // // // // // // // // // //   }

// // // // // // // // // // //   Future<Map<String, String>> getHeaders() async {
// // // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // // //     final token = prefs.getString("token");

// // // // // // // // // // //     return {
// // // // // // // // // // //       "Authorization": "Bearer $token",
// // // // // // // // // // //       "Content-Type": "application/json",
// // // // // // // // // // //       "Accept": "application/json",
// // // // // // // // // // //     };
// // // // // // // // // // //   }

// // // // // // // // // // //   // ================= API =================

// // // // // // // // // // //   Future fetchCustomers() async {
// // // // // // // // // // //     final res = await http.get(
// // // // // // // // // // //       Uri.parse(ApiEndpoints.getPartners),
// // // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // // //     );

// // // // // // // // // // //     print("customers: ${res.body}");

// // // // // // // // // // //     if (res.statusCode == 200) {
// // // // // // // // // // //       partners = parseListResponse(res.body);
// // // // // // // // // // //       setState(() {});
// // // // // // // // // // //     }
// // // // // // // // // // //   }

// // // // // // // // // // //   Future addCustomer(String name, String phone) async {
// // // // // // // // // // //     final res = await http.post(
// // // // // // // // // // //       Uri.parse(ApiEndpoints.addPartner),
// // // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // // //       body: jsonEncode({"company_name": name, "phone_number": phone}),
// // // // // // // // // // //     );

// // // // // // // // // // //     if (res.statusCode == 200 || res.statusCode == 201) {
// // // // // // // // // // //       fetchCustomers();
// // // // // // // // // // //     }
// // // // // // // // // // //   }

// // // // // // // // // // //   Future fetchWarehouses() async {
// // // // // // // // // // //     final res = await http.get(
// // // // // // // // // // //       Uri.parse(ApiEndpoints.getWarehouses),
// // // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // // //     );

// // // // // // // // // // //     print("warehouses: ${res.body}");

// // // // // // // // // // //     if (res.statusCode == 200) {
// // // // // // // // // // //       warehouses = parseListResponse(res.body);
// // // // // // // // // // //       setState(() {});
// // // // // // // // // // //     }
// // // // // // // // // // //   }

// // // // // // // // // // //   Future fetchProducts(int warehouseId) async {
// // // // // // // // // // //     final res = await http.get(
// // // // // // // // // // //       Uri.parse(
// // // // // // // // // // //         "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/$warehouseId/storage",
// // // // // // // // // // //       ),
// // // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // // //     );

// // // // // // // // // // //     print("products: ${res.body}");

// // // // // // // // // // //     if (res.statusCode == 200) {
// // // // // // // // // // //       products = parseListResponse(res.body);
// // // // // // // // // // //       setState(() {});
// // // // // // // // // // //     }
// // // // // // // // // // //   }

// // // // // // // // // // //   Future createTransaction() async {
// // // // // // // // // // //     List checksData = checks.map((c) {
// // // // // // // // // // //       return {"number": c['number']!.text, "amount": c['amount']!.text};
// // // // // // // // // // //     }).toList();

// // // // // // // // // // //     final res = await http.post(
// // // // // // // // // // //       Uri.parse(""), // 🔥 لازم يكون معرف
// // // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // // //       body: jsonEncode({
// // // // // // // // // // //         "partner_id": selectedPartner?['id'],
// // // // // // // // // // //         "warehouse_id": selectedWarehouse?['id'],
// // // // // // // // // // //         "product_id": selectedProduct?['id'],
// // // // // // // // // // //         "quantity": _quantityController.text,
// // // // // // // // // // //         "payment_method": paymentMethod,
// // // // // // // // // // //         "deposit": _depositController.text,
// // // // // // // // // // //         "checks": checksData,
// // // // // // // // // // //       }),
// // // // // // // // // // //     );

// // // // // // // // // // //     print("transaction: ${res.body}");

// // // // // // // // // // //     if (res.statusCode == 200 || res.statusCode == 201) {
// // // // // // // // // // //       ScaffoldMessenger.of(
// // // // // // // // // // //         context,
// // // // // // // // // // //       ).showSnackBar(const SnackBar(content: Text("تمت العملية بنجاح")));
// // // // // // // // // // //     } else {
// // // // // // // // // // //       ScaffoldMessenger.of(
// // // // // // // // // // //         context,
// // // // // // // // // // //       ).showSnackBar(const SnackBar(content: Text("فشل العملية")));
// // // // // // // // // // //     }
// // // // // // // // // // //   }

// // // // // // // // // // //   // ================= UI =================

// // // // // // // // // // //   @override
// // // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // // //     double quantity = double.tryParse(_quantityController.text) ?? 1;
// // // // // // // // // // //     double totalPrice = quantity * price;
// // // // // // // // // // //     double deposit = double.tryParse(_depositController.text) ?? 0;
// // // // // // // // // // //     double remaining = totalPrice - deposit;

// // // // // // // // // // //     return Scaffold(
// // // // // // // // // // //       backgroundColor: Colors.white,
// // // // // // // // // // //       appBar: AppBar(
// // // // // // // // // // //         backgroundColor: primaryBlue,
// // // // // // // // // // //         title: const Text(
// // // // // // // // // // //           "تفاصيل البيع",
// // // // // // // // // // //           style: TextStyle(color: Colors.white),
// // // // // // // // // // //         ),
// // // // // // // // // // //         centerTitle: true,
// // // // // // // // // // //       ),
// // // // // // // // // // //       body: Directionality(
// // // // // // // // // // //         textDirection: TextDirection.rtl,
// // // // // // // // // // //         child: SingleChildScrollView(
// // // // // // // // // // //           padding: const EdgeInsets.all(20),
// // // // // // // // // // //           child: Column(
// // // // // // // // // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // // // //             children: [
// // // // // // // // // // //               _buildSectionTitle("بيانات العملية"),

// // // // // // // // // // //               _buildCustomerDropdown(),

// // // // // // // // // // //               _buildWarehouseDropdown(),

// // // // // // // // // // //               _buildProductDropdown(),

// // // // // // // // // // //               _buildCustomTextField(
// // // // // // // // // // //                 _quantityController,
// // // // // // // // // // //                 "الكمية",
// // // // // // // // // // //                 Icons.shopping_cart_outlined,
// // // // // // // // // // //               ),

// // // // // // // // // // //               const SizedBox(height: 10),

// // // // // // // // // // //               Text(
// // // // // // // // // // //                 "السعر الكلي: $totalPrice",
// // // // // // // // // // //                 style: TextStyle(
// // // // // // // // // // //                   color: primaryBlue,
// // // // // // // // // // //                   fontWeight: FontWeight.bold,
// // // // // // // // // // //                 ),
// // // // // // // // // // //               ),

// // // // // // // // // // //               const Divider(),

// // // // // // // // // // //               _buildSectionTitle("تفاصيل الدفع"),

// // // // // // // // // // //               Row(
// // // // // // // // // // //                 children: [
// // // // // // // // // // //                   _buildPaymentTypeBtn("دفع كامل", paymentMethod == 0, () {
// // // // // // // // // // //                     setState(() {
// // // // // // // // // // //                       paymentMethod = 0;
// // // // // // // // // // //                       _depositController.text = totalPrice.toString();
// // // // // // // // // // //                     });
// // // // // // // // // // //                   }),
// // // // // // // // // // //                   const SizedBox(width: 8),
// // // // // // // // // // //                   _buildPaymentTypeBtn("عربون", paymentMethod == 1, () {
// // // // // // // // // // //                     setState(() => paymentMethod = 1);
// // // // // // // // // // //                   }),
// // // // // // // // // // //                   const SizedBox(width: 8),
// // // // // // // // // // //                   _buildPaymentTypeBtn("شيكات", paymentMethod == 2, () {
// // // // // // // // // // //                     setState(() => paymentMethod = 2);
// // // // // // // // // // //                   }),
// // // // // // // // // // //                 ],
// // // // // // // // // // //               ),

// // // // // // // // // // //               const SizedBox(height: 20),

// // // // // // // // // // //               if (paymentMethod == 1)
// // // // // // // // // // //                 _buildCustomTextField(
// // // // // // // // // // //                   _depositController,
// // // // // // // // // // //                   "قيمة العربون",
// // // // // // // // // // //                   Icons.payments,
// // // // // // // // // // //                 ),

// // // // // // // // // // //               if (paymentMethod == 2) _buildChecksSection(),

// // // // // // // // // // //               const SizedBox(height: 20),

// // // // // // // // // // //               Container(
// // // // // // // // // // //                 padding: const EdgeInsets.all(15),
// // // // // // // // // // //                 decoration: BoxDecoration(
// // // // // // // // // // //                   color: primaryBlue.withOpacity(0.05),
// // // // // // // // // // //                   borderRadius: BorderRadius.circular(12),
// // // // // // // // // // //                 ),
// // // // // // // // // // //                 child: Row(
// // // // // // // // // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // // // // //                   children: [
// // // // // // // // // // //                     const Text("المتبقي:"),
// // // // // // // // // // //                     Text(
// // // // // // // // // // //                       "${paymentMethod == 0 ? 0 : remaining}",
// // // // // // // // // // //                       style: TextStyle(
// // // // // // // // // // //                         color: primaryBlue,
// // // // // // // // // // //                         fontWeight: FontWeight.bold,
// // // // // // // // // // //                       ),
// // // // // // // // // // //                     ),
// // // // // // // // // // //                   ],
// // // // // // // // // // //                 ),
// // // // // // // // // // //               ),

// // // // // // // // // // //               const SizedBox(height: 30),

// // // // // // // // // // //               _buildSubmitButton(),
// // // // // // // // // // //             ],
// // // // // // // // // // //           ),
// // // // // // // // // // //         ),
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   // ================= Widgets =================

// // // // // // // // // // //   Widget _buildCustomerDropdown() {
// // // // // // // // // // //     return Row(
// // // // // // // // // // //       children: [
// // // // // // // // // // //         Expanded(
// // // // // // // // // // //           child: _buildDropdown(
// // // // // // // // // // //             "اختر زبون",
// // // // // // // // // // //             Icons.person,
// // // // // // // // // // //             partners,
// // // // // // // // // // //             selectedPartner,
// // // // // // // // // // //             (v) => setState(() => selectedPartner = v),
// // // // // // // // // // //           ),
// // // // // // // // // // //         ),
// // // // // // // // // // //         IconButton(
// // // // // // // // // // //           icon: Icon(Icons.add, color: primaryBlue),
// // // // // // // // // // //           onPressed: showAddCustomerDialog,
// // // // // // // // // // //         ),
// // // // // // // // // // //       ],
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildWarehouseDropdown() {
// // // // // // // // // // //     return _buildDropdown(
// // // // // // // // // // //       "اختر مستودع",
// // // // // // // // // // //       Icons.warehouse,
// // // // // // // // // // //       warehouses,
// // // // // // // // // // //       selectedWarehouse,
// // // // // // // // // // //       (v) async {
// // // // // // // // // // //         selectedWarehouse = v;
// // // // // // // // // // //         await fetchProducts(v['id']);
// // // // // // // // // // //       },
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildProductDropdown() {
// // // // // // // // // // //     return _buildDropdown(
// // // // // // // // // // //       "اختر منتج",
// // // // // // // // // // //       Icons.inventory,
// // // // // // // // // // //       products,
// // // // // // // // // // //       selectedProduct,
// // // // // // // // // // //       (v) {
// // // // // // // // // // //         selectedProduct = v;
// // // // // // // // // // //         price = double.parse(v['price'].toString());
// // // // // // // // // // //         setState(() {});
// // // // // // // // // // //       },
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildDropdown(
// // // // // // // // // // //     String hint,
// // // // // // // // // // //     IconData icon,
// // // // // // // // // // //     List data,
// // // // // // // // // // //     value,
// // // // // // // // // // //     Function(dynamic) onChanged,
// // // // // // // // // // //   ) {
// // // // // // // // // // //     return Container(
// // // // // // // // // // //       margin: const EdgeInsets.only(bottom: 12),
// // // // // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 10),
// // // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // // //         color: const Color(0xFFF8FAFF),
// // // // // // // // // // //         borderRadius: BorderRadius.circular(15),
// // // // // // // // // // //       ),
// // // // // // // // // // //       child: DropdownButtonFormField(
// // // // // // // // // // //         value: value,
// // // // // // // // // // //         hint: Text(hint),
// // // // // // // // // // //         items: data.map((e) {
// // // // // // // // // // //           return DropdownMenuItem(value: e, child: Text(e['name'] ?? ""));
// // // // // // // // // // //         }).toList(),
// // // // // // // // // // //         onChanged: onChanged,
// // // // // // // // // // //         decoration: InputDecoration(
// // // // // // // // // // //           icon: Icon(icon, color: primaryBlue),
// // // // // // // // // // //           border: InputBorder.none,
// // // // // // // // // // //         ),
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildChecksSection() {
// // // // // // // // // // //     return Column(
// // // // // // // // // // //       children: [
// // // // // // // // // // //         ...checks.map((c) {
// // // // // // // // // // //           return Column(
// // // // // // // // // // //             children: [
// // // // // // // // // // //               _buildCustomTextField(
// // // // // // // // // // //                 c['number']!,
// // // // // // // // // // //                 "رقم الشيك",
// // // // // // // // // // //                 Icons.confirmation_number,
// // // // // // // // // // //               ),
// // // // // // // // // // //               _buildCustomTextField(c['amount']!, "قيمة الشيك", Icons.money),
// // // // // // // // // // //             ],
// // // // // // // // // // //           );
// // // // // // // // // // //         }),
// // // // // // // // // // //         ElevatedButton(onPressed: addCheck, child: const Text("إضافة شيك")),
// // // // // // // // // // //       ],
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildCustomTextField(
// // // // // // // // // // //     TextEditingController controller,
// // // // // // // // // // //     String hint,
// // // // // // // // // // //     IconData icon,
// // // // // // // // // // //   ) {
// // // // // // // // // // //     return Container(
// // // // // // // // // // //       margin: const EdgeInsets.only(bottom: 12),
// // // // // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 15),
// // // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // // //         color: const Color(0xFFF8FAFF),
// // // // // // // // // // //         borderRadius: BorderRadius.circular(15),
// // // // // // // // // // //       ),
// // // // // // // // // // //       child: TextField(
// // // // // // // // // // //         controller: controller,
// // // // // // // // // // //         onChanged: (_) => setState(() {}),
// // // // // // // // // // //         decoration: InputDecoration(
// // // // // // // // // // //           hintText: hint,
// // // // // // // // // // //           icon: Icon(icon, color: primaryBlue),
// // // // // // // // // // //           border: InputBorder.none,
// // // // // // // // // // //         ),
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildPaymentTypeBtn(String label, bool selected, VoidCallback onTap) {
// // // // // // // // // // //     return Expanded(
// // // // // // // // // // //       child: GestureDetector(
// // // // // // // // // // //         onTap: onTap,
// // // // // // // // // // //         child: Container(
// // // // // // // // // // //           height: 45,
// // // // // // // // // // //           margin: const EdgeInsets.only(bottom: 10),
// // // // // // // // // // //           decoration: BoxDecoration(
// // // // // // // // // // //             color: selected ? const Color(0xFFE8EFFF) : Colors.white,
// // // // // // // // // // //             borderRadius: BorderRadius.circular(10),
// // // // // // // // // // //             border: Border.all(color: primaryBlue),
// // // // // // // // // // //           ),
// // // // // // // // // // //           child: Center(child: Text(label)),
// // // // // // // // // // //         ),
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildSubmitButton() {
// // // // // // // // // // //     return SizedBox(
// // // // // // // // // // //       width: double.infinity,
// // // // // // // // // // //       height: 55,
// // // // // // // // // // //       child: ElevatedButton(
// // // // // // // // // // //         onPressed: createTransaction,
// // // // // // // // // // //         style: ElevatedButton.styleFrom(
// // // // // // // // // // //           backgroundColor: primaryBlue,
// // // // // // // // // // //           shape: RoundedRectangleBorder(
// // // // // // // // // // //             borderRadius: BorderRadius.circular(15),
// // // // // // // // // // //           ),
// // // // // // // // // // //         ),
// // // // // // // // // // //         child: const Text("إتمام العملية", style: TextStyle(fontSize: 18)),
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   Widget _buildSectionTitle(String title) {
// // // // // // // // // // //     return Padding(
// // // // // // // // // // //       padding: const EdgeInsets.only(bottom: 12),
// // // // // // // // // // //       child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
// // // // // // // // // // //     );
// // // // // // // // // // //   }

// // // // // // // // // // //   // ================= Helpers =================

// // // // // // // // // // //   void addCheck() {
// // // // // // // // // // //     checks.add({
// // // // // // // // // // //       "number": TextEditingController(),
// // // // // // // // // // //       "amount": TextEditingController(),
// // // // // // // // // // //     });
// // // // // // // // // // //     setState(() {});
// // // // // // // // // // //   }

// // // // // // // // // // //   void showAddCustomerDialog() {
// // // // // // // // // // //     TextEditingController name = TextEditingController();
// // // // // // // // // // //     TextEditingController phone = TextEditingController();

// // // // // // // // // // //     showDialog(
// // // // // // // // // // //       context: context,
// // // // // // // // // // //       builder: (_) => AlertDialog(
// // // // // // // // // // //         title: const Text("إضافة زبون"),
// // // // // // // // // // //         content: Column(
// // // // // // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // // // // // //           children: [
// // // // // // // // // // //             TextField(controller: name),
// // // // // // // // // // //             TextField(controller: phone),
// // // // // // // // // // //           ],
// // // // // // // // // // //         ),
// // // // // // // // // // //         actions: [
// // // // // // // // // // //           TextButton(
// // // // // // // // // // //             onPressed: () async {
// // // // // // // // // // //               await addCustomer(name.text, phone.text);
// // // // // // // // // // //               Navigator.pop(context);
// // // // // // // // // // //             },
// // // // // // // // // // //             child: const Text("حفظ"),
// // // // // // // // // // //           ),
// // // // // // // // // // //         ],
// // // // // // // // // // //       ),
// // // // // // // // // // //     );
// // // // // // // // // // //   }
// // // // // // // // // // // }

// // // // // // // // // // import 'dart:convert';
// // // // // // // // // // import 'dart:ui';
// // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // // // import 'package:tradeflow_app/pages/link.dart';

// // // // // // // // // // class TransactionDetailsScreen extends StatefulWidget {
// // // // // // // // // //   const TransactionDetailsScreen({super.key, required bool isSale});

// // // // // // // // // //   @override
// // // // // // // // // //   State<TransactionDetailsScreen> createState() =>
// // // // // // // // // //       _TransactionDetailsScreenState();
// // // // // // // // // // }

// // // // // // // // // // class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
// // // // // // // // // //   // الألوان الأساسية - تم تعديل primaryBlue ليتوافق مع الصورة
// // // // // // // // // //   final Color primaryBlue = const Color(0xFF4A72C2);
// // // // // // // // // //   final Color accentBlue = const Color(0xFF3B82F6);
// // // // // // // // // //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// // // // // // // // // //   final TextEditingController _quantityController = TextEditingController(
// // // // // // // // // //     text: "1",
// // // // // // // // // //   );
// // // // // // // // // //   final TextEditingController _depositController = TextEditingController(
// // // // // // // // // //     text: "0",
// // // // // // // // // //   );

// // // // // // // // // //   List partners = [];
// // // // // // // // // //   List warehouses = [];
// // // // // // // // // //   List products = [];

// // // // // // // // // //   Map? selectedPartner;
// // // // // // // // // //   Map? selectedWarehouse;
// // // // // // // // // //   Map? selectedProduct;

// // // // // // // // // //   double price = 0;
// // // // // // // // // //   int paymentMethod = 0;
// // // // // // // // // //   List<Map<String, TextEditingController>> checks = [];

// // // // // // // // // //   @override
// // // // // // // // // //   void initState() {
// // // // // // // // // //     super.initState();
// // // // // // // // // //     fetchCustomers();
// // // // // // // // // //     fetchWarehouses();
// // // // // // // // // //   }

// // // // // // // // // //   // [دوال الـ API والـ Helpers كما هي دون تعديل]
// // // // // // // // // //   List parseListResponse(String body) {
// // // // // // // // // //     final data = jsonDecode(body);
// // // // // // // // // //     return data is List ? data : data['data'] ?? [];
// // // // // // // // // //   }

// // // // // // // // // //   Future<Map<String, String>> getHeaders() async {
// // // // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // // // //     final token = prefs.getString("token");
// // // // // // // // // //     return {
// // // // // // // // // //       "Authorization": "Bearer $token",
// // // // // // // // // //       "Content-Type": "application/json",
// // // // // // // // // //       "Accept": "application/json",
// // // // // // // // // //     };
// // // // // // // // // //   }

// // // // // // // // // //   Future fetchCustomers() async {
// // // // // // // // // //     final res = await http.get(
// // // // // // // // // //       Uri.parse(ApiEndpoints.getPartners),
// // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // //     );
// // // // // // // // // //     if (res.statusCode == 200) {
// // // // // // // // // //       setState(() => partners = parseListResponse(res.body));
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   Future addCustomer(String name, String phone) async {
// // // // // // // // // //     final res = await http.post(
// // // // // // // // // //       Uri.parse(ApiEndpoints.addPartner),
// // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // //       body: jsonEncode({
// // // // // // // // // //         "company_name": name,
// // // // // // // // // //         "phone_number": phone,
// // // // // // // // // //         "partner_type": "customer",
// // // // // // // // // //       }),
// // // // // // // // // //     );
// // // // // // // // // //     if (res.statusCode == 200 || res.statusCode == 201) fetchCustomers();
// // // // // // // // // //   }

// // // // // // // // // //   Future fetchWarehouses() async {
// // // // // // // // // //     final res = await http.get(
// // // // // // // // // //       Uri.parse(ApiEndpoints.getWarehouses),
// // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // //     );
// // // // // // // // // //     if (res.statusCode == 200) {
// // // // // // // // // //       setState(() => warehouses = parseListResponse(res.body));
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   Future fetchProducts(int warehouseId) async {
// // // // // // // // // //     final res = await http.get(
// // // // // // // // // //       Uri.parse(
// // // // // // // // // //         "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/$warehouseId/storage",
// // // // // // // // // //       ),
// // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // //     );
// // // // // // // // // //     if (res.statusCode == 200) {
// // // // // // // // // //       setState(() => products = parseListResponse(res.body));
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   Future createTransaction() async {
// // // // // // // // // //     List checksData = checks
// // // // // // // // // //         .map((c) => {"number": c['number']!.text, "amount": c['amount']!.text})
// // // // // // // // // //         .toList();
// // // // // // // // // //     final quantity = double.tryParse(_quantityController.text) ?? 1;
// // // // // // // // // //     final totalPrice = quantity * price;

// // // // // // // // // //     final res = await http.post(
// // // // // // // // // //       Uri.parse(""),
// // // // // // // // // //       headers: await getHeaders(),
// // // // // // // // // //       body: jsonEncode({
// // // // // // // // // //         "partner_id": selectedPartner?['id'],
// // // // // // // // // //         "warehouse_id": selectedWarehouse?['id'],
// // // // // // // // // //         "product_id": selectedProduct?['id'],
// // // // // // // // // //         "quantity": quantity,
// // // // // // // // // //         "unit_price": price,
// // // // // // // // // //         "total_price": totalPrice,
// // // // // // // // // //         "payment_method": paymentMethod,
// // // // // // // // // //         "deposit": _depositController.text,
// // // // // // // // // //         "checks": checksData,
// // // // // // // // // //       }),
// // // // // // // // // //     );

// // // // // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // // // //       SnackBar(
// // // // // // // // // //         content: Text(
// // // // // // // // // //           res.statusCode == 200 || res.statusCode == 201
// // // // // // // // // //               ? "تمت العملية بنجاح"
// // // // // // // // // //               : "فشل العملية",
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   @override
// // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // //     double quantity = double.tryParse(_quantityController.text) ?? 1;
// // // // // // // // // //     double totalPrice = quantity * price;
// // // // // // // // // //     double deposit = double.tryParse(_depositController.text) ?? 0;
// // // // // // // // // //     double remaining = totalPrice - deposit;

// // // // // // // // // //     return Scaffold(
// // // // // // // // // //       // تم إلغاء extendBodyBehindAppBar ليكون اللون سادة وواضح خلف الأيقونات
// // // // // // // // // //       extendBodyBehindAppBar: false,
// // // // // // // // // //       appBar: AppBar(
// // // // // // // // // //         elevation: 0,
// // // // // // // // // //         backgroundColor: primaryBlue, // لون أزرق سادة
// // // // // // // // // //         title: const Text(
// // // // // // // // // //           "تفاصيل العملية",
// // // // // // // // // //           style: TextStyle(
// // // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // // //             color: Colors.white,
// // // // // // // // // //             fontSize: 22,
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //         centerTitle: true,
// // // // // // // // // //         leading: IconButton(
// // // // // // // // // //           icon: const Icon(Icons.arrow_back, color: Colors.white),
// // // // // // // // // //           onPressed: () => Navigator.pop(context),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //       body: Container(
// // // // // // // // // //         decoration: BoxDecoration(color: bgGradientStart),
// // // // // // // // // //         child: Directionality(
// // // // // // // // // //           textDirection: TextDirection.rtl,
// // // // // // // // // //           child: SingleChildScrollView(
// // // // // // // // // //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// // // // // // // // // //             child: Column(
// // // // // // // // // //               children: [
// // // // // // // // // //                 _buildSectionCard(
// // // // // // // // // //                   title: "بيانات الأطراف",
// // // // // // // // // //                   icon: Icons.person_outline,
// // // // // // // // // //                   child: Column(
// // // // // // // // // //                     children: [
// // // // // // // // // //                       Row(
// // // // // // // // // //                         children: [
// // // // // // // // // //                           Expanded(
// // // // // // // // // //                             child: _customDropdown(
// // // // // // // // // //                               "الزبون",
// // // // // // // // // //                               partners,
// // // // // // // // // //                               selectedPartner,
// // // // // // // // // //                               (v) => setState(() => selectedPartner = v),
// // // // // // // // // //                             ),
// // // // // // // // // //                           ),
// // // // // // // // // //                           const SizedBox(width: 10),
// // // // // // // // // //                           _buildAddButton(showAddCustomerDialog),
// // // // // // // // // //                         ],
// // // // // // // // // //                       ),
// // // // // // // // // //                       const SizedBox(height: 15),
// // // // // // // // // //                       _customDropdown(
// // // // // // // // // //                         "المستودع",
// // // // // // // // // //                         warehouses,
// // // // // // // // // //                         selectedWarehouse,
// // // // // // // // // //                         (v) async {
// // // // // // // // // //                           setState(() => selectedWarehouse = v);
// // // // // // // // // //                           await fetchProducts(v['id']);
// // // // // // // // // //                         },
// // // // // // // // // //                       ),
// // // // // // // // // //                     ],
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //                 const SizedBox(height: 20),
// // // // // // // // // //                 _buildSectionCard(
// // // // // // // // // //                   title: "تفاصيل البضاعة",
// // // // // // // // // //                   icon: Icons.inventory_2_outlined,
// // // // // // // // // //                   child: Column(
// // // // // // // // // //                     children: [
// // // // // // // // // //                       _customDropdown(
// // // // // // // // // //                         "اختر المنتج",
// // // // // // // // // //                         products,
// // // // // // // // // //                         selectedProduct,
// // // // // // // // // //                         (v) {
// // // // // // // // // //                           selectedProduct = v;
// // // // // // // // // //                           price =
// // // // // // // // // //                               double.tryParse(v['sale_price'].toString()) ?? 0;
// // // // // // // // // //                           setState(() {});
// // // // // // // // // //                         },
// // // // // // // // // //                       ),
// // // // // // // // // //                       const SizedBox(height: 15),
// // // // // // // // // //                       _customTextField(
// // // // // // // // // //                         "الكمية المطلوبة",
// // // // // // // // // //                         _quantityController,
// // // // // // // // // //                         Icons.production_quantity_limits,
// // // // // // // // // //                       ),
// // // // // // // // // //                       const SizedBox(height: 20),
// // // // // // // // // //                       _buildPriceRow(
// // // // // // // // // //                         "السعر الإجمالي",
// // // // // // // // // //                         "$totalPrice د.أ",
// // // // // // // // // //                         isTotal: true,
// // // // // // // // // //                       ),
// // // // // // // // // //                     ],
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //                 const SizedBox(height: 20),
// // // // // // // // // //                 _buildSectionCard(
// // // // // // // // // //                   title: "طريقة الدفع",
// // // // // // // // // //                   icon: Icons.payment_outlined,
// // // // // // // // // //                   child: Column(
// // // // // // // // // //                     children: [
// // // // // // // // // //                       Row(
// // // // // // // // // //                         children: [
// // // // // // // // // //                           _payBtn("نقداً", 0),
// // // // // // // // // //                           _payBtn("عربون", 1),
// // // // // // // // // //                           _payBtn("شيكات", 2),
// // // // // // // // // //                         ],
// // // // // // // // // //                       ),
// // // // // // // // // //                       if (paymentMethod == 1) ...[
// // // // // // // // // //                         const SizedBox(height: 15),
// // // // // // // // // //                         _customTextField(
// // // // // // // // // //                           "قيمة العربون",
// // // // // // // // // //                           _depositController,
// // // // // // // // // //                           Icons.money,
// // // // // // // // // //                         ),
// // // // // // // // // //                       ],
// // // // // // // // // //                       if (paymentMethod == 2) _buildChecksSection(),
// // // // // // // // // //                       const Divider(height: 30),
// // // // // // // // // //                       _buildPriceRow(
// // // // // // // // // //                         "المبلغ المتبقي",
// // // // // // // // // //                         "$remaining د.أ",
// // // // // // // // // //                         color: Colors.redAccent,
// // // // // // // // // //                       ),
// // // // // // // // // //                     ],
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //                 const SizedBox(height: 30),
// // // // // // // // // //                 _buildSubmitButton(),
// // // // // // // // // //               ],
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   // وحدات بناء الواجهة (UI Components)

// // // // // // // // // //   Widget _buildSectionCard({
// // // // // // // // // //     required String title,
// // // // // // // // // //     required IconData icon,
// // // // // // // // // //     required Widget child,
// // // // // // // // // //   }) {
// // // // // // // // // //     return Container(
// // // // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // //         color: Colors.white,
// // // // // // // // // //         borderRadius: BorderRadius.circular(20),
// // // // // // // // // //         boxShadow: [
// // // // // // // // // //           BoxShadow(
// // // // // // // // // //             color: Colors.black.withOpacity(0.05),
// // // // // // // // // //             blurRadius: 15,
// // // // // // // // // //             offset: const Offset(0, 5),
// // // // // // // // // //           ),
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //       child: Column(
// // // // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // // // //         children: [
// // // // // // // // // //           Row(
// // // // // // // // // //             children: [
// // // // // // // // // //               Icon(icon, color: primaryBlue, size: 20),
// // // // // // // // // //               const SizedBox(width: 8),
// // // // // // // // // //               Text(
// // // // // // // // // //                 title,
// // // // // // // // // //                 style: TextStyle(
// // // // // // // // // //                   fontWeight: FontWeight.bold,
// // // // // // // // // //                   fontSize: 16,
// // // // // // // // // //                   color: primaryBlue,
// // // // // // // // // //                 ),
// // // // // // // // // //               ),
// // // // // // // // // //             ],
// // // // // // // // // //           ),
// // // // // // // // // //           const Padding(
// // // // // // // // // //             padding: EdgeInsets.symmetric(vertical: 8),
// // // // // // // // // //             child: Divider(),
// // // // // // // // // //           ),
// // // // // // // // // //           child,
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _customDropdown(
// // // // // // // // // //     String hint,
// // // // // // // // // //     List data,
// // // // // // // // // //     dynamic value,
// // // // // // // // // //     Function onChanged,
// // // // // // // // // //   ) {
// // // // // // // // // //     return Container(
// // // // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // //         color: Colors.grey.shade50,
// // // // // // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // // // // // //         border: Border.all(color: Colors.grey.shade200),
// // // // // // // // // //       ),
// // // // // // // // // //       child: DropdownButtonFormField(
// // // // // // // // // //         value: value,
// // // // // // // // // //         hint: Text(hint, style: const TextStyle(fontSize: 14)),
// // // // // // // // // //         isExpanded: true,
// // // // // // // // // //         items: data
// // // // // // // // // //             .map(
// // // // // // // // // //               (e) => DropdownMenuItem(
// // // // // // // // // //                 value: e,
// // // // // // // // // //                 child: Text(e['company_name'] ?? e['name'] ?? ""),
// // // // // // // // // //               ),
// // // // // // // // // //             )
// // // // // // // // // //             .toList(),
// // // // // // // // // //         onChanged: (v) => onChanged(v),
// // // // // // // // // //         decoration: const InputDecoration(border: InputBorder.none),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _customTextField(
// // // // // // // // // //     String hint,
// // // // // // // // // //     TextEditingController controller,
// // // // // // // // // //     IconData icon,
// // // // // // // // // //   ) {
// // // // // // // // // //     return TextField(
// // // // // // // // // //       controller: controller,
// // // // // // // // // //       keyboardType: TextInputType.number,
// // // // // // // // // //       onChanged: (_) => setState(() {}),
// // // // // // // // // //       decoration: InputDecoration(
// // // // // // // // // //         prefixIcon: Icon(icon, size: 20, color: primaryBlue),
// // // // // // // // // //         hintText: hint,
// // // // // // // // // //         filled: true,
// // // // // // // // // //         fillColor: Colors.grey.shade50,
// // // // // // // // // //         contentPadding: const EdgeInsets.symmetric(
// // // // // // // // // //           horizontal: 16,
// // // // // // // // // //           vertical: 12,
// // // // // // // // // //         ),
// // // // // // // // // //         enabledBorder: OutlineInputBorder(
// // // // // // // // // //           borderRadius: BorderRadius.circular(12),
// // // // // // // // // //           borderSide: BorderSide(color: Colors.grey.shade200),
// // // // // // // // // //         ),
// // // // // // // // // //         focusedBorder: OutlineInputBorder(
// // // // // // // // // //           borderRadius: BorderRadius.circular(12),
// // // // // // // // // //           borderSide: BorderSide(color: primaryBlue),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildPriceRow(
// // // // // // // // // //     String label,
// // // // // // // // // //     String value, {
// // // // // // // // // //     bool isTotal = false,
// // // // // // // // // //     Color? color,
// // // // // // // // // //   }) {
// // // // // // // // // //     return Row(
// // // // // // // // // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // // // //       children: [
// // // // // // // // // //         Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
// // // // // // // // // //         Text(
// // // // // // // // // //           value,
// // // // // // // // // //           style: TextStyle(
// // // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // // //             fontSize: isTotal ? 18 : 16,
// // // // // // // // // //             color: color ?? primaryBlue,
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //       ],
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _payBtn(String text, int type) {
// // // // // // // // // //     bool isSelected = paymentMethod == type;
// // // // // // // // // //     return Expanded(
// // // // // // // // // //       child: GestureDetector(
// // // // // // // // // //         onTap: () => setState(() => paymentMethod = type),
// // // // // // // // // //         child: AnimatedContainer(
// // // // // // // // // //           duration: const Duration(milliseconds: 300),
// // // // // // // // // //           margin: const EdgeInsets.all(4),
// // // // // // // // // //           padding: const EdgeInsets.symmetric(vertical: 12),
// // // // // // // // // //           decoration: BoxDecoration(
// // // // // // // // // //             color: isSelected ? primaryBlue : Colors.white,
// // // // // // // // // //             borderRadius: BorderRadius.circular(12),
// // // // // // // // // //             border: Border.all(
// // // // // // // // // //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //           child: Center(
// // // // // // // // // //             child: Text(
// // // // // // // // // //               text,
// // // // // // // // // //               style: TextStyle(
// // // // // // // // // //                 color: isSelected ? Colors.white : Colors.black87,
// // // // // // // // // //                 fontWeight: FontWeight.bold,
// // // // // // // // // //               ),
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildChecksSection() {
// // // // // // // // // //     return Column(
// // // // // // // // // //       children: [
// // // // // // // // // //         ...checks.map(
// // // // // // // // // //           (c) => Padding(
// // // // // // // // // //             padding: const EdgeInsets.only(top: 10),
// // // // // // // // // //             child: Row(
// // // // // // // // // //               children: [
// // // // // // // // // //                 Expanded(
// // // // // // // // // //                   child: _customTextField(
// // // // // // // // // //                     "رقم الشيك",
// // // // // // // // // //                     c['number']!,
// // // // // // // // // //                     Icons.numbers,
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //                 const SizedBox(width: 8),
// // // // // // // // // //                 Expanded(
// // // // // // // // // //                   child: _customTextField(
// // // // // // // // // //                     "القيمة",
// // // // // // // // // //                     c['amount']!,
// // // // // // // // // //                     Icons.attach_money,
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ],
// // // // // // // // // //             ),
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //         TextButton.icon(
// // // // // // // // // //           onPressed: () => setState(
// // // // // // // // // //             () => checks.add({
// // // // // // // // // //               "number": TextEditingController(),
// // // // // // // // // //               "amount": TextEditingController(),
// // // // // // // // // //             }),
// // // // // // // // // //           ),
// // // // // // // // // //           icon: const Icon(Icons.add_circle_outline),
// // // // // // // // // //           label: const Text("إضافة شيك جديد"),
// // // // // // // // // //         ),
// // // // // // // // // //       ],
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildAddButton(VoidCallback onPressed) {
// // // // // // // // // //     return Container(
// // // // // // // // // //       height: 50,
// // // // // // // // // //       width: 50,
// // // // // // // // // //       decoration: BoxDecoration(
// // // // // // // // // //         color: primaryBlue,
// // // // // // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // // // // // //       ),
// // // // // // // // // //       child: IconButton(
// // // // // // // // // //         icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
// // // // // // // // // //         onPressed: onPressed,
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   Widget _buildSubmitButton() {
// // // // // // // // // //     return SizedBox(
// // // // // // // // // //       width: double.infinity,
// // // // // // // // // //       height: 55,
// // // // // // // // // //       child: ElevatedButton(
// // // // // // // // // //         style: ElevatedButton.styleFrom(
// // // // // // // // // //           backgroundColor: primaryBlue,
// // // // // // // // // //           shape: RoundedRectangleBorder(
// // // // // // // // // //             borderRadius: BorderRadius.circular(15),
// // // // // // // // // //           ),
// // // // // // // // // //           elevation: 5,
// // // // // // // // // //         ),
// // // // // // // // // //         onPressed: createTransaction,
// // // // // // // // // //         child: const Text(
// // // // // // // // // //           "إتمام العملية وحفظ الفاتورة",
// // // // // // // // // //           style: TextStyle(
// // // // // // // // // //             fontSize: 18,
// // // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // // //             color: Colors.white,
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   void showAddCustomerDialog() {
// // // // // // // // // //     TextEditingController name = TextEditingController();
// // // // // // // // // //     TextEditingController phone = TextEditingController();
// // // // // // // // // //     showDialog(
// // // // // // // // // //       context: context,
// // // // // // // // // //       builder: (_) => AlertDialog(
// // // // // // // // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // // // // // // // //         title: const Text("إضافة زبون جديد", textAlign: TextAlign.center),
// // // // // // // // // //         content: Column(
// // // // // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // // // // //           children: [
// // // // // // // // // //             _customTextField("اسم الشركة/الزبون", name, Icons.business),
// // // // // // // // // //             const SizedBox(height: 10),
// // // // // // // // // //             _customTextField("رقم الهاتف", phone, Icons.phone),
// // // // // // // // // //           ],
// // // // // // // // // //         ),
// // // // // // // // // //         actions: [
// // // // // // // // // //           TextButton(
// // // // // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // // // // //             child: const Text("إلغاء"),
// // // // // // // // // //           ),
// // // // // // // // // //           ElevatedButton(
// // // // // // // // // //             onPressed: () async {
// // // // // // // // // //               await addCustomer(name.text, phone.text);
// // // // // // // // // //               Navigator.pop(context);
// // // // // // // // // //             },
// // // // // // // // // //             child: const Text("حفظ البيانات"),
// // // // // // // // // //           ),
// // // // // // // // // //         ],
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }
// // // // // // // // // // }

// // // // // // // // import 'dart:convert';
// // // // // // // // import 'dart:ui';
// // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // // import 'package:tradeflow_app/pages/link.dart';

// // // // // // // // class TransactionDetailsScreen extends StatefulWidget {
// // // // // // // //   final bool isSale;
// // // // // // // //   const TransactionDetailsScreen({super.key, required this.isSale});

// // // // // // // //   @override
// // // // // // // //   State<TransactionDetailsScreen> createState() =>
// // // // // // // //       _TransactionDetailsScreenState();
// // // // // // // // }

// // // // // // // // class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
// // // // // // // //   final Color primaryBlue = const Color(0xFF4A72C2);
// // // // // // // //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// // // // // // // //   // المتحكمات (Controllers)
// // // // // // // //   final TextEditingController _quantityController = TextEditingController(
// // // // // // // //     text: "1",
// // // // // // // //   );
// // // // // // // //   final TextEditingController _depositController = TextEditingController(
// // // // // // // //     text: "0",
// // // // // // // //   );
// // // // // // // //   final TextEditingController _priceController = TextEditingController(
// // // // // // // //     text: "0",
// // // // // // // //   ); // متحكم السعر
// // // // // // // //   final TextEditingController _supplierInvoiceController =
// // // // // // // //       TextEditingController(); // رقم فاتورة المورد

// // // // // // // //   List partners = [];
// // // // // // // //   List warehouses = [];
// // // // // // // //   List products = [];

// // // // // // // //   Map? selectedPartner;
// // // // // // // //   Map? selectedWarehouse;
// // // // // // // //   Map? selectedProduct;

// // // // // // // //   int paymentMethod = 0;
// // // // // // // //   List<Map<String, TextEditingController>> checks = [];

// // // // // // // //   @override
// // // // // // // //   void initState() {
// // // // // // // //     super.initState();
// // // // // // // //     fetchPartners();
// // // // // // // //     fetchWarehouses();
// // // // // // // //   }

// // // // // // // //   // --- دوال الـ API ---
// // // // // // // //   List parseListResponse(String body) {
// // // // // // // //     final data = jsonDecode(body);
// // // // // // // //     return data is List ? data : data['data'] ?? [];
// // // // // // // //   }

// // // // // // // //   Future<Map<String, String>> getHeaders() async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     final token = prefs.getString("token");
// // // // // // // //     return {
// // // // // // // //       "Authorization": "Bearer $token",
// // // // // // // //       "Content-Type": "application/json",
// // // // // // // //       "Accept": "application/json",
// // // // // // // //     };
// // // // // // // //   }

// // // // // // // //   Future fetchPartners() async {
// // // // // // // //     final String type = widget.isSale ? "customer" : "supplier";
// // // // // // // //     final res = await http.get(
// // // // // // // //       Uri.parse("${ApiEndpoints.getPartners}?type=$type"),
// // // // // // // //       headers: await getHeaders(),
// // // // // // // //     );
// // // // // // // //     if (res.statusCode == 200) {
// // // // // // // //       setState(() => partners = parseListResponse(res.body));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future addPartner(String name, String phone) async {
// // // // // // // //     final res = await http.post(
// // // // // // // //       Uri.parse(ApiEndpoints.addPartner),
// // // // // // // //       headers: await getHeaders(),
// // // // // // // //       body: jsonEncode({
// // // // // // // //         "company_name": name,
// // // // // // // //         "phone_number": phone,
// // // // // // // //         "partner_type": widget.isSale ? "customer" : "supplier",
// // // // // // // //       }),
// // // // // // // //     );
// // // // // // // //     if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
// // // // // // // //   }

// // // // // // // //   Future fetchWarehouses() async {
// // // // // // // //     final res = await http.get(
// // // // // // // //       Uri.parse(ApiEndpoints.getWarehouses),
// // // // // // // //       headers: await getHeaders(),
// // // // // // // //     );
// // // // // // // //     if (res.statusCode == 200) {
// // // // // // // //       setState(() => warehouses = parseListResponse(res.body));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future fetchProducts(int warehouseId) async {
// // // // // // // //     final res = await http.get(
// // // // // // // //       Uri.parse(
// // // // // // // //         "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/$warehouseId/storage",
// // // // // // // //       ),
// // // // // // // //       headers: await getHeaders(),
// // // // // // // //     );
// // // // // // // //     if (res.statusCode == 200) {
// // // // // // // //       setState(() => products = parseListResponse(res.body));
// // // // // // // //     }
// // // // // // // //   }

// // // // // // // //   Future createTransaction() async {
// // // // // // // //     List checksData = checks
// // // // // // // //         .map((c) => {"number": c['number']!.text, "amount": c['amount']!.text})
// // // // // // // //         .toList();

// // // // // // // //     final quantity = double.tryParse(_quantityController.text) ?? 1;
// // // // // // // //     final currentPrice = double.tryParse(_priceController.text) ?? 0;

// // // // // // // //     final res = await http.post(
// // // // // // // //       Uri.parse(""), // ضع رابط الـ API هنا
// // // // // // // //       headers: await getHeaders(),
// // // // // // // //       body: jsonEncode({
// // // // // // // //         "type": widget.isSale ? "sale" : "purchase",
// // // // // // // //         "partner_id": selectedPartner?['id'],
// // // // // // // //         "warehouse_id": selectedWarehouse?['id'],
// // // // // // // //         "product_id": selectedProduct?['id'],
// // // // // // // //         "quantity": quantity,
// // // // // // // //         "unit_price": currentPrice,
// // // // // // // //         "total_price": quantity * currentPrice,
// // // // // // // //         "payment_method": paymentMethod,
// // // // // // // //         "deposit": _depositController.text,
// // // // // // // //         "checks": checksData,
// // // // // // // //         "supplier_invoice_num": !widget.isSale
// // // // // // // //             ? _supplierInvoiceController.text
// // // // // // // //             : null,
// // // // // // // //       }),
// // // // // // // //     );

// // // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // //       SnackBar(
// // // // // // // //         content: Text(
// // // // // // // //           res.statusCode == 200 || res.statusCode == 201
// // // // // // // //               ? "تمت العملية بنجاح"
// // // // // // // //               : "فشل العملية",
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   @override
// // // // // // // //   Widget build(BuildContext context) {
// // // // // // // //     // حسابات ديناميكية للواجهة
// // // // // // // //     double quantity = double.tryParse(_quantityController.text) ?? 1;
// // // // // // // //     double currentPrice = double.tryParse(_priceController.text) ?? 0;
// // // // // // // //     double totalPrice = quantity * currentPrice;
// // // // // // // //     double deposit = double.tryParse(_depositController.text) ?? 0;
// // // // // // // //     double remaining = totalPrice - deposit;

// // // // // // // //     String partnerLabel = widget.isSale ? "الزبون" : "المورد";
// // // // // // // //     String pageTitle = widget.isSale
// // // // // // // //         ? "تفاصيل عملية البيع"
// // // // // // // //         : "تفاصيل عملية الشراء";

// // // // // // // //     return Scaffold(
// // // // // // // //       appBar: AppBar(
// // // // // // // //         elevation: 0,
// // // // // // // //         backgroundColor: primaryBlue,
// // // // // // // //         title: Text(
// // // // // // // //           pageTitle,
// // // // // // // //           style: const TextStyle(
// // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // //             color: Colors.white,
// // // // // // // //             fontSize: 20,
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         centerTitle: true,
// // // // // // // //         leading: IconButton(
// // // // // // // //           icon: const Icon(Icons.arrow_back, color: Colors.white),
// // // // // // // //           onPressed: () => Navigator.pop(context),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //       body: Container(
// // // // // // // //         decoration: BoxDecoration(color: bgGradientStart),
// // // // // // // //         child: Directionality(
// // // // // // // //           textDirection: TextDirection.rtl,
// // // // // // // //           child: SingleChildScrollView(
// // // // // // // //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
// // // // // // // //             child: Column(
// // // // // // // //               children: [
// // // // // // // //                 // 1. قسم الأطراف
// // // // // // // //                 _buildSectionCard(
// // // // // // // //                   title: "بيانات الأطراف",
// // // // // // // //                   icon: Icons.person_outline,
// // // // // // // //                   child: Column(
// // // // // // // //                     children: [
// // // // // // // //                       Row(
// // // // // // // //                         children: [
// // // // // // // //                           Expanded(
// // // // // // // //                             child: _customDropdown(
// // // // // // // //                               partnerLabel,
// // // // // // // //                               partners,
// // // // // // // //                               selectedPartner,
// // // // // // // //                               (v) => setState(() => selectedPartner = v),
// // // // // // // //                             ),
// // // // // // // //                           ),
// // // // // // // //                           const SizedBox(width: 10),
// // // // // // // //                           _buildAddButton(showAddPartnerDialog),
// // // // // // // //                         ],
// // // // // // // //                       ),
// // // // // // // //                       // حقل إضافي يظهر في الشراء فقط
// // // // // // // //                       if (!widget.isSale) ...[
// // // // // // // //                         const SizedBox(height: 15),
// // // // // // // //                         _customTextField(
// // // // // // // //                           "رقم فاتورة المورد",
// // // // // // // //                           _supplierInvoiceController,
// // // // // // // //                           Icons.receipt,
// // // // // // // //                           isNumeric: false,
// // // // // // // //                         ),
// // // // // // // //                       ],
// // // // // // // //                       const SizedBox(height: 15),
// // // // // // // //                       _customDropdown(
// // // // // // // //                         "المستودع",
// // // // // // // //                         warehouses,
// // // // // // // //                         selectedWarehouse,
// // // // // // // //                         (v) async {
// // // // // // // //                           setState(() => selectedWarehouse = v);
// // // // // // // //                           await fetchProducts(v['id']);
// // // // // // // //                         },
// // // // // // // //                       ),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 20),

// // // // // // // //                 // 2. قسم البضاعة
// // // // // // // //                 _buildSectionCard(
// // // // // // // //                   title: "تفاصيل البضاعة",
// // // // // // // //                   icon: Icons.inventory_2_outlined,
// // // // // // // //                   child: Column(
// // // // // // // //                     children: [
// // // // // // // //                       _customDropdown("اختر المنتج", products, selectedProduct, (
// // // // // // // //                         v,
// // // // // // // //                       ) {
// // // // // // // //                         setState(() {
// // // // // // // //                           selectedProduct = v;
// // // // // // // //                           // إذا بيع نسحب السعر الافتراضي، إذا شراء نترك السعر للمستخدم أو نسحب آخر سعر تكلفة
// // // // // // // //                           _priceController.text = widget.isSale
// // // // // // // //                               ? (v['sale_price']?.toString() ?? "0")
// // // // // // // //                               : (v['purchase_price']?.toString() ?? "0");
// // // // // // // //                         });
// // // // // // // //                       }),
// // // // // // // //                       const SizedBox(height: 15),
// // // // // // // //                       _customTextField(
// // // // // // // //                         widget.isSale
// // // // // // // //                             ? "سعر البيع للوحدة"
// // // // // // // //                             : "سعر الشراء (التكلفة) للوحدة",
// // // // // // // //                         _priceController,
// // // // // // // //                         Icons.monetization_on_outlined,
// // // // // // // //                       ),
// // // // // // // //                       const SizedBox(height: 15),
// // // // // // // //                       _customTextField(
// // // // // // // //                         "الكمية",
// // // // // // // //                         _quantityController,
// // // // // // // //                         Icons.production_quantity_limits,
// // // // // // // //                       ),
// // // // // // // //                       const SizedBox(height: 20),
// // // // // // // //                       _buildPriceRow(
// // // // // // // //                         "السعر الإجمالي",
// // // // // // // //                         "$totalPrice د.أ",
// // // // // // // //                         isTotal: true,
// // // // // // // //                       ),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 20),

// // // // // // // //                 // 3. قسم الدفع
// // // // // // // //                 _buildSectionCard(
// // // // // // // //                   title: "طريقة الدفع",
// // // // // // // //                   icon: Icons.payment_outlined,
// // // // // // // //                   child: Column(
// // // // // // // //                     children: [
// // // // // // // //                       Row(
// // // // // // // //                         children: [
// // // // // // // //                           _payBtn("نقداً", 0),
// // // // // // // //                           _payBtn("عربون", 1),
// // // // // // // //                           _payBtn("شيكات", 2),
// // // // // // // //                         ],
// // // // // // // //                       ),
// // // // // // // //                       if (paymentMethod == 1) ...[
// // // // // // // //                         const SizedBox(height: 15),
// // // // // // // //                         _customTextField(
// // // // // // // //                           "قيمة العربون",
// // // // // // // //                           _depositController,
// // // // // // // //                           Icons.money,
// // // // // // // //                         ),
// // // // // // // //                       ],
// // // // // // // //                       if (paymentMethod == 2) _buildChecksSection(),
// // // // // // // //                       const Divider(height: 30),
// // // // // // // //                       _buildPriceRow(
// // // // // // // //                         "المبلغ المتبقي",
// // // // // // // //                         "$remaining د.أ",
// // // // // // // //                         color: Colors.redAccent,
// // // // // // // //                       ),
// // // // // // // //                     ],
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(height: 30),
// // // // // // // //                 _buildSubmitButton(),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   // --- أدوات بناء الواجهة ---

// // // // // // // //   Widget _buildSectionCard({
// // // // // // // //     required String title,
// // // // // // // //     required IconData icon,
// // // // // // // //     required Widget child,
// // // // // // // //   }) {
// // // // // // // //     return Container(
// // // // // // // //       padding: const EdgeInsets.all(16),
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: Colors.white,
// // // // // // // //         borderRadius: BorderRadius.circular(20),
// // // // // // // //         boxShadow: [
// // // // // // // //           BoxShadow(
// // // // // // // //             color: Colors.black.withOpacity(0.05),
// // // // // // // //             blurRadius: 15,
// // // // // // // //             offset: const Offset(0, 5),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //       child: Column(
// // // // // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // // //         children: [
// // // // // // // //           Row(
// // // // // // // //             children: [
// // // // // // // //               Icon(icon, color: primaryBlue, size: 20),
// // // // // // // //               const SizedBox(width: 8),
// // // // // // // //               Text(
// // // // // // // //                 title,
// // // // // // // //                 style: TextStyle(
// // // // // // // //                   fontWeight: FontWeight.bold,
// // // // // // // //                   fontSize: 16,
// // // // // // // //                   color: primaryBlue,
// // // // // // // //                 ),
// // // // // // // //               ),
// // // // // // // //             ],
// // // // // // // //           ),
// // // // // // // //           const Padding(
// // // // // // // //             padding: EdgeInsets.symmetric(vertical: 8),
// // // // // // // //             child: Divider(),
// // // // // // // //           ),
// // // // // // // //           child,
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _customDropdown(
// // // // // // // //     String hint,
// // // // // // // //     List data,
// // // // // // // //     dynamic value,
// // // // // // // //     Function onChanged,
// // // // // // // //   ) {
// // // // // // // //     return Container(
// // // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: Colors.grey.shade50,
// // // // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // // // //         border: Border.all(color: Colors.grey.shade200),
// // // // // // // //       ),
// // // // // // // //       child: DropdownButtonFormField(
// // // // // // // //         value: value,
// // // // // // // //         isExpanded: true,
// // // // // // // //         hint: Text(hint, style: const TextStyle(fontSize: 14)),
// // // // // // // //         items: data
// // // // // // // //             .map(
// // // // // // // //               (e) => DropdownMenuItem(
// // // // // // // //                 value: e,
// // // // // // // //                 child: Text(e['company_name'] ?? e['name'] ?? ""),
// // // // // // // //               ),
// // // // // // // //             )
// // // // // // // //             .toList(),
// // // // // // // //         onChanged: (v) => onChanged(v),
// // // // // // // //         decoration: const InputDecoration(border: InputBorder.none),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _customTextField(
// // // // // // // //     String hint,
// // // // // // // //     TextEditingController controller,
// // // // // // // //     IconData icon, {
// // // // // // // //     bool isNumeric = true,
// // // // // // // //   }) {
// // // // // // // //     return TextField(
// // // // // // // //       controller: controller,
// // // // // // // //       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
// // // // // // // //       onChanged: (_) => setState(() {}),
// // // // // // // //       decoration: InputDecoration(
// // // // // // // //         prefixIcon: Icon(icon, size: 20, color: primaryBlue),
// // // // // // // //         hintText: hint,
// // // // // // // //         filled: true,
// // // // // // // //         fillColor: Colors.grey.shade50,
// // // // // // // //         contentPadding: const EdgeInsets.symmetric(
// // // // // // // //           horizontal: 16,
// // // // // // // //           vertical: 12,
// // // // // // // //         ),
// // // // // // // //         enabledBorder: OutlineInputBorder(
// // // // // // // //           borderRadius: BorderRadius.circular(12),
// // // // // // // //           borderSide: BorderSide(color: Colors.grey.shade200),
// // // // // // // //         ),
// // // // // // // //         focusedBorder: OutlineInputBorder(
// // // // // // // //           borderRadius: BorderRadius.circular(12),
// // // // // // // //           borderSide: BorderSide(color: primaryBlue),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildPriceRow(
// // // // // // // //     String label,
// // // // // // // //     String value, {
// // // // // // // //     bool isTotal = false,
// // // // // // // //     Color? color,
// // // // // // // //   }) {
// // // // // // // //     return Row(
// // // // // // // //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // // // // //       children: [
// // // // // // // //         Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
// // // // // // // //         Text(
// // // // // // // //           value,
// // // // // // // //           style: TextStyle(
// // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // //             fontSize: isTotal ? 18 : 16,
// // // // // // // //             color: color ?? primaryBlue,
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _payBtn(String text, int type) {
// // // // // // // //     bool isSelected = paymentMethod == type;
// // // // // // // //     return Expanded(
// // // // // // // //       child: GestureDetector(
// // // // // // // //         onTap: () => setState(() => paymentMethod = type),
// // // // // // // //         child: AnimatedContainer(
// // // // // // // //           duration: const Duration(milliseconds: 300),
// // // // // // // //           margin: const EdgeInsets.all(4),
// // // // // // // //           padding: const EdgeInsets.symmetric(vertical: 12),
// // // // // // // //           decoration: BoxDecoration(
// // // // // // // //             color: isSelected ? primaryBlue : Colors.white,
// // // // // // // //             borderRadius: BorderRadius.circular(12),
// // // // // // // //             border: Border.all(
// // // // // // // //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //           child: Center(
// // // // // // // //             child: Text(
// // // // // // // //               text,
// // // // // // // //               style: TextStyle(
// // // // // // // //                 color: isSelected ? Colors.white : Colors.black87,
// // // // // // // //                 fontWeight: FontWeight.bold,
// // // // // // // //               ),
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildChecksSection() {
// // // // // // // //     return Column(
// // // // // // // //       children: [
// // // // // // // //         ...checks.map(
// // // // // // // //           (c) => Padding(
// // // // // // // //             padding: const EdgeInsets.only(top: 10),
// // // // // // // //             child: Row(
// // // // // // // //               children: [
// // // // // // // //                 Expanded(
// // // // // // // //                   child: _customTextField(
// // // // // // // //                     "رقم الشيك",
// // // // // // // //                     c['number']!,
// // // // // // // //                     Icons.numbers,
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //                 const SizedBox(width: 8),
// // // // // // // //                 Expanded(
// // // // // // // //                   child: _customTextField(
// // // // // // // //                     "القيمة",
// // // // // // // //                     c['amount']!,
// // // // // // // //                     Icons.attach_money,
// // // // // // // //                   ),
// // // // // // // //                 ),
// // // // // // // //               ],
// // // // // // // //             ),
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //         TextButton.icon(
// // // // // // // //           onPressed: () => setState(
// // // // // // // //             () => checks.add({
// // // // // // // //               "number": TextEditingController(),
// // // // // // // //               "amount": TextEditingController(),
// // // // // // // //             }),
// // // // // // // //           ),
// // // // // // // //           icon: const Icon(Icons.add_circle_outline),
// // // // // // // //           label: const Text("إضافة شيك جديد"),
// // // // // // // //         ),
// // // // // // // //       ],
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildAddButton(VoidCallback onPressed) {
// // // // // // // //     return Container(
// // // // // // // //       height: 50,
// // // // // // // //       width: 50,
// // // // // // // //       decoration: BoxDecoration(
// // // // // // // //         color: primaryBlue,
// // // // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // // // //       ),
// // // // // // // //       child: IconButton(
// // // // // // // //         icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
// // // // // // // //         onPressed: onPressed,
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   Widget _buildSubmitButton() {
// // // // // // // //     return SizedBox(
// // // // // // // //       width: double.infinity,
// // // // // // // //       height: 55,
// // // // // // // //       child: ElevatedButton(
// // // // // // // //         style: ElevatedButton.styleFrom(
// // // // // // // //           backgroundColor: primaryBlue,
// // // // // // // //           shape: RoundedRectangleBorder(
// // // // // // // //             borderRadius: BorderRadius.circular(15),
// // // // // // // //           ),
// // // // // // // //           elevation: 5,
// // // // // // // //         ),
// // // // // // // //         onPressed: createTransaction,
// // // // // // // //         child: const Text(
// // // // // // // //           "إتمام العملية وحفظ الفاتورة",
// // // // // // // //           style: TextStyle(
// // // // // // // //             fontSize: 18,
// // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // //             color: Colors.white,
// // // // // // // //           ),
// // // // // // // //         ),
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }

// // // // // // // //   void showAddPartnerDialog() {
// // // // // // // //     TextEditingController name = TextEditingController();
// // // // // // // //     TextEditingController phone = TextEditingController();
// // // // // // // //     String label = widget.isSale ? "زبون" : "مورد";
// // // // // // // //     showDialog(
// // // // // // // //       context: context,
// // // // // // // //       builder: (_) => AlertDialog(
// // // // // // // //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// // // // // // // //         title: Text("إضافة $label جديد", textAlign: TextAlign.center),
// // // // // // // //         content: Column(
// // // // // // // //           mainAxisSize: MainAxisSize.min,
// // // // // // // //           children: [
// // // // // // // //             _customTextField(
// // // // // // // //               "اسم الشركة/$label",
// // // // // // // //               name,
// // // // // // // //               Icons.business,
// // // // // // // //               isNumeric: false,
// // // // // // // //             ),
// // // // // // // //             const SizedBox(height: 10),
// // // // // // // //             _customTextField("رقم الهاتف", phone, Icons.phone),
// // // // // // // //           ],
// // // // // // // //         ),
// // // // // // // //         actions: [
// // // // // // // //           TextButton(
// // // // // // // //             onPressed: () => Navigator.pop(context),
// // // // // // // //             child: const Text("إلغاء"),
// // // // // // // //           ),
// // // // // // // //           ElevatedButton(
// // // // // // // //             onPressed: () async {
// // // // // // // //               await addPartner(name.text, phone.text);
// // // // // // // //               Navigator.pop(context);
// // // // // // // //             },
// // // // // // // //             child: const Text("حفظ البيانات"),
// // // // // // // //           ),
// // // // // // // //         ],
// // // // // // // //       ),
// // // // // // // //     );
// // // // // // // //   }
// // // // // // // // }

// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:tradeflow_app/pages/link.dart';

// // class TransactionDetailsScreen extends StatefulWidget {
// //   final bool isSale;
// //   const TransactionDetailsScreen({super.key, required this.isSale});

// //   @override
// //   State<TransactionDetailsScreen> createState() =>
// //       _TransactionDetailsScreenState();
// // }

// // class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
// //   final Color primaryBlue = const Color(0xFF4A72C2);
// //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// //   // مصفوفات للتحكم في البيانات لكل مستودع
// //   List<TextEditingController> _quantityControllers = [
// //     TextEditingController(text: "1"),
// //   ];
// //   List<TextEditingController> _priceControllers = [
// //     TextEditingController(text: "0"),
// //   ];
// //   List<Map?> _selectedProductsList = [null];
// //   List<List> _warehouseProductsLists = [[]];

// //   final TextEditingController _depositController = TextEditingController(
// //     text: "0",
// //   );
// //   final TextEditingController _supplierInvoiceController =
// //       TextEditingController();

// //   List partners = [];
// //   List warehouses = [];
// //   Map? selectedPartner;

// //   List<Map?> selectedWarehousesList = [null];

// //   int paymentMethod = 0;
// //   List<Map<String, TextEditingController>> checks = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchPartners();
// //     fetchWarehouses();
// //   }

// //   List parseListResponse(String body) {
// //     final data = jsonDecode(body);
// //     return data is List ? data : data['data'] ?? [];
// //   }

// //   Future<Map<String, String>> getHeaders() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final token = prefs.getString("token");
// //     return {
// //       "Authorization": "Bearer $token",
// //       "Content-Type": "application/json",
// //       "Accept": "application/json",
// //     };
// //   }

// //   Future fetchPartners() async {
// //     final String type = widget.isSale ? "customer" : "supplier";
// //     final res = await http.get(
// //       Uri.parse("${ApiEndpoints.getPartners}?type=$type"),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200)
// //       setState(() => partners = parseListResponse(res.body));
// //   }

// //   Future addPartner(String name, String phone) async {
// //     final res = await http.post(
// //       Uri.parse(ApiEndpoints.addPartner),
// //       headers: await getHeaders(),
// //       body: jsonEncode({
// //         "company_name": name,
// //         "phone_number": phone,
// //         "partner_type": widget.isSale ? "customer" : "supplier",
// //       }),
// //     );
// //     if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
// //   }

// //   Future fetchWarehouses() async {
// //     final res = await http.get(
// //       Uri.parse(ApiEndpoints.getWarehouses),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200)
// //       setState(() => warehouses = parseListResponse(res.body));
// //   }

// //   Future fetchProducts(int warehouseId, int index) async {
// //     final res = await http.get(
// //       Uri.parse(
// //         "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/$warehouseId/storage",
// //       ),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200) {
// //       setState(() {
// //         _warehouseProductsLists[index] = parseListResponse(res.body);
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double overallTotal = 0;
// //     for (int i = 0; i < selectedWarehousesList.length; i++) {
// //       double q = double.tryParse(_quantityControllers[i].text) ?? 0;
// //       double p = double.tryParse(_priceControllers[i].text) ?? 0;
// //       overallTotal += (q * p);
// //     }

// //     double deposit = double.tryParse(_depositController.text) ?? 0;
// //     double remaining = overallTotal - deposit;

// //     return Scaffold(
// //       appBar: AppBar(
// //         elevation: 0,
// //         backgroundColor: primaryBlue,
// //         title: Text(
// //           widget.isSale ? "تفاصيل عملية البيع " : "تفاصيل عملية الشراء ",
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //             color: Colors.white,
// //             fontSize: 20,
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: Container(
// //         decoration: BoxDecoration(color: bgGradientStart),
// //         child: Directionality(
// //           textDirection: TextDirection.rtl,
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.all(20),
// //             child: Column(
// //               children: [
// //                 _buildSectionCard(
// //                   title: "بيانات الأطراف والمستودعات",
// //                   icon: Icons.person_outline,
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: _customDropdown(
// //                               widget.isSale ? "الزبون" : "المورد",
// //                               partners,
// //                               selectedPartner,
// //                               (v) => setState(() => selectedPartner = v),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 10),
// //                           _buildAddButton(
// //                             Icons.person_add_alt_1,
// //                             () => showAddPartnerDialog(),
// //                           ),
// //                         ],
// //                       ),
// //                       if (!widget.isSale) ...[
// //                         const SizedBox(height: 15),
// //                         _customTextField(
// //                           "رقم فاتورة المورد",
// //                           _supplierInvoiceController,
// //                           Icons.receipt,
// //                           isNumeric: false,
// //                         ),
// //                       ],
// //                       const SizedBox(height: 15),
// //                       ...List.generate(selectedWarehousesList.length, (index) {
// //                         return Padding(
// //                           padding: const EdgeInsets.only(bottom: 10),
// //                           child: Row(
// //                             children: [
// //                               Expanded(
// //                                 child: _customDropdown(
// //                                   "المستودع ${index + 1}",
// //                                   warehouses,
// //                                   selectedWarehousesList[index],
// //                                   (v) {
// //                                     setState(
// //                                       () => selectedWarehousesList[index] = v,
// //                                     );
// //                                     fetchProducts(v['id'], index);
// //                                   },
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 10),
// //                               if (index == 0)
// //                                 _buildAddButton(
// //                                   Icons.add_business_outlined,
// //                                   () {
// //                                     setState(() {
// //                                       selectedWarehousesList.add(null);
// //                                       _quantityControllers.add(
// //                                         TextEditingController(text: "1"),
// //                                       );
// //                                       _priceControllers.add(
// //                                         TextEditingController(text: "0"),
// //                                       );
// //                                       _selectedProductsList.add(null);
// //                                       _warehouseProductsLists.add([]);
// //                                     });
// //                                   },
// //                                 )
// //                               else
// //                                 _buildAddButton(Icons.remove, () {
// //                                   setState(() {
// //                                     selectedWarehousesList.removeAt(index);
// //                                     _quantityControllers.removeAt(index);
// //                                     _priceControllers.removeAt(index);
// //                                     _selectedProductsList.removeAt(index);
// //                                     _warehouseProductsLists.removeAt(index);
// //                                   });
// //                                 }, isDelete: true),
// //                             ],
// //                           ),
// //                         );
// //                       }),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),

// //                 ...List.generate(selectedWarehousesList.length, (index) {
// //                   String whName =
// //                       selectedWarehousesList[index]?['company_name'] ??
// //                       selectedWarehousesList[index]?['name'] ??
// //                       "${index + 1}";

// //                   return Column(
// //                     children: [
// //                       _buildSectionCard(
// //                         title: "بضاعة مستودع: $whName",
// //                         icon: Icons.inventory_2_outlined,
// //                         child: Column(
// //                           children: [
// //                             _customDropdown(
// //                               "اختر المنتج من $whName",
// //                               _warehouseProductsLists[index],
// //                               _selectedProductsList[index],
// //                               (v) {
// //                                 setState(() {
// //                                   _selectedProductsList[index] = v;
// //                                   _priceControllers[index].text = widget.isSale
// //                                       ? (v['sale_price']?.toString() ?? "0")
// //                                       : (v['purchase_price']?.toString() ??
// //                                             "0");
// //                                 });
// //                               },
// //                             ),
// //                             const SizedBox(height: 15),
// //                             _customTextField(
// //                               widget.isSale
// //                                   ? "سعر البيع (\$)"
// //                                   : "سعر الشراء (\$)",
// //                               _priceControllers[index],
// //                               Icons.monetization_on_outlined,
// //                             ),
// //                             const SizedBox(height: 15),
// //                             _customTextField(
// //                               "الكمية",
// //                               _quantityControllers[index],
// //                               Icons.production_quantity_limits,
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       const SizedBox(height: 10),
// //                     ],
// //                   );
// //                 }),

// //                 _buildSectionCard(
// //                   title: "الملخص المالي",
// //                   icon: Icons.summarize_outlined,
// //                   child: _buildPriceRow(
// //                     "السعر الإجمالي الكلي",
// //                     "$overallTotal \$",
// //                     isTotal: true,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),

// //                 _buildSectionCard(
// //                   title: "طريقة الدفع",
// //                   icon: Icons.payment_outlined,
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         children: [
// //                           _payBtn("نقداً", 0),
// //                           _payBtn("عربون", 1),
// //                           _payBtn("شيكات", 2),
// //                         ],
// //                       ),
// //                       if (paymentMethod == 1) ...[
// //                         const SizedBox(height: 15),
// //                         _customTextField(
// //                           "قيمة العربون (\$)",
// //                           _depositController,
// //                           Icons.money,
// //                         ),
// //                       ],
// //                       if (paymentMethod == 2) _buildChecksSection(),
// //                       const Divider(height: 30),
// //                       _buildPriceRow(
// //                         "المبلغ المتبقي",
// //                         "$remaining \$",
// //                         color: Colors.redAccent,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 30),
// //                 _buildSubmitButton(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // --- Widgets المعدلة ---

// //   Widget _buildSectionCard({
// //     required String title,
// //     required IconData icon,
// //     required Widget child,
// //   }) {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       margin: const EdgeInsets.only(bottom: 10),
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
// //               // تم تكبير الخط هنا ليكون العنوان أوضح
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
// //         hint: Text(hint, style: const TextStyle(fontSize: 15)),
// //         // تم تكبير خط اختيار المستودع والمنتج
// //         style: const TextStyle(
// //           fontSize: 17,
// //           fontWeight: FontWeight.w600,
// //           color: Colors.black87,
// //         ),
// //         items: data
// //             .map(
// //               (e) => DropdownMenuItem(
// //                 value: e,
// //                 child: Text(
// //                   e['company_name'] ?? e['name'] ?? e['product_name'] ?? "",
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
// //     IconData icon, {
// //     bool isNumeric = true,
// //   }) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
// //       onChanged: (_) => setState(() {}),
// //       // تم تكبير الخط داخل الحقول (السعر والكمية)
// //       style: const TextStyle(
// //         fontSize: 19,
// //         fontWeight: FontWeight.bold,
// //         color: Colors.black,
// //       ),
// //       decoration: InputDecoration(
// //         prefixIcon: Icon(icon, color: primaryBlue),
// //         hintText: hint,
// //         hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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

// //   Widget _buildPriceRow(
// //     String label,
// //     String value, {
// //     bool isTotal = false,
// //     Color? color,
// //   }) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(
// //           label,
// //           style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
// //         ),
// //         Text(
// //           value,
// //           style: TextStyle(
// //             fontWeight: FontWeight.bold,
// //             fontSize: isTotal ? 20 : 18,
// //             color: color ?? primaryBlue,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // باقي الدوال المساعدة بقيت كما هي لضمان استقرار العمل
// //   Widget _buildAddButton(
// //     IconData icon,
// //     VoidCallback onPressed, {
// //     bool isDelete = false,
// //   }) {
// //     return Container(
// //       height: 50,
// //       width: 50,
// //       decoration: BoxDecoration(
// //         color: isDelete ? Colors.redAccent : primaryBlue,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: IconButton(
// //         icon: Icon(icon, color: Colors.white),
// //         onPressed: onPressed,
// //       ),
// //     );
// //   }

// //   Widget _payBtn(String text, int type) {
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
// //                 fontSize: 16,
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
// //         ...checks.map(
// //           (c) => Padding(
// //             padding: const EdgeInsets.only(top: 10),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: _customTextField(
// //                     "رقم الشيك",
// //                     c['number']!,
// //                     Icons.numbers,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: _customTextField(
// //                     "القيمة (\$)",
// //                     c['amount']!,
// //                     Icons.attach_money,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //         TextButton.icon(
// //           onPressed: () => setState(
// //             () => checks.add({
// //               "number": TextEditingController(),
// //               "amount": TextEditingController(),
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
// //         onPressed: () {},
// //         child: const Text(
// //           "إتمام العملية وحفظ الفاتورة",
// //           style: TextStyle(
// //             fontSize: 19,
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void showAddPartnerDialog() {
// //     TextEditingController name = TextEditingController();
// //     TextEditingController phone = TextEditingController();
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //         title: Text(
// //           widget.isSale ? "إضافة زبون جديد" : "إضافة مورد جديد",
// //           textAlign: TextAlign.center,
// //         ),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             _customTextField("الاسم", name, Icons.business, isNumeric: false),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final bool isSale;
  const TransactionDetailsScreen({super.key, required this.isSale});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  final Color primaryBlue = const Color(0xFF4A72C2);
  final Color bgGradientStart = const Color(0xFFF0F4F8);

  // تم تعديل الهيكلية لدعم تعدد المنتجات داخل نفس كرت المستودع
  List<Map<String, dynamic>> warehouseSelections = [
    {
      "warehouse": null,
      "availableProducts": [],
      "items": [
        {
          "product": null,
          "price": TextEditingController(text: "0"),
          "qty": TextEditingController(text: "1"),
        },
      ],
    },
  ];

  final TextEditingController _depositController = TextEditingController(
    text: "0",
  );
  final TextEditingController _supplierInvoiceController =
      TextEditingController();

  List partners = [];
  List warehouses = [];
  Map? selectedPartner;

  int paymentMethod = 0;
  List<Map<String, TextEditingController>> checks = [];

  @override
  void initState() {
    super.initState();
    fetchPartners();
    fetchWarehouses();
  }

  List parseListResponse(String body) {
    final data = jsonDecode(body);
    return data is List ? data : data['data'] ?? [];
  }

  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  Future fetchPartners() async {
    final String type = widget.isSale ? "customer" : "supplier";
    final res = await http.get(
      Uri.parse("${ApiEndpoints.getPartners}?type=$type"),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200)
      setState(() => partners = parseListResponse(res.body));
  }

  Future addPartner(String name, String phone) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.addPartner),
      headers: await getHeaders(),
      body: jsonEncode({
        "company_name": name,
        "phone_number": phone,
        "partner_type": widget.isSale ? "customer" : "supplier",
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
  }

  Future fetchWarehouses() async {
    final res = await http.get(
      Uri.parse(ApiEndpoints.getWarehouses),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200)
      setState(() => warehouses = parseListResponse(res.body));
  }

  Future fetchProducts(int warehouseId, int whIndex) async {
    final res = await http.get(
      Uri.parse(
        "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/$warehouseId/storage",
      ),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200) {
      setState(() {
        warehouseSelections[whIndex]["availableProducts"] = parseListResponse(
          res.body,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double overallTotal = 0;
    // حساب المجموع الكلي لكل المنتجات في كل المستودعات
    for (var wh in warehouseSelections) {
      for (var item in wh['items']) {
        double q = double.tryParse(item['qty'].text) ?? 0;
        double p = double.tryParse(item['price'].text) ?? 0;
        overallTotal += (q * p);
      }
    }

    double deposit = double.tryParse(_depositController.text) ?? 0;
    double remaining = overallTotal - deposit;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: Text(
          widget.isSale ? "تفاصيل عملية البيع" : "تفاصيل عملية الشراء",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(color: bgGradientStart),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildSectionCard(
                  title: "بيانات الأطراف والمستودعات",
                  icon: Icons.person_outline,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _customDropdown(
                              widget.isSale ? "الزبون" : "المورد",
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
                      if (!widget.isSale) ...[
                        const SizedBox(height: 15),
                        _customTextField(
                          "رقم فاتورة المورد",
                          _supplierInvoiceController,
                          Icons.receipt,
                          isNumeric: false,
                        ),
                      ],
                      const SizedBox(height: 15),
                      // قائمة المستودعات
                      ...List.generate(warehouseSelections.length, (whIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: _customDropdown(
                                  "المستودع ${whIndex + 1}",
                                  warehouses,
                                  warehouseSelections[whIndex]['warehouse'],
                                  (v) {
                                    setState(
                                      () =>
                                          warehouseSelections[whIndex]['warehouse'] =
                                              v,
                                    );
                                    fetchProducts(v['id'], whIndex);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (whIndex == 0)
                                _buildAddButton(
                                  Icons.add_business_outlined,
                                  () {
                                    setState(() {
                                      warehouseSelections.add({
                                        "warehouse": null,
                                        "availableProducts": [],
                                        "items": [
                                          {
                                            "product": null,
                                            "price": TextEditingController(
                                              text: "0",
                                            ),
                                            "qty": TextEditingController(
                                              text: "1",
                                            ),
                                          },
                                        ],
                                      });
                                    });
                                  },
                                )
                              else
                                _buildAddButton(Icons.remove, () {
                                  setState(
                                    () => warehouseSelections.removeAt(whIndex),
                                  );
                                }, isDelete: true),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // عرض الكروت للمنتجات حسب المستودع
                ...List.generate(warehouseSelections.length, (whIndex) {
                  var whData = warehouseSelections[whIndex];
                  String whName =
                      whData['warehouse']?['name'] ??
                      whData['warehouse']?['company_name'] ??
                      "${whIndex + 1}";

                  return _buildSectionCard(
                    title: "بضاعة مستودع: $whName",
                    icon: Icons.inventory_2_outlined,
                    child: Column(
                      children: [
                        ...List.generate(whData['items'].length, (itemIndex) {
                          var item = whData['items'][itemIndex];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  if (whData['items'].length > 1)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () => setState(
                                        () =>
                                            whData['items'].removeAt(itemIndex),
                                      ),
                                    ),
                                  Expanded(
                                    child: _customDropdown(
                                      "اختر المنتج من $whName",
                                      whData['availableProducts'],
                                      item['product'],
                                      (v) {
                                        setState(() {
                                          item['product'] = v;
                                          if (v != null) {
                                            var price = widget.isSale
                                                ? (v['sale_price'] ??
                                                      v['price'] ??
                                                      0)
                                                : (v['purchase_price'] ??
                                                      v['price'] ??
                                                      0);
                                            item['price'].text = price
                                                .toString();
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              _customTextField(
                                widget.isSale
                                    ? "سعر البيع (\$)"
                                    : "سعر الشراء (\$)",
                                item['price'],
                                Icons.monetization_on_outlined,
                              ),
                              const SizedBox(height: 15),
                              _customTextField(
                                "الكمية",
                                item['qty'],
                                Icons.production_quantity_limits,
                              ),
                              const Divider(height: 30, thickness: 1),
                            ],
                          );
                        }),
                        // الزر المطلوب عند الخط الأحمر
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              whData['items'].add({
                                "product": null,
                                "price": TextEditingController(text: "0"),
                                "qty": TextEditingController(text: "1"),
                              });
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          label: const Text(
                            "إضافة صنف آخر من هذا المستودع",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                _buildSectionCard(
                  title: "الملخص المالي",
                  icon: Icons.summarize_outlined,
                  child: _buildPriceRow(
                    "السعر الإجمالي الكلي",
                    "$overallTotal \$",
                    isTotal: true,
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
                          _payBtn("نقداً", 0),
                          _payBtn("عربون", 1),
                          _payBtn("شيكات", 2),
                        ],
                      ),
                      if (paymentMethod == 1) ...[
                        const SizedBox(height: 15),
                        _customTextField(
                          "قيمة العربون (\$)",
                          _depositController,
                          Icons.money,
                        ),
                      ],
                      if (paymentMethod == 2) _buildChecksSection(),
                      const Divider(height: 30),
                      _buildPriceRow(
                        "المبلغ المتبقي",
                        "$remaining \$",
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widgets --- (نفس الويدجت الاصلية دون تعديل في التصميم)

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 10),
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
        hint: Text(hint, style: const TextStyle(fontSize: 15)),
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        items: data
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e['company_name'] ?? e['name'] ?? e['product_name'] ?? "",
                ),
              ),
            )
            .toList(),
        onChanged: (v) => onChanged(v),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _customTextField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isNumeric = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      onChanged: (_) => setState(() {}),
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryBlue),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 20 : 18,
            color: color ?? primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(
    IconData icon,
    VoidCallback onPressed, {
    bool isDelete = false,
  }) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: isDelete ? Colors.redAccent : primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _payBtn(String text, int type) {
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
                fontSize: 16,
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
        ...checks.map(
          (c) => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: _customTextField(
                    "رقم الشيك",
                    c['number']!,
                    Icons.numbers,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _customTextField(
                    "القيمة (\$)",
                    c['amount']!,
                    Icons.attach_money,
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () => setState(
            () => checks.add({
              "number": TextEditingController(),
              "amount": TextEditingController(),
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
        onPressed: () {},
        child: const Text(
          "إتمام العملية وحفظ الفاتورة",
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showAddPartnerDialog() {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.isSale ? "إضافة زبون جديد" : "إضافة مورد جديد",
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _customTextField("الاسم", name, Icons.business, isNumeric: false),
            const SizedBox(height: 10),
            _customTextField("رقم الهاتف", phone, Icons.phone),
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
