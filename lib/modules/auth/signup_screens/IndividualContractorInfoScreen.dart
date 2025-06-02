import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/auth/signup_screens/company_info_controller.dart';
import 'individual_info_controller.dart';

class IndividualInfoScreen extends StatelessWidget {
  final CompanyInfoController controller =
      Get.put(CompanyInfoController());

  InputDecoration _inputDecoration(String hintText, String iconPath) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.kDarkestBlue,
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Image.asset(iconPath,
            height: 20, width: 20, color: AppColors.ktextlight),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      hintText: hintText,
      hintStyle: AppTypography.kLight14.copyWith(color: AppColors.kinput),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue, width: 1.5),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue, width: 2),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(AppAssets.kTacLogo, height: 60),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Create Account",
                          style: AppTypography.kBold24
                              .copyWith(color: Colors.white)),
                      Text("Get Yourself Registered",
                          style: AppTypography.kLight16
                              .copyWith(color: AppColors.ktextlight)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  StepTab(title: "Account Info", isCurrent: true),
                  StepTab(title: "Documents"),
                  StepTab(title: "Set Password"),
                ],
              ),
              const SizedBox(height: 20),
              Text("Account Info",
                  style: AppTypography.kBold18.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.companyName,
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(320)
                          ],
                          decoration:
                              _inputDecoration("Full Name", AppAssets.kPer),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.companyEmail,
                          style: const TextStyle(color: AppColors.kWhite),
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                              "johndoe@gmail.com", AppAssets.kMail),
                          validator: controller.validateEmail,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.phone,
                          style: const TextStyle(color: AppColors.kWhite),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration:
                              _inputDecoration("Phone Number", AppAssets.kNum),
                          validator: controller.validatePhone,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.genderController,
                          style: const TextStyle(color: AppColors.kWhite),
                          readOnly: true,
                          onTap: controller.pickGender,
                          keyboardType: TextInputType.none,
                          decoration: _inputDecoration("Gender", AppAssets.kGen),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Select gender'
                              : null,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.postalAddress,
                          style: const TextStyle(color: AppColors.kWhite),
                          keyboardType: TextInputType.streetAddress,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(500)
                          ],
                          decoration: _inputDecoration(
                              "Postal Address", AppAssets.kLoc),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Postal Address is required';
                            }
                            return null;
                          },
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.abn,
                          style: const TextStyle(color: AppColors.kWhite),
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(
                              "Australian Business Number", AppAssets.kCal),
                          validator: controller.validateABN,
                          maxLength: 11,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                color: AppColors.ktextlight.withOpacity(0.2),
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.kSkyBlue, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kSkyBlue),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Continue to Documents",
                        style:
                            AppTypography.kBold16.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepTab extends StatelessWidget {
  final String title;
  final bool isCurrent;
  final bool isCompleted;

  const StepTab({
    required this.title,
    this.isCurrent = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor = isCompleted
        ? AppColors.kSkyBlue
        : isCurrent
            ? AppColors.kWhite
            : AppColors.ktextlight.withOpacity(0.2);

    double progressValue = isCompleted
        ? 1
        : isCurrent
            ? 0.5
            : 0.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Adjust this padding to your preference
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: AppColors.ktextlight.withOpacity(0.2),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTypography.kBold14.copyWith(
                color: Colors.white,
                fontFamily: 'YourFontFamily', // Specify the font family
                fontSize: 13, // Adjust the font size
                fontWeight:
                    FontWeight.w600, // Adjust the font weight (optional)
              ),
            )
          ],
        ),
      ),
    );
  }
}
