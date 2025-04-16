// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'dispute.dart';

// class DisputeScreen2 extends StatelessWidget {
//   const DisputeScreen2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController issueController = TextEditingController();

//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.kDarkBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kWhite),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Dispute',
//           style: TextStyle(
//               color: AppColors.kWhite,
//               fontSize: 18,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Details",
//                     style: TextStyle(
//                         color: AppColors.kWhite,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () => Get.off(() => const DisputeScreen()),
//                   child: _buildInputStyle(
//                       icon: Icons.warning_amber_rounded,
//                       text: "Earning Related"),
//                 ),
//                 const Divider(color: AppColors.kinput),
//                 const SizedBox(height: 16),
//                 _buildInputStyle(icon: Icons.work_outline, text: "Select Job"),
//                 const Divider(color: AppColors.kinput),
//                 const SizedBox(height: 16),
//                 _buildInputStyle(
//                     icon: Icons.calendar_today_outlined,
//                     text: "Date of Incident"),
//                 const Divider(color: AppColors.kinput),
//                 const SizedBox(height: 16),
//                 _buildTextField(
//                     icon: Icons.edit_outlined,
//                     controller: issueController,
//                     hint: "Please describe your issue in detail."),
//                 const Divider(color: AppColors.kinput),
//                 const SizedBox(height: 24),
//                 const Text("Transaction Information",
//                     style: TextStyle(
//                         color: AppColors.kWhite,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 16),
//                 _buildInputStyle(
//                     icon: Icons.numbers, text: "Enter transaction ID"),
//                 const Divider(color: AppColors.kinput),
//                 const SizedBox(height: 16),
//                 _buildInputStyle(
//                     icon: Icons.calendar_month, text: "Transaction Date"),
//                 const Divider(color: AppColors.kinput),
//                 const SizedBox(height: 16),
//                 _buildInputStyle(
//                     icon: Icons.attach_money, text: "Dispute Amount"),
//                 const Divider(color: AppColors.kinput),
//                 const SizedBox(height: 24),
//                 const Text("Supporting Documents",
//                     style: TextStyle(
//                         color: AppColors.kWhite,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),
//                 _buildDocAttachBox(),
//               ],
//             ),
//           ),
//           _buildBottomButtons(),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputStyle({required IconData icon, required String text}) {
//     return Row(
//       children: [
//         Icon(icon, color: AppColors.kSkyBlue, size: 20),
//         const SizedBox(width: 12),
//         Expanded(
//             child: Text(text,
//                 style: const TextStyle(color: AppColors.kinput, fontSize: 13))),
//         const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.kinput),
//       ],
//     );
//   }

//   Widget _buildTextField(
//       {required IconData icon,
//       required TextEditingController controller,
//       required String hint}) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 14),
//           child: Icon(icon, color: AppColors.kSkyBlue, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: TextField(
//             controller: controller,
//             maxLines: null,
//             style: const TextStyle(color: AppColors.kWhite, fontSize: 13),
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: const TextStyle(color: AppColors.kinput, fontSize: 13),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(vertical: 14),
//               isDense: true,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDocAttachBox() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         children: [
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Attach Doc",
//                     style: TextStyle(
//                         color: AppColors.kWhite, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 4),
//                 Text("Min 10MB. Upload only PDF, DOC, DOCX, JPG, PNG",
//                     style: TextStyle(color: AppColors.kinput, fontSize: 10)),
//               ],
//             ),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: const Text("Browse",
//                 style: TextStyle(color: AppColors.kSkyBlue)),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomButtons() {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         color: AppColors.kDarkestBlue,
//         child: Row(
//           children: [
//             Expanded(
//               flex: 3,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   side: const BorderSide(color: AppColors.kSkyBlue),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: () => Get.back(),
//                 child: const Text('Save as Draft',
//                     style: TextStyle(color: AppColors.kSkyBlue)),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 7,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kSkyBlue,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8)),
//                 ),
//                 onPressed: () {},
//                 child: const Text('Submit Dispute',
//                     style: TextStyle(color: AppColors.kDarkBlue)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
