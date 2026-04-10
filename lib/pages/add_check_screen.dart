import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'link.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddCheckScreen extends StatefulWidget {
  final Map<String, dynamic>? checkToEdit;

  const AddCheckScreen({super.key, this.checkToEdit});

  @override
  State<AddCheckScreen> createState() => _AddCheckScreenState();
}

class _AddCheckScreenState extends State<AddCheckScreen> {
  final Color activeBlue = const Color(0xFF446BC0);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _checkNumberController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _notesController =
      TextEditingController(); // المتحكم الجديد للملاحظات

  String _checkType = "صادر";
  DateTime? _selectedDate;
  bool _isEditMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.checkToEdit != null && widget.checkToEdit!.isNotEmpty) {
      _isEditMode = true;

      _nameController.text =
          widget.checkToEdit!['company_name']?.toString() ?? "";
      _checkNumberController.text =
          widget.checkToEdit!['check_number']?.toString() ?? "";
      _bankController.text = widget.checkToEdit!['bank_name']?.toString() ?? "";
      _amountController.text = widget.checkToEdit!['amount']?.toString() ?? "";
      _dateController.text =
          widget.checkToEdit!['issue_date']?.toString() ?? "";
      _notesController.text =
          widget.checkToEdit!['notes']?.toString() ??
          ""; // تعبئة الملاحظات عند التعديل
      _checkType = widget.checkToEdit!['type'] ?? "صادر";
    }
  }

  void _showSnackBar(String message, {Color color = Colors.redAccent}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _saveCheck() async {
    String name = _nameController.text.trim();
    String amount = _amountController.text.trim();
    String checkNum = _checkNumberController.text.trim();

    if (name.isEmpty ||
        checkNum.isEmpty ||
        amount.isEmpty ||
        _dateController.text.isEmpty) {
      _showSnackBar("يرجى ملء جميع الحقول المطلوبة");
      return;
    }

    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) {
        _showSnackBar("انتهت الجلسة، يرجى تسجيل الدخول");
        return;
      }

      Map<String, dynamic> data = {
        "bank_name": _bankController.text.trim(),
        "check_number": checkNum,
        "amount": int.tryParse(amount) ?? 0,
        "issue_date": _dateController.text,
        "status": widget.checkToEdit != null
            ? widget.checkToEdit!['status']
            : "pending",
        "type": _checkType,
        "company_name": name,
        "notes": _notesController.text.trim(), // إرسال الملاحظات للسيرفر
      };

      http.Response response;

      if (_isEditMode) {
        data["id"] = widget.checkToEdit!['id'];
        response = await http.patch(
          Uri.parse(ApiEndpoints.addCheck),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(data),
        );
      } else {
        response = await http.post(
          Uri.parse(ApiEndpoints.addCheck),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(data),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(
          _isEditMode ? "تم التحديث بنجاح" : "تم الحفظ بنجاح",
          color: Colors.green,
        );
        Future.delayed(
          const Duration(seconds: 1),
          () => Navigator.pop(context, true),
        );
      } else {
        var errorData = jsonDecode(response.body);
        _showSnackBar(
          "فشل العملية: ${errorData['message'] ?? 'خطأ في السيرفر'}",
        );
      }
    } catch (e) {
      _showSnackBar("حدث خطأ، تأكد من البيانات المدخلة");
    } finally {
      setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? "تعديل الشيك" : "إضافة شيك جديد",
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(
              _nameController,
              "اسم الشركة / العميل",
              Icons.business,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _checkNumberController,
              "رقم الشيك",
              Icons.numbers,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _bankController,
              "اسم البنك",
              Icons.account_balance,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              _amountController,
              "المبلغ (\$)",
              Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "تاريخ الاستحقاق",
                prefixIcon: const Icon(Icons.calendar_today, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _checkType,
              alignment: AlignmentDirectional.centerEnd,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: ["صادر", "وارد"]
                  .map(
                    (v) => DropdownMenuItem(
                      value: v,
                      child: Text(
                        v,
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _checkType = val!),
            ),
            const SizedBox(height: 15),
            // إضافة خانة الملاحظات هنا
            _buildTextField(_notesController, "ملاحظات إضافية", Icons.notes),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _isLoading ? null : _saveCheck,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isEditMode ? "تحديث الشيك" : "حفظ الشيك",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 22),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
