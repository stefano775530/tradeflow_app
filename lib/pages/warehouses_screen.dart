// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart'; // تأكد من إضافة dio في pubspec.yaml
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/link.dart';
// import 'add_warehouse_screen.dart';

// // --- نموذج البيانات (Model) المعدل ليدعم JSON ---
// class Warehouse {
//   final String name;
//   final String location;
//   final int itemsCount;
//   final int categoriesCount;

//   Warehouse({
//     required this.name,
//     required this.location,
//     required this.itemsCount,
//     required this.categoriesCount,
//   });

//   // تحويل البيانات القادمة من Map (JSON) إلى Object
//   factory Warehouse.fromJson(Map<String, dynamic> json) {
//     return Warehouse(
//       name: json['name'] ?? 'بدون اسم',
//       location: json['location'] ?? 'بدون عنوان',
//       itemsCount: json['items_count'] ?? 0,
//       categoriesCount: json['categories_count'] ?? 0,
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
//   final Dio _dio = Dio();

//   List<Warehouse> warehouses = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchWarehouses(); // جلب البيانات عند تشغيل الصفحة
//   }

//   // --- دالة جلب البيانات من الباك إند ---
//   Future<void> _fetchWarehouses() async {
//     setState(() => _isLoading = true);
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");

//     try {
//       final response = await http.get(
//         Uri.parse(
//           ApiEndpoints.getWarehouses, // تأكد أن هذا الرابط موجود في link.dart
//         ),
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",

//           // 👇 إذا عندك توكن
//           'ngrok-skip-browser-warning': 'true',
//           // السطر الخاص بالتوكن لحل مشكلة 401
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         setState(() {
//           warehouses = [Warehouse.fromJson(data)];
//           _isLoading = false;
//         });
//       } else {
//         print("Error: ${response.statusCode}");
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       print("Error fetching warehouses: $e");
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // --- الهيدر العلوي ---
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
//             child: Center(
//               child: const Text(
//                 "قسم المستودعات",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Cairo',
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),

//           // --- عرض البيانات أو مؤشر التحميل ---
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator()) // مؤشر تحميل
//                 : RefreshIndicator(
//                     onRefresh: _fetchWarehouses, // تحديث عند السحب لأسفل
//                     child: warehouses.isEmpty
//                         ? const Center(child: Text("لا توجد مستودعات مضافة"))
//                         : ListView.builder(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
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

//   // --- بناء بطاقة المستودع (يبقى كما هو) ---
//   Widget _buildWarehouseCard(Warehouse warehouse) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 15,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           children: [
//             Icon(
//               Icons.arrow_back_ios_new,
//               size: 20,
//               color: Colors.black.withOpacity(0.5),
//             ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   warehouse.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w800,
//                     fontSize: 17,
//                     fontFamily: 'Cairo',
//                   ),
//                 ),
//                 Text(
//                   warehouse.location,
//                   style: TextStyle(
//                     color: Colors.grey[700],
//                     fontSize: 14,
//                     fontFamily: 'Cairo',
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Text(
//                       " | الاصناف: ${warehouse.categoriesCount} صنف",
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Cairo',
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       "البضائع: ${warehouse.itemsCount} قطعة",
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Cairo',
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(width: 20),
//             _buildWarehouseIcon(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWarehouseIcon() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black, width: 2.0),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: const Icon(Icons.home_outlined, size: 34, color: Colors.black),
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
//           onPressed: () => _navigateToAddScreen(),
//           backgroundColor: activeBlue,
//           child: const Icon(Icons.add, color: Colors.white, size: 36),
//         ),
//       ],
//     );
//   }

//   // --- التنقل وتحديث البيانات ---
//   void _navigateToAddScreen() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const AddWarehouseScreen()),
//     );

//     // إذا رجعت من صفحة الإضافة بنجاح (result == true)
//     if (result == true) {
//       _fetchWarehouses(); // أعد جلب القائمة المحدثة من الباك إند فوراً
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'link.dart'; // تأكد أن رابط الـ API موجود هنا
import 'add_warehouse_screen.dart';

class Warehouse {
  final String name;
  final String location;
  final int itemsCount;
  final int categoriesCount;

  Warehouse({
    required this.name,
    required this.location,
    required this.itemsCount,
    required this.categoriesCount,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
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
    _fetchWarehouses(); // استدعاء البيانات عند فتح الصفحة
  }

  Future<void> _fetchWarehouses() async {
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

        // 🔹 تحقق من نوع الداتا من الباك
        if (decoded is List) {
          tempWarehouses = decoded
              .map((json) => Warehouse.fromJson(json))
              .toList();
        } else if (decoded is Map<String, dynamic> && decoded['data'] != null) {
          tempWarehouses = (decoded['data'] as List)
              .map((json) => Warehouse.fromJson(json))
              .toList();
        } else if (decoded is Map<String, dynamic>) {
          tempWarehouses = [Warehouse.fromJson(decoded)];
        }

        setState(() {
          warehouses = tempWarehouses;
          _isLoading = false;
        });
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching warehouses: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- الهيدر العلوي ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
            child: Center(
              child: const Text(
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

          // --- عرض البيانات أو مؤشر التحميل ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchWarehouses,
                    child: warehouses.isEmpty
                        ? const Center(child: Text("لا توجد مستودعات مضافة"))
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.black.withOpacity(0.5),
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
            const SizedBox(width: 20),
            _buildWarehouseIcon(),
          ],
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
      _fetchWarehouses(); // تحديث القائمة بعد الإضافة
    }
  }
}
