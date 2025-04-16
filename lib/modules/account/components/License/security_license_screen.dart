import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../data/data/constants/app_assets.dart';
import '../../../../dataproviders/api_service.dart';
import 'add_license_screen.dart';

class SecurityLicenseScreen extends StatelessWidget {
  SecurityLicenseScreen({super.key});

  final userController = Get.find<UserController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Licenses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.to(() => const AddLicenseScreen()),
            child: const Text(
              "Add License",
              style: TextStyle(
                color: AppColors.kSkyBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.kDarkBlue,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          buildLicenseCard(
            title: "Driving License No.",
            number: "N/A",
            expiry: "–",
            status: "Verification Pending",
            statusColor: AppColors.kalert,
            badgeColor: AppColors.klightalert,
            showUpdate: false,
          ),
          const SizedBox(height: 14),
          buildLicenseCard(
            title: "Construction Security License",
            number: "651331581888184884",
            expiry: "05 / 2030",
            status: "Verified",
            statusColor: AppColors.kgreen,
            badgeColor: AppColors.kgshade,
          ),
          const SizedBox(height: 14),
          buildLicenseCard(
            title: "Armed License",
            number: "651331581888184884",
            expiry: "05 / 2030",
            status: "Verified",
            statusColor: AppColors.kgreen,
            badgeColor: AppColors.kgshade,
          ),
          const SizedBox(height: 14),
          buildLicenseCard(
            title: "Mining Security License",
            number: "651331581888184884",
            expiry: "05 / 2030",
            status: "Verification Rejected",
            statusColor: AppColors.kRed,
            badgeColor: AppColors.kRed,
            showUpdate: true,
          ),
        ],
      ),
    );
  }

  Widget buildLicenseCard({
    required String title,
    required String number,
    required String expiry,
    required String status,
    required Color statusColor,
    required Color badgeColor,
    bool showUpdate = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kDarkBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Image + Status Badge + Optional Update Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: userProfileImageWidget(),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (showUpdate)
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      color: AppColors.kSkyBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: License Title
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ktextlight,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          // Row 3: License Number
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),

          // Row 4: Expiry Date (right aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Expiry Date   $expiry",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget userProfileImageWidget() {
    return Obx(() {
      final imagePath = userController.userData.value?.profileImages?.first.imageUrl;
      final imageUrl = MyApIService.fullImageUrl(imagePath);

      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: imageUrl != null
                ? NetworkImage(imageUrl)
                : AssetImage(AppAssets.kUserPicture) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}
