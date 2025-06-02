import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/modules/account/components/Settings/DeleteAccountScreen.dart';
import 'package:taccontractor/modules/account/components/Settings/otp.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool liveLocation = false;
  bool biometricLogin = false;
  final userController = Get.put(UserController());

  Future<void> sendOtp() async {
    final apiService = MyApIService(); // create instance
    try{
      final response = await apiService.sendOtp(
        userController.userData.value!.email.toString(),
      );

      if (response.statusCode == 200) {
        debugPrint("data from API ${response.body}");
        Get.to(() => OtpScreen());
      } else {
        debugPrint("data from API ${response.body}");
        debugPrint('Error login failed: ${response.body}');
      }
    }
    catch(e){
      debugPrint('Error Network error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Settings",
          style: TextStyle(
            color: AppColors.kinput,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSwitchCard(
                  icon: Icons.location_on_outlined,
                  title: 'Live Location',
                  subtitle:
                      liveLocation ? 'Enabled' : 'Disabled', // ✅ Now dynamic
                  value: liveLocation,
                  onChanged: (val) => setState(() => liveLocation = val),
                ),
                const SizedBox(height: 12),
                _buildNavigationCard(
                  icon: Icons.lock_outline,
                  title: 'Update Password',
                  subtitle: 'Manage your details',
                  onTap: () {
                    sendOtp();
                  },
                ),
                const SizedBox(height: 12),
                _buildSwitchCard(
                  icon: Icons.fingerprint,
                  title: 'Biometric Login',
                  subtitle: biometricLogin ? 'Enabled' : 'Disabled',
                  value: biometricLogin,
                  onChanged: (val) => setState(() => biometricLogin = val),
                ),
                const SizedBox(height: 12),
                _buildDeleteCard(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "App Version",
                        style: TextStyle(
                          color: AppColors.kgrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "2.1.0",
                        style: TextStyle(
                          color: AppColors.kgrey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "© 2024 TAC Solutions. All rights reserved.",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.kgrey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.kSkyBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppColors.ktextlight, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.kSkyBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.kSkyBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.ktextlight, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppColors.kgrey),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteCard() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: AppColors.kBlack.withOpacity(0.05),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => DeleteAccountScreen(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Icon(Icons.delete_forever_outlined, color: AppColors.kRed),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Delete Account",
                      style: TextStyle(
                          color: AppColors.kRed, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text("All your data will be permanently deleted",
                      style: TextStyle(color: AppColors.kRed, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
