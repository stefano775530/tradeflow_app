// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'link.dart';
// import 'add_warehouse_screen.dart';
// import 'inventory_list_screen.dart';

// // تعريف كلاس المستودع
// class Warehouse {
//   final int? id;
//   String name;
//   String location;
//   int itemsCount;
//   int categoriesCount;

//   Warehouse({
//     this.id,
//     required this.name,
//     required this.location,
//     required this.itemsCount,
//     required this.categoriesCount,
//   });

//   factory Warehouse.fromJson(Map<String, dynamic> json) {
//     return Warehouse(
//       id: json['id'],
//       name: json['name'] ?? 'بدون اسم',
//       location: json['location'] ?? 'بدون عنوان',
//       itemsCount: 0,
//       categoriesCount: 0,
//     );
//   }
// }

// class WarehousesScreen extends StatefulWidget {
//   const WarehousesScreen({super.key});

//   @override
//   State<WarehousesScreen> createState() => _WarehousesScreenState();
// }

// class _WarehousesScreenState extends State<WarehousesScreen> {
//   final Color activeBlue = const Color(0xFF446BC0);
//   List<Warehouse> warehouses = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchWarehouses();
//   }

//   Future<void> _fetchWarehouses() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");

//     try {
//       final response = await http.get(
//         Uri.parse(ApiEndpoints.getWarehouses),
//         headers: {
//           "Authorization": "Bearer $token",
//           'ngrok-skip-browser-warning': 'true',
//         },
//       );

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         List<dynamic> data = (decoded is List)
//             ? decoded
//             : (decoded['data'] ?? []);
//         List<Warehouse> tempWarehouses = [];

//         for (var item in data) {
//           Warehouse w = Warehouse.fromJson(item);
//           try {
//             final prodResponse = await http.get(
//               Uri.parse(
//                 "${ApiEndpoints.getWarehouseProducts}?warehouse_id=${w.id}",
//               ),
//               headers: {"Authorization": "Bearer $token"},
//             );
//             if (prodResponse.statusCode == 200) {
//               final List products = jsonDecode(prodResponse.body);
//               w.itemsCount = products.fold(
//                 0,
//                 (sum, p) => sum + (p['quantity'] as num? ?? 0).toInt(),
//               );
//               w.categoriesCount = products.length;
//             }
//           } catch (_) {}
//           tempWarehouses.add(w);
//         }
//         if (mounted)
//           setState(() {
//             warehouses = tempWarehouses;
//             _isLoading = false;
//           });
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _deleteWarehouse(int? id, String name) async {
//     if (id == null) return;
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");

//     bool confirm =
//         await showDialog(
//           context: context,
//           builder: (context) => Directionality(
//             textDirection: TextDirection.rtl,
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               title: const Text(
//                 "تأكيد الحذف",
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               content: Text("هل أنت متأكد من حذف مستودع '$name'؟"),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, false),
//                   child: const Text("إلغاء"),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                   ),
//                   onPressed: () => Navigator.pop(context, true),
//                   child: const Text(
//                     "حذف",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ) ??
//         false;

//     if (confirm) {
//       await http.delete(
//         Uri.parse("${ApiEndpoints.getWarehouses}/$id"),
//         headers: {"Authorization": "Bearer $token"},
//       );
//       _fetchWarehouses();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: Column(
//         children: [
//           // الـ Header الأزرق
//           Container(
//             height: 115,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: activeBlue,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(1),
//                 bottomRight: Radius.circular(1),
//               ),
//             ),
//             child: const Center(
//               child: Text(
//                 "قسم المستودعات",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : RefreshIndicator(
//                     onRefresh: _fetchWarehouses,
//                     child: warehouses.isEmpty
//                         ? ListView(
//                             children: const [
//                               SizedBox(height: 100),
//                               Center(child: Text("لا توجد مستودعات")),
//                             ],
//                           )
//                         : ListView.builder(
//                             padding: const EdgeInsets.only(
//                               top: 20,
//                               left: 20,
//                               right: 20,
//                             ),
//                             itemCount: warehouses.length,
//                             itemBuilder: (context, index) =>
//                                 _buildWarehouseCard(warehouses[index]),
//                           ),
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildFloatingActionSection(),
//     );
//   }

//   Widget _buildWarehouseCard(Warehouse warehouse) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(24),
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => InventoryListScreen(warehouse: warehouse),
//           ),
//         ).then((_) => _fetchWarehouses()),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               IconButton(
//                 icon: const Icon(
//                   Icons.delete_outline_rounded,
//                   color: Colors.redAccent,
//                   size: 24,
//                 ),
//                 onPressed: () => _deleteWarehouse(warehouse.id, warehouse.name),
//               ),
//               const Spacer(),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     warehouse.name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17,
//                       fontFamily: 'Cairo',
//                     ),
//                   ),
//                   Text(
//                     warehouse.location,
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 13,
//                       fontFamily: 'Cairo',
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       _buildInfoBadge(
//                         "${warehouse.categoriesCount} صنف",
//                         Colors.blue.shade50,
//                         Colors.blue.shade800,
//                       ),
//                       const SizedBox(width: 8),
//                       _buildInfoBadge(
//                         "${warehouse.itemsCount} قطعة",
//                         Colors.green.shade50,
//                         Colors.green.shade800,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(width: 15),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: activeBlue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Icon(Icons.home_outlined, size: 28, color: activeBlue),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoBadge(String text, Color bgColor, Color textColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//           color: textColor,
//           fontFamily: 'Cairo',
//         ),
//       ),
//     );
//   }

//   Widget _buildFloatingActionSection() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         const Text(
//           "مستودع جديد",
//           style: TextStyle(
//             fontFamily: 'Cairo',
//             fontSize: 11,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         const SizedBox(height: 8),
//         FloatingActionButton(
//           heroTag: "fab_unique",
//           onPressed: () async {
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const AddWarehouseScreen(),
//               ),
//             );
//             if (result == true) _fetchWarehouses();
//           },
//           backgroundColor: activeBlue,
//           child: const Icon(Icons.add, color: Colors.white, size: 30),
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'link.dart';
import 'add_warehouse_screen.dart';
import 'inventory_list_screen.dart';

// تعريف كلاس المستودع
class Warehouse {
  final int? id;
  String name;
  String location;

  Warehouse({this.id, required this.name, required this.location});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json['id'],
      name: json['name'] ?? 'بدون اسم',
      location: json['location'] ?? 'بدون عنوان',
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

  Future<void> _fetchWarehouses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.getWarehouses),
        headers: {
          "Authorization": "Bearer $token",
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> data = (decoded is List)
            ? decoded
            : (decoded['data'] ?? []);

        setState(() {
          warehouses = data.map((item) => Warehouse.fromJson(item)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
              content: Text("هل أنت متأكد من حذف مستودع '$name'؟"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("إلغاء"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    "حذف",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ) ??
        false;

    if (confirm) {
      await http.delete(
        Uri.parse("${ApiEndpoints.getWarehouses}/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
      _fetchWarehouses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            height: 115,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF446BC0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(1),
                bottomRight: Radius.circular(1),
              ),
            ),
            child: const Center(
              child: Text(
                "قسم المستودعات",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
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
                        ? ListView(
                            children: const [
                              SizedBox(height: 100),
                              Center(child: Text("لا توجد مستودعات")),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 20,
                              right: 20,
                            ),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InventoryListScreen(warehouse: warehouse),
          ),
        ).then((_) => _fetchWarehouses()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 24,
                ),
                onPressed: () => _deleteWarehouse(warehouse.id, warehouse.name),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    warehouse.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    warehouse.location,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: activeBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.home_outlined, size: 28, color: activeBlue),
              ),
            ],
          ),
        ),
      ),
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
          heroTag: "fab_unique",
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddWarehouseScreen(),
              ),
            );
            if (result == true) _fetchWarehouses();
          },
          backgroundColor: activeBlue,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
