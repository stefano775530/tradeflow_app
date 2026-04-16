import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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

      var response = await Dio().get(
        ApiEndpoints.getPartners,
        options: Options(
          headers: {
            "Accept": "application/json",
            "ngrok-skip-browser-warning": "true",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        var rawData = response.data;
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

  // ✅ الدالة المحدثة التي تستدعي الروابط من link.dart
  // فقط عدّل هذا الجزء داخل _saveOrUpdatePartner()

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

      Response response;

      if (isEditing) {
        // ✅ تم تعديل PUT إلى POST
        response = await Dio().post(
          ApiEndpoints.updatePartner,
          queryParameters: {"id": currentPartnerId},
          data: data,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json",
            },
            validateStatus: (status) => status! < 500,
          ),
        );
      } else {
        response = await Dio().post(
          ApiEndpoints.addPartner,
          data: data,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json",
            },
            validateStatus: (status) => status! < 500,
          ),
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
        String msg =
            response.data['message'] ?? "فشلت العملية (${response.statusCode})";

        _showSnackBar(msg, Colors.red);
      }
    } catch (e) {
      _showSnackBar("حدث خطأ في الاتصال", Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deletePartner(int id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var response = await Dio().delete(
        ApiEndpoints.deletePartner,
        queryParameters: {"id": id},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        _showSnackBar("تم الحذف بنجاح", Colors.green);
        _refreshPartners();
      }
    } catch (e) {
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

  Widget _buildPartnerCard({
    required String name,
    required String phone,
    required String type,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: activeBlue.withOpacity(0.1),
            child: Icon(Icons.person, color: activeBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  phone,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: type == "مورد"
                  ? Colors.orange.shade50
                  : Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: type == "مورد" ? Colors.orange : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
