import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/auth/sign_in_view.dart';
import 'package:taccontractor/modules/auth/signup_screens/CompanyInfoScreen.dart';
import 'package:taccontractor/modules/auth/signup_screens/IndividualContractorInfoScreen.dart';

import 'company_info_controller.dart';

// Import your target screens here
// import 'company_screen.dart';
// import 'individual_contractor_screen.dart';
// import 'login_screen.dart';

class SelectAccountTypeScreen extends StatefulWidget {
  const SelectAccountTypeScreen({super.key});

  @override
  State<SelectAccountTypeScreen> createState() =>
      _SelectAccountTypeScreenState();
}

class _SelectAccountTypeScreenState extends State<SelectAccountTypeScreen> {
  final CompanyInfoController controller = Get.put(CompanyInfoController());
  String _selectedType = 'Company';

  void _handleContinue() {
    if (_selectedType == 'Company') {
      controller.registeringAs.value = 'Company';
      debugPrint('Registering as: ${controller.registeringAs.value}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompanyInfoScreen()),
      );
    } else {
      controller.registeringAs.value = 'contractor';
      debugPrint('Registering as: ${controller.registeringAs.value}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IndividualInfoScreen()),
      );
    }
  }

  Widget _buildOption({
    required String label,
    required String asset,
    required String value,
  }) {
    bool isSelected = _selectedType == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = value),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.tenVertical,
          horizontal: AppSpacing.twentyHorizontal,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kChat : AppColors.kDarkBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.kSkyBlue,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(asset, height: 30, color: AppColors.kWhite),
                Radio<String>(
                  value: value,
                  groupValue: _selectedType,
                  onChanged: (value) => setState(() => _selectedType = value!),
                  activeColor: AppColors.kSkyBlue,
                ),
              ],
            ),
            // SizedBox(height: AppSpacing.tenVertical),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.fiftyVertical),

              // Logo and Titles
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppAssets.kTacLogo, height: 70),
                  SizedBox(width: AppSpacing.tenHorizontal),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: AppTypography.kBold24
                            .copyWith(color: AppColors.kWhite),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Get Yourself Registered',
                        style: AppTypography.kLight16
                            .copyWith(color: AppColors.ktextlight),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.fiftyVertical * 2),

              Center(
                child: Text(
                  'Registering as a',
                  style:
                      AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                ),
              ),

              SizedBox(height: AppSpacing.twentyVertical),

              _buildOption(
                label: 'Company',
                asset: AppAssets.kPer,
                value: 'Company',
              ),

              SizedBox(height: AppSpacing.fifteenVertical),

              _buildOption(
                label: 'Individual Contractor',
                asset: AppAssets.kPer,
                value: 'Individual Contractor',
              ),

              SizedBox(height: AppSpacing.thirtyVertical),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kSkyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style:
                        AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.twentyVertical),

              // Login Navigation
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInView()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.ktextlight),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: AppTypography.kBold14
                              .copyWith(color: AppColors.kSkyBlue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Powered by TAC Solutions',
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.ktextlight),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
