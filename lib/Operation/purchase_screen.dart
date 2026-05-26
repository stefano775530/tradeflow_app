// // // // // import 'dart:convert';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:intl/intl.dart' show DateFormat;
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import 'package:tradeflow_app/pages/link.dart';

// // // // // class Distribution {
// // // // //   Map? warehouse;
// // // // //   TextEditingController qty;

// // // // //   Distribution({this.warehouse, required this.qty});
// // // // // }

// // // // // class PurchaseScreen extends StatefulWidget {
// // // // //   const PurchaseScreen({super.key});

// // // // //   @override
// // // // //   State<PurchaseScreen> createState() => _PurchaseScreenState();
// // // // // }

// // // // // class _PurchaseScreenState extends State<PurchaseScreen> {
// // // // //   final Color primaryBlue = const Color(0xFF4A72C2);
// // // // //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// // // // //   List partners = [];
// // // // //   Map? selectedPartner;
// // // // //   List warehouses = [];
// // // // //   List _allProducts = [];
// // // // //   DateTime? _selectedDate;
// // // // //   final TextEditingController _dateController = TextEditingController();

// // // // //   List<Map<String, dynamic>> _purchaseItems = [
// // // // //     {
// // // // //       "product": null,
// // // // //       "is_new": false,
// // // // //       "new_product_name": TextEditingController(),
// // // // //       "total_qty": TextEditingController(text: "0"),
// // // // //       "purchase_price": TextEditingController(text: "0"),
// // // // //       "sale_price": TextEditingController(text: "0"),
// // // // //       "distributions": [
// // // // //         Distribution(warehouse: null, qty: TextEditingController(text: "0")),
// // // // //       ],
// // // // //     },
// // // // //   ];
// // // // //   String paymentMethod = "cash";
// // // // //   final TextEditingController _depositController = TextEditingController(
// // // // //     text: "0",
// // // // //   );
// // // // //   List<Map<String, TextEditingController>> checks = [];

// // // // //   // ======= الإضافة الجديدة =======
// // // // //   List existingChecks = [];
// // // // //   Map? selectedExistingCheck;
// // // // //   // ================================

// // // // //   @override
// // // // //   void initState() {
// // // // //     super.initState();
// // // // //     fetchPartners();
// // // // //     fetchWarehouses();
// // // // //     fetchAllProducts();
// // // // //     fetchExistingChecks();
// // // // //   }

// // // // //   // ======= الإضافة الجديدة =======
// // // // //   Future fetchExistingChecks() async {
// // // // //     print("Fetching existing checks...");
// // // // //     final res = await http.get(
// // // // //       Uri.parse(
// // // // //         ApiEndpoints.getChecksApi + "?type=وارد",
// // // // //       ), // تأكد أن المسار مطابق للباك إند عندك
// // // // //       headers: await getHeaders(),
// // // // //     );
// // // // //     print("Response status: ${res.statusCode}");
// // // // //     if (res.statusCode == 200) {
// // // // //       final decoded = jsonDecode(res.body);
// // // // //       print("all checks: $decoded");
// // // // //       final List allChecks =
// // // // //           (decoded is List ? decoded : decoded['data']) ?? [];
// // // // //       setState(() {
// // // // //         existingChecks = allChecks;
// // // // //       });
// // // // //     }
// // // // //   }
// // // // //   // ================================

// // // // //   double _calculateTotalInvoicePrice() {
// // // // //     double total = 0.0;
// // // // //     for (var item in _purchaseItems) {
// // // // //       double qty = double.tryParse(item['total_qty'].text) ?? 0.0;
// // // // //       double price = double.tryParse(item['purchase_price'].text) ?? 0.0;
// // // // //       total += (qty * price);
// // // // //     }
// // // // //     return total;
// // // // //   }

// // // // //   Future<Map<String, String>> getHeaders() async {
// // // // //     final prefs = await SharedPreferences.getInstance();
// // // // //     return {
// // // // //       "Authorization": "Bearer ${prefs.getString("token")}",
// // // // //       "Content-Type": "application/json",
// // // // //       "Accept": "application/json",
// // // // //     };
// // // // //   }

// // // // //   Future fetchPartners() async {
// // // // //     final res = await http.get(
// // // // //       Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
// // // // //       headers: await getHeaders(),
// // // // //     );
// // // // //     if (res.statusCode == 200) {
// // // // //       setState(
// // // // //         () => partners =
// // // // //             (jsonDecode(res.body) is List
// // // // //                 ? jsonDecode(res.body)
// // // // //                 : jsonDecode(res.body)['data']) ??
// // // // //             [],
// // // // //       );
// // // // //     }
// // // // //   }

// // // // //   Future fetchWarehouses() async {
// // // // //     final res = await http.get(
// // // // //       Uri.parse(ApiEndpoints.getWarehouses),
// // // // //       headers: await getHeaders(),
// // // // //     );
// // // // //     if (res.statusCode == 200) {
// // // // //       setState(
// // // // //         () => warehouses =
// // // // //             (jsonDecode(res.body) is List
// // // // //                 ? jsonDecode(res.body)
// // // // //                 : jsonDecode(res.body)['data']) ??
// // // // //             [],
// // // // //       );
// // // // //     }
// // // // //   }

// // // // //   Future<void> fetchAllProducts() async {
// // // // //     try {
// // // // //       final res = await http.get(
// // // // //         Uri.parse(ApiEndpoints.allproducts),
// // // // //         headers: await getHeaders(),
// // // // //       );

// // // // //       if (res.statusCode == 200) {
// // // // //         final data = jsonDecode(res.body);
// // // // //         setState(() {
// // // // //           _allProducts = data['items'] ?? [];
// // // // //         });
// // // // //       }
// // // // //     } catch (e) {
// // // // //       print(e);
// // // // //     }
// // // // //   }

// // // // //   Future addPartner(String name, String phone) async {
// // // // //     final res = await http.post(
// // // // //       Uri.parse(ApiEndpoints.addPartner),
// // // // //       headers: await getHeaders(),
// // // // //       body: jsonEncode({
// // // // //         "company_name": name,
// // // // //         "phone_number": phone,
// // // // //         "partner_type": "supplier",
// // // // //       }),
// // // // //     );
// // // // //     if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
// // // // //   }

// // // // //   int? getId(dynamic obj) {
// // // // //     if (obj == null) return null;
// // // // //     if (obj is Map) return obj['id'];
// // // // //     if (obj is int) return obj;
// // // // //     return null;
// // // // //   }

// // // // //   Future<void> submitTransaction() async {
// // // // //     try {
// // // // //       if (selectedPartner == null) {
// // // // //         throw Exception("الرجاء اختيار المورد");
// // // // //       }

// // // // //       List itemsData = [];

// // // // //       for (var item in _purchaseItems) {
// // // // //         final isNew = item['is_new'] == true;

// // // // //         final product = item['product'];
// // // // //         final newName = item['new_product_name'].text.trim();

// // // // //         String itemName = "";
// // // // //         int? productId;

// // // // //         if (isNew) {
// // // // //           if (newName.isEmpty) {
// // // // //             throw Exception("اسم المنتج الجديد مطلوب");
// // // // //           }
// // // // //           itemName = newName;
// // // // //         } else {
// // // // //           if (product == null) {
// // // // //             throw Exception("الرجاء اختيار منتج");
// // // // //           }
// // // // //           itemName = product['name'] ?? "";
// // // // //           productId = product['id'];
// // // // //         }

// // // // //         double totalQty = double.tryParse(item['total_qty'].text.trim()) ?? 0;

// // // // //         if (totalQty <= 0) {
// // // // //           throw Exception("الكمية يجب أن تكون أكبر من 0");
// // // // //         }

// // // // //         double unitCost =
// // // // //             double.tryParse(item['purchase_price'].text.trim()) ?? 0;

// // // // //         if (unitCost <= 0) {
// // // // //           throw Exception("سعر الشراء يجب أن يكون أكبر من 0");
// // // // //         }

// // // // //         double salePrice = double.tryParse(item['sale_price'].text.trim()) ?? 0;

// // // // //         double distributedQty = 0;
// // // // //         List allocations = [];

// // // // //         for (var dist in item['distributions']) {
// // // // //           if (dist.warehouse == null) continue;

// // // // //           double q = double.tryParse(dist.qty.text.trim()) ?? 0;

// // // // //           if (q <= 0) continue;

// // // // //           distributedQty += q;

// // // // //           allocations.add({
// // // // //             "warehouse_id": dist.warehouse['id'],
// // // // //             "quantity": q,
// // // // //           });
// // // // //         }

// // // // //         if ((distributedQty - totalQty).abs() > 0.0001) {
// // // // //           throw Exception(
// // // // //             "الكمية غير متطابقة: الكلي=$totalQty والموزع=$distributedQty للمنتج $itemName",
// // // // //           );
// // // // //         }

// // // // //         itemsData.add({
// // // // //           "product_id": productId,
// // // // //           "item_name": itemName,
// // // // //           "quantity": totalQty,
// // // // //           "unit_cost": unitCost,
// // // // //           "sale_price": salePrice,
// // // // //           "allocations": allocations,
// // // // //         });
// // // // //       }

// // // // //       if (itemsData.isEmpty) {
// // // // //         throw Exception("الرجاء إضافة منتج واحد على الأقل");
// // // // //       }

// // // // //       if (selectedPartner!['partner_type'] != 'supplier') {
// // // // //         throw Exception("الرجاء اختيار مورد (Supplier) صحيح");
// // // // //       }

// // // // //       final body = {
// // // // //         "partner_id": selectedPartner!['id'],
// // // // //         "purchase_date": DateTime.now().toIso8601String().substring(0, 10),
// // // // //         "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
// // // // //         "items": itemsData,
// // // // //       };

// // // // //       final response = await http.post(
// // // // //         Uri.parse(ApiEndpoints.addpurchase),
// // // // //         headers: await getHeaders(),
// // // // //         body: jsonEncode(body),
// // // // //       );

// // // // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // // // //         final data = jsonDecode(response.body);
// // // // //         await handlePayment(data['purchase']['id']);

// // // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // // //           const SnackBar(
// // // // //             content: Text("تم حفظ الفاتورة بنجاح"),
// // // // //             backgroundColor: Colors.green,
// // // // //           ),
// // // // //         );

// // // // //         if (mounted) {
// // // // //           Navigator.pop(context);
// // // // //         }
// // // // //       } else {
// // // // //         throw Exception("فشل الحفظ: ${response.body}");
// // // // //       }
// // // // //     } catch (e) {
// // // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // // //         SnackBar(content: Text("$e"), backgroundColor: Colors.red),
// // // // //       );
// // // // //     }
// // // // //   }

// // // // //   Future<void> handlePayment(int? purchaseId) async {
// // // // //     if (purchaseId == null) return;
// // // // //     double amount = double.tryParse(_depositController.text) ?? 0;

// // // // //     if (paymentMethod == "cash") {
// // // // //       if (amount > 0) {
// // // // //         await sendPayment(purchaseId, "cash", amount);
// // // // //       }
// // // // //     } else if (paymentMethod == "check") {
// // // // //       for (var c in checks) {
// // // // //         String bank = c['bank']!.text;
// // // // //         String number = c['number']!.text;
// // // // //         String date = c['date']!.text;
// // // // //         double amt = double.tryParse(c['amount']!.text) ?? 0;

// // // // //         if (bank.isEmpty || number.isEmpty || date.isEmpty || amt <= 0) {
// // // // //           continue;
// // // // //         }

// // // // //         await sendPayment(
// // // // //           purchaseId,
// // // // //           "check",
// // // // //           amt,
// // // // //           note: "شيك من $bank",
// // // // //           checkData: {
// // // // //             "bank_name": bank,
// // // // //             "check_number": number,
// // // // //             "company_name": "eehab",
// // // // //             "issue_date": _selectedDate != null
// // // // //                 ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
// // // // //                 : DateTime.now().toString().substring(0, 10),
// // // // //             "cashing_date": date,
// // // // //             "status": "pending",
// // // // //             "type": "صادر",
// // // // //           },
// // // // //         );
// // // // //       }
// // // // //       // ======= الإضافة الجديدة =======
// // // // //     } else if (paymentMethod == "existing_check") {
// // // // //       if (selectedExistingCheck != null) {
// // // // //         await sendPayment(
// // // // //           purchaseId,
// // // // //           "check",
// // // // //           (selectedExistingCheck!['amount'] is int
// // // // //                   ? (selectedExistingCheck!['amount'] as int).toDouble()
// // // // //                   : selectedExistingCheck!['amount']?.toDouble()) ??
// // // // //               0,
// // // // //           note: "شيك موجود رقم ${selectedExistingCheck!['check_number'] ?? ''}",
// // // // //           checkData: {"check_id": selectedExistingCheck!['id']},
// // // // //         );
// // // // //       }
// // // // //     }
// // // // //     // ================================
// // // // //   }

// // // // //   Future<void> _selectDate(BuildContext context) async {
// // // // //     final DateTime? picked = await showDatePicker(
// // // // //       context: context,
// // // // //       initialDate: _selectedDate ?? DateTime.now(),
// // // // //       firstDate: DateTime(2000),
// // // // //       lastDate: DateTime(2101),
// // // // //     );
// // // // //     if (picked != null) {
// // // // //       setState(() {
// // // // //         _selectedDate = picked;
// // // // //         _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   Future<void> _selectCheckDate(
// // // // //     BuildContext context,
// // // // //     TextEditingController controller,
// // // // //   ) async {
// // // // //     final DateTime? picked = await showDatePicker(
// // // // //       context: context,
// // // // //       initialDate: DateTime.now(),
// // // // //       firstDate: DateTime(2000),
// // // // //       lastDate: DateTime(2101),
// // // // //     );
// // // // //     if (picked != null) {
// // // // //       setState(() {
// // // // //         controller.text = DateFormat('yyyy-MM-dd').format(picked);
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   Future<int?> sendCheck({
// // // // //     required String bankName,
// // // // //     required String checkNumber,
// // // // //     required String companyName,
// // // // //     required double amount,
// // // // //     required String cashingDate,
// // // // //   }) async {
// // // // //     final headers = await getHeaders();

// // // // //     final body = {
// // // // //       "bank_name": bankName,
// // // // //       "check_number": checkNumber,
// // // // //       "company_name": companyName,
// // // // //       "amount": amount,
// // // // //       "issue_date": _selectedDate != null
// // // // //           ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
// // // // //           : DateTime.now().toString().substring(0, 10),
// // // // //       "cashing_date": cashingDate,
// // // // //       "status": "pending",
// // // // //       "type": "صادر",
// // // // //     };

// // // // //     final response = await http.post(
// // // // //       Uri.parse(ApiEndpoints.addCheck),
// // // // //       headers: headers,
// // // // //       body: jsonEncode(body),
// // // // //     );

// // // // //     if (response.statusCode == 200 || response.statusCode == 201) {
// // // // //       final data = jsonDecode(response.body);
// // // // //       return data['check']['id'];
// // // // //     }
// // // // //     return null;
// // // // //   }

// // // // //   Future<void> sendPayment(
// // // // //     int purchaseId,
// // // // //     String method,
// // // // //     double amount, {
// // // // //     String note = "",
// // // // //     Map<String, dynamic>? checkData,
// // // // //   }) async {
// // // // //     final headers = await getHeaders();

// // // // //     final body = {
// // // // //       "purchase_id": purchaseId,
// // // // //       "payment_method": method,
// // // // //       "amount": amount,
// // // // //       "payment_date": DateTime.now().toString().substring(0, 10),
// // // // //       "notes": note,
// // // // //     };
// // // // //     if (method == "check" && checkData != null) {
// // // // //       body["check"] = checkData;
// // // // //     }
// // // // //     final response = await http.post(
// // // // //       Uri.parse("${ApiEndpoints.pur}/$purchaseId/payments"),
// // // // //       headers: headers,
// // // // //       body: jsonEncode(body),
// // // // //     );
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         backgroundColor: primaryBlue,
// // // // //         title: const Text(
// // // // //           "شراء وتوزيع بضاعة",
// // // // //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // // // //         ),
// // // // //         centerTitle: true,
// // // // //       ),
// // // // //       body: Directionality(
// // // // //         textDirection: TextDirection.rtl,
// // // // //         child: SingleChildScrollView(
// // // // //           padding: const EdgeInsets.all(20),
// // // // //           child: Column(
// // // // //             children: [
// // // // //               _buildSectionCard(
// // // // //                 title: "بيانات المورد",
// // // // //                 icon: Icons.person_outline,
// // // // //                 child: Row(
// // // // //                   children: [
// // // // //                     Expanded(
// // // // //                       child: _customDropdown(
// // // // //                         "اختر البارتنر",
// // // // //                         partners,
// // // // //                         selectedPartner,
// // // // //                         (val) {
// // // // //                           setState(() {
// // // // //                             selectedPartner = val;
// // // // //                           });
// // // // //                         },
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(width: 10),
// // // // //                     _buildAddButton(
// // // // //                       Icons.person_add_alt_1,
// // // // //                       () => showAddPartnerDialog(),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),

// // // // //               ..._purchaseItems.asMap().entries.map((entry) {
// // // // //                 int itemIndex = entry.key;
// // // // //                 var item = entry.value;
// // // // //                 return _buildSectionCard(
// // // // //                   title: "المنتج ${itemIndex + 1}",
// // // // //                   icon: Icons.shopping_bag_outlined,
// // // // //                   child: Column(
// // // // //                     children: [
// // // // //                       Row(
// // // // //                         children: [
// // // // //                           Expanded(
// // // // //                             child: item['is_new']
// // // // //                                 ? _customTextFieldGeneral(
// // // // //                                     "اسم المنتج الجديد",
// // // // //                                     item['new_product_name'],
// // // // //                                     Icons.edit_note,
// // // // //                                     isNumeric: false,
// // // // //                                   )
// // // // //                                 : _customDropdown(
// // // // //                                     "اختر المنتج",
// // // // //                                     _allProducts,
// // // // //                                     item['product'],
// // // // //                                     (val) {
// // // // //                                       setState(() {
// // // // //                                         item['product'] = val;
// // // // //                                       });
// // // // //                                     },
// // // // //                                   ),
// // // // //                           ),
// // // // //                           const SizedBox(width: 10),
// // // // //                           _buildAddButton(
// // // // //                             item['is_new'] ? Icons.list : Icons.add_box,
// // // // //                             () => setState(
// // // // //                               () => item['is_new'] = !item['is_new'],
// // // // //                             ),
// // // // //                           ),
// // // // //                         ],
// // // // //                       ),
// // // // //                       const SizedBox(height: 15),
// // // // //                       _customTextFieldGeneral(
// // // // //                         "الكمية الكلية",
// // // // //                         item['total_qty'],
// // // // //                         Icons.production_quantity_limits,
// // // // //                         onChanged: (val) => setState(() {}),
// // // // //                       ),
// // // // //                       const SizedBox(height: 15),
// // // // //                       Row(
// // // // //                         children: [
// // // // //                           Expanded(
// // // // //                             child: _priceTextFieldCustom(
// // // // //                               "سعر شراء",
// // // // //                               item['purchase_price'],
// // // // //                               onChanged: (val) => setState(() {}),
// // // // //                             ),
// // // // //                           ),
// // // // //                           const SizedBox(width: 10),
// // // // //                           Expanded(
// // // // //                             child: _priceTextFieldCustom(
// // // // //                               "سعر بيع",
// // // // //                               item['sale_price'],
// // // // //                             ),
// // // // //                           ),
// // // // //                         ],
// // // // //                       ),
// // // // //                       const Divider(height: 30),
// // // // //                       const Text(
// // // // //                         "توزيع الكمية على المستودعات:",
// // // // //                         style: TextStyle(fontWeight: FontWeight.bold),
// // // // //                       ),
// // // // //                       const SizedBox(height: 10),
// // // // //                       ...List.generate(item['distributions'].length, (
// // // // //                         distIndex,
// // // // //                       ) {
// // // // //                         var dist = item['distributions'][distIndex];

// // // // //                         return Padding(
// // // // //                           padding: const EdgeInsets.only(bottom: 8),
// // // // //                           child: Row(
// // // // //                             children: [
// // // // //                               Expanded(
// // // // //                                 flex: 2,
// // // // //                                 child: _customDropdown(
// // // // //                                   "المستودع",
// // // // //                                   warehouses,
// // // // //                                   dist.warehouse,
// // // // //                                   (v) {
// // // // //                                     print("SELECTED WAREHOUSE: $v");
// // // // //                                     setState(() {
// // // // //                                       dist.warehouse = v;
// // // // //                                     });
// // // // //                                   },
// // // // //                                 ),
// // // // //                               ),
// // // // //                               const SizedBox(width: 8),
// // // // //                               Expanded(
// // // // //                                 flex: 1,
// // // // //                                 child: _customTextFieldGeneral(
// // // // //                                   "الكمية",
// // // // //                                   dist.qty,
// // // // //                                   Icons.pie_chart_outline,
// // // // //                                 ),
// // // // //                               ),
// // // // //                               IconButton(
// // // // //                                 icon: Icon(
// // // // //                                   distIndex == 0
// // // // //                                       ? Icons.add_circle_outline
// // // // //                                       : Icons.remove_circle_outline,
// // // // //                                   color: primaryBlue,
// // // // //                                 ),
// // // // //                                 onPressed: () {
// // // // //                                   setState(() {
// // // // //                                     if (distIndex == 0) {
// // // // //                                       item['distributions'].add(
// // // // //                                         Distribution(
// // // // //                                           warehouse: null,
// // // // //                                           qty: TextEditingController(text: "0"),
// // // // //                                         ),
// // // // //                                       );
// // // // //                                     } else {
// // // // //                                       item['distributions'].removeAt(distIndex);
// // // // //                                     }
// // // // //                                   });
// // // // //                                 },
// // // // //                               ),
// // // // //                             ],
// // // // //                           ),
// // // // //                         );
// // // // //                       }),
// // // // //                       if (itemIndex > 0)
// // // // //                         TextButton.icon(
// // // // //                           onPressed: () => setState(
// // // // //                             () => _purchaseItems.removeAt(itemIndex),
// // // // //                           ),
// // // // //                           icon: const Icon(Icons.delete, color: Colors.red),
// // // // //                           label: const Text(
// // // // //                             "حذف هذا المنتج",
// // // // //                             style: TextStyle(color: Colors.red),
// // // // //                           ),
// // // // //                         ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 );
// // // // //               }),

// // // // //               ElevatedButton.icon(
// // // // //                 onPressed: () => setState(
// // // // //                   () => _purchaseItems.add({
// // // // //                     "product": null,
// // // // //                     "is_new": false,
// // // // //                     "new_product_name": TextEditingController(),
// // // // //                     "total_qty": TextEditingController(text: "0"),
// // // // //                     "purchase_price": TextEditingController(text: "0"),
// // // // //                     "sale_price": TextEditingController(text: "0"),
// // // // //                     "distributions": [
// // // // //                       Distribution(
// // // // //                         warehouse: null,
// // // // //                         qty: TextEditingController(text: "0"),
// // // // //                       ),
// // // // //                     ],
// // // // //                   }),
// // // // //                 ),
// // // // //                 icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
// // // // //                 label: const Text(
// // // // //                   "إضافة منتج آخر للفاتورة",
// // // // //                   style: TextStyle(color: Colors.white),
// // // // //                 ),
// // // // //                 style: ElevatedButton.styleFrom(
// // // // //                   backgroundColor: Colors.green,
// // // // //                   shape: RoundedRectangleBorder(
// // // // //                     borderRadius: BorderRadius.circular(12),
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //               const SizedBox(height: 20),

// // // // //               _buildFinancialSummaryCard(),

// // // // //               _buildSectionCard(
// // // // //                 title: "طريقة الدفع",
// // // // //                 icon: Icons.payment_outlined,
// // // // //                 child: Column(
// // // // //                   children: [
// // // // //                     Row(
// // // // //                       children: [
// // // // //                         _payBtn("نقداً", "cash"),
// // // // //                         _payBtn("شيكات", "check"),
// // // // //                         _payBtn("شيك موجود", "existing_check"),
// // // // //                       ],
// // // // //                     ),
// // // // //                     if (paymentMethod == "cash") ...[
// // // // //                       const SizedBox(height: 15),
// // // // //                       _customTextFieldGeneral(
// // // // //                         "المبلغ المدفوع",
// // // // //                         _depositController,
// // // // //                         Icons.money,
// // // // //                       ),
// // // // //                     ],
// // // // //                     if (paymentMethod == "check") _buildChecksSection(),
// // // // //                     if (paymentMethod == "existing_check")
// // // // //                       _buildExistingCheckSelector(),
// // // // //                     const SizedBox(height: 20),
// // // // //                     _buildSubmitButton(),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildFinancialSummaryCard() {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.all(16),
// // // // //       margin: const EdgeInsets.only(bottom: 20),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(20),
// // // // //         boxShadow: [
// // // // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
// // // // //         ],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Row(
// // // // //             children: [
// // // // //               Icon(Icons.assignment_outlined, color: primaryBlue, size: 22),
// // // // //               const SizedBox(width: 8),
// // // // //               Text(
// // // // //                 "الملخص المالي",
// // // // //                 style: TextStyle(
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                   fontSize: 18,
// // // // //                   color: primaryBlue,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const Divider(height: 20),
// // // // //           Row(
// // // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //             children: [
// // // // //               Text(
// // // // //                 "\$ ${_calculateTotalInvoicePrice().toStringAsFixed(1)}",
// // // // //                 style: TextStyle(
// // // // //                   fontSize: 18,
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                   color: primaryBlue,
// // // // //                 ),
// // // // //               ),
// // // // //               Text(
// // // // //                 "السعر الإجمالي الكلي",
// // // // //                 style: TextStyle(
// // // // //                   fontSize: 15,
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                   color: Colors.grey[700],
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   // ======= الإضافة الجديدة =======
// // // // //   Widget _buildExistingCheckSelector() {
// // // // //     return Container(
// // // // //       margin: const EdgeInsets.only(top: 10),
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.grey.shade50,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         border: Border.all(color: Colors.grey.shade200),
// // // // //       ),
// // // // //       child: DropdownButtonFormField<Map>(
// // // // //         value: selectedExistingCheck,
// // // // //         isExpanded: true,
// // // // //         hint: const Text("اختر شيك موجود"),
// // // // //         items: existingChecks.map((e) {
// // // // //           return DropdownMenuItem<Map>(
// // // // //             value: e as Map,
// // // // //             child: Text(e['check_number']?.toString() ?? ""),
// // // // //           );
// // // // //         }).toList(),
// // // // //         onChanged: (v) => setState(() => selectedExistingCheck = v),
// // // // //         decoration: const InputDecoration(border: InputBorder.none),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // //   // ================================

// // // // //   Widget _priceTextFieldCustom(
// // // // //     String labelText,
// // // // //     TextEditingController controller, {
// // // // //     ValueChanged<String>? onChanged,
// // // // //   }) {
// // // // //     return TextField(
// // // // //       controller: controller,
// // // // //       keyboardType: TextInputType.number,
// // // // //       onChanged: onChanged,
// // // // //       style: const TextStyle(fontWeight: FontWeight.bold),
// // // // //       decoration: InputDecoration(
// // // // //         labelText: labelText,
// // // // //         floatingLabelBehavior: FloatingLabelBehavior.always,
// // // // //         labelStyle: TextStyle(
// // // // //           fontSize: 14,
// // // // //           color: Colors.grey[700],
// // // // //           fontWeight: FontWeight.normal,
// // // // //         ),
// // // // //         filled: true,
// // // // //         fillColor: Colors.grey.shade50,
// // // // //         contentPadding: const EdgeInsets.symmetric(
// // // // //           horizontal: 16,
// // // // //           vertical: 12,
// // // // //         ),
// // // // //         enabledBorder: OutlineInputBorder(
// // // // //           borderRadius: BorderRadius.circular(12),
// // // // //           borderSide: BorderSide(color: Colors.grey.shade200),
// // // // //         ),
// // // // //         focusedBorder: OutlineInputBorder(
// // // // //           borderRadius: BorderRadius.circular(12),
// // // // //           borderSide: BorderSide(color: primaryBlue),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _customTextFieldGeneral(
// // // // //     String hint,
// // // // //     TextEditingController controller,
// // // // //     IconData icon, {
// // // // //     bool isNumeric = true,
// // // // //     ValueChanged<String>? onChanged,
// // // // //   }) {
// // // // //     return TextField(
// // // // //       controller: controller,
// // // // //       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
// // // // //       onChanged: onChanged,
// // // // //       style: const TextStyle(fontWeight: FontWeight.bold),
// // // // //       decoration: InputDecoration(
// // // // //         prefixIcon: Icon(icon, color: primaryBlue),
// // // // //         hintText: hint,
// // // // //         filled: true,
// // // // //         fillColor: Colors.grey.shade50,
// // // // //         enabledBorder: OutlineInputBorder(
// // // // //           borderRadius: BorderRadius.circular(12),
// // // // //           borderSide: BorderSide(color: Colors.grey.shade200),
// // // // //         ),
// // // // //         focusedBorder: OutlineInputBorder(
// // // // //           borderRadius: BorderRadius.circular(12),
// // // // //           borderSide: BorderSide(color: primaryBlue),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildSectionCard({
// // // // //     required String title,
// // // // //     required IconData icon,
// // // // //     required Widget child,
// // // // //   }) {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.all(16),
// // // // //       margin: const EdgeInsets.only(bottom: 20),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.white,
// // // // //         borderRadius: BorderRadius.circular(20),
// // // // //         boxShadow: [
// // // // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
// // // // //         ],
// // // // //       ),
// // // // //       child: Column(
// // // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // // //         children: [
// // // // //           Row(
// // // // //             children: [
// // // // //               Icon(icon, color: primaryBlue, size: 22),
// // // // //               const SizedBox(width: 8),
// // // // //               Text(
// // // // //                 title,
// // // // //                 style: TextStyle(
// // // // //                   fontWeight: FontWeight.bold,
// // // // //                   fontSize: 18,
// // // // //                   color: primaryBlue,
// // // // //                 ),
// // // // //               ),
// // // // //             ],
// // // // //           ),
// // // // //           const Divider(height: 20),
// // // // //           child,
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _customDropdown(
// // // // //     String hint,
// // // // //     List data,
// // // // //     dynamic value,
// // // // //     Function onChanged,
// // // // //   ) {
// // // // //     return Container(
// // // // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // // // //       decoration: BoxDecoration(
// // // // //         color: Colors.grey.shade50,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //         border: Border.all(color: Colors.grey.shade200),
// // // // //       ),
// // // // //       child: DropdownButtonFormField(
// // // // //         value: value,
// // // // //         isExpanded: true,
// // // // //         hint: Text(hint),
// // // // //         items: data.map((e) {
// // // // //           return DropdownMenuItem(
// // // // //             value: e,
// // // // //             child: Text(
// // // // //               e['name'] ??
// // // // //                   e['company_name'] ??
// // // // //                   e['check_number'] ??
// // // // //                   e['product_name'] ??
// // // // //                   "",
// // // // //             ),
// // // // //           );
// // // // //         }).toList(),
// // // // //         onChanged: (v) => onChanged(v),
// // // // //         decoration: const InputDecoration(border: InputBorder.none),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _payBtn(String text, String type) {
// // // // //     bool isSelected = paymentMethod == type;
// // // // //     return Expanded(
// // // // //       child: GestureDetector(
// // // // //         onTap: () => setState(() => paymentMethod = type),
// // // // //         child: Container(
// // // // //           margin: const EdgeInsets.all(4),
// // // // //           padding: const EdgeInsets.symmetric(vertical: 14),
// // // // //           decoration: BoxDecoration(
// // // // //             color: isSelected ? primaryBlue : Colors.white,
// // // // //             borderRadius: BorderRadius.circular(12),
// // // // //             border: Border.all(
// // // // //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// // // // //             ),
// // // // //           ),
// // // // //           child: Center(
// // // // //             child: Text(
// // // // //               text,
// // // // //               style: TextStyle(
// // // // //                 color: isSelected ? Colors.white : Colors.black87,
// // // // //                 fontWeight: FontWeight.bold,
// // // // //               ),
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildChecksSection() {
// // // // //     return Column(
// // // // //       children: [
// // // // //         ...checks.asMap().entries.map((entry) {
// // // // //           int index = entry.key;
// // // // //           var c = entry.value;
// // // // //           return Container(
// // // // //             margin: const EdgeInsets.only(top: 10),
// // // // //             padding: const EdgeInsets.all(10),
// // // // //             decoration: BoxDecoration(
// // // // //               border: Border.all(color: primaryBlue),
// // // // //               borderRadius: BorderRadius.circular(12),
// // // // //             ),
// // // // //             child: Column(
// // // // //               children: [
// // // // //                 Row(
// // // // //                   children: [
// // // // //                     Expanded(
// // // // //                       child: _customTextFieldGeneral(
// // // // //                         "البنك",
// // // // //                         c['bank']!,
// // // // //                         Icons.account_balance,
// // // // //                         isNumeric: false,
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(width: 8),
// // // // //                     Expanded(
// // // // //                       child: _customTextFieldGeneral(
// // // // //                         "رقم الشيك",
// // // // //                         c['number']!,
// // // // //                         Icons.numbers,
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //                 const SizedBox(height: 8),
// // // // //                 Row(
// // // // //                   children: [
// // // // //                     Expanded(
// // // // //                       child: _customTextFieldGeneral(
// // // // //                         "القيمة",
// // // // //                         c['amount']!,
// // // // //                         Icons.attach_money,
// // // // //                       ),
// // // // //                     ),
// // // // //                     const SizedBox(width: 8),
// // // // //                     Expanded(
// // // // //                       child: TextField(
// // // // //                         controller: c['date']!,
// // // // //                         readOnly: true,
// // // // //                         style: const TextStyle(fontWeight: FontWeight.bold),
// // // // //                         onTap: () => _selectCheckDate(context, c['date']!),
// // // // //                         decoration: InputDecoration(
// // // // //                           prefixIcon: Icon(
// // // // //                             Icons.date_range,
// // // // //                             color: primaryBlue,
// // // // //                           ),
// // // // //                           hintText: "التاريخ",
// // // // //                           filled: true,
// // // // //                           fillColor: Colors.grey.shade50,
// // // // //                           enabledBorder: OutlineInputBorder(
// // // // //                             borderRadius: BorderRadius.circular(12),
// // // // //                             borderSide: BorderSide(color: Colors.grey.shade200),
// // // // //                           ),
// // // // //                           focusedBorder: OutlineInputBorder(
// // // // //                             borderRadius: BorderRadius.circular(12),
// // // // //                             borderSide: BorderSide(color: primaryBlue),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //                 IconButton(
// // // // //                   icon: const Icon(Icons.delete, color: Colors.red),
// // // // //                   onPressed: () => setState(() => checks.removeAt(index)),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           );
// // // // //         }),
// // // // //         TextButton.icon(
// // // // //           onPressed: () => setState(
// // // // //             () => checks.add({
// // // // //               "bank": TextEditingController(),
// // // // //               "number": TextEditingController(),
// // // // //               "amount": TextEditingController(),
// // // // //               "date": TextEditingController(),
// // // // //             }),
// // // // //           ),
// // // // //           icon: const Icon(Icons.add),
// // // // //           label: const Text("إضافة شيك"),
// // // // //         ),
// // // // //       ],
// // // // //     );
// // // // //   }

// // // // //   Widget _buildSubmitButton() {
// // // // //     return SizedBox(
// // // // //       width: double.infinity,
// // // // //       height: 60,
// // // // //       child: ElevatedButton(
// // // // //         style: ElevatedButton.styleFrom(
// // // // //           backgroundColor: primaryBlue,
// // // // //           shape: RoundedRectangleBorder(
// // // // //             borderRadius: BorderRadius.circular(15),
// // // // //           ),
// // // // //         ),
// // // // //         onPressed: submitTransaction,
// // // // //         child: const Text(
// // // // //           "حفظ فاتورة الشراء والتوزيع",
// // // // //           style: TextStyle(
// // // // //             fontSize: 18,
// // // // //             color: Colors.white,
// // // // //             fontWeight: FontWeight.bold,
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
// // // // //     return Container(
// // // // //       height: 50,
// // // // //       width: 50,
// // // // //       decoration: BoxDecoration(
// // // // //         color: primaryBlue,
// // // // //         borderRadius: BorderRadius.circular(12),
// // // // //       ),
// // // // //       child: IconButton(
// // // // //         icon: Icon(icon, color: Colors.white),
// // // // //         onPressed: onPressed,
// // // // //       ),
// // // // //     );
// // // // //   }

// // // // //   void showAddPartnerDialog() {
// // // // //     TextEditingController name = TextEditingController();
// // // // //     TextEditingController phone = TextEditingController();
// // // // //     showDialog(
// // // // //       context: context,
// // // // //       builder: (_) => AlertDialog(
// // // // //         title: const Text("إضافة مورد جديد"),
// // // // //         content: Column(
// // // // //           mainAxisSize: MainAxisSize.min,
// // // // //           children: [
// // // // //             _customTextFieldGeneral(
// // // // //               "اسم المورد",
// // // // //               name,
// // // // //               Icons.business,
// // // // //               isNumeric: false,
// // // // //             ),
// // // // //             const SizedBox(height: 10),
// // // // //             _customTextFieldGeneral("رقم الهاتف", phone, Icons.phone),
// // // // //           ],
// // // // //         ),
// // // // //         actions: [
// // // // //           TextButton(
// // // // //             onPressed: () => Navigator.pop(context),
// // // // //             child: const Text("إلغاء"),
// // // // //           ),
// // // // //           ElevatedButton(
// // // // //             onPressed: () async {
// // // // //               await addPartner(name.text, phone.text);
// // // // //               Navigator.pop(context);
// // // // //             },
// // // // //             child: const Text("حفظ"),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // import 'dart:convert';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:intl/intl.dart' show DateFormat;
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import 'package:tradeflow_app/pages/link.dart';

// // // // class Distribution {
// // // //   Map? warehouse;
// // // //   TextEditingController qty;

// // // //   Distribution({this.warehouse, required this.qty});
// // // // }

// // // // class PurchaseScreen extends StatefulWidget {
// // // //   const PurchaseScreen({super.key});

// // // //   @override
// // // //   State<PurchaseScreen> createState() => _PurchaseScreenState();
// // // // }

// // // // class _PurchaseScreenState extends State<PurchaseScreen> {
// // // //   final Color primaryBlue = const Color(0xFF4A72C2);
// // // //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// // // //   List partners = [];
// // // //   Map? selectedPartner;
// // // //   List warehouses = [];
// // // //   List _allProducts = [];
// // // //   DateTime? _selectedDate;
// // // //   final TextEditingController _dateController = TextEditingController();

// // // //   List<Map<String, dynamic>> _purchaseItems = [
// // // //     {
// // // //       "product": null,
// // // //       "is_new": false,
// // // //       "new_product_name": TextEditingController(),
// // // //       "total_qty": TextEditingController(text: "0"),
// // // //       "purchase_price": TextEditingController(text: "0"),
// // // //       "sale_price": TextEditingController(text: "0"),
// // // //       "distributions": [
// // // //         Distribution(warehouse: null, qty: TextEditingController(text: "0")),
// // // //       ],
// // // //     },
// // // //   ];
// // // //   String paymentMethod = "cash";
// // // //   final TextEditingController _depositController = TextEditingController(
// // // //     text: "0",
// // // //   );
// // // //   List<Map<String, TextEditingController>> checks = [];

// // // //   List existingChecks = [];
// // // //   Map? selectedExistingCheck;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     fetchPartners();
// // // //     fetchWarehouses();
// // // //     fetchAllProducts();
// // // //     fetchExistingChecks();
// // // //   }

// // // //   Future fetchExistingChecks() async {
// // // //     print("Fetching existing checks...");
// // // //     try {
// // // //       final res = await http.get(
// // // //         Uri.parse(ApiEndpoints.getChecksApi),
// // // //         headers: await getHeaders(),
// // // //       );
// // // //       print("Response status: ${res.statusCode}");
// // // //       if (res.statusCode == 200) {
// // // //         final decoded = jsonDecode(res.body);
// // // //         print("all checks: $decoded");
// // // //         final List allChecks =
// // // //             (decoded is List ? decoded : decoded['data']) ?? [];
// // // //         setState(() {
// // // //           existingChecks = allChecks;
// // // //         });
// // // //       }
// // // //     } catch (e) {
// // // //       print("Error fetching checks: $e");
// // // //     }
// // // //   }

// // // //   double _calculateTotalInvoicePrice() {
// // // //     double total = 0.0;
// // // //     for (var item in _purchaseItems) {
// // // //       double qty = double.tryParse(item['total_qty'].text) ?? 0.0;
// // // //       double price = double.tryParse(item['purchase_price'].text) ?? 0.0;
// // // //       total += (qty * price);
// // // //     }
// // // //     return total;
// // // //   }

// // // //   Future<Map<String, String>> getHeaders() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     return {
// // // //       "Authorization": "Bearer ${prefs.getString("token")}",
// // // //       "Content-Type": "application/json",
// // // //       "Accept": "application/json",
// // // //     };
// // // //   }

// // // //   Future fetchPartners() async {
// // // //     final res = await http.get(
// // // //       Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
// // // //       headers: await getHeaders(),
// // // //     );
// // // //     if (res.statusCode == 200) {
// // // //       setState(
// // // //         () => partners =
// // // //             (jsonDecode(res.body) is List
// // // //                 ? jsonDecode(res.body)
// // // //                 : jsonDecode(res.body)['data']) ??
// // // //             [],
// // // //       );
// // // //     }
// // // //   }

// // // //   Future fetchWarehouses() async {
// // // //     final res = await http.get(
// // // //       Uri.parse(ApiEndpoints.getWarehouses),
// // // //       headers: await getHeaders(),
// // // //     );
// // // //     if (res.statusCode == 200) {
// // // //       setState(
// // // //         () => warehouses =
// // // //             (jsonDecode(res.body) is List
// // // //                 ? jsonDecode(res.body)
// // // //                 : jsonDecode(res.body)['data']) ??
// // // //             [],
// // // //       );
// // // //     }
// // // //   }

// // // //   Future<void> fetchAllProducts() async {
// // // //     try {
// // // //       final res = await http.get(
// // // //         Uri.parse(ApiEndpoints.allproducts),
// // // //         headers: await getHeaders(),
// // // //       );

// // // //       if (res.statusCode == 200) {
// // // //         final data = jsonDecode(res.body);
// // // //         setState(() {
// // // //           _allProducts = data['items'] ?? [];
// // // //         });
// // // //       }
// // // //     } catch (e) {
// // // //       print(e);
// // // //     }
// // // //   }

// // // //   Future addPartner(String name, String phone) async {
// // // //     final res = await http.post(
// // // //       Uri.parse(ApiEndpoints.addPartner),
// // // //       headers: await getHeaders(),
// // // //       body: jsonEncode({
// // // //         "company_name": name,
// // // //         "phone_number": phone,
// // // //         "partner_type": "supplier",
// // // //       }),
// // // //     );
// // // //     if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
// // // //   }

// // // //   int? getId(dynamic obj) {
// // // //     if (obj == null) return null;
// // // //     if (obj is Map) return obj['id'];
// // // //     if (obj is int) return obj;
// // // //     return null;
// // // //   }

// // // //   Future<void> submitTransaction() async {
// // // //     try {
// // // //       if (selectedPartner == null) {
// // // //         throw Exception("الرجاء اختيار المورد");
// // // //       }

// // // //       List itemsData = [];

// // // //       for (var item in _purchaseItems) {
// // // //         final isNew = item['is_new'] == true;

// // // //         final product = item['product'];
// // // //         final newName = item['new_product_name'].text.trim();

// // // //         String itemName = "";
// // // //         int? productId;

// // // //         if (isNew) {
// // // //           if (newName.isEmpty) {
// // // //             throw Exception("اسم المنتج الجديد مطلوب");
// // // //           }
// // // //           itemName = newName;
// // // //         } else {
// // // //           if (product == null) {
// // // //             throw Exception("الرجاء اختيار منتج");
// // // //           }
// // // //           itemName = product['name'] ?? "";
// // // //           productId = product['id'];
// // // //         }

// // // //         double totalQty = double.tryParse(item['total_qty'].text.trim()) ?? 0;

// // // //         if (totalQty <= 0) {
// // // //           throw Exception("الكمية يجب أن تكون أكبر من 0");
// // // //         }

// // // //         double unitCost =
// // // //             double.tryParse(item['purchase_price'].text.trim()) ?? 0;

// // // //         if (unitCost <= 0) {
// // // //           throw Exception("سعر الشراء يجب أن يكون أكبر من 0");
// // // //         }

// // // //         double salePrice = double.tryParse(item['sale_price'].text.trim()) ?? 0;

// // // //         double distributedQty = 0;
// // // //         List allocations = [];

// // // //         for (var dist in item['distributions']) {
// // // //           if (dist.warehouse == null) continue;

// // // //           double q = double.tryParse(dist.qty.text.trim()) ?? 0;

// // // //           if (q <= 0) continue;

// // // //           distributedQty += q;

// // // //           allocations.add({
// // // //             "warehouse_id": dist.warehouse['id'],
// // // //             "quantity": q,
// // // //           });
// // // //         }

// // // //         if ((distributedQty - totalQty).abs() > 0.0001) {
// // // //           throw Exception(
// // // //             "الكمية غير متطابقة: الكلي=$totalQty والموزع=$distributedQty للمنتج $itemName",
// // // //           );
// // // //         }

// // // //         itemsData.add({
// // // //           "product_id": productId,
// // // //           "item_name": itemName,
// // // //           "quantity": totalQty,
// // // //           "unit_cost": unitCost,
// // // //           "sale_price": salePrice,
// // // //           "allocations": allocations,
// // // //         });
// // // //       }

// // // //       if (itemsData.isEmpty) {
// // // //         throw Exception("الرجاء إضافة منتج واحد على الأقل");
// // // //       }

// // // //       if (selectedPartner!['partner_type'] != 'supplier') {
// // // //         throw Exception("الرجاء اختيار مورد (Supplier) صحيح");
// // // //       }

// // // //       final body = {
// // // //         "partner_id": selectedPartner!['id'],
// // // //         "purchase_date": DateTime.now().toIso8601String().substring(0, 10),
// // // //         "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
// // // //         "items": itemsData,
// // // //       };

// // // //       final response = await http.post(
// // // //         Uri.parse(ApiEndpoints.addpurchase),
// // // //         headers: await getHeaders(),
// // // //         body: jsonEncode(body),
// // // //       );

// // // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // // //         final data = jsonDecode(response.body);
// // // //         await handlePayment(data['purchase']['id']);

// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           const SnackBar(
// // // //             content: Text("تم حفظ الفاتورة بنجاح"),
// // // //             backgroundColor: Colors.green,
// // // //           ),
// // // //         );

// // // //         if (mounted) {
// // // //           Navigator.pop(context);
// // // //         }
// // // //       } else {
// // // //         throw Exception("فشل الحفظ: ${response.body}");
// // // //       }
// // // //     } catch (e) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(content: Text("$e"), backgroundColor: Colors.red),
// // // //       );
// // // //     }
// // // //   }

// // // //   Future<void> handlePayment(int? purchaseId) async {
// // // //     if (purchaseId == null) return;
// // // //     double amount = double.tryParse(_depositController.text) ?? 0;

// // // //     if (paymentMethod == "cash") {
// // // //       if (amount > 0) {
// // // //         await sendPayment(purchaseId, "cash", amount);
// // // //       }
// // // //     } else if (paymentMethod == "check") {
// // // //       for (var c in checks) {
// // // //         String bank = c['bank']!.text;
// // // //         String number = c['number']!.text;
// // // //         String date = c['date']!.text;
// // // //         double amt = double.tryParse(c['amount']!.text) ?? 0;

// // // //         if (bank.isEmpty || number.isEmpty || date.isEmpty || amt <= 0) {
// // // //           continue;
// // // //         }

// // // //         await sendPayment(
// // // //           purchaseId,
// // // //           "check",
// // // //           amt,
// // // //           note: "شيك من $bank",
// // // //           checkData: {
// // // //             "bank_name": bank,
// // // //             "check_number": number,
// // // //             "company_name": "eehab",
// // // //             "issue_date": _selectedDate != null
// // // //                 ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
// // // //                 : DateTime.now().toString().substring(0, 10),
// // // //             "cashing_date": date,
// // // //             "status": "pending",
// // // //             "type": "صادر",
// // // //           },
// // // //         );
// // // //       }
// // // //     } else if (paymentMethod == "existing_check") {
// // // //       if (selectedExistingCheck != null) {
// // // //         await sendPayment(
// // // //           purchaseId,
// // // //           "check",
// // // //           (selectedExistingCheck!['amount'] is int
// // // //                   ? (selectedExistingCheck!['amount'] as int).toDouble()
// // // //                   : selectedExistingCheck!['amount']?.toDouble()) ??
// // // //               0,
// // // //           note: "شيك موجود رقم ${selectedExistingCheck!['check_number'] ?? ''}",
// // // //           checkData: {"check_id": selectedExistingCheck!['id']},
// // // //         );
// // // //       }
// // // //     }
// // // //   }

// // // //   Future<void> _selectDate(BuildContext context) async {
// // // //     final DateTime? picked = await showDatePicker(
// // // //       context: context,
// // // //       initialDate: _selectedDate ?? DateTime.now(),
// // // //       firstDate: DateTime(2000),
// // // //       lastDate: DateTime(2101),
// // // //     );
// // // //     if (picked != null) {
// // // //       setState(() {
// // // //         _selectedDate = picked;
// // // //         _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
// // // //       });
// // // //     }
// // // //   }

// // // //   Future<void> _selectCheckDate(
// // // //     BuildContext context,
// // // //     TextEditingController controller,
// // // //   ) async {
// // // //     final DateTime? picked = await showDatePicker(
// // // //       context: context,
// // // //       initialDate: DateTime.now(),
// // // //       firstDate: DateTime(2000),
// // // //       lastDate: DateTime(2101),
// // // //     );
// // // //     if (picked != null) {
// // // //       setState(() {
// // // //         controller.text = DateFormat('yyyy-MM-dd').format(picked);
// // // //       });
// // // //     }
// // // //   }

// // // //   Future<int?> sendCheck({
// // // //     required String bankName,
// // // //     required String checkNumber,
// // // //     required String companyName,
// // // //     required double amount,
// // // //     required String cashingDate,
// // // //   }) async {
// // // //     final headers = await getHeaders();

// // // //     final body = {
// // // //       "bank_name": bankName,
// // // //       "check_number": checkNumber,
// // // //       "company_name": companyName,
// // // //       "amount": amount,
// // // //       "issue_date": _selectedDate != null
// // // //           ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
// // // //           : DateTime.now().toString().substring(0, 10),
// // // //       "cashing_date": cashingDate,
// // // //       "status": "pending",
// // // //       "type": "صادر",
// // // //     };

// // // //     final response = await http.post(
// // // //       Uri.parse(ApiEndpoints.addCheck),
// // // //       headers: headers,
// // // //       body: jsonEncode(body),
// // // //     );

// // // //     if (response.statusCode == 200 || response.statusCode == 201) {
// // // //       final data = jsonDecode(response.body);
// // // //       return data['check']['id'];
// // // //     }
// // // //     return null;
// // // //   }

// // // //   Future<void> sendPayment(
// // // //     int purchaseId,
// // // //     String method,
// // // //     double amount, {
// // // //     String note = "",
// // // //     Map<String, dynamic>? checkData,
// // // //   }) async {
// // // //     final headers = await getHeaders();

// // // //     final body = {
// // // //       "purchase_id": purchaseId,
// // // //       "payment_method": method,
// // // //       "amount": amount,
// // // //       "payment_date": DateTime.now().toString().substring(0, 10),
// // // //       "notes": note,
// // // //     };
// // // //     if (method == "check" && checkData != null) {
// // // //       body["check"] = checkData;
// // // //     }
// // // //     await http.post(
// // // //       Uri.parse("${ApiEndpoints.pur}/$purchaseId/payments"),
// // // //       headers: headers,
// // // //       body: jsonEncode(body),
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         backgroundColor: primaryBlue,
// // // //         title: const Text(
// // // //           "شراء وتوزيع بضاعة",
// // // //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // // //         ),
// // // //         centerTitle: true,
// // // //       ),
// // // //       body: Directionality(
// // // //         textDirection: TextDirection.rtl,
// // // //         child: SingleChildScrollView(
// // // //           padding: const EdgeInsets.all(20),
// // // //           child: Column(
// // // //             children: [
// // // //               _buildSectionCard(
// // // //                 title: "بيانات المورد",
// // // //                 icon: Icons.person_outline,
// // // //                 child: Row(
// // // //                   children: [
// // // //                     Expanded(
// // // //                       child: _customDropdown(
// // // //                         "اختر البارتنر",
// // // //                         partners,
// // // //                         selectedPartner,
// // // //                         (val) {
// // // //                           setState(() {
// // // //                             selectedPartner = val;
// // // //                           });
// // // //                         },
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 10),
// // // //                     _buildAddButton(
// // // //                       Icons.person_add_alt_1,
// // // //                       () => showAddPartnerDialog(),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),

// // // //               ..._purchaseItems.asMap().entries.map((entry) {
// // // //                 int itemIndex = entry.key;
// // // //                 var item = entry.value;
// // // //                 return _buildSectionCard(
// // // //                   title: "المنتج ${itemIndex + 1}",
// // // //                   icon: Icons.shopping_bag_outlined,
// // // //                   child: Column(
// // // //                     children: [
// // // //                       Row(
// // // //                         children: [
// // // //                           Expanded(
// // // //                             child: item['is_new']
// // // //                                 ? _customTextFieldGeneral(
// // // //                                     "اسم المنتج الجديد",
// // // //                                     item['new_product_name'],
// // // //                                     Icons.edit_note,
// // // //                                     isNumeric: false,
// // // //                                   )
// // // //                                 : _customDropdown(
// // // //                                     "اختر المنتج",
// // // //                                     _allProducts,
// // // //                                     item['product'],
// // // //                                     (val) {
// // // //                                       setState(() {
// // // //                                         item['product'] = val;
// // // //                                       });
// // // //                                     },
// // // //                                   ),
// // // //                           ),
// // // //                           const SizedBox(width: 10),
// // // //                           _buildAddButton(
// // // //                             item['is_new'] ? Icons.list : Icons.add_box,
// // // //                             () => setState(
// // // //                               () => item['is_new'] = !item['is_new'],
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                       const SizedBox(height: 15),
// // // //                       _customTextFieldGeneral(
// // // //                         "الكمية الكلية",
// // // //                         item['total_qty'],
// // // //                         Icons.production_quantity_limits,
// // // //                         onChanged: (val) => setState(() {}),
// // // //                       ),
// // // //                       const SizedBox(height: 15),
// // // //                       Row(
// // // //                         children: [
// // // //                           Expanded(
// // // //                             child: _priceTextFieldCustom(
// // // //                               "سعر شراء",
// // // //                               item['purchase_price'],
// // // //                               onChanged: (val) => setState(() {}),
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(width: 10),
// // // //                           Expanded(
// // // //                             child: _priceTextFieldCustom(
// // // //                               "سعر بيع",
// // // //                               item['sale_price'],
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                       const Divider(height: 30),
// // // //                       const Text(
// // // //                         "توزيع الكمية على المستودعات:",
// // // //                         style: TextStyle(fontWeight: FontWeight.bold),
// // // //                       ),
// // // //                       const SizedBox(height: 10),
// // // //                       ...List.generate(item['distributions'].length, (
// // // //                         distIndex,
// // // //                       ) {
// // // //                         var dist = item['distributions'][distIndex];

// // // //                         return Padding(
// // // //                           padding: const EdgeInsets.only(bottom: 8),
// // // //                           child: Row(
// // // //                             children: [
// // // //                               Expanded(
// // // //                                 flex: 2,
// // // //                                 child: _customDropdown(
// // // //                                   "المستودع",
// // // //                                   warehouses,
// // // //                                   dist.warehouse,
// // // //                                   (v) {
// // // //                                     print("SELECTED WAREHOUSE: $v");
// // // //                                     setState(() {
// // // //                                       dist.warehouse = v;
// // // //                                     });
// // // //                                   },
// // // //                                 ),
// // // //                               ),
// // // //                               const SizedBox(width: 8),
// // // //                               Expanded(
// // // //                                 flex: 1,
// // // //                                 child: _customTextFieldGeneral(
// // // //                                   "الكمية",
// // // //                                   dist.qty,
// // // //                                   Icons.pie_chart_outline,
// // // //                                 ),
// // // //                               ),
// // // //                               IconButton(
// // // //                                 icon: Icon(
// // // //                                   distIndex == 0
// // // //                                       ? Icons.add_circle_outline
// // // //                                       : Icons.remove_circle_outline,
// // // //                                   color: primaryBlue,
// // // //                                 ),
// // // //                                 onPressed: () {
// // // //                                   setState(() {
// // // //                                     if (distIndex == 0) {
// // // //                                       item['distributions'].add(
// // // //                                         Distribution(
// // // //                                           warehouse: null,
// // // //                                           qty: TextEditingController(text: "0"),
// // // //                                         ),
// // // //                                       );
// // // //                                     } else {
// // // //                                       item['distributions'].removeAt(distIndex);
// // // //                                     }
// // // //                                   });
// // // //                                 },
// // // //                               ),
// // // //                             ],
// // // //                           ),
// // // //                         );
// // // //                       }),
// // // //                       if (itemIndex > 0)
// // // //                         TextButton.icon(
// // // //                           onPressed: () => setState(
// // // //                             () => _purchaseItems.removeAt(itemIndex),
// // // //                           ),
// // // //                           icon: const Icon(Icons.delete, color: Colors.red),
// // // //                           label: const Text(
// // // //                             "حذف هذا المنتج",
// // // //                             style: TextStyle(color: Colors.red),
// // // //                           ),
// // // //                         ),
// // // //                     ],
// // // //                   ),
// // // //                 );
// // // //               }),

// // // //               ElevatedButton.icon(
// // // //                 onPressed: () => setState(
// // // //                   () => _purchaseItems.add({
// // // //                     "product": null,
// // // //                     "is_new": false,
// // // //                     "new_product_name": TextEditingController(),
// // // //                     "total_qty": TextEditingController(text: "0"),
// // // //                     "purchase_price": TextEditingController(text: "0"),
// // // //                     "sale_price": TextEditingController(text: "0"),
// // // //                     "distributions": [
// // // //                       Distribution(
// // // //                         warehouse: null,
// // // //                         qty: TextEditingController(text: "0"),
// // // //                       ),
// // // //                     ],
// // // //                   }),
// // // //                 ),
// // // //                 icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
// // // //                 label: const Text(
// // // //                   "إضافة منتج آخر للفاتورة",
// // // //                   style: TextStyle(color: Colors.white),
// // // //                 ),
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: Colors.green,
// // // //                   shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(12),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(height: 20),

// // // //               _buildFinancialSummaryCard(),

// // // //               _buildSectionCard(
// // // //                 title: "طريقة الدفع",
// // // //                 icon: Icons.payment_outlined,
// // // //                 child: Column(
// // // //                   children: [
// // // //                     Row(
// // // //                       children: [
// // // //                         _payBtn("نقداً", "cash"),
// // // //                         _payBtn("شيكات", "check"),
// // // //                         _payBtn("شيك موجود", "existing_check"),
// // // //                       ],
// // // //                     ),
// // // //                     if (paymentMethod == "cash") ...[
// // // //                       const SizedBox(height: 15),
// // // //                       _customTextFieldGeneral(
// // // //                         "المبلغ المدفوع",
// // // //                         _depositController,
// // // //                         Icons.money,
// // // //                       ),
// // // //                     ],
// // // //                     if (paymentMethod == "check") _buildChecksSection(),
// // // //                     if (paymentMethod == "existing_check")
// // // //                       _buildExistingCheckSelector(),
// // // //                     const SizedBox(height: 20),
// // // //                     _buildSubmitButton(),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildFinancialSummaryCard() {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(16),
// // // //       margin: const EdgeInsets.only(bottom: 20),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(20),
// // // //         boxShadow: [
// // // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               Icon(Icons.assignment_outlined, color: primaryBlue, size: 22),
// // // //               const SizedBox(width: 8),
// // // //               Text(
// // // //                 "الملخص المالي",
// // // //                 style: TextStyle(
// // // //                   fontWeight: FontWeight.bold,
// // // //                   fontSize: 18,
// // // //                   color: primaryBlue,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const Divider(height: 20),
// // // //           Row(
// // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //             children: [
// // // //               Text(
// // // //                 "\$ ${_calculateTotalInvoicePrice().toStringAsFixed(1)}",
// // // //                 style: TextStyle(
// // // //                   fontSize: 18,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: primaryBlue,
// // // //                 ),
// // // //               ),
// // // //               Text(
// // // //                 "السعر الإجمالي الكلي",
// // // //                 style: TextStyle(
// // // //                   fontSize: 15,
// // // //                   fontWeight: FontWeight.bold,
// // // //                   color: Colors.grey[700],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ======= التعديل الجديد لعرض التاريخ والقيمة بشكل مرتب ومنسق للمستخدم =======
// // // //   Widget _buildExistingCheckSelector() {
// // // //     return Container(
// // // //       margin: const EdgeInsets.only(top: 10),
// // // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.grey.shade50,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: Colors.grey.shade200),
// // // //       ),
// // // //       child: DropdownButtonFormField<Map>(
// // // //         value: selectedExistingCheck,
// // // //         isExpanded: true,
// // // //         hint: const Text("اختر شيك موجود"),
// // // //         items: existingChecks.map((e) {
// // // //           final Map checkMap = e as Map;

// // // //           // 1. تحديد التاريخ المناسب (يعرض cashing_date وإذا كان فارغاً يأخذ issue_date)
// // // //           String displayDate = "";
// // // //           if (checkMap['cashing_date'] != null &&
// // // //               checkMap['cashing_date'].toString().trim().isNotEmpty) {
// // // //             displayDate = checkMap['cashing_date'].toString();
// // // //           } else if (checkMap['issue_date'] != null &&
// // // //               checkMap['issue_date'].toString().trim().isNotEmpty) {
// // // //             displayDate = checkMap['issue_date'].toString();
// // // //           } else {
// // // //             displayDate = "بدون تاريخ";
// // // //           }

// // // //           // 2. جلب القيمة وتحويلها لرقم عشري لتنسيقها بشكل مالي
// // // //           double amount = 0.0;
// // // //           if (checkMap['amount'] is num) {
// // // //             amount = (checkMap['amount'] as num).toDouble();
// // // //           } else if (checkMap['amount'] != null) {
// // // //             amount = double.tryParse(checkMap['amount'].toString()) ?? 0.0;
// // // //           }

// // // //           // 3. جلب رقم الشيك لعرضه كمعلومة مرجعية فرعية تمنع التشابه
// // // //           String checkNum = checkMap['check_number']?.toString() ?? "بدون رقم";

// // // //           return DropdownMenuItem<Map>(
// // // //             value: checkMap,
// // // //             child: Row(
// // // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //               children: [
// // // //                 Row(
// // // //                   children: [
// // // //                     Icon(
// // // //                       Icons.calendar_today,
// // // //                       size: 14,
// // // //                       color: Colors.grey[600],
// // // //                     ),
// // // //                     const SizedBox(width: 6),
// // // //                     Text(
// // // //                       displayDate,
// // // //                       style: TextStyle(color: Colors.grey[800], fontSize: 14),
// // // //                     ),
// // // //                     const Padding(
// // // //                       padding: EdgeInsets.symmetric(horizontal: 8.0),
// // // //                       child: Text(
// // // //                         "•",
// // // //                         style: TextStyle(
// // // //                           fontWeight: FontWeight.bold,
// // // //                           color: Colors.grey,
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                     Text(
// // // //                       "\$ ${amount.toStringAsFixed(2)}",
// // // //                       style: TextStyle(
// // // //                         color: primaryBlue,
// // // //                         fontWeight: FontWeight.bold,
// // // //                         fontSize: 14,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 Text(
// // // //                   "رقم: $checkNum",
// // // //                   style: TextStyle(color: Colors.grey[500], fontSize: 12),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           );
// // // //         }).toList(),
// // // //         onChanged: (v) => setState(() => selectedExistingCheck = v),
// // // //         decoration: const InputDecoration(border: InputBorder.none),
// // // //       ),
// // // //     );
// // // //   }
// // // //   // ====================================================================

// // // //   Widget _priceTextFieldCustom(
// // // //     String labelText,
// // // //     TextEditingController controller, {
// // // //     ValueChanged<String>? onChanged,
// // // //   }) {
// // // //     return TextField(
// // // //       controller: controller,
// // // //       keyboardType: TextInputType.number,
// // // //       onChanged: onChanged,
// // // //       style: const TextStyle(fontWeight: FontWeight.bold),
// // // //       decoration: InputDecoration(
// // // //         labelText: labelText,
// // // //         floatingLabelBehavior: FloatingLabelBehavior.always,
// // // //         labelStyle: TextStyle(
// // // //           fontSize: 14,
// // // //           color: Colors.grey[700],
// // // //           fontWeight: FontWeight.normal,
// // // //         ),
// // // //         filled: true,
// // // //         fillColor: Colors.grey.shade50,
// // // //         contentPadding: const EdgeInsets.symmetric(
// // // //           horizontal: 16,
// // // //           vertical: 12,
// // // //         ),
// // // //         enabledBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: Colors.grey.shade200),
// // // //         ),
// // // //         focusedBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: primaryBlue),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _customTextFieldGeneral(
// // // //     String hint,
// // // //     TextEditingController controller,
// // // //     IconData icon, {
// // // //     bool isNumeric = true,
// // // //     ValueChanged<String>? onChanged,
// // // //   }) {
// // // //     return TextField(
// // // //       controller: controller,
// // // //       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
// // // //       onChanged: onChanged,
// // // //       style: const TextStyle(fontWeight: FontWeight.bold),
// // // //       decoration: InputDecoration(
// // // //         prefixIcon: Icon(icon, color: primaryBlue),
// // // //         hintText: hint,
// // // //         filled: true,
// // // //         fillColor: Colors.grey.shade50,
// // // //         enabledBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: Colors.grey.shade200),
// // // //         ),
// // // //         focusedBorder: OutlineInputBorder(
// // // //           borderRadius: BorderRadius.circular(12),
// // // //           borderSide: BorderSide(color: primaryBlue),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildSectionCard({
// // // //     required String title,
// // // //     required IconData icon,
// // // //     required Widget child,
// // // //   }) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.all(16),
// // // //       margin: const EdgeInsets.only(bottom: 20),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(20),
// // // //         boxShadow: [
// // // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
// // // //         ],
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               Icon(icon, color: primaryBlue, size: 22),
// // // //               const SizedBox(width: 8),
// // // //               Text(
// // // //                 title,
// // // //                 style: TextStyle(
// // // //                   fontWeight: FontWeight.bold,
// // // //                   fontSize: 18,
// // // //                   color: primaryBlue,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //           const Divider(height: 20),
// // // //           child,
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _customDropdown(
// // // //     String hint,
// // // //     List data,
// // // //     dynamic value,
// // // //     Function onChanged,
// // // //   ) {
// // // //     return Container(
// // // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.grey.shade50,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(color: Colors.grey.shade200),
// // // //       ),
// // // //       child: DropdownButtonFormField(
// // // //         value: value,
// // // //         isExpanded: true,
// // // //         hint: Text(hint),
// // // //         items: data.map((e) {
// // // //           return DropdownMenuItem(
// // // //             value: e,
// // // //             child: Text(
// // // //               e['name'] ??
// // // //                   e['company_name'] ??
// // // //                   e['check_number'] ??
// // // //                   e['product_name'] ??
// // // //                   "",
// // // //             ),
// // // //           );
// // // //         }).toList(),
// // // //         onChanged: (v) => onChanged(v),
// // // //         decoration: const InputDecoration(border: InputBorder.none),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _payBtn(String text, String type) {
// // // //     bool isSelected = paymentMethod == type;
// // // //     return Expanded(
// // // //       child: GestureDetector(
// // // //         onTap: () => setState(() => paymentMethod = type),
// // // //         child: Container(
// // // //           margin: const EdgeInsets.all(4),
// // // //           padding: const EdgeInsets.symmetric(vertical: 14),
// // // //           decoration: BoxDecoration(
// // // //             color: isSelected ? primaryBlue : Colors.white,
// // // //             borderRadius: BorderRadius.circular(12),
// // // //             border: Border.all(
// // // //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// // // //             ),
// // // //           ),
// // // //           child: Center(
// // // //             child: Text(
// // // //               text,
// // // //               style: TextStyle(
// // // //                 color: isSelected ? Colors.white : Colors.black87,
// // // //                 fontWeight: FontWeight.bold,
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildChecksSection() {
// // // //     return Column(
// // // //       children: [
// // // //         ...checks.asMap().entries.map((entry) {
// // // //           int index = entry.key;
// // // //           var c = entry.value;
// // // //           return Container(
// // // //             margin: const EdgeInsets.only(top: 10),
// // // //             padding: const EdgeInsets.all(10),
// // // //             decoration: BoxDecoration(
// // // //               border: Border.all(color: primaryBlue),
// // // //               borderRadius: BorderRadius.circular(12),
// // // //             ),
// // // //             child: Column(
// // // //               children: [
// // // //                 Row(
// // // //                   children: [
// // // //                     Expanded(
// // // //                       child: _customTextFieldGeneral(
// // // //                         "البنك",
// // // //                         c['bank']!,
// // // //                         Icons.account_balance,
// // // //                         isNumeric: false,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 8),
// // // //                     Expanded(
// // // //                       child: _customTextFieldGeneral(
// // // //                         "رقم الشيك",
// // // //                         c['number']!,
// // // //                         Icons.numbers,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 const SizedBox(height: 8),
// // // //                 Row(
// // // //                   children: [
// // // //                     Expanded(
// // // //                       child: _customTextFieldGeneral(
// // // //                         "القيمة",
// // // //                         c['amount']!,
// // // //                         Icons.attach_money,
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(width: 8),
// // // //                     Expanded(
// // // //                       child: TextField(
// // // //                         controller: c['date']!,
// // // //                         readOnly: true,
// // // //                         style: const TextStyle(fontWeight: FontWeight.bold),
// // // //                         onTap: () => _selectCheckDate(context, c['date']!),
// // // //                         decoration: InputDecoration(
// // // //                           prefixIcon: Icon(
// // // //                             Icons.date_range,
// // // //                             color: primaryBlue,
// // // //                           ),
// // // //                           hintText: "التاريخ",
// // // //                           filled: true,
// // // //                           fillColor: Colors.grey.shade50,
// // // //                           enabledBorder: OutlineInputBorder(
// // // //                             borderRadius: BorderRadius.circular(12),
// // // //                             borderSide: BorderSide(color: Colors.grey.shade200),
// // // //                           ),
// // // //                           focusedBorder: OutlineInputBorder(
// // // //                             borderRadius: BorderRadius.circular(12),
// // // //                             borderSide: BorderSide(color: primaryBlue),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 IconButton(
// // // //                   icon: const Icon(Icons.delete, color: Colors.red),
// // // //                   onPressed: () => setState(() => checks.removeAt(index)),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           );
// // // //         }),
// // // //         TextButton.icon(
// // // //           onPressed: () => setState(
// // // //             () => checks.add({
// // // //               "bank": TextEditingController(),
// // // //               "number": TextEditingController(),
// // // //               "amount": TextEditingController(),
// // // //               "date": TextEditingController(),
// // // //             }),
// // // //           ),
// // // //           icon: const Icon(Icons.add),
// // // //           label: const Text("إضافة شيك"),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildSubmitButton() {
// // // //     return SizedBox(
// // // //       width: double.infinity,
// // // //       height: 60,
// // // //       child: ElevatedButton(
// // // //         style: ElevatedButton.styleFrom(
// // // //           backgroundColor: primaryBlue,
// // // //           shape: RoundedRectangleBorder(
// // // //             borderRadius: BorderRadius.circular(15),
// // // //           ),
// // // //         ),
// // // //         onPressed: submitTransaction,
// // // //         child: const Text(
// // // //           "حفظ فاتورة الشراء والتوزيع",
// // // //           style: TextStyle(
// // // //             fontSize: 18,
// // // //             color: Colors.white,
// // // //             fontWeight: FontWeight.bold,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
// // // //     return Container(
// // // //       height: 50,
// // // //       width: 50,
// // // //       decoration: BoxDecoration(
// // // //         color: primaryBlue,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //       ),
// // // //       child: IconButton(
// // // //         icon: Icon(icon, color: Colors.white),
// // // //         onPressed: onPressed,
// // // //       ),
// // // //     );
// // // //   }

// // // //   void showAddPartnerDialog() {
// // // //     TextEditingController name = TextEditingController();
// // // //     TextEditingController phone = TextEditingController();
// // // //     showDialog(
// // // //       context: context,
// // // //       builder: (_) => AlertDialog(
// // // //         title: const Text("إضافة مورد جديد"),
// // // //         content: Column(
// // // //           mainAxisSize: MainAxisSize.min,
// // // //           children: [
// // // //             _customTextFieldGeneral(
// // // //               "اسم المورد",
// // // //               name,
// // // //               Icons.business,
// // // //               isNumeric: false,
// // // //             ),
// // // //             const SizedBox(height: 10),
// // // //             _customTextFieldGeneral("رقم الهاتف", phone, Icons.phone),
// // // //           ],
// // // //         ),
// // // //         actions: [
// // // //           TextButton(
// // // //             onPressed: () => Navigator.pop(context),
// // // //             child: const Text("إلغاء"),
// // // //           ),
// // // //           ElevatedButton(
// // // //             onPressed: () async {
// // // //               await addPartner(name.text, phone.text);
// // // //               Navigator.pop(context);
// // // //             },
// // // //             child: const Text("حفظ"),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // import 'dart:convert';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:intl/intl.dart' show DateFormat;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:tradeflow_app/pages/link.dart'; // تأكد من مسار هذا الملف عندك

// // // class Distribution {
// // //   Map? warehouse;
// // //   TextEditingController qty;

// // //   Distribution({this.warehouse, required this.qty});
// // // }

// // // class PurchaseScreen extends StatefulWidget {
// // //   const PurchaseScreen({super.key});

// // //   @override
// // //   State<PurchaseScreen> createState() => _PurchaseScreenState();
// // // }

// // // class _PurchaseScreenState extends State<PurchaseScreen> {
// // //   final Color primaryBlue = const Color(0xFF4A72C2);
// // //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// // //   List partners = [];
// // //   Map? selectedPartner;
// // //   List warehouses = [];
// // //   List _allProducts = [];
// // //   DateTime? _selectedDate;
// // //   final TextEditingController _dateController = TextEditingController();

// // //   List<Map<String, dynamic>> _purchaseItems = [
// // //     {
// // //       "product": null,
// // //       "is_new": false,
// // //       "new_product_name": TextEditingController(),
// // //       "total_qty": TextEditingController(text: "0"),
// // //       "purchase_price": TextEditingController(text: "0"),
// // //       "sale_price": TextEditingController(text: "0"),
// // //       "distributions": [
// // //         Distribution(warehouse: null, qty: TextEditingController(text: "0")),
// // //       ],
// // //     },
// // //   ];

// // //   String paymentMethod = "cash";
// // //   final TextEditingController _depositController = TextEditingController(
// // //     text: "0",
// // //   );
// // //   List<Map<String, TextEditingController>> checks = [];
// // //   List existingChecks = [];
// // //   Map? selectedExistingCheck;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchPartners();
// // //     fetchWarehouses();
// // //     fetchAllProducts();
// // //     fetchExistingChecks();
// // //   }

// // //   Future<Map<String, String>> getHeaders() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return {
// // //       "Authorization": "Bearer ${prefs.getString("token")}",
// // //       "Content-Type": "application/json",
// // //       "Accept": "application/json",
// // //     };
// // //   }

// // //   Future fetchExistingChecks() async {
// // //     try {
// // //       final res = await http.get(
// // //         Uri.parse(ApiEndpoints.getChecksApi),
// // //         headers: await getHeaders(),
// // //       );
// // //       if (res.statusCode == 200) {
// // //         final decoded = jsonDecode(res.body);
// // //         final List allChecks =
// // //             (decoded is List ? decoded : decoded['data']) ?? [];
// // //         setState(() {
// // //           existingChecks = allChecks;
// // //         });
// // //       }
// // //     } catch (e) {
// // //       print("Error fetching checks: $e");
// // //     }
// // //   }

// // //   double _calculateTotalInvoicePrice() {
// // //     double total = 0.0;
// // //     for (var item in _purchaseItems) {
// // //       double qty = double.tryParse(item['total_qty'].text) ?? 0.0;
// // //       double price = double.tryParse(item['purchase_price'].text) ?? 0.0;
// // //       total += (qty * price);
// // //     }
// // //     return total;
// // //   }

// // //   Future fetchPartners() async {
// // //     final res = await http.get(
// // //       Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
// // //       headers: await getHeaders(),
// // //     );
// // //     if (res.statusCode == 200) {
// // //       setState(
// // //         () => partners =
// // //             (jsonDecode(res.body) is List
// // //                 ? jsonDecode(res.body)
// // //                 : jsonDecode(res.body)['data']) ??
// // //             [],
// // //       );
// // //     }
// // //   }

// // //   Future fetchWarehouses() async {
// // //     final res = await http.get(
// // //       Uri.parse(ApiEndpoints.getWarehouses),
// // //       headers: await getHeaders(),
// // //     );
// // //     if (res.statusCode == 200) {
// // //       setState(
// // //         () => warehouses =
// // //             (jsonDecode(res.body) is List
// // //                 ? jsonDecode(res.body)
// // //                 : jsonDecode(res.body)['data']) ??
// // //             [],
// // //       );
// // //     }
// // //   }

// // //   Future<void> fetchAllProducts() async {
// // //     try {
// // //       final res = await http.get(
// // //         Uri.parse(ApiEndpoints.allproducts),
// // //         headers: await getHeaders(),
// // //       );
// // //       if (res.statusCode == 200) {
// // //         final data = jsonDecode(res.body);
// // //         setState(() {
// // //           _allProducts = data['items'] ?? [];
// // //         });
// // //       }
// // //     } catch (e) {
// // //       print(e);
// // //     }
// // //   }

// // //   Future addPartner(String name, String phone) async {
// // //     final res = await http.post(
// // //       Uri.parse(ApiEndpoints.addPartner),
// // //       headers: await getHeaders(),
// // //       body: jsonEncode({
// // //         "company_name": name,
// // //         "phone_number": phone,
// // //         "partner_type": "supplier",
// // //       }),
// // //     );
// // //     if (res.statusCode == 200 || res.statusCode == 201) fetchPartners();
// // //   }

// // //   Future<void> submitTransaction() async {
// // //     try {
// // //       if (selectedPartner == null) throw Exception("الرجاء اختيار المورد");

// // //       List itemsData = [];
// // //       for (var item in _purchaseItems) {
// // //         final isNew = item['is_new'] == true;
// // //         final product = item['product'];
// // //         final newName = item['new_product_name'].text.trim();
// // //         String itemName = "";
// // //         int? productId;

// // //         if (isNew) {
// // //           if (newName.isEmpty) throw Exception("اسم المنتج الجديد مطلوب");
// // //           itemName = newName;
// // //         } else {
// // //           if (product == null) throw Exception("الرجاء اختيار منتج");
// // //           itemName = product['name'] ?? "";
// // //           productId = product['id'];
// // //         }

// // //         double totalQty = double.tryParse(item['total_qty'].text.trim()) ?? 0;
// // //         if (totalQty <= 0) throw Exception("الكمية يجب أن تكون أكبر من 0");

// // //         double unitCost =
// // //             double.tryParse(item['purchase_price'].text.trim()) ?? 0;
// // //         if (unitCost <= 0) throw Exception("سعر الشراء يجب أن يكون أكبر من 0");

// // //         double salePrice = double.tryParse(item['sale_price'].text.trim()) ?? 0;
// // //         double distributedQty = 0;
// // //         List allocations = [];

// // //         for (var dist in item['distributions']) {
// // //           if (dist.warehouse == null) continue;
// // //           double q = double.tryParse(dist.qty.text.trim()) ?? 0;
// // //           if (q <= 0) continue;
// // //           distributedQty += q;
// // //           allocations.add({
// // //             "warehouse_id": dist.warehouse['id'],
// // //             "quantity": q,
// // //           });
// // //         }

// // //         if ((distributedQty - totalQty).abs() > 0.0001) {
// // //           throw Exception(
// // //             "الكمية غير متطابقة: الكلي=$totalQty والموزع=$distributedQty للمنتج $itemName",
// // //           );
// // //         }

// // //         itemsData.add({
// // //           "product_id": productId,
// // //           "item_name": itemName,
// // //           "quantity": totalQty,
// // //           "unit_cost": unitCost,
// // //           "sale_price": salePrice,
// // //           "allocations": allocations,
// // //         });
// // //       }

// // //       if (itemsData.isEmpty)
// // //         throw Exception("الرجاء إضافة منتج واحد على الأقل");
// // //       if (selectedPartner!['partner_type'] != 'supplier')
// // //         throw Exception("الرجاء اختيار مورد (Supplier) صحيح");

// // //       final body = {
// // //         "partner_id": selectedPartner!['id'],
// // //         "purchase_date": DateTime.now().toIso8601String().substring(0, 10),
// // //         "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
// // //         "items": itemsData,
// // //       };

// // //       final response = await http.post(
// // //         Uri.parse(ApiEndpoints.addpurchase),
// // //         headers: await getHeaders(),
// // //         body: jsonEncode(body),
// // //       );

// // //       if (response.statusCode == 200 || response.statusCode == 201) {
// // //         final data = jsonDecode(response.body);
// // //         await handlePayment(data['purchase']['id']);

// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(
// // //             content: Text("تم حفظ الفاتورة بنجاح"),
// // //             backgroundColor: Colors.green,
// // //           ),
// // //         );
// // //         if (mounted) Navigator.pop(context);
// // //       } else {
// // //         throw Exception("فشل الحفظ: ${response.body}");
// // //       }
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text("$e"), backgroundColor: Colors.red),
// // //       );
// // //     }
// // //   }

// // //   Future<void> handlePayment(int? purchaseId) async {
// // //     if (purchaseId == null) return;
// // //     double amount = double.tryParse(_depositController.text) ?? 0;

// // //     if (paymentMethod == "cash") {
// // //       if (amount > 0) {
// // //         await sendPayment(purchaseId, "cash", amount);
// // //       }
// // //     } else if (paymentMethod == "check") {
// // //       for (var c in checks) {
// // //         String bank = c['bank']!.text;
// // //         String number = c['number']!.text;
// // //         String date = c['date']!.text;
// // //         double amt = double.tryParse(c['amount']!.text) ?? 0;

// // //         if (bank.isEmpty || number.isEmpty || date.isEmpty || amt <= 0)
// // //           continue;

// // //         await sendPayment(
// // //           purchaseId,
// // //           "check",
// // //           amt,
// // //           note: "شيك من $bank",
// // //           checkData: {
// // //             "bank_name": bank,
// // //             "check_number": number,
// // //             "company_name": "الشركة",
// // //             "issue_date": DateTime.now().toString().substring(0, 10),
// // //             "cashing_date": date,
// // //             "status": "pending",
// // //             "type": "صادر",
// // //           },
// // //         );
// // //       }
// // //     } else if (paymentMethod == "existing_check") {
// // //       if (selectedExistingCheck != null) {
// // //         double checkAmount = 0.0;
// // //         var rawAmount = selectedExistingCheck!['amount'];
// // //         if (rawAmount is num) {
// // //           checkAmount = rawAmount.toDouble();
// // //         } else if (rawAmount != null) {
// // //           checkAmount = double.tryParse(rawAmount.toString()) ?? 0.0;
// // //         }

// // //         await sendPayment(
// // //           purchaseId,
// // //           "check",
// // //           checkAmount,
// // //           note: "شيك موجود رقم ${selectedExistingCheck!['check_number'] ?? ''}",
// // //           checkData: {"check_id": selectedExistingCheck!['id']},
// // //         );
// // //       }
// // //     }
// // //   }

// // //   Future<void> sendPayment(
// // //     int purchaseId,
// // //     String method,
// // //     double amount, {
// // //     String note = "",
// // //     Map<String, dynamic>? checkData,
// // //   }) async {
// // //     final body = {
// // //       "purchase_id": purchaseId,
// // //       "payment_method": method,
// // //       "amount": amount,
// // //       "payment_date": DateTime.now().toString().substring(0, 10),
// // //       "notes": note,
// // //     };
// // //     if (method == "check" && checkData != null) body["check"] = checkData;

// // //     await http.post(
// // //       Uri.parse("${ApiEndpoints.pur}/$purchaseId/payments"),
// // //       headers: await getHeaders(),
// // //       body: jsonEncode(body),
// // //     );
// // //   }

// // //   Future<void> _selectCheckDate(
// // //     BuildContext context,
// // //     TextEditingController controller,
// // //   ) async {
// // //     final DateTime? picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime(2000),
// // //       lastDate: DateTime(2101),
// // //     );
// // //     if (picked != null) {
// // //       setState(() => controller.text = DateFormat('yyyy-MM-dd').format(picked));
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: bgGradientStart,
// // //       appBar: AppBar(
// // //         backgroundColor: primaryBlue,
// // //         title: const Text(
// // //           "شراء وتوزيع بضاعة",
// // //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// // //         ),
// // //         centerTitle: true,
// // //         iconTheme: const IconThemeData(color: Colors.white),
// // //       ),
// // //       body: Directionality(
// // //         textDirection: TextDirection.rtl,
// // //         child: SingleChildScrollView(
// // //           padding: const EdgeInsets.all(20),
// // //           child: Column(
// // //             children: [
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
// // //                         (val) => setState(() => selectedPartner = val),
// // //                       ),
// // //                     ),
// // //                     const SizedBox(width: 10),
// // //                     _buildAddButton(
// // //                       Icons.person_add_alt_1,
// // //                       showAddPartnerDialog,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),

// // //               ..._purchaseItems.asMap().entries.map((entry) {
// // //                 int itemIndex = entry.key;
// // //                 var item = entry.value;
// // //                 return _buildSectionCard(
// // //                   title: "المنتج ${itemIndex + 1}",
// // //                   icon: Icons.shopping_bag_outlined,
// // //                   child: Column(
// // //                     children: [
// // //                       Row(
// // //                         children: [
// // //                           Expanded(
// // //                             child: item['is_new']
// // //                                 ? _customTextFieldGeneral(
// // //                                     "اسم المنتج الجديد",
// // //                                     item['new_product_name'],
// // //                                     Icons.edit_note,
// // //                                     isNumeric: false,
// // //                                   )
// // //                                 : _customDropdown(
// // //                                     "اختر المنتج",
// // //                                     _allProducts,
// // //                                     item['product'],
// // //                                     (val) =>
// // //                                         setState(() => item['product'] = val),
// // //                                   ),
// // //                           ),
// // //                           const SizedBox(width: 10),
// // //                           _buildAddButton(
// // //                             item['is_new'] ? Icons.list : Icons.add_box,
// // //                             () => setState(
// // //                               () => item['is_new'] = !item['is_new'],
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       const SizedBox(height: 15),
// // //                       _customTextFieldGeneral(
// // //                         "الكمية الكلية",
// // //                         item['total_qty'],
// // //                         Icons.production_quantity_limits,
// // //                         onChanged: (val) => setState(() {}),
// // //                       ),
// // //                       const SizedBox(height: 15),
// // //                       Row(
// // //                         children: [
// // //                           Expanded(
// // //                             child: _priceTextFieldCustom(
// // //                               "سعر شراء",
// // //                               item['purchase_price'],
// // //                               onChanged: (val) => setState(() {}),
// // //                             ),
// // //                           ),
// // //                           const SizedBox(width: 10),
// // //                           Expanded(
// // //                             child: _priceTextFieldCustom(
// // //                               "سعر بيع",
// // //                               item['sale_price'],
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       const Divider(height: 30),
// // //                       const Text(
// // //                         "توزيع الكمية على المستودعات:",
// // //                         style: TextStyle(fontWeight: FontWeight.bold),
// // //                       ),
// // //                       const SizedBox(height: 10),
// // //                       ...List.generate(item['distributions'].length, (
// // //                         distIndex,
// // //                       ) {
// // //                         var dist = item['distributions'][distIndex];
// // //                         return Padding(
// // //                           padding: const EdgeInsets.only(bottom: 8),
// // //                           child: Row(
// // //                             children: [
// // //                               Expanded(
// // //                                 flex: 2,
// // //                                 child: _customDropdown(
// // //                                   "المستودع",
// // //                                   warehouses,
// // //                                   dist.warehouse,
// // //                                   (v) => setState(() => dist.warehouse = v),
// // //                                 ),
// // //                               ),
// // //                               const SizedBox(width: 8),
// // //                               Expanded(
// // //                                 flex: 1,
// // //                                 child: _customTextFieldGeneral(
// // //                                   "الكمية",
// // //                                   dist.qty,
// // //                                   Icons.pie_chart_outline,
// // //                                 ),
// // //                               ),
// // //                               IconButton(
// // //                                 icon: Icon(
// // //                                   distIndex == 0
// // //                                       ? Icons.add_circle_outline
// // //                                       : Icons.remove_circle_outline,
// // //                                   color: primaryBlue,
// // //                                 ),
// // //                                 onPressed: () {
// // //                                   setState(() {
// // //                                     if (distIndex == 0) {
// // //                                       item['distributions'].add(
// // //                                         Distribution(
// // //                                           warehouse: null,
// // //                                           qty: TextEditingController(text: "0"),
// // //                                         ),
// // //                                       );
// // //                                     } else {
// // //                                       item['distributions'].removeAt(distIndex);
// // //                                     }
// // //                                   });
// // //                                 },
// // //                               ),
// // //                             ],
// // //                           ),
// // //                         );
// // //                       }),
// // //                       if (itemIndex > 0)
// // //                         TextButton.icon(
// // //                           onPressed: () => setState(
// // //                             () => _purchaseItems.removeAt(itemIndex),
// // //                           ),
// // //                           icon: const Icon(Icons.delete, color: Colors.red),
// // //                           label: const Text(
// // //                             "حذف هذا المنتج",
// // //                             style: TextStyle(color: Colors.red),
// // //                           ),
// // //                         ),
// // //                     ],
// // //                   ),
// // //                 );
// // //               }),

// // //               ElevatedButton.icon(
// // //                 onPressed: () => setState(
// // //                   () => _purchaseItems.add({
// // //                     "product": null,
// // //                     "is_new": false,
// // //                     "new_product_name": TextEditingController(),
// // //                     "total_qty": TextEditingController(text: "0"),
// // //                     "purchase_price": TextEditingController(text: "0"),
// // //                     "sale_price": TextEditingController(text: "0"),
// // //                     "distributions": [
// // //                       Distribution(
// // //                         warehouse: null,
// // //                         qty: TextEditingController(text: "0"),
// // //                       ),
// // //                     ],
// // //                   }),
// // //                 ),
// // //                 icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
// // //                 label: const Text(
// // //                   "إضافة منتج آخر للفاتورة",
// // //                   style: TextStyle(color: Colors.white),
// // //                 ),
// // //                 style: ElevatedButton.styleFrom(
// // //                   backgroundColor: Colors.green,
// // //                   shape: RoundedRectangleBorder(
// // //                     borderRadius: BorderRadius.circular(12),
// // //                   ),
// // //                 ),
// // //               ),
// // //               const SizedBox(height: 20),

// // //               _buildFinancialSummaryCard(),

// // //               _buildSectionCard(
// // //                 title: "طريقة الدفع",
// // //                 icon: Icons.payment_outlined,
// // //                 child: Column(
// // //                   children: [
// // //                     Row(
// // //                       children: [
// // //                         _payBtn("نقداً", "cash"),
// // //                         _payBtn("شيكات", "check"),
// // //                         _payBtn("شيك موجود", "existing_check"),
// // //                       ],
// // //                     ),
// // //                     if (paymentMethod == "cash") ...[
// // //                       const SizedBox(height: 15),
// // //                       _customTextFieldGeneral(
// // //                         "المبلغ المدفوع",
// // //                         _depositController,
// // //                         Icons.money,
// // //                       ),
// // //                     ],
// // //                     if (paymentMethod == "check") _buildChecksSection(),
// // //                     if (paymentMethod == "existing_check")
// // //                       _buildExistingCheckSelector(),
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

// // //   // === مكونات الواجهة (Widgets) التي كانت مفقودة ===

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
// // //         borderRadius: BorderRadius.circular(16),
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
// // //         ],
// // //       ),
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           Row(
// // //             children: [
// // //               Icon(icon, color: primaryBlue),
// // //               const SizedBox(width: 8),
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(
// // //                   fontWeight: FontWeight.bold,
// // //                   fontSize: 16,
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

// // //   Widget _buildFinancialSummaryCard() {
// // //     return Container(
// // //       padding: const EdgeInsets.all(16),
// // //       margin: const EdgeInsets.only(bottom: 20),
// // //       decoration: BoxDecoration(
// // //         color: Colors.white,
// // //         borderRadius: BorderRadius.circular(16),
// // //         boxShadow: [
// // //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
// // //         ],
// // //       ),
// // //       child: Row(
// // //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //         children: [
// // //           Text(
// // //             "\$ ${_calculateTotalInvoicePrice().toStringAsFixed(1)}",
// // //             style: TextStyle(
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.bold,
// // //               color: primaryBlue,
// // //             ),
// // //           ),
// // //           Text(
// // //             "السعر الإجمالي الكلي",
// // //             style: TextStyle(
// // //               fontSize: 15,
// // //               fontWeight: FontWeight.bold,
// // //               color: Colors.grey[700],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _customDropdown(
// // //     String hint,
// // //     List items,
// // //     Map? selectedValue,
// // //     ValueChanged<Map?>? onChanged,
// // //   ) {
// // //     return DropdownButtonFormField<Map>(
// // //       value: selectedValue,
// // //       isExpanded: true,
// // //       hint: Text(hint),
// // //       items: items
// // //           .map(
// // //             (e) => DropdownMenuItem<Map>(
// // //               value: e as Map,
// // //               child: Text(e['name'] ?? e['company_name'] ?? "بدون اسم"),
// // //             ),
// // //           )
// // //           .toList(),
// // //       onChanged: onChanged,
// // //       decoration: InputDecoration(
// // //         filled: true,
// // //         fillColor: Colors.grey.shade50,
// // //         contentPadding: const EdgeInsets.symmetric(
// // //           horizontal: 16,
// // //           vertical: 12,
// // //         ),
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

// // //   Widget _buildExistingCheckSelector() {
// // //     return Container(
// // //       margin: const EdgeInsets.only(top: 10),
// // //       padding: const EdgeInsets.symmetric(horizontal: 12),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade50,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: Colors.grey.shade200),
// // //       ),
// // //       child: DropdownButtonFormField<Map>(
// // //         value: selectedExistingCheck,
// // //         isExpanded: true,
// // //         hint: const Text("اختر شيك موجود"),
// // //         items: existingChecks.map((e) {
// // //           final Map checkMap = e as Map;
// // //           String displayDate =
// // //               checkMap['cashing_date']?.toString() ??
// // //               checkMap['issue_date']?.toString() ??
// // //               "بدون تاريخ";
// // //           double amount =
// // //               double.tryParse(checkMap['amount']?.toString() ?? "0") ?? 0.0;
// // //           return DropdownMenuItem<Map>(
// // //             value: checkMap,
// // //             child: Text(
// // //               "$displayDate • \$${amount.toStringAsFixed(2)} • رقم: ${checkMap['check_number'] ?? '-'}",
// // //             ),
// // //           );
// // //         }).toList(),
// // //         onChanged: (v) => setState(() => selectedExistingCheck = v),
// // //         decoration: const InputDecoration(border: InputBorder.none),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
// // //     return Container(
// // //       decoration: BoxDecoration(
// // //         color: primaryBlue.withOpacity(0.1),
// // //         borderRadius: BorderRadius.circular(12),
// // //       ),
// // //       child: IconButton(
// // //         icon: Icon(icon, color: primaryBlue),
// // //         onPressed: onPressed,
// // //       ),
// // //     );
// // //   }

// // //   void showAddPartnerDialog() {
// // //     TextEditingController nameCtrl = TextEditingController();
// // //     TextEditingController phoneCtrl = TextEditingController();
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text("إضافة مورد جديد"),
// // //         content: Column(
// // //           mainAxisSize: MainAxisSize.min,
// // //           children: [
// // //             TextField(
// // //               controller: nameCtrl,
// // //               decoration: const InputDecoration(labelText: "اسم الشركة/المورد"),
// // //             ),
// // //             TextField(
// // //               controller: phoneCtrl,
// // //               decoration: const InputDecoration(labelText: "رقم الهاتف"),
// // //             ),
// // //           ],
// // //         ),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context),
// // //             child: const Text("إلغاء"),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: () {
// // //               if (nameCtrl.text.isNotEmpty) {
// // //                 addPartner(nameCtrl.text, phoneCtrl.text);
// // //                 Navigator.pop(context);
// // //               }
// // //             },
// // //             child: const Text("حفظ"),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _payBtn(String title, String method) {
// // //     bool isSelected = paymentMethod == method;
// // //     return Expanded(
// // //       child: GestureDetector(
// // //         onTap: () => setState(() => paymentMethod = method),
// // //         child: Container(
// // //           margin: const EdgeInsets.symmetric(horizontal: 4),
// // //           padding: const EdgeInsets.symmetric(vertical: 12),
// // //           decoration: BoxDecoration(
// // //             color: isSelected ? primaryBlue : Colors.grey.shade100,
// // //             borderRadius: BorderRadius.circular(10),
// // //             border: Border.all(
// // //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// // //             ),
// // //           ),
// // //           alignment: Alignment.center,
// // //           child: Text(
// // //             title,
// // //             style: TextStyle(
// // //               color: isSelected ? Colors.white : Colors.black87,
// // //               fontWeight: FontWeight.bold,
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildChecksSection() {
// // //     return Column(
// // //       children: [
// // //         const SizedBox(height: 15),
// // //         ...checks.asMap().entries.map((entry) {
// // //           int index = entry.key;
// // //           var check = entry.value;
// // //           return Container(
// // //             margin: const EdgeInsets.only(bottom: 10),
// // //             padding: const EdgeInsets.all(10),
// // //             decoration: BoxDecoration(
// // //               border: Border.all(color: Colors.grey.shade300),
// // //               borderRadius: BorderRadius.circular(10),
// // //             ),
// // //             child: Column(
// // //               children: [
// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                   children: [
// // //                     Text(
// // //                       "شيك ${index + 1}",
// // //                       style: const TextStyle(fontWeight: FontWeight.bold),
// // //                     ),
// // //                     IconButton(
// // //                       icon: const Icon(Icons.delete, color: Colors.red),
// // //                       onPressed: () => setState(() => checks.removeAt(index)),
// // //                     ),
// // //                   ],
// // //                 ),
// // //                 _customTextFieldGeneral(
// // //                   "اسم البنك",
// // //                   check['bank']!,
// // //                   Icons.account_balance,
// // //                   isNumeric: false,
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //                 _customTextFieldGeneral(
// // //                   "رقم الشيك",
// // //                   check['number']!,
// // //                   Icons.numbers,
// // //                   isNumeric: false,
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //                 _customTextFieldGeneral(
// // //                   "المبلغ",
// // //                   check['amount']!,
// // //                   Icons.money,
// // //                 ),
// // //                 const SizedBox(height: 10),
// // //                 InkWell(
// // //                   onTap: () => _selectCheckDate(context, check['date']!),
// // //                   child: IgnorePointer(
// // //                     child: _customTextFieldGeneral(
// // //                       "تاريخ الصرف",
// // //                       check['date']!,
// // //                       Icons.calendar_today,
// // //                       isNumeric: false,
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           );
// // //         }),
// // //         TextButton.icon(
// // //           onPressed: () => setState(
// // //             () => checks.add({
// // //               'bank': TextEditingController(),
// // //               'number': TextEditingController(),
// // //               'amount': TextEditingController(),
// // //               'date': TextEditingController(),
// // //             }),
// // //           ),
// // //           icon: const Icon(Icons.add),
// // //           label: const Text("إضافة شيك آخر"),
// // //         ),
// // //       ],
// // //     );
// // //   }

// // //   Widget _priceTextFieldCustom(
// // //     String labelText,
// // //     TextEditingController controller, {
// // //     ValueChanged<String>? onChanged,
// // //   }) {
// // //     return TextField(
// // //       controller: controller,
// // //       keyboardType: TextInputType.number,
// // //       onChanged: onChanged,
// // //       decoration: InputDecoration(
// // //         labelText: labelText,
// // //         filled: true,
// // //         fillColor: Colors.grey.shade50,
// // //         contentPadding: const EdgeInsets.symmetric(
// // //           horizontal: 16,
// // //           vertical: 12,
// // //         ),
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

// // //   Widget _customTextFieldGeneral(
// // //     String hint,
// // //     TextEditingController controller,
// // //     IconData icon, {
// // //     bool isNumeric = true,
// // //     ValueChanged<String>? onChanged,
// // //   }) {
// // //     return TextField(
// // //       controller: controller,
// // //       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
// // //       onChanged: onChanged,
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

// // //   Widget _buildSubmitButton() {
// // //     return SizedBox(
// // //       width: double.infinity,
// // //       height: 50,
// // //       child: ElevatedButton(
// // //         style: ElevatedButton.styleFrom(
// // //           backgroundColor: primaryBlue,
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(12),
// // //           ),
// // //         ),
// // //         onPressed: submitTransaction,
// // //         child: const Text(
// // //           "حفظ المعاملة",
// // //           style: TextStyle(
// // //             fontSize: 18,
// // //             color: Colors.white,
// // //             fontWeight: FontWeight.bold,
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:intl/intl.dart' show DateFormat;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:tradeflow_app/pages/link.dart'; // تأكد من مسار هذا الملف عندك

// // class Distribution {
// //   Map? warehouse;
// //   TextEditingController qty;

// //   Distribution({this.warehouse, required this.qty});
// // }

// // class PurchaseScreen extends StatefulWidget {
// //   const PurchaseScreen({super.key});

// //   @override
// //   State<PurchaseScreen> createState() => _PurchaseScreenState();
// // }

// // class _PurchaseScreenState extends State<PurchaseScreen> {
// //   final Color primaryBlue = const Color(0xFF4A72C2);
// //   final Color bgGradientStart = const Color(0xFFF0F4F8);

// //   List partners = [];
// //   Map? selectedPartner;
// //   List warehouses = [];
// //   List _allProducts = [];
// //   DateTime? _selectedDate;
// //   final TextEditingController _dateController = TextEditingController();

// //   List<Map<String, dynamic>> _purchaseItems = [
// //     {
// //       "product": null,
// //       "is_new": false,
// //       "new_product_name": TextEditingController(),
// //       "total_qty": TextEditingController(text: "0"),
// //       "purchase_price": TextEditingController(text: "0"),
// //       "sale_price": TextEditingController(text: "0"),
// //       "distributions": [
// //         Distribution(warehouse: null, qty: TextEditingController(text: "0")),
// //       ],
// //     },
// //   ];

// //   String paymentMethod = "cash";
// //   final TextEditingController _depositController = TextEditingController(
// //     text: "0",
// //   );
// //   List<Map<String, TextEditingController>> checks = [];
// //   List existingChecks = [];
// //   Map? selectedExistingCheck;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchPartners();
// //     fetchWarehouses();
// //     fetchAllProducts();
// //     fetchExistingChecks();
// //   }

// //   Future<Map<String, String>> getHeaders() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return {
// //       "Authorization": "Bearer ${prefs.getString("token")}",
// //       "Content-Type": "application/json",
// //       "Accept": "application/json",
// //     };
// //   }

// //   Future fetchExistingChecks() async {
// //     try {
// //       final res = await http.get(
// //         Uri.parse(ApiEndpoints.getChecksApi),
// //         headers: await getHeaders(),
// //       );
// //       if (res.statusCode == 200) {
// //         final decoded = jsonDecode(res.body);
// //         final List allChecks =
// //             (decoded is List ? decoded : decoded['data']) ?? [];
// //         setState(() {
// //           existingChecks = allChecks;
// //         });
// //       }
// //     } catch (e) {
// //       print("Error fetching checks: $e");
// //     }
// //   }

// //   double _calculateTotalInvoicePrice() {
// //     double total = 0.0;
// //     for (var item in _purchaseItems) {
// //       double qty = double.tryParse(item['total_qty'].text) ?? 0.0;
// //       double price = double.tryParse(item['purchase_price'].text) ?? 0.0;
// //       total += (qty * price);
// //     }
// //     return total;
// //   }

// //   Future fetchPartners() async {
// //     final res = await http.get(
// //       Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200) {
// //       setState(
// //         () => partners =
// //             (jsonDecode(res.body) is List
// //                 ? jsonDecode(res.body)
// //                 : jsonDecode(res.body)['data']) ??
// //             [],
// //       );
// //     }
// //   }

// //   Future fetchWarehouses() async {
// //     final res = await http.get(
// //       Uri.parse(ApiEndpoints.getWarehouses),
// //       headers: await getHeaders(),
// //     );
// //     if (res.statusCode == 200) {
// //       setState(
// //         () => warehouses =
// //             (jsonDecode(res.body) is List
// //                 ? jsonDecode(res.body)
// //                 : jsonDecode(res.body)['data']) ??
// //             [],
// //       );
// //     }
// //   }

// //   Future<void> fetchAllProducts() async {
// //     try {
// //       final res = await http.get(
// //         Uri.parse(ApiEndpoints.allproducts),
// //         headers: await getHeaders(),
// //       );
// //       if (res.statusCode == 200) {
// //         final data = jsonDecode(res.body);
// //         setState(() {
// //           _allProducts = data['items'] ?? [];
// //         });
// //       }
// //     } catch (e) {
// //       print(e);
// //     }
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
// //         final isNew = item['is_new'] == true;
// //         final product = item['product'];
// //         final newName = item['new_product_name'].text.trim();
// //         String itemName = "";
// //         int? productId;

// //         if (isNew) {
// //           if (newName.isEmpty) throw Exception("اسم المنتج الجديد مطلوب");
// //           itemName = newName;
// //         } else {
// //           if (product == null) throw Exception("الرجاء اختيار منتج");
// //           itemName = product['name'] ?? "";
// //           productId = product['id'];
// //         }

// //         double totalQty = double.tryParse(item['total_qty'].text.trim()) ?? 0;
// //         if (totalQty <= 0) throw Exception("الكمية يجب أن تكون أكبر من 0");

// //         double unitCost =
// //             double.tryParse(item['purchase_price'].text.trim()) ?? 0;
// //         if (unitCost <= 0) throw Exception("سعر الشراء يجب أن يكون أكبر من 0");

// //         double salePrice = double.tryParse(item['sale_price'].text.trim()) ?? 0;
// //         double distributedQty = 0;
// //         List allocations = [];

// //         for (var dist in item['distributions']) {
// //           if (dist.warehouse == null) continue;
// //           double q = double.tryParse(dist.qty.text.trim()) ?? 0;
// //           if (q <= 0) continue;
// //           distributedQty += q;
// //           allocations.add({
// //             "warehouse_id": dist.warehouse['id'],
// //             "quantity": q,
// //           });
// //         }

// //         if ((distributedQty - totalQty).abs() > 0.0001) {
// //           throw Exception(
// //             "الكمية غير متطابقة: الكلي=$totalQty والموزع=$distributedQty للمنتج $itemName",
// //           );
// //         }

// //         itemsData.add({
// //           "product_id": productId,
// //           "item_name": itemName,
// //           "quantity": totalQty,
// //           "unit_cost": unitCost,
// //           "sale_price": salePrice,
// //           "allocations": allocations,
// //         });
// //       }

// //       if (itemsData.isEmpty)
// //         throw Exception("الرجاء إضافة منتج واحد على الأقل");
// //       if (selectedPartner!['partner_type'] != 'supplier')
// //         throw Exception("الرجاء اختيار مورد (Supplier) صحيح");

// //       final body = {
// //         "partner_id": selectedPartner!['id'],
// //         "purchase_date": DateTime.now().toIso8601String().substring(0, 10),
// //         "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
// //         "items": itemsData,
// //       };

// //       final response = await http.post(
// //         Uri.parse(ApiEndpoints.addpurchase),
// //         headers: await getHeaders(),
// //         body: jsonEncode(body),
// //       );

// //       if (response.statusCode == 200 || response.statusCode == 201) {
// //         final data = jsonDecode(response.body);
// //         await handlePayment(data['purchase']['id']);

// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //             content: Text("تم حفظ الفاتورة بنجاح"),
// //             backgroundColor: Colors.green,
// //           ),
// //         );
// //         if (mounted) Navigator.pop(context);
// //       } else {
// //         throw Exception("فشل الحفظ: ${response.body}");
// //       }
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text("$e"), backgroundColor: Colors.red),
// //       );
// //     }
// //   }

// //   Future<void> handlePayment(int? purchaseId) async {
// //     if (purchaseId == null) return;
// //     double amount = double.tryParse(_depositController.text) ?? 0;

// //     if (paymentMethod == "cash") {
// //       if (amount > 0) {
// //         await sendPayment(purchaseId, "cash", amount);
// //       }
// //     } else if (paymentMethod == "check") {
// //       for (var c in checks) {
// //         String bank = c['bank']!.text;
// //         String number = c['number']!.text;
// //         String date = c['date']!.text;
// //         double amt = double.tryParse(c['amount']!.text) ?? 0;

// //         if (bank.isEmpty || number.isEmpty || date.isEmpty || amt <= 0)
// //           continue;

// //         await sendPayment(
// //           purchaseId,
// //           "check",
// //           amt,
// //           note: "شيك من $bank",
// //           checkData: {
// //             "bank_name": bank,
// //             "check_number": number,
// //             "company_name": "الشركة",
// //             "issue_date": DateTime.now().toString().substring(0, 10),
// //             "cashing_date": date,
// //             "status": "pending",
// //             "type": "صادر",
// //           },
// //         );
// //       }
// //     } else if (paymentMethod == "existing_check") {
// //       if (selectedExistingCheck != null) {
// //         double checkAmount = 0.0;
// //         var rawAmount = selectedExistingCheck!['amount'];
// //         if (rawAmount is num) {
// //           checkAmount = rawAmount.toDouble();
// //         } else if (rawAmount != null) {
// //           checkAmount = double.tryParse(rawAmount.toString()) ?? 0.0;
// //         }

// //         await sendPayment(
// //           purchaseId,
// //           "check",
// //           checkAmount,
// //           note: "شيك موجود رقم ${selectedExistingCheck!['check_number'] ?? ''}",
// //           checkData: {"check_id": selectedExistingCheck!['id']},
// //         );
// //       }
// //     }
// //   }

// //   Future<void> sendPayment(
// //     int purchaseId,
// //     String method,
// //     double amount, {
// //     String note = "",
// //     Map<String, dynamic>? checkData,
// //   }) async {
// //     final body = {
// //       "purchase_id": purchaseId,
// //       "payment_method": method,
// //       "amount": amount,
// //       "payment_date": DateTime.now().toString().substring(0, 10),
// //       "notes": note,
// //     };
// //     if (method == "check" && checkData != null) body["check"] = checkData;

// //     await http.post(
// //       Uri.parse("${ApiEndpoints.pur}/$purchaseId/payments"),
// //       headers: await getHeaders(),
// //       body: jsonEncode(body),
// //     );
// //   }

// //   Future<void> _selectCheckDate(
// //     BuildContext context,
// //     TextEditingController controller,
// //   ) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //     if (picked != null) {
// //       setState(() => controller.text = DateFormat('yyyy-MM-dd').format(picked));
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: bgGradientStart,
// //       appBar: AppBar(
// //         backgroundColor: primaryBlue,
// //         title: const Text(
// //           "شراء وتوزيع بضاعة",
// //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         iconTheme: const IconThemeData(color: Colors.white),
// //       ),
// //       body: Directionality(
// //         textDirection: TextDirection.rtl,
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             children: [
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
// //                         (val) => setState(() => selectedPartner = val),
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10),
// //                     _buildAddButton(
// //                       Icons.person_add_alt_1,
// //                       showAddPartnerDialog,
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //               ..._purchaseItems.asMap().entries.map((entry) {
// //                 int itemIndex = entry.key;
// //                 var item = entry.value;
// //                 return _buildSectionCard(
// //                   title: "المنتج ${itemIndex + 1}",
// //                   icon: Icons.shopping_bag_outlined,
// //                   child: Column(
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: item['is_new']
// //                                 ? _customTextFieldGeneral(
// //                                     "اسم المنتج الجديد",
// //                                     item['new_product_name'],
// //                                     Icons.edit_note,
// //                                     isNumeric: false,
// //                                   )
// //                                 : _customDropdown(
// //                                     "اختر المنتج",
// //                                     _allProducts,
// //                                     item['product'],
// //                                     (val) =>
// //                                         setState(() => item['product'] = val),
// //                                   ),
// //                           ),
// //                           const SizedBox(width: 10),
// //                           _buildAddButton(
// //                             item['is_new'] ? Icons.list : Icons.add_box,
// //                             () => setState(
// //                               () => item['is_new'] = !item['is_new'],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 15),
// //                       _customTextFieldGeneral(
// //                         "الكمية الكلية",
// //                         item['total_qty'],
// //                         Icons.production_quantity_limits,
// //                         onChanged: (val) => setState(() {}),
// //                       ),
// //                       const SizedBox(height: 15),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: _priceTextFieldCustom(
// //                               "سعر شراء",
// //                               item['purchase_price'],
// //                               onChanged: (val) => setState(() {}),
// //                             ),
// //                           ),
// //                           const SizedBox(width: 10),
// //                           Expanded(
// //                             child: _priceTextFieldCustom(
// //                               "سعر بيع",
// //                               item['sale_price'],
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
// //                                   dist.warehouse,
// //                                   (v) => setState(() => dist.warehouse = v),
// //                                 ),
// //                               ),
// //                               const SizedBox(width: 8),
// //                               Expanded(
// //                                 flex: 1,
// //                                 child: _customTextFieldGeneral(
// //                                   "الكمية",
// //                                   dist.qty,
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
// //                                       item['distributions'].add(
// //                                         Distribution(
// //                                           warehouse: null,
// //                                           qty: TextEditingController(text: "0"),
// //                                         ),
// //                                       );
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

// //               ElevatedButton.icon(
// //                 onPressed: () => setState(
// //                   () => _purchaseItems.add({
// //                     "product": null,
// //                     "is_new": false,
// //                     "new_product_name": TextEditingController(),
// //                     "total_qty": TextEditingController(text: "0"),
// //                     "purchase_price": TextEditingController(text: "0"),
// //                     "sale_price": TextEditingController(text: "0"),
// //                     "distributions": [
// //                       Distribution(
// //                         warehouse: null,
// //                         qty: TextEditingController(text: "0"),
// //                       ),
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

// //               _buildFinancialSummaryCard(),

// //               _buildSectionCard(
// //                 title: "طريقة الدفع",
// //                 icon: Icons.payment_outlined,
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       children: [
// //                         _payBtn("نقداً", "cash"),
// //                         _payBtn("شيكات", "check"),
// //                         _payBtn("شيك موجود", "existing_check"),
// //                       ],
// //                     ),
// //                     if (paymentMethod == "cash") ...[
// //                       const SizedBox(height: 15),
// //                       _customTextFieldGeneral(
// //                         "المبلغ المدفوع",
// //                         _depositController,
// //                         Icons.money,
// //                       ),
// //                     ],
// //                     if (paymentMethod == "check") _buildChecksSection(),
// //                     if (paymentMethod == "existing_check")
// //                       _buildExistingCheckSelector(),
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

// //   // === مكونات الواجهة (Widgets) ===

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
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             children: [
// //               Icon(icon, color: primaryBlue),
// //               const SizedBox(width: 8),
// //               Text(
// //                 title,
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 16,
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

// //   Widget _buildFinancialSummaryCard() {
// //     return Container(
// //       padding: const EdgeInsets.all(16),
// //       margin: const EdgeInsets.only(bottom: 20),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
// //         ],
// //       ),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //         children: [
// //           Text(
// //             "\$ ${_calculateTotalInvoicePrice().toStringAsFixed(1)}",
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: primaryBlue,
// //             ),
// //           ),
// //           Text(
// //             "السعر الإجمالي الكلي",
// //             style: TextStyle(
// //               fontSize: 15,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.grey[700],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _customDropdown(
// //     String hint,
// //     List items,
// //     Map? selectedValue,
// //     ValueChanged<Map?>? onChanged,
// //   ) {
// //     return DropdownButtonFormField<Map>(
// //       value: selectedValue,
// //       isExpanded: true,
// //       hint: Text(hint),
// //       items: items
// //           .map(
// //             (e) => DropdownMenuItem<Map>(
// //               value: e as Map,
// //               child: Text(e['name'] ?? e['company_name'] ?? "بدون اسم"),
// //             ),
// //           )
// //           .toList(),
// //       onChanged: onChanged,
// //       decoration: InputDecoration(
// //         filled: true,
// //         fillColor: Colors.grey.shade50,
// //         contentPadding: const EdgeInsets.symmetric(
// //           horizontal: 16,
// //           vertical: 12,
// //         ),
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

// //   Widget _buildExistingCheckSelector() {
// //     return Container(
// //       margin: const EdgeInsets.only(top: 10),
// //       padding: const EdgeInsets.symmetric(horizontal: 12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50,
// //         borderRadius: BorderRadius.circular(12),
// //         border: Border.all(color: Colors.grey.shade200),
// //       ),
// //       child: DropdownButtonFormField<Map>(
// //         value: selectedExistingCheck,
// //         isExpanded: true,
// //         hint: const Text("اختر شيك موجود"),
// //         decoration: const InputDecoration(border: InputBorder.none),
// //         items: existingChecks.map((e) {
// //           final Map checkMap = e as Map;

// //           // 1. تحديد التاريخ المناسب
// //           String displayDate = "";
// //           if (checkMap['cashing_date'] != null &&
// //               checkMap['cashing_date'].toString().trim().isNotEmpty) {
// //             displayDate = checkMap['cashing_date'].toString();
// //           } else if (checkMap['issue_date'] != null &&
// //               checkMap['issue_date'].toString().trim().isNotEmpty) {
// //             displayDate = checkMap['issue_date'].toString();
// //           } else {
// //             displayDate = "بدون تاريخ";
// //           }

// //           // 2. جلب القيمة وتحويلها
// //           double amount = 0.0;
// //           if (checkMap['amount'] is num) {
// //             amount = (checkMap['amount'] as num).toDouble();
// //           } else if (checkMap['amount'] != null) {
// //             amount = double.tryParse(checkMap['amount'].toString()) ?? 0.0;
// //           }

// //           // 3. جلب رقم الشيك
// //           String checkNum = checkMap['check_number']?.toString() ?? "بدون رقم";

// //           return DropdownMenuItem<Map>(
// //             value: checkMap,
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 // رقم الشيك على اليمين
// //                 Text(
// //                   "رقم: $checkNum",
// //                   style: TextStyle(color: Colors.grey[500], fontSize: 13),
// //                 ),

// //                 // التاريخ والمبلغ على اليسار
// //                 Directionality(
// //                   textDirection: TextDirection.ltr,
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(
// //                         Icons.calendar_today_outlined,
// //                         size: 16,
// //                         color: Colors.grey[600],
// //                       ),
// //                       const SizedBox(width: 8),
// //                       Text(
// //                         displayDate,
// //                         style: TextStyle(color: Colors.grey[800], fontSize: 14),
// //                       ),
// //                       const Padding(
// //                         padding: EdgeInsets.symmetric(horizontal: 8.0),
// //                         child: Text(
// //                           "•",
// //                           style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                       ),
// //                       Text(
// //                         "\$ ${amount.toStringAsFixed(2)}",
// //                         style: TextStyle(
// //                           color: primaryBlue,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }).toList(),
// //         onChanged: (v) => setState(() => selectedExistingCheck = v),
// //       ),
// //     );
// //   }

// //   Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: primaryBlue.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: IconButton(
// //         icon: Icon(icon, color: primaryBlue),
// //         onPressed: onPressed,
// //       ),
// //     );
// //   }

// //   void showAddPartnerDialog() {
// //     TextEditingController nameCtrl = TextEditingController();
// //     TextEditingController phoneCtrl = TextEditingController();
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text("إضافة مورد جديد"),
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: nameCtrl,
// //               decoration: const InputDecoration(labelText: "اسم الشركة/المورد"),
// //             ),
// //             TextField(
// //               controller: phoneCtrl,
// //               decoration: const InputDecoration(labelText: "رقم الهاتف"),
// //             ),
// //           ],
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context),
// //             child: const Text("إلغاء"),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (nameCtrl.text.isNotEmpty) {
// //                 addPartner(nameCtrl.text, phoneCtrl.text);
// //                 Navigator.pop(context);
// //               }
// //             },
// //             child: const Text("حفظ"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _payBtn(String title, String method) {
// //     bool isSelected = paymentMethod == method;
// //     return Expanded(
// //       child: GestureDetector(
// //         onTap: () => setState(() => paymentMethod = method),
// //         child: Container(
// //           margin: const EdgeInsets.symmetric(horizontal: 4),
// //           padding: const EdgeInsets.symmetric(vertical: 12),
// //           decoration: BoxDecoration(
// //             color: isSelected ? primaryBlue : Colors.grey.shade100,
// //             borderRadius: BorderRadius.circular(10),
// //             border: Border.all(
// //               color: isSelected ? primaryBlue : Colors.grey.shade300,
// //             ),
// //           ),
// //           alignment: Alignment.center,
// //           child: Text(
// //             title,
// //             style: TextStyle(
// //               color: isSelected ? Colors.white : Colors.black87,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildChecksSection() {
// //     return Column(
// //       children: [
// //         const SizedBox(height: 15),
// //         ...checks.asMap().entries.map((entry) {
// //           int index = entry.key;
// //           var check = entry.value;
// //           return Container(
// //             margin: const EdgeInsets.only(bottom: 10),
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               border: Border.all(color: Colors.grey.shade300),
// //               borderRadius: BorderRadius.circular(10),
// //             ),
// //             child: Column(
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       "شيك ${index + 1}",
// //                       style: const TextStyle(fontWeight: FontWeight.bold),
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.delete, color: Colors.red),
// //                       onPressed: () => setState(() => checks.removeAt(index)),
// //                     ),
// //                   ],
// //                 ),
// //                 _customTextFieldGeneral(
// //                   "اسم البنك",
// //                   check['bank']!,
// //                   Icons.account_balance,
// //                   isNumeric: false,
// //                 ),
// //                 const SizedBox(height: 10),
// //                 _customTextFieldGeneral(
// //                   "رقم الشيك",
// //                   check['number']!,
// //                   Icons.numbers,
// //                   isNumeric: false,
// //                 ),
// //                 const SizedBox(height: 10),
// //                 _customTextFieldGeneral(
// //                   "المبلغ",
// //                   check['amount']!,
// //                   Icons.money,
// //                 ),
// //                 const SizedBox(height: 10),
// //                 InkWell(
// //                   onTap: () => _selectCheckDate(context, check['date']!),
// //                   child: IgnorePointer(
// //                     child: _customTextFieldGeneral(
// //                       "تاريخ الصرف",
// //                       check['date']!,
// //                       Icons.calendar_today,
// //                       isNumeric: false,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }),
// //         TextButton.icon(
// //           onPressed: () => setState(
// //             () => checks.add({
// //               'bank': TextEditingController(),
// //               'number': TextEditingController(),
// //               'amount': TextEditingController(),
// //               'date': TextEditingController(),
// //             }),
// //           ),
// //           icon: const Icon(Icons.add),
// //           label: const Text("إضافة شيك آخر"),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget _priceTextFieldCustom(
// //     String labelText,
// //     TextEditingController controller, {
// //     ValueChanged<String>? onChanged,
// //   }) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: TextInputType.number,
// //       onChanged: onChanged,
// //       decoration: InputDecoration(
// //         labelText: labelText,
// //         filled: true,
// //         fillColor: Colors.grey.shade50,
// //         contentPadding: const EdgeInsets.symmetric(
// //           horizontal: 16,
// //           vertical: 12,
// //         ),
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

// //   Widget _customTextFieldGeneral(
// //     String hint,
// //     TextEditingController controller,
// //     IconData icon, {
// //     bool isNumeric = true,
// //     ValueChanged<String>? onChanged,
// //   }) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
// //       onChanged: onChanged,
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

// //   Widget _buildSubmitButton() {
// //     return SizedBox(
// //       width: double.infinity,
// //       height: 50,
// //       child: ElevatedButton(
// //         style: ElevatedButton.styleFrom(
// //           backgroundColor: primaryBlue,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(12),
// //           ),
// //         ),
// //         onPressed: submitTransaction,
// //         child: const Text(
// //           "حفظ المعاملة",
// //           style: TextStyle(
// //             fontSize: 18,
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart'; // تأكد من مسار هذا الملف عندك

class Distribution {
  Map? warehouse;
  TextEditingController qty;

  Distribution({this.warehouse, required this.qty});
}

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
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  List<Map<String, dynamic>> _purchaseItems = [
    {
      "product": null,
      "is_new": false,
      "new_product_name": TextEditingController(),
      "total_qty": TextEditingController(text: "0"),
      "purchase_price": TextEditingController(text: "0"),
      "sale_price": TextEditingController(text: "0"),
      "distributions": [
        Distribution(warehouse: null, qty: TextEditingController(text: "0")),
      ],
    },
  ];

  String paymentMethod = "cash";
  final TextEditingController _depositController = TextEditingController(
    text: "0",
  );
  List<Map<String, TextEditingController>> checks = [];
  List existingChecks = [];
  Map? selectedExistingCheck;

  @override
  void initState() {
    super.initState();
    fetchPartners();
    fetchWarehouses();
    fetchAllProducts();
    fetchExistingChecks();
  }

  Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "Authorization": "Bearer ${prefs.getString("token")}",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  Future fetchExistingChecks() async {
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.getChecksApi),
        headers: await getHeaders(),
      );
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List allChecks =
            (decoded is List ? decoded : decoded['data']) ?? [];
        setState(() {
          existingChecks = allChecks;
        });
      }
    } catch (e) {
      print("Error fetching checks: $e");
    }
  }

  double _calculateTotalInvoicePrice() {
    double total = 0.0;
    for (var item in _purchaseItems) {
      double qty = double.tryParse(item['total_qty'].text) ?? 0.0;
      double price = double.tryParse(item['purchase_price'].text) ?? 0.0;
      total += (qty * price);
    }
    return total;
  }

  // رجعنا للدالة الأصلية مع إضافة الفلترة البرمجية لضمان عرض الموردين فقط
  Future fetchPartners() async {
    final res = await http.get(
      Uri.parse("${ApiEndpoints.getPartners}?type=supplier"),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200) {
      // جلب الداتا كاملة حسب نظام كودك الأصلي
      List allPartners =
          (jsonDecode(res.body) is List
              ? jsonDecode(res.body)
              : jsonDecode(res.body)['data']) ??
          [];

      setState(() {
        // الفلترة السحرية هون: بناخذ فقط الشركاء اللي نوعهم supplier
        partners = allPartners
            .where((p) => p['partner_type'] == 'supplier')
            .toList();
      });
    }
  }

  Future fetchWarehouses() async {
    final res = await http.get(
      Uri.parse(ApiEndpoints.getWarehouses),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200) {
      setState(
        () => warehouses =
            (jsonDecode(res.body) is List
                ? jsonDecode(res.body)
                : jsonDecode(res.body)['data']) ??
            [],
      );
    }
  }

  // Future<void> fetchAllProducts() async {
  //   try {
  //     final res = await http.get(
  //       Uri.parse(ApiEndpoints.allproducts),
  //       headers: await getHeaders(),
  //     );
  //     if (res.statusCode == 200) {
  //       final data = jsonDecode(res.body);
  //       setState(() {
  //         _allProducts = data['items'] ?? [];
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  Future<void> fetchAllProducts() async {
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.allproducts),
        headers: await getHeaders(),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        List products = data['items'] ?? [];

        // حذف التكرار حسب اسم المنتج
        final uniqueProductsMap = <String, dynamic>{};

        for (var product in products) {
          String name = (product['name'] ?? '').toString().trim();

          if (!uniqueProductsMap.containsKey(name)) {
            uniqueProductsMap[name] = product;
          }
        }

        setState(() {
          _allProducts = uniqueProductsMap.values.toList();
        });
      }
    } catch (e) {
      print(e);
    }
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
        final isNew = item['is_new'] == true;
        final product = item['product'];
        final newName = item['new_product_name'].text.trim();
        String itemName = "";
        int? productId;

        if (isNew) {
          if (newName.isEmpty) throw Exception("اسم المنتج الجديد مطلوب");
          itemName = newName;
        } else {
          if (product == null) throw Exception("الرجاء اختيار منتج");
          itemName = product['name'] ?? "";
          productId = product['id'];
        }

        double totalQty = double.tryParse(item['total_qty'].text.trim()) ?? 0;
        if (totalQty <= 0) throw Exception("الكمية يجب أن تكون أكبر من 0");

        double unitCost =
            double.tryParse(item['purchase_price'].text.trim()) ?? 0;
        if (unitCost <= 0) throw Exception("سعر الشراء يجب أن يكون أكبر من 0");

        double salePrice = double.tryParse(item['sale_price'].text.trim()) ?? 0;
        double distributedQty = 0;
        List allocations = [];

        for (var dist in item['distributions']) {
          if (dist.warehouse == null) continue;
          double q = double.tryParse(dist.qty.text.trim()) ?? 0;
          if (q <= 0) continue;
          distributedQty += q;
          allocations.add({
            "warehouse_id": dist.warehouse['id'],
            "quantity": q,
          });
        }

        if ((distributedQty - totalQty).abs() > 0.0001) {
          throw Exception(
            "الكمية غير متطابقة: الكلي=$totalQty والموزع=$distributedQty للمنتج $itemName",
          );
        }

        itemsData.add({
          "product_id": productId,
          "item_name": itemName,
          "quantity": totalQty,
          "unit_cost": unitCost,
          "sale_price": salePrice,
          "allocations": allocations,
        });
      }

      if (itemsData.isEmpty)
        throw Exception("الرجاء إضافة منتج واحد على الأقل");
      if (selectedPartner!['partner_type'] != 'supplier')
        throw Exception("الرجاء اختيار مورد (Supplier) صحيح");

      final body = {
        "partner_id": selectedPartner!['id'],
        "purchase_date": DateTime.now().toIso8601String().substring(0, 10),
        "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
        "items": itemsData,
      };

      final response = await http.post(
        Uri.parse(ApiEndpoints.addpurchase),
        headers: await getHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await handlePayment(data['purchase']['id']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تم حفظ الفاتورة بنجاح"),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) Navigator.pop(context);
      } else {
        throw Exception("فشل الحفظ: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> handlePayment(int? purchaseId) async {
    if (purchaseId == null) return;
    double amount = double.tryParse(_depositController.text) ?? 0;

    if (paymentMethod == "cash") {
      if (amount > 0) {
        await sendPayment(purchaseId, "cash", amount);
      }
    } else if (paymentMethod == "check") {
      for (var c in checks) {
        String bank = c['bank']!.text;
        String number = c['number']!.text;
        String date = c['date']!.text;
        double amt = double.tryParse(c['amount']!.text) ?? 0;

        if (bank.isEmpty || number.isEmpty || date.isEmpty || amt <= 0)
          continue;

        await sendPayment(
          purchaseId,
          "check",
          amt,
          note: "شيك من $bank",
          checkData: {
            "bank_name": bank,
            "check_number": number,
            "company_name": "شيك شخصي",
            "issue_date": DateTime.now().toString().substring(0, 10),
            "cashing_date": date,
            "status": "pending",
            "type": "صادر",
          },
        );
      }
    } else if (paymentMethod == "existing_check") {
      if (selectedExistingCheck != null) {
        double amount = 0.0;
        var rawAmount = selectedExistingCheck!['amount'];
        if (rawAmount is num) {
          amount = rawAmount.toDouble();
        } else if (rawAmount != null) {
          amount = double.tryParse(rawAmount.toString()) ?? 0.0;
        }

        await sendPayment(
          purchaseId,
          "existing_check",
          amount,
          note: "شيك موجود رقم ${selectedExistingCheck!['check_number'] ?? ''}",
          check_id: selectedExistingCheck!['id'],
        );
      }
    }
  }

  Future<void> sendPayment(
    int purchaseId,
    String method,
    double amount, {
    String note = "",
    Map<String, dynamic>? checkData,
    int? check_id,
  }) async {
    final body = {
      "purchase_id": purchaseId,
      "payment_method": method,
      "amount": amount,
      "payment_date": DateTime.now().toString().substring(0, 10),
      "notes": note,
    };
    if (method == "check" && checkData != null) body["check"] = checkData;
    if (method == "existing_check" && check_id != null) {
      body["check_id"] = check_id;
    }
    await http.post(
      Uri.parse("${ApiEndpoints.pur}/$purchaseId/payments"),
      headers: await getHeaders(),
      body: jsonEncode(body),
    );
  }

  Future<void> _selectCheckDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => controller.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGradientStart,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          "شراء وتوزيع بضاعة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
                        (val) => setState(() => selectedPartner = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildAddButton(
                      Icons.person_add_alt_1,
                      showAddPartnerDialog,
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
                                    (val) =>
                                        setState(() => item['product'] = val),
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
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _priceTextFieldCustom(
                              "سعر شراء",
                              item['purchase_price'],
                              onChanged: (val) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                                  dist.warehouse,
                                  (v) => setState(() => dist.warehouse = v),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: _customTextFieldGeneral(
                                  "الكمية",
                                  dist.qty,
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
                                      item['distributions'].add(
                                        Distribution(
                                          warehouse: null,
                                          qty: TextEditingController(text: "0"),
                                        ),
                                      );
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
                      Distribution(
                        warehouse: null,
                        qty: TextEditingController(text: "0"),
                      ),
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

              _buildFinancialSummaryCard(),

              _buildSectionCard(
                title: "طريقة الدفع",
                icon: Icons.payment_outlined,
                child: Column(
                  children: [
                    Row(
                      children: [
                        _payBtn("نقداً", "cash"),
                        _payBtn("شيكات", "check"),
                        _payBtn("شيك موجود", "existing_check"),
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
                    if (paymentMethod == "existing_check")
                      _buildExistingCheckSelector(),
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

  // === مكونات الواجهة (Widgets) ===

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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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

  Widget _buildFinancialSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "\$ ${_calculateTotalInvoicePrice().toStringAsFixed(1)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),
          Text(
            "السعر الإجمالي الكلي",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customDropdown(
    String hint,
    List items,
    Map? selectedValue,
    ValueChanged<Map?>? onChanged,
  ) {
    return DropdownButtonFormField<Map>(
      value: selectedValue,
      isExpanded: true,
      hint: Text(hint),
      items: items
          .map(
            (e) => DropdownMenuItem<Map>(
              value: e as Map,
              child: Text(e['name'] ?? e['company_name'] ?? "بدون اسم"),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
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

  Widget _buildExistingCheckSelector() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonFormField<Map>(
        value: selectedExistingCheck,
        isExpanded: true,
        hint: const Text("اختر شيك موجود"),
        decoration: const InputDecoration(border: InputBorder.none),
        items: existingChecks.map((e) {
          final Map checkMap = e as Map;

          String displayDate = "";
          if (checkMap['cashing_date'] != null &&
              checkMap['cashing_date'].toString().trim().isNotEmpty) {
            displayDate = checkMap['cashing_date'].toString();
          } else if (checkMap['issue_date'] != null &&
              checkMap['issue_date'].toString().trim().isNotEmpty) {
            displayDate = checkMap['issue_date'].toString();
          } else {
            displayDate = "بدون تاريخ";
          }

          double amount = 0.0;
          if (checkMap['amount'] is num) {
            amount = (checkMap['amount'] as num).toDouble();
          } else if (checkMap['amount'] != null) {
            amount = double.tryParse(checkMap['amount'].toString()) ?? 0.0;
          }

          String checkNum = checkMap['check_number']?.toString() ?? "بدون رقم";

          return DropdownMenuItem<Map>(
            value: checkMap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "رقم: $checkNum",
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        displayDate,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "•",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        "\$ ${amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (v) => setState(() => selectedExistingCheck = v),
      ),
    );
  }

  Widget _buildAddButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: primaryBlue),
        onPressed: onPressed,
      ),
    );
  }

  void showAddPartnerDialog() {
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController phoneCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إضافة مورد جديد"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "اسم الشركة/المورد"),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: "رقم الهاتف"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty) {
                addPartner(nameCtrl.text, phoneCtrl.text);
                Navigator.pop(context);
              }
            },
            child: const Text("حفظ"),
          ),
        ],
      ),
    );
  }

  Widget _payBtn(String title, String method) {
    bool isSelected = paymentMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => paymentMethod = method),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryBlue : Colors.grey.shade300,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChecksSection() {
    return Column(
      children: [
        const SizedBox(height: 15),
        ...checks.asMap().entries.map((entry) {
          int index = entry.key;
          var check = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "شيك ${index + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => checks.removeAt(index)),
                    ),
                  ],
                ),
                _customTextFieldGeneral(
                  "اسم البنك",
                  check['bank']!,
                  Icons.account_balance,
                  isNumeric: false,
                ),
                const SizedBox(height: 10),
                _customTextFieldGeneral(
                  "رقم الشيك",
                  check['number']!,
                  Icons.numbers,
                  isNumeric: false,
                ),
                const SizedBox(height: 10),
                _customTextFieldGeneral(
                  "المبلغ",
                  check['amount']!,
                  Icons.money,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _selectCheckDate(context, check['date']!),
                  child: IgnorePointer(
                    child: _customTextFieldGeneral(
                      "تاريخ الصرف",
                      check['date']!,
                      Icons.calendar_today,
                      isNumeric: false,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => setState(
            () => checks.add({
              'bank': TextEditingController(),
              'number': TextEditingController(),
              'amount': TextEditingController(),
              'date': TextEditingController(),
            }),
          ),
          icon: const Icon(Icons.add),
          label: const Text("إضافة شيك آخر"),
        ),
      ],
    );
  }

  Widget _priceTextFieldCustom(
    String labelText,
    TextEditingController controller, {
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
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

  Widget _customTextFieldGeneral(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isNumeric = true,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: submitTransaction,
        child: const Text(
          "حفظ المعاملة",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
