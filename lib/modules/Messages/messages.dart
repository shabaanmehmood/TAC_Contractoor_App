import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'chat_screen.dart';

import 'messages_controller.dart';

class MessagesScreen extends StatelessWidget {
  MessagesScreen({Key? key}) : super(key: key);

  final MessagesController controller = Get.put(MessagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(AppAssets.kUserPicture, height: 35, width: 35),
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
            Obx(() {
              return Wrap(
                spacing: 4.0, // Spacing between chips
                runSpacing: 4.0, // Spacing between rows of chips
                children: List.generate(
                  MessagesController.chipLabels.length,
                  (index) {
                    final isSelected =
                        controller.selectedChipIndex.value == index;
                    return ChoiceChip(
                      label: Text(
                        MessagesController.chipLabels[index],
                        style: TextStyle(
                          fontSize: 12.0, // Reduce font size for smaller chips
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) {
                        controller.selectedChipIndex.value = index;
                      },
                      selectedColor: AppColors.kSkyBlue,
                      backgroundColor: AppColors.kDarkBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.ktextlight,
                      ),
                    );
                  },
                ),
              );
            }),
            SizedBox(height: AppSpacing.tenVertical),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(
                    color: AppColors.kSkyBlue,
                  ));
                }
                if (controller.messages.isEmpty) {
                  return Center(
                    child: Text(
                      "No guards found.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchAllContractors();
                  },
                  color: AppColors.kPrimary, // Optional: match your theme
                  child:ListView.separated(
  itemCount: controller.messages.length,
  separatorBuilder: (context, index) {
    return SizedBox(height: Get.height * 0.02);
  },
  itemBuilder: (context, index) {
    final msg = controller.messages[index];
    return Container(
      padding: EdgeInsets.all(Get.width * 0.03),
      decoration: BoxDecoration(
        color: AppColors.kinput.withOpacity(0.5),
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() => ChatScreen(
            contractorId: msg.contractorId,
            message: msg.message,
            image: msg.image,
            name: msg.name,
            time: msg.time,
          ));
          print("User clicked: ${msg.name}");
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                msg.image,
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
                  Text(
                    msg.name,
                    style: AppTypography.kBold16.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
)
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
