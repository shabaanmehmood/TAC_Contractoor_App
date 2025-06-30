import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/job_model.dart';
import 'package:taccontractor/models/shift_model.dart';
import 'package:taccontractor/models/signUpModelForContractor.dart';
import 'package:taccontractor/modules/Jobs/Create%20Jobs/job_posted_screen.dart';
import 'package:taccontractor/modules/account/account.dart';
import 'package:taccontractor/modules/auth/signup_screens/document_upload_screen.dart';

import '../../../dataproviders/api_service.dart';
import '../../../models/createJobModel.dart';
import '../../../models/preferenceModel.dart';
import '../../../models/requiredLicenseModel.dart';
import '../../../models/required_skills.dart';
import '../../../models/signUpModelForCompany.dart';
import '../../../routes/app_routes.dart';
import '../../../widhets/common widgets/buttons/adaptive_dialogue.dart';
import '../../../widhets/common widgets/buttons/tappableInputTile.dart';
import 'company_info_controller.dart';
import 'job_posted_error.dart';

class RequiredDocsScreen extends StatefulWidget {
  @override
  State<RequiredDocsScreen> createState() => _RequiredDocsScreenState();
}

class _RequiredDocsScreenState extends State<RequiredDocsScreen> {
  final SetJobDetailsController controller = Get.find();

  Future<void> createJob() async {
    if (controller.shifts.isEmpty ||
        controller.selectedLicenses.isEmpty ||
        controller.selectedSkills.isEmpty) {
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
      latitude: '37.4634',
      longitude: '-122.1654',
      reportingManagerNumber: controller.reportingManagerNumber.text,
      reportingManagerName: controller.reportingManager.text,
      minAge: controller.minAge.value.toString(),
      maxAge: controller.maxAge.value.toString(),
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
      SkillIds: controller.selectedSkills
          .map((skill) => SkillModel(id: skill.id))
          .toList(),
      shifts: controller.shifts.toList(),
      preferences: Preferences(
        minYearsExperience: controller.minExperience.value,
        maxYearsExperience: controller.maxExperience.value,
        appearanceRequirements: controller.jobAppearance.text,
      ),
      // Other fields...
    );

    final response = await MyApIService().createJob(job);
    if (response.statusCode == 201) {
      Get.offAll(() => AccountScreen());
    } else {
      Get.snackbar("Error", "Job creation failed");
    }
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
                  ),
                  const SizedBox(width: 10),
                  Text("Create New Job", style: AppTypography.kBold24.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  StepTab(title: "Job Details", isCompleted: true),
                  StepTab(title: "Preferences", isCompleted: true,),
                  StepTab(title: "Required Docs", isCurrent: true,),
                ],
              ),
              const SizedBox(height: 20),
              Text("Set Required Docs",
                  style: AppTypography.kBold20.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKeyfordocs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.passport.value = value ?? false;
                          },
                          value: controller.passport.value,
                          title: Text(
                            'Passport',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.visaWorkingRights.value = value ?? false;
                          },
                          value: controller.visaWorkingRights.value,
                          title: Text(
                            'Visa',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.abn.value = value ?? false;
                          },
                          value: controller.abn.value,
                          title: Text(
                            'ABN',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.nationalCrimeCheck.value = value ?? false;
                          },
                          value: controller.nationalCrimeCheck.value,
                          title: Text(
                            'National Crime Police Check',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.faceVideoSelfie.value = value ?? false;
                          },
                          value: controller.faceVideoSelfie.value,
                          title: Text(
                            'Face Video Selfie',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.securityLicense.value = value ?? false;
                          },
                          value: controller.securityLicense.value,
                          title: Text(
                            'Security License',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.whiteCard.value = value ?? false;
                          },
                          value: controller.whiteCard.value,
                          title: Text(
                            'White Card',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.rSA.value = value ?? false;
                          },
                          value: controller.rSA.value,
                          title: Text(
                            'RSA',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.blueCard.value = value ?? false;
                          },
                          value: controller.blueCard.value,
                          title: Text(
                            'Blue Card',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.marineCardForPortSecurities.value = value ?? false;
                          },
                          value: controller.marineCardForPortSecurities.value,
                          title: Text(
                            'Maritime Card for Port Securities',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.yellowCard.value = value ?? true;
                          },
                          value: controller.yellowCard.value,
                          title: Text(
                            'Yellow Card',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.driverLicense.value = value ?? false;
                          },
                          value: controller.driverLicense.value,
                          title: Text(
                            'Driver License',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppColors.kSkyBlue,
                          onChanged: (value) {
                            controller.cPrValid.value = value ?? false;
                          },
                          value: controller.cPrValid.value,
                          title: Text(
                            'CPR Valid',
                            style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                          ),
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
                      // onPressed: (){
                      //   // Get.to(JobPostedScreen(
                      //   //   message: "Your Job has been Posted!",
                      //   //   jobdata: JobData(
                      //   //     id: "12345",
                      //   //     categoryName: "Security",
                      //   //     contractorId: "67890",
                      //   //     contractorName: "John Doe",
                      //   //     createdAt: DateTime.now(),
                      //   //     description: "Security job description",
                      //   //     jobSOPs: "Standard Operating Procedures for the job",
                      //   //     latitude: "37.7749",
                      //   //     leaderRequired: 1,
                      //   //     location: "San Francisco",
                      //   //     longitude: "-122.4194",
                      //   //     noOfGuardsRequired: 1,
                      //   //     payPerHour: "30",
                      //   //     premisesTypeName: "Office",
                      //   //     responsibilities: "Guarding the premises",
                      //   //     title: "Security Job",
                      //   //     updatedAt: DateTime.now(),
                      //   //     distance: 0.0,
                      //   //     shifts: [
                      //   //       Shift(
                      //   //         days: ["Monday", "Tuesday"],
                      //   //         id: "shift1",
                      //   //         startTime: "08:00",
                      //   //         endTime: "16:00",
                      //   //         date: DateTime.now().toString(),
                      //   //       ),
                      //   //     ],
                      //   //   ),
                      //   // ));
                      //   Get.to(JobPostedScreenError(
                      //     message: "Job Posting Failed!",
                      //     jobData: JobData(
                      //       id: "12345",
                      //       categoryName: "Security",
                      //       contractorId: "67890",
                      //       contractorName: "John Doe",
                      //       createdAt: DateTime.now(),
                      //       description: "Security job description",
                      //       jobSOPs: "Standard Operating Procedures for the job",
                      //       latitude: "37.7749",
                      //       leaderRequired: 1,
                      //       location: "San Francisco",
                      //       longitude: "-122.4194",
                      //       noOfGuardsRequired: 1,
                      //       payPerHour: "30",
                      //       premisesTypeName: "Office",
                      //       responsibilities: "Guarding the premises",
                      //       title: "Security Job",
                      //       updatedAt: DateTime.now(),
                      //       distance: 0.0,
                      //       shifts: [
                      //         Shift(
                      //           days: ["Monday", "Tuesday"],
                      //           id: "shift1",
                      //           startTime: "08:00",
                      //           endTime: "16:00",
                      //           date: DateTime.now().toString(),
                      //         ),
                      //       ],
                      //     ),
                      //   ));
                      // },
                      onPressed: () async {
                        if (controller.formKeyfordocs.currentState!.validate()) {
                          await createJob();
                        } else {
                          Get.snackbar("Error", "Please fill all required fields");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("Post Job",
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