import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'link.dart';
import 'warehouses_screen.dart';

// موديل المنتج المعدل ليتوافق مع تسميات السيرفر (quantity بدلاً من plates_count)
class Product {
  final String id;
  String name;
  int quantity; // تم التغيير هنا لتطابق السيرفر
  double purchasePrice;
  double salePrice;
  double thickness;
  double height;
  double width;
  String status;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.salePrice,
    required this.thickness,
    required this.height,
    required this.width,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      // السيرفر يرجعها باسم quantity أو plates_count؟
      // بناءً على خطأ الإضافة، السيرفر يتوقع quantity، لذا سنقرأها منه
      quantity: json['quantity'] ?? json['plates_count'] ?? 0,
      purchasePrice: double.tryParse(json['purchase_price'].toString()) ?? 0.0,
      salePrice: double.tryParse(json['sale_price'].toString()) ?? 0.0,
      thickness: double.tryParse(json['thickness'].toString()) ?? 0.0,
      height: double.tryParse(json['height'].toString()) ?? 0.0,
      width: double.tryParse(json['width'].toString()) ?? 0.0,
      status: json['status'] ?? 'ok',
    );
  }
}

class InventoryListScreen extends StatefulWidget {
  final Warehouse warehouse;
  const InventoryListScreen({super.key, required this.warehouse});

  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  final Color bgLight = const Color(0xFFF8F9FA);
  final Color cardWhite = Colors.white;
  final Color activeBlue = const Color(0xFF446BC0);

  bool _isAddSectionVisible = false;
  bool _isEditMode = false;
  bool _isLoading = false;
  String? _selectedProductId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _platesController = TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _thicknessController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse(
          "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/${widget.warehouse.id}/storage",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          products = data.map((item) => Product.fromJson(item)).toList();
        });
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteWarehouse() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "حذف المستودع",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "هل أنت متأكد من حذف '${widget.warehouse.name}' نهائياً؟",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    "إلغاء",
                    style: TextStyle(color: Colors.grey, fontFamily: 'Cairo'),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    "حذف الآن",
                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                  ),
                ),
              ],
            ),
          ),
        ) ??
        false;

    if (confirm) {
      try {
        final response = await http.delete(
          Uri.parse("${ApiEndpoints.getWarehouses}/${widget.warehouse.id}"),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> _confirmAction() async {
    if (_nameController.text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    // التعديل الجوهري هنا: إرسال quantity بدلاً من plates_count
    final Map<String, dynamic> data = {
      "name": _nameController.text,
      "quantity":
          int.tryParse(_platesController.text) ?? 0, // تم التغيير لـ quantity
      "purchase_price": double.tryParse(_purchasePriceController.text) ?? 0.0,
      "sale_price": double.tryParse(_salePriceController.text) ?? 0.0,
      "thickness": double.tryParse(_thicknessController.text) ?? 0.0,
      "height": _heightController.text,
      "width": _widthController.text,
      "status": "ok",
    };

    try {
      String baseUrl =
          "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/${widget.warehouse.id}/storage";
      http.Response response;

      if (_isEditMode && _selectedProductId != null) {
        response = await http.put(
          Uri.parse("$baseUrl/$_selectedProductId"),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(data),
        );
      } else {
        response = await http.post(
          Uri.parse(baseUrl),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(data),
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _resetForm();
        _fetchProducts();
      } else {
        // سيطبع لك السيرفر الآن إذا كان هناك حقول أخرى ناقصة
        debugPrint("Server Error: ${response.body}");
      }
    } catch (e) {
      debugPrint("Connection Error: $e");
    }
  }

  Future<void> _deleteProduct(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.delete(
        Uri.parse(
          "https://roger-unimplored-luella.ngrok-free.dev/api/warehouse/${widget.warehouse.id}/storage/$productId",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        _fetchProducts();
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }

  void _resetForm() {
    setState(() {
      _isAddSectionVisible = false;
      _isEditMode = false;
      _selectedProductId = null;
      _nameController.clear();
      _platesController.clear();
      _purchasePriceController.clear();
      _salePriceController.clear();
      _thicknessController.clear();
      _heightController.clear();
      _widthController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: cardWhite,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "تفاصيل المستودع",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_forever_rounded,
              color: Colors.redAccent,
              size: 26,
            ),
            onPressed: _deleteWarehouse,
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _buildHeaderCard(),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildAddForm(),
              crossFadeState: _isAddSectionVisible
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "الأصناف المتاحة بالمخزن",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : products.isEmpty
                  ? const Center(
                      child: Text(
                        "لا توجد أصناف حالياً",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      itemBuilder: (context, index) =>
                          _buildProductItem(products[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: activeBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: activeBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(
                  () => _isAddSectionVisible = !_isAddSectionVisible,
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isAddSectionVisible ? Icons.close : Icons.add,
                    color: activeBlue,
                    size: 28,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.warehouse.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    widget.warehouse.location,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.inventory_2_rounded,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem("${products.length}", "الأصناف"),
                Container(width: 1.5, height: 30, color: Colors.grey[200]),
                _buildStatItem(
                  "${products.fold(0, (sum, item) => sum + item.quantity)}",
                  "إجمالي الألواح",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildAddForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: activeBlue.withOpacity(0.1), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          Text(
            _isEditMode ? "تعديل بيانات الصنف" : "إضافة صنف جديد",
            style: TextStyle(
              color: activeBlue,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          _buildInput("اسم المنتج", _nameController),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInput(
                  "عدد الألواح",
                  _platesController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInput(
                  "سعر الشراء",
                  _purchasePriceController,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInput(
                  "سعر البيع",
                  _salePriceController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInput(
                  "السماكة (مم)",
                  _thicknessController,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInput(
                  "الارتفاع (سم)",
                  _heightController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInput(
                  "العرض (سم)",
                  _widthController,
                  isNumber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _confirmAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "حفظ البيانات",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _resetForm,
                child: const Text(
                  "إلغاء",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
    String hint,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontFamily: 'Cairo',
        ),
        filled: true,
        fillColor: bgLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildProductItem(Product p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => _showOptions(p),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${p.quantity}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              const Text(
                "لوح",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          p.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 15,
            fontFamily: 'Cairo',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "شراء: ${p.purchasePrice} | بيع: ${p.salePrice}\nالمقاس: ${p.thickness}x${p.height}x${p.width}",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: Icon(Icons.more_vert, color: Colors.grey[400]),
      ),
    );
  }

  void _showOptions(Product p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "خيارات المنتج",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                Icons.edit_note_rounded,
                "تعديل البيانات",
                Colors.blue,
                () {
                  Navigator.pop(context);
                  setState(() {
                    _isAddSectionVisible = true;
                    _isEditMode = true;
                    _selectedProductId = p.id;
                    _nameController.text = p.name;
                    _platesController.text = p.quantity.toString();
                    _purchasePriceController.text = p.purchasePrice.toString();
                    _salePriceController.text = p.salePrice.toString();
                    _thicknessController.text = p.thickness.toString();
                    _heightController.text = p.height.toString();
                    _widthController.text = p.width.toString();
                  });
                },
              ),
              _buildOptionTile(
                Icons.delete_sweep_rounded,
                "حذف من المخزن",
                Colors.redAccent,
                () {
                  Navigator.pop(context);
                  _deleteProduct(p.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 15,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
