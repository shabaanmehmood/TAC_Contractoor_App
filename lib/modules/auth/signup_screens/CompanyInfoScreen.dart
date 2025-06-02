import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'company_info_controller.dart';

class CompanyInfoScreen extends StatelessWidget {
  final CompanyInfoController controller = Get.put(CompanyInfoController());

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
                  StepTab(title: "Company Info", isCurrent: true),
                  StepTab(title: "Documents"),
                  StepTab(title: "Set Password"),
                ],
              ),
              const SizedBox(height: 20),
              Text("Company Info",
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
                          decoration:
                              _inputDecoration("Company Name", AppAssets.kPer),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.companyEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppColors.kWhite),
                          decoration: _inputDecoration(
                              "Company Email", AppAssets.kMail),
                          validator: controller.validateEmail,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.phone,
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
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.postalAddress,
                          decoration: _inputDecoration(
                              "Postal Address", AppAssets.kLoc),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.license,
                          decoration: _inputDecoration(
                              "Master Security License", AppAssets.kCal),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.abn,
                          decoration: _inputDecoration(
                              "Australian Business Number", AppAssets.kCal),
                          validator: controller.validateABN,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                          maxLength: 11,
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.acn,
                          decoration: _inputDecoration(
                              "Australian Company Number", AppAssets.kCal),
                          validator: controller.validateACN,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                          maxLength: 9,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                  color: AppColors.ktextlight, thickness: 1, height: 0),
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
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Back',
                        style: AppTypography.kBold16
                            .copyWith(color: AppColors.kSkyBlue)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("Continue to Documents",
                          style: AppTypography.kBold16
                              .copyWith(color: Colors.black)),
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
