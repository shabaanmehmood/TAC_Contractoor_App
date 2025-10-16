// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/data/data/constants/app_typography.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
// import 'package:taccontractor/data/data/constants/app_spacing.dart';
// import 'package:taccontractor/data/data/constants/app_assets.dart';
// import 'chat_screen.dart';
//
// import 'messages_controller.dart';
//
// class MessagesScreen extends StatelessWidget {
//   MessagesScreen({Key? key}) : super(key: key);
//
//   final MessagesController controller = Get.put(MessagesController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // Removes the back button
//         backgroundColor: AppColors.kDarkestBlue,
//         elevation: 0,
//         title: Row(
//           children: [
//             Image.asset(AppAssets.kUserPicture, height: 35, width: 35),
//             SizedBox(width: 8),
//             Text('Messages',
//                 style: AppTypography.kBold18.copyWith(color: Colors.white)),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: AppSpacing.fifteenHorizontal),
//         child: Column(
//           children: [
//             SizedBox(height: AppSpacing.tenVertical),
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColors.kJobCardColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: controller.searchController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: 'Search for guards...',
//                         hintStyle: TextStyle(color: AppColors.kinput),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   Icon(Icons.search, color: Colors.white),
//                 ],
//               ),
//             ),
//             SizedBox(height: AppSpacing.twentyVertical),
//             Obx(() {
//               return Wrap(
//                 spacing: 4.0, // Spacing between chips
//                 runSpacing: 4.0, // Spacing between rows of chips
//                 children: List.generate(
//                   MessagesController.chipLabels.length,
//                   (index) {
//                     final isSelected =
//                         controller.selectedChipIndex.value == index;
//                     return ChoiceChip(
//                       label: Text(
//                         MessagesController.chipLabels[index],
//                         style: TextStyle(
//                           fontSize: 12.0, // Reduce font size for smaller chips
//                         ),
//                       ),
//                       selected: isSelected,
//                       onSelected: (_) {
//                         controller.selectedChipIndex.value = index;
//                       },
//                       selectedColor: AppColors.kSkyBlue,
//                       backgroundColor: AppColors.kDarkBlue,
//                       labelStyle: TextStyle(
//                         color: isSelected ? Colors.white : AppColors.ktextlight,
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }),
//             SizedBox(height: AppSpacing.tenVertical),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return Center(child: CircularProgressIndicator(
//                     color: AppColors.kSkyBlue,
//                   ));
//                 }
//                 if (controller.messages.isEmpty) {
//                   return Center(
//                     child: Text(
//                       "No guards found.",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   );
//                 }
//                 return RefreshIndicator(
//                   onRefresh: () async {
//                     await controller.fetchAllContractors();
//                   },
//                   color: AppColors.kPrimary, // Optional: match your theme
//                   child:ListView.separated(
//   itemCount: controller.messages.length,
//   separatorBuilder: (context, index) {
//     return SizedBox(height: Get.height * 0.02);
//   },
//   itemBuilder: (context, index) {
//     final msg = controller.messages[index];
//     return Container(
//       padding: EdgeInsets.all(Get.width * 0.03),
//       decoration: BoxDecoration(
//         color: AppColors.kinput.withOpacity(0.5),
//         borderRadius: BorderRadius.circular(Get.width * 0.02),
//       ),
//       child: GestureDetector(
//         onTap: () {
//           Get.to(() => ChatScreen(
//             contractorId: msg.contractorId,
//             message: msg.message,
//             image: msg.image,
//             name: msg.name,
//             time: msg.time,
//           ));
//           print("User clicked: ${msg.name}");
//         },
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.asset(
//                 msg.image,
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     msg.name,
//                     style: AppTypography.kBold16.copyWith(color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   },
// )
//                 );
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/modules/Messages/socket_file.dart';
import 'chat_screen.dart';
import 'messages_controller.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final MessagesController controller = Get.put(MessagesController());
   final UserController userController = Get.put(UserController());


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SocketService().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: Row(
          children: [
             Builder(
        builder: (_) {
          final profileImages = userController.userData.value?.profileImages;
          final mainImage = profileImages?.firstWhereOrNull((img) => img.isMain == true);
          final imageUrl = (mainImage?.image != null && mainImage!.image!.isNotEmpty)
              ? '${MyApIService.imageBaseUrl}/${mainImage.image}'
              : null;

          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: imageUrl != null
                    ? NetworkImage(imageUrl)
                    :  AssetImage(AppAssets.kUserPicture) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
            SizedBox(width: 8),
            Text('Messages',
                style: AppTypography.kBold18.copyWith(color: Colors.white)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.fifteenHorizontal),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.tenVertical),
            Container(
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search for guards...',
                        hintStyle: TextStyle(color: AppColors.kinput),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kSkyBlue,
                    ),
                  );
                }
                if (controller.filteredChats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            color: Colors.white.withOpacity(0.3),
                            size: 64
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No chats found",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.fetchChatList();
                  },
                  color: AppColors.kPrimary,
                  child: ListView.separated(
                    itemCount: controller.filteredChats.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: Get.height * 0.02);
                    },
                    itemBuilder: (context, index) {
                      final chat = controller.filteredChats[index];
                      final formattedTime = controller.formatTimestamp(chat.lastMessageTimestamp);

                      return Container(
                        padding: EdgeInsets.all(Get.width * 0.03),
                        decoration: BoxDecoration(
                          color: AppColors.kinput.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(Get.width * 0.02),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => ChatScreen(
                              contractorId: chat.partnerId,
                              message: chat.lastMessageText,
                              image: chat.image,
                              name: chat.partnerName,
                              time: formattedTime,
                            ));
                            print("User clicked: ${chat.partnerName}");
                            print("User image: ${chat.image}");

                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  chat.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chat.partnerName,
                                            style: AppTypography.kBold16.copyWith(
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (formattedTime.isNotEmpty)
                                          Text(
                                            formattedTime,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chat.lastMessageText,
                                            style: TextStyle(
                                              color: chat.isSeen
                                                  ? AppColors.ktextlight
                                                  : Colors.white.withOpacity(0.9),
                                              fontSize: 14,
                                              fontWeight: chat.isSeen
                                                  ? FontWeight.normal
                                                  : FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}