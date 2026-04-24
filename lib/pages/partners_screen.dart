import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradeflow_app/pages/link.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  bool isAdding = false;
  bool isLoading = false;
  bool isEditing = false;
  int? currentPartnerId;
  late Future<List<dynamic>> _partnersFuture;

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedType = "customer";

  // الألوان والخطوط المعتمدة في مشروعك
  final Color activeBlue = const Color(0xFF446BC0);
  final Color textGrey = const Color(0xFF8E8E93);

  @override
  void initState() {
    super.initState();
    _refreshPartners();
  }

  void _refreshPartners() {
    setState(() {
      _partnersFuture = _fetchPartnersFromApi();
    });
  }

  Future<List<dynamic>> _fetchPartnersFromApi() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var response = await http.get(
        Uri.parse("${ApiEndpoints.getPartners}"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var rawData = jsonDecode(response.body);
        if (rawData is List) return rawData;
        if (rawData is Map && rawData.containsKey('data'))
          return rawData['data'] as List;
        return rawData['partners'] as List;
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching: $e");
      return [];
    }
  }

  Future<void> _saveOrUpdatePartner() async {
    if (companyNameController.text.isEmpty || phoneController.text.isEmpty) {
      _showSnackBar("الرجاء ملء البيانات", Colors.orange);
      return;
    }

    setState(() => isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      Map<String, dynamic> data = {
        "company_name": companyNameController.text,
        "partner_type": selectedType,
        "phone_number": phoneController.text,
      };

      var response;

      if (isEditing) {
        response = await http.patch(
          Uri.parse("${ApiEndpoints.baseUrl}/partners/${currentPartnerId!}"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );
      } else {
        response = await http.post(
          Uri.parse("${ApiEndpoints.addPartner}"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: jsonEncode(data),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _resetForm();
        _refreshPartners();

        _showSnackBar(
          isEditing ? "تم التعديل بنجاح ✓" : "تمت الإضافة بنجاح ✓",
          Colors.green,
        );
      } else {
        String msg;
        try {
          final resBody = jsonDecode(response.body);
          msg = resBody['message'] ?? "فشلت العملية (${response.statusCode})";
        } catch (e) {
          msg = "فشلت العملية (${response.statusCode})";
        }

        _showSnackBar(msg, Colors.red);
      }
    } catch (e) {
      debugPrint("Error saving/updating: $e");
      _showSnackBar("حدث خطأ في الاتصال", Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deletePartner(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var response = await http.delete(
        Uri.parse("${ApiEndpoints.baseUrl}/partners/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar("تم الحذف بنجاح", Colors.green);
        _refreshPartners();
      }
    } catch (e) {
      debugPrint("Error deleting partner: $e");
      _showSnackBar("خطأ في الحذف", Colors.red);
    }
  }

  void _prepareEdit(Map<String, dynamic> partner) {
    setState(() {
      isEditing = true;
      isAdding = true;
      currentPartnerId = partner['id'];
      companyNameController.text = partner['company_name'] ?? "";
      phoneController.text = partner['phone_number'] ?? "";
      selectedType = partner['partner_type'] ?? "customer";
    });
  }

  void _resetForm() {
    setState(() {
      isAdding = false;
      isEditing = false;
      currentPartnerId = null;
      companyNameController.clear();
      phoneController.clear();
      selectedType = "customer";
    });
  }

  void _showOptions(Map<String, dynamic> partner) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text(
                  "تعديل البيانات",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _prepareEdit(partner);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  "حذف الشريك",
                  style: TextStyle(fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deletePartner(partner['id']);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "الشركاء (موردين وزبائن)",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                isAdding ? _resetForm() : setState(() => isAdding = true),
            icon: CircleAvatar(
              backgroundColor: activeBlue,
              child: Icon(
                isAdding ? Icons.close : Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: RefreshIndicator(
          onRefresh: () async => _refreshPartners(),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              if (isAdding) _buildForm(),
              const SizedBox(height: 10),
              FutureBuilder<List<dynamic>>(
                future: _partnersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final partners = snapshot.data ?? [];
                  if (partners.isEmpty) return _buildEmptyState();

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: partners.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = partners[index];
                      return GestureDetector(
                        onTap: () => _showOptions(p),
                        child: _buildPartnerCard(
                          name: p['company_name'] ?? "بدون اسم",
                          phone: p['phone_number'] ?? "بدون رقم",
                          type: p['partner_type'] == 'supplier'
                              ? "مورد"
                              : "زبون",
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: activeBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildTextField("اسم الشركة", companyNameController, Icons.business),
          const SizedBox(height: 12),
          _buildTextField(
            "رقم الهاتف",
            phoneController,
            Icons.phone,
            isPhone: true,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Text("النوع:", style: TextStyle(fontFamily: 'Cairo')),
              const SizedBox(width: 15),
              _typeOption("زبون", "customer"),
              _typeOption("مورد", "supplier"),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isLoading ? null : _saveOrUpdatePartner,
              style: ElevatedButton.styleFrom(
                backgroundColor: activeBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isEditing ? "حفظ التعديلات" : "تأكيد وحفظ",
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeOption(String label, String value) {
    bool isSelected = selectedType == value;
    return GestureDetector(
      onTap: () => setState(() => selectedType = value),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isPhone = false,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: activeBlue),
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "لا يوجد بيانات",
        style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
      ),
    );
  }

  // ✅ تم تكبير العناصر هنا في هذه الدالة
  Widget _buildPartnerCard({
    required String name,
    required String phone,
    required String type,
  }) {
    return Container(
      padding: const EdgeInsets.all(16), // زيادة المساحة الداخلية
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26, // تكبير دائرة الأيقونة
            backgroundColor: activeBlue.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: activeBlue,
              size: 28,
            ), // تكبير الأيقونة
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // تكبير حجم الخط للاسم
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: textGrey,
                    fontSize: 15, // تكبير حجم الخط للرقم
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ), // تكبير مساحة التاغ
            decoration: BoxDecoration(
              color: type == "مورد"
                  ? Colors.orange.shade50
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14, // تكبير خط كلمة مورد/زبون
                fontWeight: FontWeight.bold,
                color: type == "مورد"
                    ? Colors.orange.shade800
                    : Colors.green.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
