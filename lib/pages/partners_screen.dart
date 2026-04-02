import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  bool isAdding = false;
  bool isLoading = false;
  late Future<List<dynamic>> _partnersFuture;

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  final Color activeBlue = const Color(0xFF4A80F0);
  final Color textGrey = const Color(0xFF8E8E93);

  @override
  void initState() {
    super.initState();
    _refreshPartners();
  }

  // دالة لتحديث الحالة وجلب البيانات من جديد
  void _refreshPartners() {
    setState(() {
      _partnersFuture = _fetchPartnersFromApi();
    });
  }

  // جلب البيانات مع تجاوز حماية ngrok ومعالجة هيكلية الـ JSON
  Future<List<dynamic>> _fetchPartnersFromApi() async {
    try {
      const String url =
          "https://roger-unimplored-luella.ngrok-free.dev/api/partners";

      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "ngrok-skip-browser-warning": "true", // تجاوز صفحة التحذير
          },
        ),
      );

      if (response.statusCode == 200) {
        var rawData = response.data;
        // التأكد من استخراج القائمة سواء كانت مباشرة أو داخل مفتاح data
        if (rawData is List) {
          return rawData;
        } else if (rawData is Map && rawData.containsKey('data')) {
          return rawData['data'] as List;
        }
      }
      return [];
    } catch (e) {
      debugPrint("Error Fetching: $e");
      return [];
    }
  }

  // حفظ الشريك وتحديث القائمة فوراً
  Future<void> _savePartner() async {
    if (companyNameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء ملء البيانات الأساسية")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      const String url =
          "https://roger-unimplored-luella.ngrok-free.dev/api/partners/add";
      Map<String, dynamic> data = {
        "company_name": companyNameController.text,
        "partner_type": typeController.text.contains("مورد")
            ? "supplier"
            : "customer",
        "phone_number": phoneController.text,
      };

      var response = await Dio().post(
        url,
        data: data,
        options: Options(
          headers: {
            "Accept": "application/json",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تمت إضافة الشريك بنجاح")),
          );
        }

        // تنظيف الحقول
        companyNameController.clear();
        phoneController.clear();
        typeController.clear();

        // تحديث الواجهة وإعادة جلب البيانات فوراً
        setState(() {
          isAdding = false;
          _partnersFuture = _fetchPartnersFromApi();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("خطأ في الاتصال: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
          "الشركاء (موردين وزبائن)",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () => setState(() => isAdding = !isAdding),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: activeBlue,
                child: Icon(
                  isAdding ? Icons.close : Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
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
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            children: [
              if (isAdding) ...[
                _buildAddPartnerForm(),
                const SizedBox(height: 20),
              ],

              FutureBuilder<List<dynamic>>(
                future: _partnersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final partners = snapshot.data ?? [];

                  if (partners.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: partners.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final p = partners[index];
                      return _buildPartnerCard(
                        name: p['company_name'] ?? "بدون اسم",
                        phone: p['phone_number'] ?? "بدون رقم",
                        type: p['partner_type'] == 'supplier' ? "مورد" : "زبون",
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

  // --- مساعدات بناء الواجهة ---

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Icon(Icons.person_search, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text(
            "لا يوجد شركاء مضافين حالياً في السيرفر",
            style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPartnerForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: activeBlue.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Text(
            "إضافة شريك جديد",
            style: TextStyle(
              fontFamily: 'Cairo',
              color: activeBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          _buildTextField("اسم الشركة", companyNameController),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTextField("الوصف (مورد/زبون)", typeController),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTextField(
                  "رقم الهاتف",
                  phoneController,
                  isPhone: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _savePartner,
              style: ElevatedButton.styleFrom(
                backgroundColor: activeBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "تأكيد",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isPhone = false,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.business, color: Colors.blueGrey, size: 40),
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
                    fontSize: 15,
                  ),
                ),
                Text(
                  phone,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: textGrey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Chip(
            label: Text(
              type,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            backgroundColor: type == "مورد" ? activeBlue : Colors.green,
          ),
        ],
      ),
    );
  }
}
