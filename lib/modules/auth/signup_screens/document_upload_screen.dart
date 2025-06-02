import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/auth/signup_screens/set_pass.dart';

import '../../../widhets/common overlays/uploadFile_overlay.dart';

class DocumentInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passport = TextEditingController();
  final securityLicense = TextEditingController();
  final visaForWorkingRights = TextEditingController();
  final abn = TextEditingController();
  final nationalCrimePoliceCheck = TextEditingController();
  final whiteCard = TextEditingController();

  final RxString passportFile = "".obs;
  final RxString securityLicenseFile = "".obs;
  final RxString visaForWorkingRightsFile = "".obs;
  final RxString abnFile = "".obs;
  final RxString nationalCrimePoliceCheckFile = "".obs;
  final RxString whiteCardFile = "".obs;
}

class DocumentInfoScreen extends StatelessWidget {
  DocumentInfoScreen({super.key});
  final DocumentInfoController controller = Get.put(DocumentInfoController());
  final uploadFileController = UploadFileController();

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
              // Header
              Row(
                children: [
                  Image.asset(AppAssets.kTacLogo, height: 50),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Create Account",
                          style: AppTypography.kBold20
                              .copyWith(color: AppColors.kWhite)),
                      Text("Get Yourself Registered",
                          style: AppTypography.kLight14
                              .copyWith(color: AppColors.ktextlight)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: const [
                  StepTab(title: "Company Info", isCompleted: true,),
                  StepTab(title: "Documents", isCurrent: true,),
                  StepTab(title: "Set Password"),
                ],
              ),

              const SizedBox(height: 25),
              Text("Documents",
                  style: AppTypography.kBold16.copyWith(color: Colors.white)),
              const SizedBox(height: 20),

              // Document Upload List
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        _DocumentTile(
                          title: "Passport",
                          controller: controller.passport,
                          filePath: controller.passportFile,
                          onTap: () async {
                            String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: true);
                            if (path != null) {
                              controller.passport.text = path;
                              controller.passportFile.value = path;
                            }
                          },
                          onChanged: (_) => controller.formKey.currentState?.validate(),
                          isRequired: true,
                        ),
                        _DocumentTile(
                          title: "Security License",
                          controller: controller.securityLicense,
                          filePath: controller.securityLicenseFile,
                          onTap: () async {
                            String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: true);
                            if (path != null) {
                              controller.securityLicense.text = path;
                              controller.securityLicenseFile.value = path;
                            }
                          },
                          onChanged: (_) => controller.formKey.currentState?.validate(),
                          isRequired: true,
                        ),
                        _DocumentTile(
                          title: "Visa for Working Rights",
                          controller: controller.visaForWorkingRights,
                          filePath: controller.visaForWorkingRightsFile,
                          onTap: () async {
                            String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: true);
                            if (path != null) {
                              controller.visaForWorkingRights.text = path;
                              controller.visaForWorkingRightsFile.value = path;
                            }
                          },
                          onChanged: (_) => controller.formKey.currentState?.validate(),
                          isRequired: true,
                        ),
                        _DocumentTile(
                          title: "ABN",
                          controller: controller.abn,
                          filePath: controller.abnFile,
                          onTap: () async {
                            String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: true);
                            if (path != null) {
                              controller.abn.text = path;
                              controller.abnFile.value = path;
                            }
                          },
                          onChanged: (_) => controller.formKey.currentState?.validate(),
                          isRequired: false,
                        ),
                        _DocumentTile(
                          title: "National Crime Police Check",
                          controller: controller.nationalCrimePoliceCheck,
                          filePath: controller.nationalCrimePoliceCheckFile,
                          onTap: () async {
                            String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: true);
                            if (path != null) {
                              controller.nationalCrimePoliceCheck.text = path;
                              controller.nationalCrimePoliceCheckFile.value = path;
                            }
                          },
                          onChanged: (_) => controller.formKey.currentState?.validate(),
                          isRequired: true,
                        ),
                        _DocumentTile(
                          title: "White Card",
                          controller: controller.whiteCard,
                          filePath: controller.whiteCardFile,
                          onTap: () async {
                            String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true, showPickFileOption: true);
                            if (path != null) {
                              controller.whiteCard.text = path;
                              controller.whiteCardFile.value = path;
                            }
                          },
                          onChanged: (_) => controller.formKey.currentState?.validate(),
                          isRequired: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Divider(color: AppColors.ktextlight, height: 1),
              const SizedBox(height: 14),

              // Navigation Buttons
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.kSkyBlue, width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Back", style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          Get.to(() => SetPasswordScreen());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("Proceed to Password Setup", style: AppTypography.kBold14.copyWith(color: Colors.black)),
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

class _DocumentTile extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool isRequired;
  final RxString? filePath;

  const _DocumentTile({
    required this.title,
    this.onTap,
    this.controller,
    this.onChanged,
    this.isRequired = false,
    this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.kDarkBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: title,
                    style: AppTypography.kBold14.copyWith(
                      color: AppColors.kWhite,
                      fontSize: 12,
                    ),
                    children: isRequired
                        ? [
                      TextSpan(
                        text: '  Required*',
                        style: AppTypography.kLight14.copyWith(
                          color: AppColors.kRed,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      )
                    ]
                        : [],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Size limit or hint text comes here.",
                  style: AppTypography.kLight14.copyWith(
                    color: AppColors.kinput,
                    fontSize: 12,
                  ),
                ),
                TextFormField(
                  controller: controller,
                  style: const TextStyle(color: Colors.transparent),
                  validator: (value) {
                    if (isRequired && (value == null || value.isEmpty)) {
                      return "This field is required";
                    }
                    return null;
                  },
                  onChanged: onChanged,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Obx(() => Text(
              filePath?.value.isNotEmpty == true ? "File Selected" : "Upload",
              style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
            )),
          ),
        ],
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
