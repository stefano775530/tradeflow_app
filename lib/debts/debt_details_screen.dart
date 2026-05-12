// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tradeflow_app/pages/link.dart';

// class DebtDetailsScreen extends StatefulWidget {
//   final String partnerId;
//   final String partnerName;

//   const DebtDetailsScreen({
//     super.key,
//     required this.partnerId,
//     required this.partnerName,
//   });

//   @override
//   State<DebtDetailsScreen> createState() => _DebtDetailsScreenState();
// }

// class _DebtDetailsScreenState extends State<DebtDetailsScreen> {
//   final Color primaryBlue = const Color(0xFF3D5EAB);
//   List<dynamic> _transactions = [];
//   Map<String, dynamic>? _partnerInfo;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDetails();
//   }

//   Future<void> _fetchDetails() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("token");

//     try {
//       // استدعاء الرابط الخاص بالبارتنر لجلب ديونه وعملياته
//       final response = await http.get(
//         Uri.parse("${ApiEndpoints.getDebts}/${widget.partnerId}"),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//           'ngrok-skip-browser-warning': 'true',
//         },
//       );

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         setState(() {
//           _partnerInfo = decoded['data'];
//           _transactions = decoded['data']['transactions'] ?? [];
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: primaryBlue,
//         title: Text(
//           widget.partnerName,
//           style: const TextStyle(fontFamily: 'Cairo', color: Colors.white),
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // عرض الرصيد الإجمالي في الأعلى
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   margin: const EdgeInsets.all(15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "الرصيد المتبقي:",
//                         style: TextStyle(
//                           fontFamily: 'Cairo',
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         "₪ ${_partnerInfo?['balance'] ?? '0'}",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: primaryBlue,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 const Text(
//                   "سجل العمليات",
//                   style: TextStyle(
//                     fontFamily: 'Cairo',
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _transactions.length,
//                     itemBuilder: (context, index) {
//                       final tx = _transactions[index];
//                       return ListTile(
//                         leading: Icon(Icons.history, color: primaryBlue),
//                         title: Text(tx['type'] ?? "عملية"),
//                         subtitle: Text(tx['date'] ?? ""),
//                         trailing: Text(
//                           "₪ ${tx['amount']}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
