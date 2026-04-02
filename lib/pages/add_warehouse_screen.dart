import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'link.dart'; // تأكد أن ملف link.dart موجود بجانب هذا الملف في مجلد lib

class AddWarehouseScreen extends StatefulWidget {
  const AddWarehouseScreen({super.key});

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  final Color activeBlue = const Color(0xFF4A80F0);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isLoading = false;

  Future<void> _saveWarehouse() async {
    final String name = _nameController.text.trim();
    final String location = _locationController.text.trim();

    if (name.isEmpty) {
      _showSnackBar("يرجى إدخال اسم المستودع", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(ApiEndpoints.addWarehouse);

      // التوكن الذي أرسلته لي
      const String myToken =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InNpc2lAc2lzaS5jb20iLCJ1c2VySWQiOjEsImlhdCI6MTc3NTEyOTM5NiwiZXhwIjoxNzc1MTMyOTk2fQ.6xAAPFo7sFR50p1QxP_UFtx9_FVnrhRlMbwC2W-5zNQ";

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // السطر الخاص بـ ngrok
          'ngrok-skip-browser-warning': 'true',
          // السطر الخاص بالتوكن لحل مشكلة 401
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode({'name': name, 'location': location}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar("تمت إضافة $name بنجاح", Colors.green);
        if (mounted) Navigator.pop(context, true);
      } else {
        _showSnackBar("فشل في الحفظ: ${response.statusCode}", Colors.red);
        // لطباعة الخطأ بالتفصيل في الـ Debug Console إذا فشل الطلب
        print("Response Error Body: ${response.body}");
      }
    } catch (e) {
      _showSnackBar("حدث خطأ في الاتصال بالسيرفر", Colors.red);
      print("Error details: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "إضافة مستودع جديد",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("اسم المستودع"),
              _buildTextField("مثال: مستودع المنطقة الوسطى", _nameController),
              const SizedBox(height: 20),
              _buildLabel("الموقع / العنوان"),
              _buildTextField(
                "أدخل موقع المستودع بالتفصيل",
                _locationController,
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveWarehouse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeBlue,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "حفظ المستودع",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
