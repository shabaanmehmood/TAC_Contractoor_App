// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/data/data/constants/app_assets.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
// import 'package:taccontractor/data/data/constants/app_spacing.dart';
// import 'package:taccontractor/data/data/constants/app_typography.dart';
// import 'package:taccontractor/modules/contractor_messages_screen/chat_Screen.dart';
//
// class ContractorMessagesScreen extends StatefulWidget {
//   const ContractorMessagesScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ContractorMessagesScreen> createState() => _ContractorMessagesScreenState();
// }
//
// class _ContractorMessagesScreenState extends State<ContractorMessagesScreen> {
//   final List<String> filters = ["All", "Unread", "Blocked", "Favorites"];
//   int selectedFilter = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: Padding(
//         padding: EdgeInsets.only(
//           right: Get.height * 0.02,
//           top: Get.height * 0.06,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Top Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Image.asset(
//                       AppAssets.kTacLogo,
//                       height: Get.height * 0.05,
//                       width: Get.width * 0.2,
//                       fit: BoxFit.contain,
//                     ),
//                     Text(
//                       "Messages",
//                       style: AppTypography.kBold24.copyWith(color: AppColors.kWhite),
//                     ),
//                   ],
//                 ),
//                 Image.asset("assets/icon/plus.png", scale: Get.width * 0.003, color: AppColors.kSkyBlue),
//               ],
//             ),
//
//             /// Search Bar
//             Container(
//               margin: EdgeInsets.only(
//                   left: Get.width * 0.04,
//                   top: Get.width * 0.04,
//                   bottom: Get.width * 0.04),
//               child: TextFormField(
//                 style: const TextStyle(color: AppColors.kgrey),
//                 decoration: InputDecoration(
//                   fillColor: AppColors.kDarkBlue,
//                   filled: true,
//                   hintText: "Search for security jobs...",
//                   suffixIcon: Image.asset("assets/icon/search.png", scale: Get.width * 0.004),
//                   hintStyle: TextStyle(color: AppColors.kgrey, fontSize: 16),
//                   contentPadding: EdgeInsets.symmetric(
//                     vertical: Get.width * 0.03,
//                     horizontal: Get.width * 0.04,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(Get.width * 0.04),
//                     borderSide: const BorderSide(width: 0.8, color: AppColors.kgrey),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(Get.width * 0.09),
//                     borderSide: const BorderSide(width: 0.04, color: AppColors.kgrey),
//                   ),
//                 ),
//               ),
//             ),
//
//             /// Scrollable Filter Tabs
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Padding(
//                 padding: EdgeInsets.only(left: Get.width * 0.03),
//                 child: Row(
//                   children: List.generate(filters.length, (index) {
//                     final isSelected = selectedFilter == index;
//                     return Padding(
//                       padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
//                       child: OutlinedButton(
//                         onPressed: () {
//                           setState(() {
//                             selectedFilter = index;
//                           });
//                         },
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: isSelected ? AppColors.kSkyBlue : Colors.transparent,
//                           side: BorderSide(color: AppColors.kSkyBlue),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(Get.width * 0.02),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: Get.width * 0.03,
//                               vertical: Get.width * 0.01),
//                         ),
//                         child: Text(
//                           filters[index],
//                           style: AppTypography.kBold16.copyWith(
//                             color: isSelected ? AppColors.kBlack : AppColors.kWhite,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//
//             SizedBox(height: Get.height * 0.001),
//
//             /// Message Cards
//             Expanded(
//               child: Padding(
//                 padding:  EdgeInsets.only(
//                   left: Get.height * 0.02
//                   ),
//                 child: ListView(
//                   children: [
//                     _buildMessageCard(
//                       name: "Johsan Bill",
//                       time: "09:35 pm",
//                       message: "Hey. Do keep the time track and be on time. Thanks",
//                       imagePath: "assets/userpicture.jpg",
//                       isSelected: true,
//                     ),
//                     SizedBox(height: 12),
//                     _buildMessageCard(
//                       name: "Chris Hemsworth",
//                       time: "11:35 pm",
//                       message: "Buddy. Do you have your armed suite with you. Need you urge...",
//                       imagePath: "assets/userpicture.jpg",
//                       isSelected: false,
//                     ),
//                     SizedBox(height: 12),
//                     _buildMessageCard(
//                       name: "SilverLuxe Labs",
//                       time: "09:35 pm",
//                       message: "Hey Sir. We have updated your shift, be on time.",
//                       imagePath: "assets/userpicture.jpg",
//                       isSelected: false,
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMessageCard({
//     required String name,
//     required String time,
//     required String message,
//     required String imagePath,
//     bool isSelected = false,
//   }) {
//     return GestureDetector(
//       onTap:(){
//            Get.to(ContractorChatScreen());
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.kCard,
//           borderRadius: BorderRadius.circular(12),
//           border: isSelected
//               ? Border(right: BorderSide(color: AppColors.kSkyBlue, width: 3))
//               : null,
//         ),
//         padding: EdgeInsets.all(Get.width * 0.03),
//         child: Row(
//           children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(Get.width * 0.02),
//                 child: Image.asset(
//                   'assets/userpicture.jpg',
//                   width: Get.width * 0.13,
//                   height: Get.width * 0.13,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(name, style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
//                   SizedBox(height: 4),
//                   Text(
//                     message,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               time,
//               style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
