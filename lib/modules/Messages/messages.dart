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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search for security jobs...',
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
                      selectedColor: AppColors.kPrimary,
                      backgroundColor: AppColors.kJobCardColor,
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
                return ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ChatScreen(
                              // assuming msg.image exists
                              ));
                          print("Message clicked: ${msg.name}");
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          msg.name,
                                          style: AppTypography.kBold16
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        msg.time,
                                        style: AppTypography.kLight14.copyWith(
                                            color: AppColors.ktextlight),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    msg.message,
                                    style: AppTypography.kLight14
                                        .copyWith(color: AppColors.ktextlight),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
