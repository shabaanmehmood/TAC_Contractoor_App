import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Jobs/Create%20Jobs/required_docs_screen.dart';
import 'package:taccontractor/modules/auth/signup_screens/set_pass.dart';
import 'package:taccontractor/modules/myJobs/myJobsScreen.dart';

import '../../../dataproviders/api_service.dart';
import '../../../models/createJobModel.dart';
import '../../../models/preferenceModel.dart';
import '../../../models/requiredLicenseModel.dart';
import '../../../routes/app_routes.dart';
import '../../../widhets/common overlays/uploadFile_overlay.dart';
import '../../../widhets/common widgets/buttons/tappableInputTile.dart';
import '../../account/account.dart';
import '../../landing_page/landing_page.dart';
import 'company_info_controller.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final SetJobDetailsController controller = Get.find();
  bool _isSubmitting = false;

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
  }

  Future<void> createJob() async {
    final coords =
        await controller.setLatLngFromAddress(controller.siteLocation.text);

    if (coords == null) {
      Get.snackbar("Error", "Could not determine location coordinates");
      return;
    }
    if (controller.shifts.isEmpty) {
      Get.snackbar("Error", "Please complete all sections");
      return;
    }

    final job = CreateJobModel(
      title: controller.jobTitle.text,
      payPerHour: controller.payPerHour.text,
      categoryId: controller.selectedCategory.value.toString(),
      premisesTypeId: controller.selectedPremises.value,
      description: controller.jobDescription.value,
      responsibilities: controller.jobResponsiblities.text,
      location: controller.siteLocation.text,
      latitude: coords['lat'].toString(),
      longitude: coords['lon'].toString(),
      reportingManagerNumber: controller.reportingManagerNumber.text,
      reportingManagerName: controller.reportingManager.text,
      minAge: controller.ageLimitEnabled.value
          ? controller.minAge.value.toString()
          : null,
      maxAge: controller.ageLimitEnabled.value
          ? controller.maxAge.value.toString()
          : null,
      minimumLevel: controller.minimumLevel.value.toString(),
      maximumLevel: controller.maximumLevel.value.toString(),
      noOfGuardsRequired: int.parse(controller.noOfGuardsRequired.text),
      jobType: controller.jobType.value,
      leaderRequired: controller.leaderRequired.value,
      jobSOPs: controller.jobSOPs.text,
      contractorId: controller.userController.userData.value!.id!,
      requiredLicense: controller.selectedLicenses
          .map((license) => RequiredLicense(id: license.id, name: license.name))
          .toList(),
        requiredSkills: controller.requiredSkills.text.trim(),
      shifts: controller.shifts.toList(),
      preferences: Preferences(
        minYearsExperience: controller.experienceLimitEnabled.value
          ? controller.minExperience.value
          : null,
        maxYearsExperience: controller.experienceLimitEnabled.value
          ? controller.maxExperience.value
          : null,
        appearanceRequirements: controller.jobAppearance.text,
      ),
      // cardNumber: controller.cardNumberController.text,
      // expiryMonth: controller.cardExpiryMonthController.text,
      // expiryYear: controller.cardExpiryYearController.text,
      // cvv: controller.cardCvvController.text,
    );

    final response = await MyApIService().createJob(job);
    if (response.statusCode == 201) {
      controller.clearAllFields();
      Get.offAllNamed(AppRoutes.landing, arguments: {'selectedIndex': 2});
    } else {
      Get.snackbar("Error", "Job creation failed");
    }
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
                      "Optional Licenses",
                      style: AppTypography.kBold18
                          .copyWith(color: AppColors.kWhite),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("Done",
                          style: AppTypography.kBold16.copyWith(
                            color: AppColors.kSkyBlue,
                          )),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.tenVertical),
                // Multi-select list of licenses
                ...controller.availableLicenses
                    .map((license) => _buildLicenseOption(controller, license))
                    .toList(),
              ],
            );
          }),
        );
      },
    );
  }

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
          values: RangeValues(controller.minExperience.value.toDouble(),
              controller.maxExperience.value.toDouble()),
          min: 0,
          max: 50,
          divisions: 50,
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
          values: RangeValues(controller.minAge.value.toDouble(),
              controller.maxAge.value.toDouble()),
          min: 0,
          max: 50,
          divisions: 50,
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

  Widget _buildLevelsLimitSlider() {
    return Obx(() => RangeSlider(
          activeColor: AppColors.kSkyBlue,
          inactiveColor: Colors.grey,
          values: RangeValues(controller.minimumLevel.value.toDouble(),
              controller.maximumLevel.value.toDouble()),
          min: 0,
          max: 5,
          divisions: 5,
          labels: RangeLabels(
            "${controller.minimumLevel.value} level",
            "${controller.maximumLevel.value} level",
          ),
          onChanged: (RangeValues values) {
            controller.minimumLevel.value = values.start.toInt();
            controller.maximumLevel.value = values.end.toInt();
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
                      child: Image.asset(AppAssets.kArrowBackward)),
                  const SizedBox(width: 10),
                  Text("Create New Job",
                      style:
                          AppTypography.kBold24.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  StepTab(title: "Job Details", isCompleted: true),
                  StepTab(
                    title: "Preferences",
                    isCurrent: true,
                  ),
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
                          final licenseNames =
                              controller.selectedLicenses.isEmpty
                                  ? "No licenses selected (optional)"
                                  : controller.selectedLicenses
                                      .map((e) => e.name)
                                      .join(', ');

                          return TappableInputTile(
                            title: "Optional Licenses",
                            controller:
                                TextEditingController(text: licenseNames),
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
                          onChanged: (value) {
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Levels",
                          style: AppTypography.kBold16
                              .copyWith(color: AppColors.kWhite),
                        ),
                        _buildLevelsLimitSlider(),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Age Limit (optional)",
                          style: AppTypography.kBold16
                              .copyWith(color: AppColors.kWhite),
                        ),
                        Obx(() => Column(
                              children: [
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    "Set age limit",
                                    style: AppTypography.kLight14
                                        .copyWith(color: AppColors.kWhite),
                                  ),
                                  value: controller.ageLimitEnabled.value,
                                  activeColor: AppColors.kSkyBlue,
                                  onChanged: (enabled) => controller
                                      .ageLimitEnabled.value = enabled,
                                ),
                                if (controller.ageLimitEnabled.value)
                                  _buildAgeLimitSlider(),
                              ],
                            )),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Years of Experience (optional)",
                          style: AppTypography.kBold16
                              .copyWith(color: AppColors.kWhite),
                        ),
                        Obx(() => Column(
                              children: [
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    "Set experience range",
                                    style: AppTypography.kLight14
                                        .copyWith(color: AppColors.kWhite),
                                  ),
                                  value:
                                      controller.experienceLimitEnabled.value,
                                  activeColor: AppColors.kSkyBlue,
                                  onChanged: (enabled) => controller
                                      .experienceLimitEnabled.value = enabled,
                                ),
                                if (controller.experienceLimitEnabled.value)
                                  _buildExperienceSlider(),
                              ],
                            )),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Required Skills",
                          style: AppTypography.kBold16
                              .copyWith(color: AppColors.kWhite),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        TextFormField(
                          controller: controller.requiredSkills,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 2,
                          maxLines: 4,
                          style: const TextStyle(color: AppColors.kWhite),
                          decoration: _inputDecoration(
                            'Describe the skills needed for this job',
                            AppAssets.kMail,
                          ),
                        ),
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
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              final preferencesValid = controller
                                      .formKeyforpreference.currentState
                                      ?.validate() ??
                                  false;
                              final jobDetailsValid = controller
                                      .formKey.currentState
                                      ?.validate() ??
                                  false;

                              if (!preferencesValid || !jobDetailsValid) {
                                Get.snackbar(
                                  "Error",
                                  "Please fill all the required fields",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              setState(() => _isSubmitting = true);
                              try {
                                await createJob();
                              } finally {
                                if (mounted) {
                                  setState(() => _isSubmitting = false);
                                }
                              }
                            },
                      // onPressed: () {
                      //   if (controller.formKeyforpreference.currentState!
                      //           .validate() &&
                      //       controller.requiredSkills.text.trim().isNotEmpty &&
                      //       controller.shifts.isNotEmpty &&
                      //       controller.formKey.currentState!.validate()) {
                      //     showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         final TextEditingController cardNumberController =
                      //             TextEditingController();
                      //         final TextEditingController
                      //             expiryMonthController =
                      //             TextEditingController();
                      //         final TextEditingController expiryYearController =
                      //             TextEditingController();
                      //         final TextEditingController cvvController =
                      //             TextEditingController();
                      //         final GlobalKey<FormState> formKey =
                      //             GlobalKey<FormState>();
                      //         bool isLoading = false;

                      //         return StatefulBuilder(
                      //           builder: (context, setState) {
                      //             return SingleChildScrollView(
                      //               child: AlertDialog(
                      //                 backgroundColor: AppColors.kDarkestBlue,
                      //                 shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10)),
                      //                 title: Text(
                      //                   "Enter Card Details",
                      //                   style: AppTypography.kBold18
                      //                       .copyWith(color: Colors.white),
                      //                 ),
                      //                 content: Form(
                      //                   key: formKey,
                      //                   child: Column(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       TextFormField(
                      //                         controller: controller
                      //                             .cardNumberController,
                      //                         keyboardType:
                      //                             TextInputType.number,
                      //                         decoration: _inputDecoration(
                      //                             "Card Number",
                      //                             AppAssets.kMail),
                      //                         style: TextStyle(
                      //                             color: AppColors.kWhite),
                      //                         validator: (value) {
                      //                           if (value == null ||
                      //                               value.isEmpty ||
                      //                               value.length < 16) {
                      //                             return "Card Number is required";
                      //                           }
                      //                           return null;
                      //                         },
                      //                       ),
                      //                       SizedBox(
                      //                           height: AppSpacing.tenVertical),
                      //                       TextFormField(
                      //                         controller: controller
                      //                             .cardExpiryMonthController,
                      //                         keyboardType:
                      //                             TextInputType.number,
                      //                         maxLength: 2,
                      //                         decoration: _inputDecoration(
                      //                             "Expiry Month",
                      //                             AppAssets.kMail),
                      //                         style: TextStyle(
                      //                             color: AppColors.kWhite),
                      //                         validator: (value) {
                      //                           if (value == null ||
                      //                               value.isEmpty ||
                      //                               value.length != 2) {
                      //                             return "Expiry Month is required";
                      //                           }
                      //                           return null;
                      //                         },
                      //                       ),
                      //                       SizedBox(
                      //                           height: AppSpacing.tenVertical),
                      //                       TextFormField(
                      //                         controller: controller
                      //                             .cardExpiryYearController,
                      //                         keyboardType:
                      //                             TextInputType.number,
                      //                         maxLength: 4,
                      //                         decoration: _inputDecoration(
                      //                             "Expiry Year",
                      //                             AppAssets.kMail),
                      //                         style: TextStyle(
                      //                             color: AppColors.kWhite),
                      //                         validator: (value) {
                      //                           if (value == null ||
                      //                               value.isEmpty ||
                      //                               value.length != 4) {
                      //                             return "Expiry Year is required";
                      //                           }
                      //                           return null;
                      //                         },
                      //                       ),
                      //                       SizedBox(
                      //                           height: AppSpacing.tenVertical),
                      //                       TextFormField(
                      //                         controller:
                      //                             controller.cardCvvController,
                      //                         keyboardType:
                      //                             TextInputType.number,
                      //                         maxLength: 3,
                      //                         decoration: _inputDecoration(
                      //                             "CVV", AppAssets.kMail),
                      //                         style: TextStyle(
                      //                             color: AppColors.kWhite),
                      //                         validator: (value) {
                      //                           if (value == null ||
                      //                               value.isEmpty) {
                      //                             return "CVV is required";
                      //                           }
                      //                           return null;
                      //                         },
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 actions: [
                      //                   TextButton(
                      //                     onPressed: () {
                      //                       if (Navigator.canPop(context)) {
                      //                         Navigator.pop(context);
                      //                       } else {
                      //                         Get.back();
                      //                       }
                      //                     },
                      //                     child: Text("Cancel",
                      //                         style: TextStyle(
                      //                             color: AppColors.kSkyBlue)),
                      //                   ),
                      //                   ElevatedButton(
                      //                     onPressed: () async {
                      //                       if (formKey.currentState!
                      //                           .validate()) {
                      //                         setState(() {
                      //                           isLoading = true;
                      //                         });
                      //                         await createJob();
                      //                         setState(() {
                      //                           isLoading = false;
                      //                         });
                      //                       } else {
                      //                         Get.snackbar(
                      //                           "Error",
                      //                           "Please fill all the fields",
                      //                           snackPosition:
                      //                               SnackPosition.BOTTOM,
                      //                           backgroundColor:
                      //                               Colors.red.withOpacity(0.8),
                      //                           colorText: Colors.white,
                      //                         );
                      //                       }
                      //                     },
                      //                     style: ElevatedButton.styleFrom(
                      //                       backgroundColor: AppColors.kSkyBlue,
                      //                     ),
                      //                     child: isLoading
                      //                         ? CircularProgressIndicator(
                      //                             color: Colors.white)
                      //                         : Text("Submit"),
                      //                   ),
                      //                 ],
                      //               ),
                      //             );
                      //           },
                      //         );
                      //       },
                      //     );
                      //   } else {
                      //     Get.snackbar(
                      //       "Error",
                      //       "Please fill all the required fields.",
                      //       snackPosition: SnackPosition.BOTTOM,
                      //       backgroundColor: Colors.red.withOpacity(0.8),
                      //       colorText: Colors.white,
                      //     );
                      //   }
                    //  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text("Post Job",
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
    final SetJobDetailsController controller =
        Get.put(SetJobDetailsController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSpacing.fiveVertical,
        ),
        Container(
          padding: EdgeInsets.only(top: 8, right: 8, left: 8),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Row(
                children: [
                  Text("20y",
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kWhite)),
                  Spacer(),
                  Text("30y",
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kWhite)),
                  Spacer(),
                  Text("40y",
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kWhite)),
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
