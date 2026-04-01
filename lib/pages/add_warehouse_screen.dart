import 'package:flutter/material.dart';

class AddWarehouseScreen extends StatefulWidget {
  const AddWarehouseScreen({super.key});

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  // الألوان المستخدمة لتطابق هوية التطبيق
  final Color activeBlue = const Color(0xFF4A80F0);

  // المتحكمات لاستقبال النصوص من الحقول
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
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
              const SizedBox(height: 20),

              _buildLabel("سعة التخزين"),
              _buildTextField(
                "القيمة بالطن أو الوحدات",
                _capacityController,
                isNumber: true,
              ),
              const SizedBox(height: 40),

              // زر الحفظ المعدل لإرسال البيانات للخلف
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      // التعديل هنا: إرسال البيانات كـ Map عند الرجوع
                      Navigator.pop(context, {
                        'name': _nameController.text,
                        'location': _locationController.text,
                        'capacity': _capacityController.text,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "تمت إضافة ${_nameController.text} بنجاح",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("يرجى إدخال اسم المستودع"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeBlue,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
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

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
