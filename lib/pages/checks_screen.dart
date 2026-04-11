import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'link.dart';
import 'add_check_screen.dart';

class ChecksScreen extends StatefulWidget {
  const ChecksScreen({super.key});

  @override
  State<ChecksScreen> createState() => _ChecksScreenState();
}

class _ChecksScreenState extends State<ChecksScreen> {
  List checks = [];
  bool _isLoading = true;

  // ✅ الثوابت اللونية (كما هي في كودك)
  static const Color greenColor = Color(0xFF20E070);
  static const Color redColor = Color(0xFFFF2020);
  static const Color statusBgColor = Color(0xFFFFEB9B);
  static const Color statusTextColor = Color(0xFFC0A000);
  static const Color activeBlue = Color(0xFF446BC0);

  @override
  void initState() {
    super.initState();
    fetchChecks();
  }

  // --- دالة جلب البيانات ---
  Future<void> fetchChecks() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var response = await http.get(
        Uri.parse(ApiEndpoints.getChecks),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            if (responseData is Map) {
              checks = responseData['checks'] ?? responseData['data'] ?? [];
            } else if (responseData is List) {
              checks = responseData;
            }
          });
        }
      } else {
        _showErrorSnackBar("فشل تحميل البيانات، يرجى المحاولة مجدداً");
      }
    } catch (e) {
      debugPrint("Error fetching checks: $e");
      _showErrorSnackBar("تعذر الاتصال بالخادم");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ دالة التحديث (معدلة بالكامل لحل الـ 404)
  Future<void> _updateCheckStatus(
    Map<String, dynamic> check,
    String newStatus,
  ) async {
    final String oldStatus = check["status"];
    final dynamic checkId = check["id"];

    setState(() {
      check["status"] = newStatus;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final requestBody = jsonEncode({"status": newStatus});

      // تصحيح المسار بإضافة /api/ ليتوافق مع السيرفر
      String updateUrl = "${ApiEndpoints.baseUrl}/api/checks/$checkId";

      var response = await http.put(
        Uri.parse(updateUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: requestBody,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        final int idx = checks.indexWhere((c) => c["id"] == checkId);
        if (idx != -1 && mounted) {
          setState(() {
            checks[idx]["status"] = newStatus;
          });
        }
        _showSuccessSnackBar(
          newStatus == "collected"
              ? "تم تحويل الشيك إلى محصل"
              : "تم إعادة الشيك إلى قيد الانتظار",
        );
      } else {
        _revertStatus(checkId, oldStatus);
        _showErrorSnackBar("فشل تحديث الحالة (${response.statusCode})");
      }
    } catch (e) {
      _revertStatus(checkId, oldStatus);
      _showErrorSnackBar("تعذر الاتصال بالخادم");
    }
  }

  void _revertStatus(dynamic id, String oldStatus) {
    final int idx = checks.indexWhere((c) => c["id"] == id);
    if (idx != -1 && mounted) {
      setState(() => checks[idx]["status"] = oldStatus);
    }
  }

  // ✅ دالة الحذف (معدلة لضمان المسار الصحيح)
  Future<void> _deleteCheck(dynamic id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var response = await http.delete(
        Uri.parse("${ApiEndpoints.baseUrl}/api/checks/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _showSuccessSnackBar("تم حذف الشيك بنجاح");
        fetchChecks();
      } else {
        _showErrorSnackBar("فشل حذف الشيك (${response.statusCode})");
      }
    } catch (e) {
      _showErrorSnackBar("تعذر الاتصال بالخادم");
    }
  }

  // --- عرض رسائل تنبيهية ---
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
          textAlign: TextAlign.right,
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Cairo'),
          textAlign: TextAlign.right,
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // --- الـ Dialogs كاملة كما هي في ملفك ---
  void _confirmDelete(dynamic id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "تأكيد الحذف",
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        content: const Text(
          "هل أنت متأكد من حذف هذا الشيك نهائياً؟",
          textAlign: TextAlign.right,
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCheck(id);
            },
            child: const Text(
              "حذف",
              style: TextStyle(color: Colors.red, fontFamily: 'Cairo'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckDetailsDialog(Map<String, dynamic> check) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "تفاصيل الشيك",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow("اسم العميل:", check["company_name"]),
              _detailRow("رقم الشيك:", check["check_number"]),
              _detailRow("البنك:", check["bank_name"]),
              _detailRow("المبلغ:", "\$ ${check["amount"]}"),
              _detailRow("التاريخ:", check["issue_date"]),
              _detailRow("النوع:", check["type"]),
              _detailRow(
                "الحالة:",
                check["status"] == "pending" ? "قيد الانتظار" : "محصل",
              ),
              const Divider(height: 30),
              const Text(
                "الملاحظات:",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                (check["notes"] == null || check["notes"].toString().isEmpty)
                    ? "لا توجد ملاحظات"
                    : check["notes"],
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "إغلاق",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              value?.toString() ?? "---",
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // --- القائمة المنبثقة (BottomSheet) ---
  void _showCheckOptions(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final check = checks[index];
        bool isCollected = check["status"] == "collected";
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility, color: activeBlue),
                title: const Text(
                  "عرض البيانات الكاملة",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showCheckDetailsDialog(check);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text(
                  "تعديل بيانات الشيك",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCheckScreen(checkToEdit: check),
                    ),
                  );
                  if (result == true) fetchChecks();
                },
              ),
              ListTile(
                leading: Icon(
                  isCollected ? Icons.history : Icons.check_circle,
                  color: isCollected ? Colors.orange : Colors.green,
                ),
                title: Text(
                  isCollected ? "إعادة إلى قيد الانتظار" : "تحويل إلى محصل",
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _updateCheckStatus(
                    check,
                    isCollected ? "pending" : "collected",
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "حذف الشيك",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(check["id"]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // --- بناء الواجهة (Build UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "إدارة الشيكات",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: activeBlue))
          : RefreshIndicator(
              onRefresh: fetchChecks,
              child: checks.isEmpty ? _buildEmptyState() : _buildChecksList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCheckScreen()),
          );
          if (result == true) fetchChecks();
        },
        backgroundColor: activeBlue,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: const [
        SizedBox(height: 200),
        Center(
          child: Column(
            children: [
              Icon(Icons.folder_open, size: 70, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "لا توجد شيكات حتى الآن",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "اضغط على + لإضافة شيك جديد",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChecksList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: checks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showCheckOptions(index),
          child: _buildCheckCard(
            check: checks[index],
            isOutgoing: checks[index]["type"] == "صادر",
          ),
        );
      },
    );
  }

  Widget _buildCheckCard({
    required Map<String, dynamic> check,
    required bool isOutgoing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isOutgoing
              ? redColor.withOpacity(0.5)
              : greenColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$ ${NumberFormat('#,###').format(double.tryParse(check["amount"].toString()) ?? 0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      check["company_name"] ?? "غير معروف",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildBadge(
                      check["type"] ?? "وارد",
                      isOutgoing ? redColor : greenColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusBadge(check["status"]),
                Text(
                  "تاريخ الاستحقاق: ${check["issue_date"]}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    bool isPending = status == "pending";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPending ? statusBgColor : Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isPending ? "قيد الانتظار" : "محصل",
        style: TextStyle(
          fontFamily: 'Cairo',
          color: isPending ? statusTextColor : Colors.green.shade700,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
