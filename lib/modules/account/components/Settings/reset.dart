import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final userController = Get.put(UserController());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> resetPassword() async {
   final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.resetPassword(
          userController.userData.value!.email.toString(),
          passwordController.text.toString(),
          confirmPasswordController.text.toString(),
        );

        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.offAndToNamed(AppRoutes.getLandingPageRoute());
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error Reset Password failed: ${response.body}');
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: AppColors.kinput, size: 16),
          onPressed: () => Get.back(),
        ),
        title: const Text('Verify Email',
            style: TextStyle(color: AppColors.kWhite)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.kinput, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reset Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
            const SizedBox(height: 4),
            const Text("Set new password here.",
                style: TextStyle(color: AppColors.kinput, fontSize: 12)),
            const SizedBox(height: 24),

            // New Password Field
            TextField(
              controller: passwordController,
              obscureText: _obscureNewPassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'New Password',
                hintStyle: const TextStyle(color: AppColors.kinput),
                prefixIcon:
                    const Icon(Icons.lock_outline, color: AppColors.kinput),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.kinput,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNewPassword = !_obscureNewPassword;
                    });
                  },
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kinput),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Password Field
            TextField(
              controller: confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Confirm Password',
                hintStyle: const TextStyle(color: AppColors.kinput),
                prefixIcon:
                    const Icon(Icons.lock_outline, color: AppColors.kinput),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.kinput,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kinput),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Update Password Button
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  if (passwordController.text.isNotEmpty &&
                      confirmPasswordController.text.isNotEmpty) {
                    resetPassword();
                  } else {
                    Get.snackbar("Error", "Please fill all fields",
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                child: const Text("Update Password",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
