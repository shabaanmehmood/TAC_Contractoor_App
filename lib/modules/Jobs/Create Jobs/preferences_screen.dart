import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Jobs/Create%20Jobs/required_docs_screen.dart';
import 'package:taccontractor/modules/auth/signup_screens/set_pass.dart';

import '../../../models/requiredLicenseModel.dart';
import '../../../widhets/common overlays/uploadFile_overlay.dart';
import '../../../widhets/common widgets/buttons/tappableInputTile.dart';
import 'company_info_controller.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final SetJobDetailsController controller = Get.find();

  InputDecoration _inputDecoration(String hintText, String iconPath) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.kDarkestBlue,
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      hintText: hintText,
      counter: const Offstage(),
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
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.fetchLicenses();
    controller.fetchRequiredSkills();
  }

  void showLicensesBottomSheet(BuildContext context, controller) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColors.kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            if (controller.availableLicenses.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 5,
                  indent: 140,
                  endIndent: 140,
                ),
                // Title & Done Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Required Licenses",
                      style: AppTypography.kBold18.copyWith(
                          color: AppColors.kWhite
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("Done", style: AppTypography.kBold16.copyWith(
                        color: AppColors.kSkyBlue,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.tenVertical),
                // Multi-select list of licenses
                ...controller.availableLicenses.map((license) =>
                    _buildLicenseOption(controller, license)
                ).toList(),
              ],
            );
          }),
        );
      },
    );
  }

  void showSkillsBottomSheet(BuildContext context, controller) {
    controller.fetchRequiredSkills();

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColors.kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            if (controller.availableSkills.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    color: Colors.grey,
                    thickness: 5,
                    indent: 140,
                    endIndent: 140,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Required Skills",
                        style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text("Done", style: AppTypography.kBold16.copyWith(
                          color: AppColors.kSkyBlue,
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                  ...controller.availableSkills.map((skill) =>
                      _buildSkillOption(controller, skill)
                  ).toList(),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildSkillOption(controller, skill) {
    return Obx(() => Column(
      children: [
        CheckboxListTile(
          value: controller.selectedSkills.contains(skill),
          onChanged: (selected) {
            if (selected == true) {
              controller.selectedSkills.add(skill);
            } else {
              controller.selectedSkills.remove(skill);
            }
          },
          title: Text(skill.name, style: TextStyle(color: Colors.white)),
          activeColor: AppColors.kSkyBlue,
          checkColor: AppColors.kDarkBlue,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        Divider(color: AppColors.kSkyBlue),
      ],
    ));
  }

  // Widget _buildSkillOption(controller, String skill) {
  //   return Obx(() => Column(
  //     children: [
  //       CheckboxListTile(
  //         value: controller.selectedSkills.contains(skill),
  //         onChanged: (selected) {
  //           if (selected == true) {
  //             controller.selectedSkills.add(skill);
  //           } else {
  //             controller.selectedSkills.remove(skill);
  //           }
  //         },
  //         title: Text(skill, style: TextStyle(color: Colors.white)),
  //         activeColor: AppColors.kSkyBlue,
  //         checkColor: AppColors.kDarkBlue,
  //         controlAffinity: ListTileControlAffinity.leading,
  //       ),
  //       Divider(color: AppColors.kSkyBlue),
  //     ],
  //   ));
  // }

  Widget _buildLicenseOption(controller, RequiredLicense license) {
    return Obx(() => Column(
      children: [
        CheckboxListTile(
          value: controller.selectedLicenses.contains(license),
          onChanged: (selected) {
            if (selected == true) {
              controller.selectedLicenses.add(license);
            } else {
              controller.selectedLicenses.remove(license);
            }
          },
          title: Text(license.name, style: TextStyle(color: Colors.white)),
          activeColor: AppColors.kSkyBlue,
          checkColor: AppColors.kDarkBlue,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        Divider(color: AppColors.kSkyBlue),
      ],
    ));
  }

  Widget _buildExperienceSlider() {
    return Obx(() => RangeSlider(
      activeColor: AppColors.kSkyBlue,
      inactiveColor: Colors.grey,
      values: RangeValues(
          controller.minExperience.value.toDouble(),
          controller.maxExperience.value.toDouble()
      ),
      min: 0,
      max: 100,
      divisions: 100,
      labels: RangeLabels(
        "${controller.minExperience.value} years",
        "${controller.maxExperience.value} years",
      ),
      onChanged: (RangeValues values) {
        controller.minExperience.value = values.start.toInt();
        controller.maxExperience.value = values.end.toInt();
      },
    ));
  }

  Widget _buildAgeLimitSlider() {
    return Obx(() => RangeSlider(
      activeColor: AppColors.kSkyBlue,
      inactiveColor: Colors.grey,
      values: RangeValues(
          controller.minAge.value.toDouble(),
          controller.maxAge.value.toDouble()
      ),
      min: 0,
      max: 100,
      divisions: 100,
      labels: RangeLabels(
        "${controller.minAge.value} years",
        "${controller.maxAge.value} years",
      ),
      onChanged: (RangeValues values) {
        controller.minAge.value = values.start.toInt();
        controller.maxAge.value = values.end.toInt();
      },
    ));
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
                  GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(AppAssets.kArrowBackward)
                  ),                  const SizedBox(width: 10),
                  Text("Create New Job", style: AppTypography.kBold24.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  StepTab(title: "Job Details", isCompleted: true),
                  StepTab(title: "Preferences", isCurrent: true,),
                  StepTab(title: "Required Docs"),
                ],
              ),
              const SizedBox(height: 20),
              Text("Set Your Guard Preference",
                  style: AppTypography.kBold20.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKeyforpreference,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          // Show comma-separated license names or placeholder
                          final licenseNames = controller.selectedLicenses.isEmpty
                              ? "License Required"
                              : controller.selectedLicenses.map((e) => e.name).join(', ');

                          return TappableInputTile(
                            title: "License Required",
                            controller: TextEditingController(text: licenseNames),
                            onTap: () {
                              showLicensesBottomSheet(context, controller);
                            },
                          );
                        }),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.jobAppearance,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(color: AppColors.kWhite),
                          decoration: _inputDecoration(
                              "Job Appearance", AppAssets.kMail),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TappableInputTile(
                          controller: controller.level,
                          title: "Levels",
                          onTap: (){},
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Age Limit",
                          style: AppTypography.kBold16.copyWith(
                              color: AppColors.kWhite),
                        ),
                        _buildAgeLimitSlider(),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Years of Experience",
                          style: AppTypography.kBold16.copyWith(
                              color: AppColors.kWhite),
                        ),
                        _buildExperienceSlider(),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Required Skills",
                          style: AppTypography.kBold16.copyWith(
                              color: AppColors.kWhite),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        Obx(() {
                          final skillNames = controller.selectedSkills.isEmpty
                              ? "Required Skills"
                              : controller.selectedSkills.map((e) => e.name).join(', ');

                          return TappableInputTile(
                            title: "Required Skills",
                            controller: TextEditingController(text: skillNames),
                            onTap: () {
                              showSkillsBottomSheet(context, controller);
                            },
                          );
                        }),


                        SizedBox(height: 20),
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
                      onPressed: (){
                        if(controller.formKeyforpreference.currentState!.validate()) {
                          Get.to(() => RequiredDocsScreen());
                        } else {
                          Get.snackbar(
                            "Error",
                            "Please fill all the required fields.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.8),
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("Next & Set Required Docs",
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

  Widget _buildSlider(String value) {
    final SetJobDetailsController controller = Get.put(SetJobDetailsController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.fiveVertical,),
        Container(
          padding: EdgeInsets.only(top: 8,right: 8, left: 8),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text("20y", style: AppTypography.kBold16.copyWith(
                      color: AppColors.kWhite
                  )),
                  Spacer(),
                  Text("30y", style: AppTypography.kBold16.copyWith(
                      color: AppColors.kWhite
                  )),
                  Spacer(),
                  Text("40y", style: AppTypography.kBold16.copyWith(
                      color: AppColors.kWhite
                  )),
                ],
              ),
              Slider(
                value: double.parse(controller.ageLimit.value),
                min: 20,
                max: 100,
                divisions: 2,
                onChanged: (value) {
                  controller.ageLimit.value = value.toInt().toString();
                },
                activeColor: AppColors.kSkyBlue,
                inactiveColor: Colors.grey,
              ),
            ],
          ),
        ),
      ],
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