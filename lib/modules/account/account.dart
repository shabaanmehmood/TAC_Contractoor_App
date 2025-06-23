import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/modules/account/components/Earning/earnings_screen.dart';
import 'package:taccontractor/modules/account/components/bank%20details/bank_details_screen.dart';
import 'package:taccontractor/modules/account/components/logout.dart';
import 'package:taccontractor/modules/account/components/profile/profile_screen.dart';
import 'package:taccontractor/modules/account/help_support.dart';
import 'package:taccontractor/modules/account/components/reviews/reviews_screen.dart';
import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_assets.dart';
import '../../dataproviders/api_service.dart';
import 'components/Settings/SettingsScreen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>().obs;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: Column(
        children: [
          // App Bar
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
            decoration: const BoxDecoration(
              color: AppColors.kDarkestBlue,
              border: Border(
                bottom: BorderSide(width: 0.5, color: AppColors.kgrey),
              ),
            ),
            child: Row(
              children: [
                Image.asset(AppAssets.kTacLogo, width: 24, height: 24),
                const SizedBox(width: 8),
                const Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Card
                  Container(
                    width: screenWidth * 0.92,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.kDarkestBlue,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.kgrey.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Obx(() {
                        //   final imagePath = userController.value.userData.value
                        //       ?.profileImages?.first.imageUrl;
                        //   final imageUrl = MyApIService.fullImageUrl(imagePath);
                        //   return Container(
                        //     width: 56,
                        //     height: 56,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8),
                        //       image: DecorationImage(
                        //         image: imageUrl != null
                        //             ? NetworkImage(imageUrl)
                        //             : AssetImage(AppAssets.kUserPicture)
                        //                 as ImageProvider,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   );
                        // }),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image:
                              // imageUrl != null
                              // ? NetworkImage(imageUrl) :
                              AssetImage(AppAssets.kUserPicture),
                              // as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      userController.value.userData.value?.name ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.kSkyBlue,
                                    size: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Security Head',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () =>
                                    Get.to(() => const ReviewsScreen()),
                                child: Row(
                                  children: const [
                                    Icon(Icons.star,
                                        size: 16, color: AppColors.kSkyBlue),
                                    SizedBox(width: 4),
                                    Text(
                                      "5.0",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "(12 reviews)",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Summary Info Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        buildInfoCard('Team Members', '0'),
                        buildInfoCard('Active Jobs', '0'),
                        buildInfoCard('Total Guards Hired', '0'),
                        buildInfoCard('Total Spent', '\$0.0'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Menu Cards
                  buildCard(
                    screenWidth,
                    'Profile',
                    Icons.person,
                    'Manage your profile and documents',
                    onTap: () => Get.to(() => const ProfileScreen()),
                  ),
                  buildCard(
                    screenWidth,
                    'Payments',
                    Icons.payment,
                    'Payment record for jobs and guards',
                    onTap: () => Get.to(() => EarningsScreen()),
                  ),
                  buildCard(
                    screenWidth,
                    'Pay Guards',
                    Icons.account_balance,
                    'Add your card details',
                    onTap: () => Get.to(() => BankDetailsScreen()),
                  ),
                  buildCard(
                    screenWidth,
                    'Help & Support',
                    Icons.help,
                    'Get assistance',
                    onTap: () => Get.to(() => const HelpSupportScreen()),
                  ),
                  buildCard(
                    screenWidth,
                    'Settings',
                    Icons.settings,
                    'Manage your account',
                    onTap: () => Get.to(() => const SettingsScreen()),
                  ),
                  buildCard(
                    screenWidth,
                    'Logout',
                    Icons.logout,
                    'Sign Out securely',
                    onTap: () => showLogoutBottomSheet(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(
    double screenWidth,
    String title,
    IconData icon,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.92,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.kPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white)
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String value) {
    return Container(
      width: (Get.width - 16 * 2 - 12) / 2,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(color: AppColors.ktextlight, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: AppColors.kWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
