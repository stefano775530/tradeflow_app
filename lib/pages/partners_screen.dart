import 'package:flutter/material.dart';

class PartnersScreen extends StatefulWidget {
  const PartnersScreen({super.key});

  @override
  State<PartnersScreen> createState() => _PartnersScreenState();
}

class _PartnersScreenState extends State<PartnersScreen> {
  bool isAdding = false;
  final Color activeBlue = const Color(0xFF4A80F0);
  final Color textGrey = const Color(0xFF8E8E93);

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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          children: [
            if (isAdding) ...[
              _buildAddPartnerForm(),
              const SizedBox(height: 20),
            ],
            _buildPartnerCard(
              name: "شركة المنار لمواد العزل",
              phone: "0592224456",
              type: "مورد",
              imageUrl: "https://via.placeholder.com/150",
            ),
            const SizedBox(height: 12),
            _buildPartnerCard(
              name: "شركة عمر ورشدي العالول",
              phone: "0592224456",
              type: "زبون",
              imageUrl: "https://via.placeholder.com/150",
            ),
            const SizedBox(height: 12),
            _buildPartnerCard(
              name: "شركة الاحسان للاستيراد والتصدير",
              phone: "0592224456",
              type: "زبون",
              imageUrl: "https://via.placeholder.com/150",
            ),
            const SizedBox(height: 12),
            _buildPartnerCard(
              name: "شركة الحمد للاخشاب الحديثة",
              phone: "0592224456",
              type: "مورد",
              imageUrl: "https://via.placeholder.com/150",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPartnerForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: activeBlue.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: activeBlue.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "إضافة عميل جديد",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: activeBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildTextField("اسم الشركة التي يتبع إليها العميل"),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTextField("الوصف (زبون/مورد)")),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField("رقم الهاتف")),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "تأكيد",
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => isAdding = false),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: activeBlue.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "إلغاء",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          color: Colors.grey.shade400,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildPartnerCard({
    required String name,
    required String phone,
    required String type,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                color: Colors.grey.shade100,
                child: Icon(Icons.person, color: Colors.grey.shade400),
              ),
            ),
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
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: type == "مورد"
                  ? activeBlue.withValues(alpha: 0.1)
                  : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: type == "مورد" ? activeBlue : Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
