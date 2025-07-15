import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'icon': 'assets/logo.png',
      'title': 'Badge Earned',
      'subtitle': 'Congratulations! You have earned the Leader badge for our...',
      'time': '09:35 PM'
    },
    {
      'avatar': 'assets/userpicture.jpg',
      'title': 'Congratulations! Alex hired you.',
      'subtitle': 'Your application for "Job Name" is approved.',
      'time': '09:35 PM'
    },
    {
      'avatar': 'assets/userpicture.jpg',
      'title': 'Message Received',
      'subtitle': 'New message from your contractor John Smith.',
      'time': '09:35 PM'
    },
    {
      'icon': 'assets/logo.png',
      'title': 'Shift Reminder',
      'subtitle': 'Your shift starts in 30 minutes. Please check in.',
      'time': '09:35 PM'
    },
    {
      'avatar': 'assets/userpicture.jpg',
      'title': 'Job Complete. Contract ended by client',
      'subtitle': 'Your [License/ID] is expiring soon. Update it in the system.',
      'time': '09:35 PM'
    },
    {
      'icon': 'assets/logo.png',
      'title': 'App Update Available',
      'subtitle': 'View your recommended match today!',
      'time': '09:35 PM'
    },
    {
      'icon': 'assets/logo.png',
      'title': 'Badge Earned',
      'subtitle': 'Congratulations! You have earned the Leader badge for our...',
      'time': '09:35 PM'
    },
    {
      'avatar': 'assets/userpicture.jpg',
      'title': 'Congratulations! Alex hired you.',
      'subtitle': 'Your application for "Job Name" is approved.',
      'time': '09:35 PM'
    },
    {
      'avatar': 'assets/userpicture.jpg',
      'title': 'Message Received',
      'subtitle': 'New message from your contractor John Smith.',
      'time': '09:35 PM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          children: [
            /// Header Row
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.01,
                left: Get.width * 0.04,
                right: Get.width * 0.04
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Image.asset(
                          AppAssets.kBack,
                          height: Get.height * 0.07,
                          width: Get.width * 0.07,
                          color: AppColors.kgrey,
                        ),
                      ),
                      SizedBox(width: Get.width * 0.04),
                      Text(
                        "Notifications",
                        style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),

                   Text(
                        "Mark All Read",
                        style: AppTypography.kBold18.copyWith(color: AppColors.kSkyBlue),
                      ),
                ],
              ),
            ),

            /// Divider
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.kgrey,
              margin: EdgeInsets.symmetric(vertical: Get.height * 0.015),
            ),

            /// Notification List (Fixed Height instead of Expanded)
            SizedBox(
              height: Get.height * 0.78, // Adjust based on screen
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.04,
                      vertical: Get.height * 0.008,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kinput.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(Get.width * 0.035),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Avatar or Icon
                          item.containsKey('avatar')
                              ? CircleAvatar(
                                  radius: Get.width * 0.06,
                                  backgroundImage: AssetImage(item['avatar']),
                                )
                              : Image.asset(
                                  item['icon'],
                                  width: Get.width * 0.12,
                                  height: Get.width * 0.12,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(width: Get.width * 0.03),

                          /// Text Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'],
                                  style: AppTypography.kBold14.copyWith(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item['subtitle'],
                                  style: AppTypography.kLight12.copyWith(color: Colors.grey.shade400),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item['time'],
                                  style: AppTypography.kLight11.copyWith(color: Colors.grey.shade600),
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
            ),
          ],
        ),
      ),
    );
  }
}
