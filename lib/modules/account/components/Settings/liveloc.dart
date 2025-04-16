// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LiveLocationScreen extends StatefulWidget {
//   const LiveLocationScreen({super.key});

//   @override
//   State<LiveLocationScreen> createState() => _LiveLocationScreenState();
// }

// class _LiveLocationScreenState extends State<LiveLocationScreen> {
//   bool isLiveLocationEnabled = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0F1F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A0F1F),
//         title: const Text("Settings"),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "Live Location",
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//             Switch(
//               value: isLiveLocationEnabled,
//               activeColor: Colors.green,
//               onChanged: (value) {
//                 setState(() => isLiveLocationEnabled = value);
//                 if (value) _showLiveLocationBottomSheet();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showLiveLocationBottomSheet() {
//     Get.bottomSheet(
//       Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           color: Color(0xFF0A0F1F),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.blueAccent),
//                 const SizedBox(width: 8),
//                 const Text(
//                   "Live Location",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 GestureDetector(
//                   onTap: () => Get.back(),
//                   child: const Icon(Icons.close, color: Colors.white),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Allow Current Location?",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "We need your location to provide accurate tracking and better services.",
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Get.back();
//                       setState(() => isLiveLocationEnabled = false);
//                     },
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.red,
//                       side: const BorderSide(color: Colors.red),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text("Disable"),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Get.back();
//                       // Proceed with enabling logic
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text("Enable"),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
// }
