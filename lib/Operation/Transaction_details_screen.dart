import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' show DateFormat;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';
// import 'package:intl/intl.dart';

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

  // مصفوفات للتحكم في البيانات لكل مستودع
  List<TextEditingController> _quantityControllers = [
    TextEditingController(text: "1"),
  ];
  List<TextEditingController> _priceControllers = [
    TextEditingController(text: "0"),
  ];
  List<Map?> _selectedProductsList = [null];
  List<List> _warehouseProductsLists = [[]];

  final TextEditingController _depositController = TextEditingController(
    text: "0",
  );
  final TextEditingController _supplierInvoiceController =
      TextEditingController();

  List partners = [];
  List warehouses = [];
  Map? selectedPartner;

  List<Map?> selectedWarehousesList = [null];

  int paymentMethod = 0;
  List<Map<String, TextEditingController>> checks = [];
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
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

  Future<void> submitTransaction() async {
    try {
      final headers = await getHeaders();

      if (selectedPartner == null) {
        throw Exception("لازم تختاري زبون أول");
      }

      // تجهيز items
      List items = [];

      for (int i = 0; i < selectedWarehousesList.length; i++) {
        final warehouse = selectedWarehousesList[i];
        final product = _selectedProductsList[i];

        if (warehouse == null || product == null) continue;

        final quantity = double.tryParse(_quantityControllers[i].text) ?? 0;
        final price = double.tryParse(_priceControllers[i].text) ?? 0;

        items.add({
          "quantity": quantity,
          "unit_price": price,
          "allocations": [
            {
              "storage_id": product['id'] ?? 0, // مهم جدا
              "quantity": quantity,
            },
          ],
        });
      }

      final body = {
        "partner_id": selectedPartner!['id'],
        "sale_date": DateTime.now().toString().substring(0, 10),
        "invoice_number": _supplierInvoiceController.text.isEmpty
            ? "INV-${DateTime.now().millisecondsSinceEpoch}"
            : _supplierInvoiceController.text,
        "notes": "from app",
        "items": items,
      };
      print("Partner: $selectedPartner");
      print("Items: $items");
      print("Body: $body");
      // 🔥 إرسال عملية البيع
      final response = await http.post(
        Uri.parse(ApiEndpoints.addsale), // تأكدي من الرابط
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['sale']['id'] == null) {
          throw Exception("الـ API ما رجع sale id");
        }

        final int saleId = data['sale']['id'];
        // 👇 إذا في دفع
        await handlePayment(saleId);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تمت العملية بنجاح")));

        Navigator.pop(context);
      } else {
        throw Exception("فشل العملية: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    }
  }

  Future<void> handlePayment(int? saleId) async {
    if (saleId == null) return;
    double amount = double.tryParse(_depositController.text) ?? 0;

    if (paymentMethod == 0) {
      // نقدي
      if (amount > 0) {
        await sendPayment(saleId, "cash", amount);
      }
    } else if (paymentMethod == 1) {
      for (var c in checks) {
        String bank = c['bank']!.text;
        String number = c['number']!.text;
        String date = c['date']!.text;
        double amount = double.tryParse(c['amount']!.text) ?? 0;

        if (bank.isEmpty || number.isEmpty || date.isEmpty || amount <= 0) {
          continue; // تخطي الشيكات غير المكتملة
        }

        await sendCheck(
          bankName: bank,
          checkNumber: number,
          companyName:
              selectedPartner?['company_name'] ??
              selectedPartner?['name'] ??
              "Unknown",
          amount: amount,
          cashingDate: date,
        );

        // ربط الشيك بالعملية المالية
        await sendPayment(saleId, "check", amount, note: "شيك من ${bank}");
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

  Future<void> sendCheck({
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

    await http.post(
      Uri.parse(ApiEndpoints.addCheck), // تأكدي من الرابط
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<void> sendPayment(
    int saleId,
    String method,
    double amount, {
    String note = "",
    Map<String, dynamic>? checkData,
  }) async {
    final headers = await getHeaders();

    final body = {
      "id": saleId,
      "payment_method": method,
      "amount": amount,
      "payment_date": DateTime.now().toString().substring(0, 10),
      "notes": note,
    };
    if (method == "check" && checkData != null) {
      body["check"] = checkData;
    }
    await http.post(
      Uri.parse("${ApiEndpoints.addsale}/$saleId/payments"), // تأكدي من الرابط
      headers: headers,
      body: jsonEncode(body),
    );
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

  Future fetchProducts(int warehouseId, int index) async {
    final res = await http.get(
      Uri.parse("${ApiEndpoints.baseUrl}/warehouse/$warehouseId/storage"),
      headers: await getHeaders(),
    );
    if (res.statusCode == 200) {
      setState(() {
        _warehouseProductsLists[index] = parseListResponse(res.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double overallTotal = 0;
    for (int i = 0; i < selectedWarehousesList.length; i++) {
      double q = double.tryParse(_quantityControllers[i].text) ?? 0;
      double p = double.tryParse(_priceControllers[i].text) ?? 0;
      overallTotal += (q * p);
    }

    double deposit = double.tryParse(_depositController.text) ?? 0;
    double checksTotal = 0;
    for (var c in checks) {
      double amount = double.tryParse(c['amount']!.text) ?? 0;
      checksTotal += amount;
    }
    double remaining = overallTotal - (deposit + checksTotal);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        title: Text(
          widget.isSale ? "تفاصيل عملية البيع " : "تفاصيل عملية الشراء ",
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
                      ...List.generate(selectedWarehousesList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: _customDropdown(
                                  "المستودع ${index + 1}",
                                  warehouses,
                                  selectedWarehousesList[index],
                                  (v) {
                                    setState(
                                      () => selectedWarehousesList[index] = v,
                                    );
                                    fetchProducts(v['id'], index);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (index == 0)
                                _buildAddButton(
                                  Icons.add_business_outlined,
                                  () {
                                    setState(() {
                                      selectedWarehousesList.add(null);
                                      _quantityControllers.add(
                                        TextEditingController(text: "1"),
                                      );
                                      _priceControllers.add(
                                        TextEditingController(text: "0"),
                                      );
                                      _selectedProductsList.add(null);
                                      _warehouseProductsLists.add([]);
                                    });
                                  },
                                )
                              else
                                _buildAddButton(Icons.remove, () {
                                  setState(() {
                                    selectedWarehousesList.removeAt(index);
                                    _quantityControllers.removeAt(index);
                                    _priceControllers.removeAt(index);
                                    _selectedProductsList.removeAt(index);
                                    _warehouseProductsLists.removeAt(index);
                                  });
                                }, isDelete: true),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                ...List.generate(selectedWarehousesList.length, (index) {
                  String whName =
                      selectedWarehousesList[index]?['company_name'] ??
                      selectedWarehousesList[index]?['name'] ??
                      "${index + 1}";

                  return Column(
                    children: [
                      _buildSectionCard(
                        title: "بضاعة مستودع: $whName",
                        icon: Icons.inventory_2_outlined,
                        child: Column(
                          children: [
                            _customDropdown(
                              "اختر المنتج من $whName",
                              _warehouseProductsLists[index],
                              _selectedProductsList[index],
                              (v) {
                                setState(() {
                                  _selectedProductsList[index] = v;
                                  _priceControllers[index].text = widget.isSale
                                      ? (v['sale_price']?.toString() ?? "0")
                                      : (v['purchase_price']?.toString() ??
                                            "0");
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            _customTextField(
                              widget.isSale
                                  ? "سعر البيع (\$)"
                                  : "سعر الشراء (\$)",
                              _priceControllers[index],
                              Icons.monetization_on_outlined,
                            ),
                            const SizedBox(height: 15),
                            _customTextField(
                              "الكمية",
                              _quantityControllers[index],
                              Icons.production_quantity_limits,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
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
                      Row(children: [_payBtn("نقداً", 0), _payBtn("شيكات", 1)]),
                      if (paymentMethod == 0) ...[
                        const SizedBox(height: 15),
                        _customTextField(
                          "المبلغ المدفوع (\$)",
                          _depositController,
                          Icons.money,
                        ),
                      ],
                      if (paymentMethod == 1) _buildChecksSection(),
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

  // --- Widgets المعدلة ---

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
              // تم تكبير الخط هنا ليكون العنوان أوضح
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
        // تم تكبير خط اختيار المستودع والمنتج
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
      // تم تكبير الخط داخل الحقول (السعر والكمية)
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

  // باقي الدوال المساعدة بقيت كما هي لضمان استقرار العمل
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

  // Widget _buildChecksSection() {
  //   return Column(
  //     children: [
  //       ...checks.map(
  //         (c) => Padding(
  //           padding: const EdgeInsets.only(top: 10),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: _customTextField(
  //                   "رقم الشيك",
  //                   c['number']!,
  //                   Icons.numbers,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: _customTextField(
  //                   "القيمة (\$)",
  //                   c['amount']!,
  //                   Icons.attach_money,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       TextButton.icon(
  //         onPressed: () => setState(
  //           () => checks.add({
  //             "number": TextEditingController(),
  //             "amount": TextEditingController(),
  //           }),
  //         ),
  //         icon: const Icon(Icons.add),
  //         label: const Text("إضافة شيك"),
  //       ),
  //     ],
  //   );
  // }
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
                      child: _customTextField(
                        "اسم البنك",
                        c['bank']!,
                        Icons.account_balance,
                        isNumeric: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _customTextField(
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
                      child: _customTextField(
                        "القيمة",
                        c['amount']!,
                        Icons.attach_money,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _customTextField(
                        "تاريخ الصرف",
                        c['date']!,
                        Icons.date_range,
                        isNumeric: false,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => checks.removeAt(index));
                    },
                  ),
                ),
              ],
            ),
          );
        }),

        TextButton.icon(
          onPressed: () {
            setState(() {
              checks.add({
                "bank": TextEditingController(),
                "number": TextEditingController(),
                "amount": TextEditingController(),
                "date": TextEditingController(),
              });
            });

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("تمت إضافة شيك ✔")));
          },
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
