// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/link.dart';

// class TransactionDetailsScreen extends StatefulWidget {
//   const TransactionDetailsScreen({super.key});

//   @override
//   State<TransactionDetailsScreen> createState() =>
//       _TransactionDetailsScreenState();
// }

// class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
//   final Color primaryBlue = const Color(0xFF446BC0);

//   final TextEditingController _quantityController = TextEditingController(
//     text: "1",
//   );
//   final TextEditingController _depositController = TextEditingController(
//     text: "0",
//   );

//   List partners = [];
//   List warehouses = [];
//   List products = [];

//   Map? selectedPartner;
//   Map? selectedWarehouse;
//   Map? selectedProduct;

//   double price = 0;
//   int paymentMethod = 0;

//   List<Map<String, TextEditingController>> checks = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchCustomers();
//     fetchWarehouses();
//   }

//   // ================= HELPER =================

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

//   // ================= API =================

//   Future fetchCustomers() async {
//     final res = await http.get(
//       Uri.parse(ApiEndpoints.getPartners),
//       headers: await getHeaders(),
//     );

//     print("customers: ${res.body}");

//     if (res.statusCode == 200) {
//       partners = parseListResponse(res.body);
//       setState(() {});
//     }
//   }

//   Future addCustomer(String name, String phone) async {
//     final res = await http.post(
//       Uri.parse(ApiEndpoints.addPartner),
//       headers: await getHeaders(),
//       body: jsonEncode({"company_name": name, "phone_number": phone}),
//     );

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       fetchCustomers();
//     }
//   }

//   Future fetchWarehouses() async {
//     final res = await http.get(
//       Uri.parse(ApiEndpoints.getWarehouses),
//       headers: await getHeaders(),
//     );

//     print("warehouses: ${res.body}");

//     if (res.statusCode == 200) {
//       warehouses = parseListResponse(res.body);
//       setState(() {});
//     }
//   }

//   Future fetchProducts(int warehouseId) async {
//     final res = await http.get(
//       Uri.parse(
//         "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/$warehouseId/storage",
//       ),
//       headers: await getHeaders(),
//     );

//     print("products: ${res.body}");

//     if (res.statusCode == 200) {
//       products = parseListResponse(res.body);
//       setState(() {});
//     }
//   }

//   Future createTransaction() async {
//     List checksData = checks.map((c) {
//       return {"number": c['number']!.text, "amount": c['amount']!.text};
//     }).toList();

//     final res = await http.post(
//       Uri.parse(""), // 🔥 لازم يكون معرف
//       headers: await getHeaders(),
//       body: jsonEncode({
//         "partner_id": selectedPartner?['id'],
//         "warehouse_id": selectedWarehouse?['id'],
//         "product_id": selectedProduct?['id'],
//         "quantity": _quantityController.text,
//         "payment_method": paymentMethod,
//         "deposit": _depositController.text,
//         "checks": checksData,
//       }),
//     );

//     print("transaction: ${res.body}");

//     if (res.statusCode == 200 || res.statusCode == 201) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("تمت العملية بنجاح")));
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("فشل العملية")));
//     }
//   }

//   // ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     double quantity = double.tryParse(_quantityController.text) ?? 1;
//     double totalPrice = quantity * price;
//     double deposit = double.tryParse(_depositController.text) ?? 0;
//     double remaining = totalPrice - deposit;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         title: const Text(
//           "تفاصيل البيع",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildSectionTitle("بيانات العملية"),

//               _buildCustomerDropdown(),

//               _buildWarehouseDropdown(),

//               _buildProductDropdown(),

//               _buildCustomTextField(
//                 _quantityController,
//                 "الكمية",
//                 Icons.shopping_cart_outlined,
//               ),

//               const SizedBox(height: 10),

//               Text(
//                 "السعر الكلي: $totalPrice",
//                 style: TextStyle(
//                   color: primaryBlue,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const Divider(),

//               _buildSectionTitle("تفاصيل الدفع"),

//               Row(
//                 children: [
//                   _buildPaymentTypeBtn("دفع كامل", paymentMethod == 0, () {
//                     setState(() {
//                       paymentMethod = 0;
//                       _depositController.text = totalPrice.toString();
//                     });
//                   }),
//                   const SizedBox(width: 8),
//                   _buildPaymentTypeBtn("عربون", paymentMethod == 1, () {
//                     setState(() => paymentMethod = 1);
//                   }),
//                   const SizedBox(width: 8),
//                   _buildPaymentTypeBtn("شيكات", paymentMethod == 2, () {
//                     setState(() => paymentMethod = 2);
//                   }),
//                 ],
//               ),

//               const SizedBox(height: 20),

//               if (paymentMethod == 1)
//                 _buildCustomTextField(
//                   _depositController,
//                   "قيمة العربون",
//                   Icons.payments,
//                 ),

//               if (paymentMethod == 2) _buildChecksSection(),

//               const SizedBox(height: 20),

//               Container(
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: primaryBlue.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("المتبقي:"),
//                     Text(
//                       "${paymentMethod == 0 ? 0 : remaining}",
//                       style: TextStyle(
//                         color: primaryBlue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),

//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ================= Widgets =================

//   Widget _buildCustomerDropdown() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildDropdown(
//             "اختر زبون",
//             Icons.person,
//             partners,
//             selectedPartner,
//             (v) => setState(() => selectedPartner = v),
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.add, color: primaryBlue),
//           onPressed: showAddCustomerDialog,
//         ),
//       ],
//     );
//   }

//   Widget _buildWarehouseDropdown() {
//     return _buildDropdown(
//       "اختر مستودع",
//       Icons.warehouse,
//       warehouses,
//       selectedWarehouse,
//       (v) async {
//         selectedWarehouse = v;
//         await fetchProducts(v['id']);
//       },
//     );
//   }

//   Widget _buildProductDropdown() {
//     return _buildDropdown(
//       "اختر منتج",
//       Icons.inventory,
//       products,
//       selectedProduct,
//       (v) {
//         selectedProduct = v;
//         price = double.parse(v['price'].toString());
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildDropdown(
//     String hint,
//     IconData icon,
//     List data,
//     value,
//     Function(dynamic) onChanged,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFF),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: DropdownButtonFormField(
//         value: value,
//         hint: Text(hint),
//         items: data.map((e) {
//           return DropdownMenuItem(value: e, child: Text(e['name'] ?? ""));
//         }).toList(),
//         onChanged: onChanged,
//         decoration: InputDecoration(
//           icon: Icon(icon, color: primaryBlue),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildChecksSection() {
//     return Column(
//       children: [
//         ...checks.map((c) {
//           return Column(
//             children: [
//               _buildCustomTextField(
//                 c['number']!,
//                 "رقم الشيك",
//                 Icons.confirmation_number,
//               ),
//               _buildCustomTextField(c['amount']!, "قيمة الشيك", Icons.money),
//             ],
//           );
//         }),
//         ElevatedButton(onPressed: addCheck, child: const Text("إضافة شيك")),
//       ],
//     );
//   }

//   Widget _buildCustomTextField(
//     TextEditingController controller,
//     String hint,
//     IconData icon,
//   ) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF8FAFF),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: TextField(
//         controller: controller,
//         onChanged: (_) => setState(() {}),
//         decoration: InputDecoration(
//           hintText: hint,
//           icon: Icon(icon, color: primaryBlue),
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }

//   Widget _buildPaymentTypeBtn(String label, bool selected, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           height: 45,
//           margin: const EdgeInsets.only(bottom: 10),
//           decoration: BoxDecoration(
//             color: selected ? const Color(0xFFE8EFFF) : Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: primaryBlue),
//           ),
//           child: Center(child: Text(label)),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 55,
//       child: ElevatedButton(
//         onPressed: createTransaction,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryBlue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//         ),
//         child: const Text("إتمام العملية", style: TextStyle(fontSize: 18)),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//     );
//   }

//   // ================= Helpers =================

//   void addCheck() {
//     checks.add({
//       "number": TextEditingController(),
//       "amount": TextEditingController(),
//     });
//     setState(() {});
//   }

//   void showAddCustomerDialog() {
//     TextEditingController name = TextEditingController();
//     TextEditingController phone = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("إضافة زبون"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(controller: name),
//             TextField(controller: phone),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               await addCustomer(name.text, phone.text);
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
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

class TransactionDetailsScreen extends StatefulWidget {
  const TransactionDetailsScreen({super.key});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  // الألوان الأساسية - تم تعديل primaryBlue ليتوافق مع الصورة
  final Color primaryBlue = const Color(0xFF4A72C2);
  final Color accentBlue = const Color(0xFF3B82F6);
  final Color bgGradientStart = const Color(0xFFF0F4F8);

  final TextEditingController _quantityController = TextEditingController(
    text: "1",
  );
  final TextEditingController _depositController = TextEditingController(
    text: "0",
  );

  List partners = [];
  List warehouses = [];
  List products = [];

  Map? selectedPartner;
  Map? selectedWarehouse;
  Map? selectedProduct;

  double price = 0;
  int paymentMethod = 0;
  List<Map<String, TextEditingController>> checks = [];

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    fetchWarehouses();
  }

  // [دوال الـ API والـ Helpers كما هي دون تعديل]
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

  Future fetchCustomers() async {
    final res = await http.get(
      Uri.parse(ApiEndpoints.getPartners),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200) {
      setState(() => partners = parseListResponse(res.body));
    }
  }

  Future addCustomer(String name, String phone) async {
    final res = await http.post(
      Uri.parse(ApiEndpoints.addPartner),
      headers: await getHeaders(),
      body: jsonEncode({
        "company_name": name,
        "phone_number": phone,
        "partner_type": "customer",
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) fetchCustomers();
  }

  Future fetchWarehouses() async {
    final res = await http.get(
      Uri.parse(ApiEndpoints.getWarehouses),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200) {
      setState(() => warehouses = parseListResponse(res.body));
    }
  }

  Future fetchProducts(int warehouseId) async {
    final res = await http.get(
      Uri.parse(
        "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/$warehouseId/storage",
      ),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200) {
      setState(() => products = parseListResponse(res.body));
    }
  }

  Future createTransaction() async {
    List checksData = checks
        .map((c) => {"number": c['number']!.text, "amount": c['amount']!.text})
        .toList();
    final quantity = double.tryParse(_quantityController.text) ?? 1;
    final totalPrice = quantity * price;

    final res = await http.post(
      Uri.parse(""),
      headers: await getHeaders(),
      body: jsonEncode({
        "partner_id": selectedPartner?['id'],
        "warehouse_id": selectedWarehouse?['id'],
        "product_id": selectedProduct?['id'],
        "quantity": quantity,
        "unit_price": price,
        "total_price": totalPrice,
        "payment_method": paymentMethod,
        "deposit": _depositController.text,
        "checks": checksData,
      }),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          res.statusCode == 200 || res.statusCode == 201
              ? "تمت العملية بنجاح"
              : "فشل العملية",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double quantity = double.tryParse(_quantityController.text) ?? 1;
    double totalPrice = quantity * price;
    double deposit = double.tryParse(_depositController.text) ?? 0;
    double remaining = totalPrice - deposit;

    return Scaffold(
      // تم إلغاء extendBodyBehindAppBar ليكون اللون سادة وواضح خلف الأيقونات
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue, // لون أزرق سادة
        title: const Text(
          "تفاصيل العملية",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: bgGradientStart),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                _buildSectionCard(
                  title: "بيانات الأطراف",
                  icon: Icons.person_outline,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _customDropdown(
                              "الزبون",
                              partners,
                              selectedPartner,
                              (v) => setState(() => selectedPartner = v),
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildAddButton(showAddCustomerDialog),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _customDropdown(
                        "المستودع",
                        warehouses,
                        selectedWarehouse,
                        (v) async {
                          setState(() => selectedWarehouse = v);
                          await fetchProducts(v['id']);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: "تفاصيل البضاعة",
                  icon: Icons.inventory_2_outlined,
                  child: Column(
                    children: [
                      _customDropdown(
                        "اختر المنتج",
                        products,
                        selectedProduct,
                        (v) {
                          selectedProduct = v;
                          price =
                              double.tryParse(v['sale_price'].toString()) ?? 0;
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 15),
                      _customTextField(
                        "الكمية المطلوبة",
                        _quantityController,
                        Icons.production_quantity_limits,
                      ),
                      const SizedBox(height: 20),
                      _buildPriceRow(
                        "السعر الإجمالي",
                        "$totalPrice د.أ",
                        isTotal: true,
                      ),
                    ],
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
                          "قيمة العربون",
                          _depositController,
                          Icons.money,
                        ),
                      ],
                      if (paymentMethod == 2) _buildChecksSection(),
                      const Divider(height: 30),
                      _buildPriceRow(
                        "المبلغ المتبقي",
                        "$remaining د.أ",
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

  // وحدات بناء الواجهة (UI Components)

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryBlue, size: 20),
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
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
        hint: Text(hint, style: const TextStyle(fontSize: 14)),
        isExpanded: true,
        items: data
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e['company_name'] ?? e['name'] ?? ""),
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
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: primaryBlue),
        hintText: hint,
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

  Widget _buildPriceRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 16,
            color: color ?? primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _payBtn(String text, int type) {
    bool isSelected = paymentMethod == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => paymentMethod = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
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
                    "القيمة",
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
          icon: const Icon(Icons.add_circle_outline),
          label: const Text("إضافة شيك جديد"),
        ),
      ],
    );
  }

  Widget _buildAddButton(VoidCallback onPressed) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: createTransaction,
        child: const Text(
          "إتمام العملية وحفظ الفاتورة",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showAddCustomerDialog() {
    TextEditingController name = TextEditingController();
    TextEditingController phone = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("إضافة زبون جديد", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _customTextField("اسم الشركة/الزبون", name, Icons.business),
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
              await addCustomer(name.text, phone.text);
              Navigator.pop(context);
            },
            child: const Text("حفظ البيانات"),
          ),
        ],
      ),
    );
  }
}
