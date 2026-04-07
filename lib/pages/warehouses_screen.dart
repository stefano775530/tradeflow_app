import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'link.dart';
import 'add_warehouse_screen.dart';
import 'inventory_list_screen.dart';

class Warehouse {
  final int? id;
  final String name;
  final String location;
  final int itemsCount;
  final int categoriesCount;

  Warehouse({
    this.id,
    required this.name,
    required this.location,
    required this.itemsCount,
    required this.categoriesCount,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'],
      name: json['name'] ?? 'بدون اسم',
      location: json['location'] ?? 'بدون عنوان',
      itemsCount: json['items_count'] ?? 0,
      categoriesCount: json['categories_count'] ?? 0,
    );
  }
}

class WarehousesScreen extends StatefulWidget {
  const WarehousesScreen({super.key});

  @override
  State<WarehousesScreen> createState() => _WarehousesScreenState();
}

class _WarehousesScreenState extends State<WarehousesScreen> {
  final Color activeBlue = const Color(0xFF446BC0);
  List<Warehouse> warehouses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWarehouses();
  }

  Future<void> _deleteWarehouse(int? id, String name) async {
    if (id == null) return;

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
                "تأكيد الحذف",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "هل أنت متأكد من حذف مستودع '$name'؟ لا يمكن التراجع عن هذه العملية.",
                style: const TextStyle(fontFamily: 'Cairo'),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
          Uri.parse("${ApiEndpoints.getWarehouses}/$id"),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        );

        if (response.statusCode == 200 || response.statusCode == 204) {
          _fetchWarehouses();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "تم حذف مستودع $name بنجاح",
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          throw Exception("فشل الحذف من السيرفر");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "حدث خطأ أثناء محاولة الحذف",
              style: TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchWarehouses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getWarehouses),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<Warehouse> tempWarehouses = [];

        if (decoded is List) {
          tempWarehouses = decoded
              .map((json) => Warehouse.fromJson(json))
              .toList();
        } else if (decoded is Map<String, dynamic> && decoded['data'] != null) {
          tempWarehouses = (decoded['data'] as List)
              .map((json) => Warehouse.fromJson(json))
              .toList();
        }

        if (mounted) {
          setState(() {
            warehouses = tempWarehouses;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 60, 20, 25),
            child: Center(
              child: Text(
                "قسم المستودعات",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchWarehouses,
                    child: warehouses.isEmpty
                        ? const Center(
                            child: Text(
                              "لا توجد مستودعات مضافة",
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: warehouses.length,
                            itemBuilder: (context, index) =>
                                _buildWarehouseCard(warehouses[index]),
                          ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionSection(),
    );
  }

  Widget _buildWarehouseCard(Warehouse warehouse) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InventoryListScreen(warehouse: warehouse),
              ),
            );
          },
          onLongPress: () => _deleteWarehouse(warehouse.id, warehouse.name),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // أيقونة الحذف اختيارية هنا، قمت بإبقائها صغيرة ومرتبة
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  onPressed: () =>
                      _deleteWarehouse(warehouse.id, warehouse.name),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      warehouse.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Text(
                      warehouse.location,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          " | الاصناف: ${warehouse.categoriesCount} صنف",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "البضائع: ${warehouse.itemsCount} قطعة",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 15),
                _buildWarehouseIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWarehouseIcon() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.home_outlined, size: 34, color: Colors.black),
    );
  }

  Widget _buildFloatingActionSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "مستودع جديد",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        FloatingActionButton(
          // هذا السطر هو الحل لمشكلة الـ Hero Tag
          heroTag: "main_warehouse_fab_unique",
          onPressed: _navigateToAddScreen,
          backgroundColor: activeBlue,
          child: const Icon(Icons.add, color: Colors.white, size: 36),
        ),
      ],
    );
  }

  void _navigateToAddScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWarehouseScreen()),
    );
    if (result == true) {
      _fetchWarehouses();
    }
  }
}
