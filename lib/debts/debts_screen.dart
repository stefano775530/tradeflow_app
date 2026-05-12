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

  // الفلتر الحالي لكل تاب
  DebtFilter _filterOwedToUs = DebtFilter.all;
  DebtFilter _filterOwedByUs = DebtFilter.all;

  @override
  void initState() {
    super.initState();

    // fetchPartnersDebts(true);
    //fetchPartnersDebts(isOwedToUs:false);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchPartnersDebts(bool isOwedToUs) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      debugPrint("TOKEN: $token");
      debugPrint("URL: ${ApiEndpoints.getDebts}");

      final response = await http.get(
        Uri.parse("${ApiEndpoints.getDebts}"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      debugPrint("STATUS CODE: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        var rawData = jsonDecode(response.body);
        List<dynamic> allPartners = [];

        if (rawData is List) {
          allPartners = rawData;
        } else if (rawData is Map && rawData.containsKey('data')) {
          allPartners = rawData['data'] as List;
        }

        debugPrint("ALL PARTNERS COUNT: ${allPartners.length}");
        if (allPartners.isNotEmpty) {
          debugPrint("FIRST ITEM: ${allPartners[0]}");
          debugPrint(
            "PARTNER_TYPE VALUE: ${allPartners[0]['Partner']?['partner_type']}",
          );
        }

        if (isOwedToUs) {
          return allPartners
              .where((p) => p['Partner']['partner_type'] == 'customer')
              .toList();
        } else {
          return allPartners
              .where((p) => p['Partner']['partner_type'] == 'supplier')
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  // تصفية القائمة حسب الفلتر المختار
  // List<dynamic> _applyFilter(List<dynamic> data, DebtFilter filter) {
  //   switch (filter) {
  //     case DebtFilter.all:
  //       return data;
  //     case DebtFilter.partial:
  //       // دفع جزئي = رصيد أكبر من 0 لكن ليس كاملاً (عدّل الشرط حسب منطق تطبيقك)
  //       return data.where((p) {
  //         final balance = double.tryParse(p['balance']?.toString() ?? '0') ?? 0;
  //         return balance > 0 &&
  //             balance < (p['total_amount'] ?? double.infinity);
  //       }).toList();
  //     case DebtFilter.unpaid:
  //       // لم يدفع = رصيد يساوي المبلغ الكامل أو لا يوجد أي دفعة
  //       return data.where((p) {
  //         final balance = double.tryParse(p['balance']?.toString() ?? '0') ?? 0;
  //         return balance > 0;
  //       }).toList();
  //   }
  // }
  List<dynamic> _applyFilter(List<dynamic> data, DebtFilter filter) {
    switch (filter) {
      case DebtFilter.all:
        return data;

      case DebtFilter.partial:
        return data.where((p) {
          return p['payment_status'] == 'partial';
        }).toList();

      case DebtFilter.unpaid:
        return data.where((p) {
          return p['payment_status'] == 'unpaid';
        }).toList();
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
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
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
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد بيانات"));
        }

        final allData = snapshot.data!;
        final filteredData = _applyFilter(allData, currentFilter);

        // حساب عدد كل فئة للـ badge
        final countAll = allData.length;
        final countPartial = _applyFilter(allData, DebtFilter.partial).length;
        final countUnpaid = _applyFilter(allData, DebtFilter.unpaid).length;

        return Column(
          children: [
            // --- أزرار الفلتر ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFilterButton(
                      label: "جميع الموردين",
                      shortLabel: "الكل",
                      icon: Icons.group_outlined,
                      count: countAll,
                      isSelected: currentFilter == DebtFilter.all,
                      color: primaryBlue,
                      onTap: () => setState(() {
                        if (isOwedToUs) {
                          _filterOwedToUs = DebtFilter.all;
                        } else {
                          _filterOwedByUs = DebtFilter.all;
                        }
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterButton(
                      label: "دفع جزئي",
                      shortLabel: "جزئي",
                      icon: Icons.payments_outlined,
                      count: countPartial,
                      isSelected: currentFilter == DebtFilter.partial,
                      color: const Color(0xFFB45309),
                      onTap: () => setState(() {
                        if (isOwedToUs) {
                          _filterOwedToUs = DebtFilter.partial;
                        } else {
                          _filterOwedByUs = DebtFilter.partial;
                        }
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildFilterButton(
                      label: "لم يدفع نهائياً",
                      shortLabel: "لم يدفع",
                      icon: Icons.cancel_outlined,
                      count: countUnpaid,
                      isSelected: currentFilter == DebtFilter.unpaid,
                      color: const Color(0xFFDC2626),
                      onTap: () => setState(() {
                        if (isOwedToUs) {
                          _filterOwedToUs = DebtFilter.unpaid;
                        } else {
                          _filterOwedByUs = DebtFilter.unpaid;
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // --- القائمة ---
            Expanded(
              child: filteredData.isEmpty
                  ? const Center(
                      child: Text(
                        "لا توجد نتائج",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filteredData.length,
                      itemBuilder: (context, index) {
                        final item = filteredData[index];

                        final partner = item['Partner'];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DebtDetailsScreen(
                                  partnerId: partner['id'],
                                  partnerName:
                                      partner['company_name'] ?? "بدون اسم",
                                  currentBalance:
                                      item['remaining_amount']?.toString() ??
                                      "0",
                                ),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),

                              leading: CircleAvatar(
                                backgroundColor: primaryBlue.withOpacity(0.12),
                                child: Text(
                                  _getInitials(partner['company_name'] ?? "؟"),
                                  style: TextStyle(
                                    color: primaryBlue,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                  ),
                                ),
                              ),

                              title: Text(
                                partner['company_name'] ?? "بدون اسم",
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              subtitle: Text(
                                partner['phone_number'] ?? "بدون هاتف",
                                style: const TextStyle(color: Colors.grey),
                              ),

                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₪ ${item['remaining_amount'] ?? '0'}",
                                    style: TextStyle(
                                      color: isOwedToUs
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Text(
                                    "المتبقي",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      // itemBuilder: (context, index) {
                      //   final item = filteredData[index];
                      //   return InkWell(
                      //     onTap: () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => DebtDetailsScreen(
                      //             partnerId: item['id'],
                      //             partnerName:
                      //                 item['company_name'] ?? "بدون اسم",
                      //             currentBalance:
                      //                 item['balance']?.toString() ?? "0",
                      //           ),
                      //         ),
                      //       ).then((_) => setState(() {}));
                      //     },
                      //     child: Card(
                      //       elevation: 1,
                      //       margin: const EdgeInsets.only(bottom: 12),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //       child: ListTile(
                      //         contentPadding: const EdgeInsets.symmetric(
                      //           horizontal: 20,
                      //           vertical: 8,
                      //         ),
                      //         leading: CircleAvatar(
                      //           backgroundColor: primaryBlue.withOpacity(0.12),
                      //           child: Text(
                      //             _getInitials(item['company_name'] ?? "؟"),
                      //             style: TextStyle(
                      //               color: primaryBlue,
                      //               fontWeight: FontWeight.bold,
                      //               fontFamily: 'Cairo',
                      //               fontSize: 13,
                      //             ),
                      //           ),
                      //         ),
                      //         title: Text(
                      //           item['company_name'] ?? "بدون اسم",
                      //           style: const TextStyle(
                      //             fontFamily: 'Cairo',
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         subtitle: Text(
                      //           item['phone_number'] ?? "بدون هاتف",
                      //           style: const TextStyle(color: Colors.grey),
                      //         ),
                      //         trailing: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.end,
                      //           children: [
                      //             Text(
                      //               "₪ ${item['balance'] ?? '0'}",
                      //               style: TextStyle(
                      //                 color: isOwedToUs
                      //                     ? Colors.green
                      //                     : Colors.red,
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 18,
                      //               ),
                      //             ),
                      //             const Text(
                      //               "الرصيد الحالي",
                      //               style: TextStyle(
                      //                 fontSize: 10,
                      //                 color: Colors.grey,
                      //                 fontFamily: 'Cairo',
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // },
                    ),
            ),
          ],
        );
      },
    );
  }

  // --- زر الفلتر ---
  Widget _buildFilterButton({
    required String label,
    required String shortLabel,
    required IconData icon,
    required int count,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              shortLabel,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.25)
                    : color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // استخراج الأحرف الأولى للاسم
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}

// --- صفحة التفاصيل (بدون تغيير) ---
class DebtDetailsScreen extends StatefulWidget {
  final int partnerId;
  final String partnerName;
  final String currentBalance;

  const DebtDetailsScreen({
    super.key,
    required this.partnerId,
    required this.partnerName,
    required this.currentBalance,
  });

  @override
  State<DebtDetailsScreen> createState() => _DebtDetailsScreenState();
}

class _DebtDetailsScreenState extends State<DebtDetailsScreen> {
  final Color primaryBlue = const Color(0xFF3D5EAB);
  bool isCash = true;
  bool isCheck = false;
  bool isSaving = false;

  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _checkNumController = TextEditingController();
  final TextEditingController _checkValueController = TextEditingController();

  Future<List<dynamic>> fetchTransactions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      final response = await http.get(
        Uri.parse(
          "${ApiEndpoints.baseUrl}/partners/${widget.partnerId}/transactions",
        ),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Error: $e");
    }
    return [];
  }

  Future<void> _submitPayment() async {
    setState(() => isSaving = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final response = await http.post(
        Uri.parse("${ApiEndpoints.addPayment}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "partner_id": widget.partnerId,
          "amount": isCash ? _cashController.text : _checkValueController.text,
          "payment_method": isCash ? "cash" : "check",
          "bank_name": isCheck ? _bankNameController.text : null,
          "check_number": isCheck ? _checkNumController.text : null,
          "date": DateTime.now().toString(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم الحفظ بنجاح")));
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 15,
            left: 20,
            right: 20,
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "تسجيل دفعة لـ ${widget.partnerName}",
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: _buildTypeCard(
                      label: "نقدي",
                      icon: Icons.money,
                      isSelected: isCash,
                      onTap: () => setModalState(() {
                        isCash = true;
                        isCheck = false;
                      }),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildTypeCard(
                      label: "شيك",
                      icon: Icons.confirmation_number_outlined,
                      isSelected: isCheck,
                      onTap: () => setModalState(() {
                        isCheck = true;
                        isCash = false;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              if (isCash)
                _buildTextField(
                  label: "المبلغ النقدي",
                  icon: Icons.payments_outlined,
                  controller: _cashController,
                  isNumber: true,
                ),
              if (isCheck) ...[
                _buildTextField(
                  label: "اسم البنك",
                  icon: Icons.account_balance,
                  controller: _bankNameController,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: "رقم الشيك",
                  icon: Icons.tag,
                  controller: _checkNumController,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: "القيمة",
                  icon: Icons.attach_money,
                  controller: _checkValueController,
                  isNumber: true,
                ),
              ],
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
                  onPressed: isSaving ? null : _submitPayment,
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 40,
              right: 20,
              left: 20,
            ),
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
                const Icon(Icons.more_vert, color: Colors.white),
                Text(
                  widget.partnerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -25),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    "الرصيد الحالي",
                    widget.currentBalance,
                    primaryBlue,
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "سجل العمليات",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchTransactions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final trans = snapshot.data ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: trans.length,
                  itemBuilder: (context, index) {
                    final t = trans[index];
                    return _buildTimelineItem(
                      t['type'] ?? "عملية",
                      t['amount'].toString(),
                      t['date'] ?? "",
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _showPaymentSheet(context),
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
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? primaryBlue : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF7F9FC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          "₪ $value",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String type, String amount, String date) {
    return ListTile(
      leading: Icon(Icons.circle, size: 12, color: primaryBlue),
      title: Text(
        type,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(date, style: const TextStyle(fontSize: 12)),
      trailing: Text(
        "₪ $amount",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
