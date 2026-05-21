// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:intl/intl.dart' show DateFormat;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:tradeflow_app/pages/link.dart';

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

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchPartners();
// //     fetchWarehouses();
// //     fetchAllProducts();
// //   }

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

// //   int? getId(dynamic obj) {
// //     if (obj == null) return null;
// //     if (obj is Map) return obj['id'];
// //     if (obj is int) return obj;
// //     return null;
// //   }

// //   // Future<void> submitTransaction() async {
// //   //   try {
// //   //     if (selectedPartner == null) throw Exception("الرجاء اختيار المورد");

// //   //     List itemsData = [];
// //   //     for (var item in _purchaseItems) {
// //   //       double unitCost =
// //   //           double.tryParse(item['purchase_price'].text.trim()) ?? -1;

// //   //       if (unitCost <= 0) {
// //   //         throw Exception("سعر الشراء يجب أن يكون أكبر من 0");
// //   //       }
// //   //       if (item['product'] == null && item['new_product_name'].text.isEmpty) {
// //   //         continue;
// //   //       }

// //   //       // تحويل وتأمين الأرقام لتجنب مشاكل الفواصل العشرية
// //   //       double totalQty = double.tryParse(item['total_qty'].text) ?? 0;
// //   //       double distributedQty = 0;
// //   //       List allocations = [];

// //   //       for (var dist in item['distributions']) {
// //   //         if (dist.warehouse == null) continue;
// //   //         double q = double.tryParse(dist.qty.text) ?? 0;

// //   //         if (dist.warehouse?['id'] != null && q > 0) {
// //   //           distributedQty += q;

// //   //           allocations.add({
// //   //             "warehouse_id": dist.warehouse?['id'],
// //   //             "quantity": q,
// //   //           });
// //   //         }
// //   //       }

// //   //       // مقارنة القيم بعد تحويلها لـ double مع تقريب طفيف لمنع أخطاء الكسور الدقيقة جداً
// //   //       if ((distributedQty - totalQty).abs() > 0.0001) {
// //   //         final productName = item['is_new']
// //   //             ? item['new_product_name'].text
// //   //             : item['product']['name'];
// //   //         print("UI QTY FIELD: ${item['total_qty'].text}");
// //   //         print("DISTRIBUTIONS:");
// //   //         for (var d in item['distributions']) {
// //   //           print("WH: ${d.warehouse?['id']} QTY: ${d.qty.text}");
// //   //         }

// //   //         throw Exception(
// //   //           "خطأ: الكمية الكلية ($totalQty) لا تساوي مجموع الكميات الموزعة ($distributedQty) لمنتج $productName",
// //   //         );
// //   //       }

// //   //       itemsData.add({
// //   //         "product_id": item['is_new'] ? null : item['product']['id'],
// //   //         "new_product_name": item['is_new']
// //   //             ? item['new_product_name'].text
// //   //             : null,
// //   //         "quantity": totalQty,
// //   //         "unit_cost": unitCost,
// //   //         "sale_price": double.tryParse(item['sale_price'].text) ?? 0,
// //   //         "allocations": allocations,
// //   //       });
// //   //     }

// //   //     if (itemsData.isEmpty)
// //   //       throw Exception("الرجاء إضافة منتج واحد على الأقل بالفاتورة");

// //   //     final body = {
// //   //       "partner_id": selectedPartner!['id'],
// //   //       "purchase_date": DateTime.now().toString().substring(0, 10),
// //   //       "invoice_number": "PUR-${DateTime.now().millisecondsSinceEpoch}",
// //   //       "items": itemsData,
// //   //     };

// //   //     final response = await http.post(
// //   //       Uri.parse(ApiEndpoints.addpurchase),
// //   //       headers: await getHeaders(),
// //   //       body: jsonEncode(body),
// //   //     );

// //   //     if (response.statusCode == 200 || response.statusCode == 201) {
// //   //       final data = jsonDecode(response.body);
// //   //       await handlePayment(data['purchase']['id']);
// //   //       ScaffoldMessenger.of(context).showSnackBar(
// //   //         const SnackBar(
// //   //           content: Text("تم حفظ الفاتورة والتوزيع بنجاح"),
// //   //           backgroundColor: Colors.green,
// //   //         ),
// //   //       );
// //   //     } else {
// //   //       throw Exception("فشل حفظ الفاتورة من السيرفر: ${response.body}");
// //   //     }
// //   //   } catch (e) {
// //   //     ScaffoldMessenger.of(context).showSnackBar(
// //   //       SnackBar(content: Text("$e"), backgroundColor: Colors.red),
// //   //     );
// //   //   }
// //   // }
// //   Future<void> submitTransaction() async {
// //     try {
// //       if (selectedPartner == null) {
// //         throw Exception("الرجاء اختيار المورد");
// //       }

// //       List itemsData = [];

// //       for (var item in _purchaseItems) {
// //         final isNew = item['is_new'] == true;

// //         final product = item['product'];
// //         final newName = item['new_product_name'].text.trim();

// //         // ✅ 1) اسم المنتج (إجباري دائماً)
// //         String itemName = "";
// //         int? productId;

// //         if (isNew) {
// //           if (newName.isEmpty) {
// //             throw Exception("اسم المنتج الجديد مطلوب");
// //           }
// //           itemName = newName;
// //         } else {
// //           if (product == null) {
// //             throw Exception("الرجاء اختيار منتج");
// //           }
// //           itemName = product['name'] ?? "";
// //           productId = product['id'];
// //         }

// //         // ✅ 2) الكميات
// //         double totalQty = double.tryParse(item['total_qty'].text.trim()) ?? 0;

// //         if (totalQty <= 0) {
// //           throw Exception("الكمية يجب أن تكون أكبر من 0");
// //         }

// //         // ✅ 3) الأسعار
// //         double unitCost =
// //             double.tryParse(item['purchase_price'].text.trim()) ?? 0;

// //         if (unitCost <= 0) {
// //           throw Exception("سعر الشراء يجب أن يكون أكبر من 0");
// //         }

// //         double salePrice = double.tryParse(item['sale_price'].text.trim()) ?? 0;

// //         // ✅ 4) التوزيع
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

// //         // ✅ 5) أهم تعديل (حل item name error)
// //         itemsData.add({
// //           "product_id": productId,
// //           "item_name": itemName, // 🔥 هذا اللي كان ناقص عندك غالباً
// //           "quantity": totalQty,
// //           "unit_cost": unitCost,
// //           "sale_price": salePrice,
// //           "allocations": allocations,
// //         });
// //       }

// //       if (itemsData.isEmpty) {
// //         throw Exception("الرجاء إضافة منتج واحد على الأقل");
// //       }

// //       // 🔥 تأكيد supplier قبل الإرسال
// //       if (selectedPartner!['partner_type'] != 'supplier') {
// //         throw Exception("الرجاء اختيار مورد (Supplier) صحيح");
// //       }

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

// //         if (bank.isEmpty || number.isEmpty || date.isEmpty || amt <= 0) {
// //           continue;
// //         }

// //         await sendPayment(
// //           purchaseId,
// //           "check",
// //           amt,
// //           note: "شيك من $bank",
// //           checkData: {
// //             "bank_name": bank,
// //             "check_number": number,
// //             "company_name": "eehab",
// //             "issue_date": _selectedDate != null
// //                 ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
// //                 : DateTime.now().toString().substring(0, 10),
// //             "cashing_date": date,
// //             "status": "pending",
// //             "type": "صادر",
// //           },
// //         );
// //       }
// //     }
// //   }

// //   Future<void> _selectDate(BuildContext context) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate ?? DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //     if (picked != null) {
// //       setState(() {
// //         _selectedDate = picked;
// //         _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
// //       });
// //     }
// //   }

// //   Future<int?> sendCheck({
// //     required String bankName,
// //     required String checkNumber,
// //     required String companyName,
// //     required double amount,
// //     required String cashingDate,
// //   }) async {
// //     final headers = await getHeaders();

// //     final body = {
// //       "bank_name": bankName,
// //       "check_number": checkNumber,
// //       "company_name": companyName,
// //       "amount": amount,
// //       "issue_date": _selectedDate != null
// //           ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
// //           : DateTime.now().toString().substring(0, 10),
// //       "cashing_date": cashingDate,
// //       "status": "pending",
// //       "type": "صادر",
// //     };

// //     final response = await http.post(
// //       Uri.parse(ApiEndpoints.addCheck),
// //       headers: headers,
// //       body: jsonEncode(body),
// //     );

// //     if (response.statusCode == 200 || response.statusCode == 201) {
// //       final data = jsonDecode(response.body);
// //       return data['check']['id'];
// //     }
// //     return null;
// //   }

// //   Future<void> sendPayment(
// //     int purchaseId,
// //     String method,
// //     double amount, {
// //     String note = "",
// //     Map<String, dynamic>? checkData,
// //   }) async {
// //     final headers = await getHeaders();

// //     final body = {
// //       "purchase_id": purchaseId,
// //       "payment_method": method,
// //       "amount": amount,
// //       "payment_date": DateTime.now().toString().substring(0, 10),
// //       "notes": note,
// //     };
// //     if (method == "check" && checkData != null) {
// //       body["check"] = checkData;
// //     }
// //     final response = await http.post(
// //       Uri.parse("${ApiEndpoints.pur}/$purchaseId/payments"),
// //       headers: headers,
// //       body: jsonEncode(body),
// //     );
// //   }

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
// //               _buildSectionCard(
// //                 title: "بيانات المورد",
// //                 icon: Icons.person_outline,
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: _customDropdown(
// //                         "اختر البارتنر",
// //                         partners,
// //                         selectedPartner,
// //                         (val) {
// //                           setState(() {
// //                             selectedPartner = val;
// //                           });
// //                         },
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
// //                                     (val) {
// //                                       setState(() {
// //                                         item['product'] = val;
// //                                       });
// //                                     },
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
// //                       ),
// //                       const SizedBox(height: 15),
// //                       Row(
// //                         children: [
// //                           Expanded(
// //                             child: _priceTextFieldCustom(
// //                               "سعر شراء",
// //                               item['purchase_price'],
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
// //                                   (v) {
// //                                     print("SELECTED WAREHOUSE: $v");
// //                                     setState(() {
// //                                       dist.warehouse = v;
// //                                     });
// //                                   },
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
// //                                       item['distributions'].add({
// //                                         "warehouse_id": null,
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

// //               ElevatedButton.icon(
// //                 onPressed: () => setState(
// //                   () => _purchaseItems.add({
// //                     "product": null,
// //                     "is_new": false,
// //                     "new_product_name": TextEditingController(),
// //                     "total_qty": TextEditingController(text: "0"),
// //                     "purchase_price": TextEditingController(text: ""),
// //                     "sale_price": TextEditingController(text: "0"),
// //                     "distributions": [
// //                       {
// //                         "warehouse_id": null,
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
// //                       _customTextFieldGeneral(
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

// //   Widget _priceTextFieldCustom(
// //     String labelText,
// //     TextEditingController controller,
// //   ) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: TextInputType.number,
// //       style: const TextStyle(fontWeight: FontWeight.bold),
// //       decoration: InputDecoration(
// //         labelText: labelText,
// //         floatingLabelBehavior: FloatingLabelBehavior.always,
// //         labelStyle: TextStyle(
// //           fontSize: 14,
// //           color: Colors.grey[700],
// //           fontWeight: FontWeight.normal,
// //         ),
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
// //   }) {
// //     return TextField(
// //       controller: controller,
// //       keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
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

// //   // Widget _customDropdown({
// //   //   required String hint,
// //   //   required List data,
// //   //   dynamic value,
// //   //   required ValueChanged<dynamic> onChanged,
// //   // }) {
// //   //   return Container(
// //   //     padding: const EdgeInsets.symmetric(horizontal: 12),
// //   //     decoration: BoxDecoration(
// //   //       color: Colors.grey.shade50,
// //   //       borderRadius: BorderRadius.circular(12),
// //   //       border: Border.all(color: Colors.grey.shade200),
// //   //     ),
// //   //     child: DropdownButtonFormField<dynamic>(
// //   //       value: value,
// //   //       isExpanded: true,
// //   //       hint: Text(hint),
// //   //       items: data.map<DropdownMenuItem<dynamic>>((e) {
// //   //         final dynamic id = e is Map ? e['id'] : e;
// //   //         final String name = e is Map
// //   //             ? (e['name'] ?? e['company_name'] ?? e['product_name'] ?? '')
// //   //                   .toString()
// //   //             : e.toString();

// //   //         return DropdownMenuItem<dynamic>(value: id, child: Text(name));
// //   //       }).toList(),
// //   //       onChanged: onChanged,
// //   //       decoration: const InputDecoration(border: InputBorder.none),
// //   //     ),
// //   //   );
// //   // }
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
// //         items: // data
// //             //     .map(
// //             //       (e) => DropdownMenuItem(
// //             //         value: e,
// //             //         child: Text(
// //             //           e['name'] ?? e['company_name'] ?? e['product_name'] ?? "",
// //             //         ),
// //             //       ),
// //             //     )
// //             //     .toList(),
// //             data.map((e) {
// //               return DropdownMenuItem(
// //                 value: e,
// //                 child: Text(
// //                   e['name'] ?? e['company_name'] ?? e['product_name'] ?? "",
// //                 ),
// //               );
// //             }).toList(),
// //         onChanged: (v) => onChanged(v),
// //         decoration: const InputDecoration(border: InputBorder.none),
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
// //                       child: _customTextFieldGeneral(
// //                         "البنك",
// //                         c['bank']!,
// //                         Icons.account_balance,
// //                         isNumeric: false,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       child: _customTextFieldGeneral(
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
// //                       child: _customTextFieldGeneral(
// //                         "القيمة",
// //                         c['amount']!,
// //                         Icons.attach_money,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 8),
// //                     Expanded(
// //                       child: _customTextFieldGeneral(
// //                         "التاريخ",
// //                         c['date']!,
// //                         Icons.date_range,
// //                         isNumeric: false,
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
// //             _customTextFieldGeneral(
// //               "اسم المورد",
// //               name,
// //               Icons.business,
// //               isNumeric: false,
// //             ),
// //             const SizedBox(height: 10),
// //             _customTextFieldGeneral("رقم الهاتف", phone, Icons.phone),
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
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

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

  @override
  void initState() {
    super.initState();
    fetchPartners();
    fetchWarehouses();
    fetchAllProducts();
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
    if (res.statusCode == 200) {
      setState(
        () => partners =
            (jsonDecode(res.body) is List
                ? jsonDecode(res.body)
                : jsonDecode(res.body)['data']) ??
            [],
      );
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

  Future<void> fetchAllProducts() async {
    try {
      final res = await http.get(
        Uri.parse(ApiEndpoints.allproducts),
        headers: await getHeaders(),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _allProducts = data['items'] ?? [];
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

  int? getId(dynamic obj) {
    if (obj == null) return null;
    if (obj is Map) return obj['id'];
    if (obj is int) return obj;
    return null;
  }

  Future<void> submitTransaction() async {
    try {
      if (selectedPartner == null) {
        throw Exception("الرجاء اختيار المورد");
      }

      List itemsData = [];

      for (var item in _purchaseItems) {
        final isNew = item['is_new'] == true;

        final product = item['product'];
        final newName = item['new_product_name'].text.trim();

        String itemName = "";
        int? productId;

        if (isNew) {
          if (newName.isEmpty) {
            throw Exception("اسم المنتج الجديد مطلوب");
          }
          itemName = newName;
        } else {
          if (product == null) {
            throw Exception("الرجاء اختيار منتج");
          }
          itemName = product['name'] ?? "";
          productId = product['id'];
        }

        double totalQty = double.tryParse(item['total_qty'].text.trim()) ?? 0;

        if (totalQty <= 0) {
          throw Exception("الكمية يجب أن تكون أكبر من 0");
        }

        double unitCost =
            double.tryParse(item['purchase_price'].text.trim()) ?? 0;

        if (unitCost <= 0) {
          throw Exception("سعر الشراء يجب أن يكون أكبر من 0");
        }

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

      if (itemsData.isEmpty) {
        throw Exception("الرجاء إضافة منتج واحد على الأقل");
      }

      if (selectedPartner!['partner_type'] != 'supplier') {
        throw Exception("الرجاء اختيار مورد (Supplier) صحيح");
      }

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

        if (mounted) {
          Navigator.pop(context);
        }
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

        if (bank.isEmpty || number.isEmpty || date.isEmpty || amt <= 0) {
          continue;
        }

        await sendPayment(
          purchaseId,
          "check",
          amt,
          note: "شيك من $bank",
          checkData: {
            "bank_name": bank,
            "check_number": number,
            "company_name": "eehab",
            "issue_date": _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : DateTime.now().toString().substring(0, 10),
            "cashing_date": date,
            "status": "pending",
            "type": "صادر",
          },
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
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
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<int?> sendCheck({
    required String bankName,
    required String checkNumber,
    required String companyName,
    required double amount,
    required String cashingDate,
  }) async {
    final headers = await getHeaders();

    final body = {
      "bank_name": bankName,
      "check_number": checkNumber,
      "company_name": companyName,
      "amount": amount,
      "issue_date": _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : DateTime.now().toString().substring(0, 10),
      "cashing_date": cashingDate,
      "status": "pending",
      "type": "صادر",
    };

    final response = await http.post(
      Uri.parse(ApiEndpoints.addCheck),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['check']['id'];
    }
    return null;
  }

  Future<void> sendPayment(
    int purchaseId,
    String method,
    double amount, {
    String note = "",
    Map<String, dynamic>? checkData,
  }) async {
    final headers = await getHeaders();

    final body = {
      "purchase_id": purchaseId,
      "payment_method": method,
      "amount": amount,
      "payment_date": DateTime.now().toString().substring(0, 10),
      "notes": note,
    };
    if (method == "check" && checkData != null) {
      body["check"] = checkData;
    }
    final response = await http.post(
      Uri.parse("${ApiEndpoints.pur}/$purchaseId/payments"),
      headers: headers,
      body: jsonEncode(body),
    );
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
                        "اختر البارتنر",
                        partners,
                        selectedPartner,
                        (val) {
                          setState(() {
                            selectedPartner = val;
                          });
                        },
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
                                    (val) {
                                      setState(() {
                                        item['product'] = val;
                                      });
                                    },
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
                                  (v) {
                                    print("SELECTED WAREHOUSE: $v");
                                    setState(() {
                                      dist.warehouse = v;
                                    });
                                  },
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

  Widget _buildFinancialSummaryCard() {
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
              Icon(Icons.assignment_outlined, color: primaryBlue, size: 22),
              const SizedBox(width: 8),
              Text(
                "الملخص المالي",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryBlue,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
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
        ],
      ),
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
        items: data.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(
              e['name'] ?? e['company_name'] ?? e['product_name'] ?? "",
            ),
          );
        }).toList(),
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
                      child: TextField(
                        controller: c['date']!,
                        readOnly: true,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        onTap: () => _selectCheckDate(context, c['date']!),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.date_range,
                            color: primaryBlue,
                          ),
                          hintText: "التاريخ",
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
