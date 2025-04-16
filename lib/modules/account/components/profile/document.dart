import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';

class DocumentsController extends GetxController {
  var documents = <Map<String, dynamic>>[
    {
      'title': 'Passport',
      'verified': true,
      'image': 'assets/userpicture.jpg', // Replace with actual path
    },
    {
      'title': 'Police Verification',
      'verified': false,
      'image': '',
    }
  ].obs;
}

class DocumentScreen extends StatelessWidget {
  DocumentScreen({super.key});

  final DocumentsController controller = Get.put(DocumentsController());
  final UserController userController = Get.find<UserController>(); // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
        title: const Text('Documents',
            style: TextStyle(color: AppColors.kWhite, fontSize: 16)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Obx(() {
          return Column(
            children: controller.documents.map((doc) {
              final String title = doc['title'] as String;
              final bool verified = doc['verified'] as bool;

              return Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 16),
                child: verified
                    ? buildVerifiedCard(title)
                    : buildUploadCard(title),
              );
            }).toList(),
          );
        }),
      ),
    );
  }

  Widget buildVerifiedCard(String title) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.kinput, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.kgreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Text('Verified',
                      style: TextStyle(
                          color: AppColors.kgreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          // Image from userController
          Padding(
            padding:
            const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Obx(() {
                final imagePath =
                    userController.userData.value?.profileImages?.first.imageUrl;
                final imageUrl = MyApIService.fullImageUrl(imagePath);
                return Image(
                  image: imageUrl != null
                      ? NetworkImage(imageUrl)
                      : AssetImage(AppAssets.kUserPicture)
                  as ImageProvider,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUploadCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.kgrey.withOpacity(0.3), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with Icon and Add
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circular Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kSkyBlue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.insert_drive_file,
                    color: AppColors.kSkyBlue, size: 20),
              ),
              GestureDetector(
                onTap: () {
                  // Upload logic
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: AppColors.kSkyBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title text
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: AppColors.kinput,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          const Text(
            'Upload a clear and recent profile picture (JPG, PNG, max 5MB).',
            style: TextStyle(
              fontSize: 9,
              color: AppColors.ktextlight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
