import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/models/ReportAnIssue.dart';
import 'package:taccontractor/models/user_model.dart';

import '../../../../../dataproviders/api_service.dart';
import '../../../../../widhets/common overlays/uploadFile_overlay.dart';

class ReportIssueController extends GetxController {
  var selectedImagePath = ''.obs; // Store image path
  var checkboxValue = false.obs;
  TextEditingController subjectController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MyApIService apiService = MyApIService();
  UserController userController = Get.find<UserController>();

  void addReportAnIssue() async {
    try {
      final reportAnIssue = ReportAnIssueModel(
        contractorId: userController.userData!.value!.id!,
        description: descriptionController.text.trim(),
        issueDate: expiryDateController.text.trim(),
        subject: subjectController.text.trim(),
        supportDocuments: selectedImagePath.value.isNotEmpty
            ? [selectedImagePath.value]
            : [],
      );
      final response = await apiService.addReportAnIssue(
        reportAnIssue,
      );

      if (response.statusCode == 201) {
        debugPrint("✅ Report submitted successfully. Response: ${response.body}");
        Get.back(result: true);
      } else {
        debugPrint("❌ Failed to submit report. Status Code: ${response.statusCode}");
        debugPrint("Response Body: ${response.body}");
      }
    } catch (e) {
      debugPrint("🚨 Exception while submitting report: $e");
    }
  }

  void setSelectedImagePath(String path) {
    selectedImagePath.value = path;
    update();
  }

}

class ReportIssueScreen extends StatelessWidget {

  final ReportIssueController controller = Get.put(ReportIssueController());
  final UploadFileController uploadFileController = Get.put(UploadFileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: Text(
          'Report an Issue',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: AppColors.kinput, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Details",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(height: 16),
                  buildTextField(Icons.warning_amber_rounded, "Subject", (){}, controller.subjectController),
                  SizedBox(height: 16),
                  buildTextField(Icons.calendar_month_rounded, "Issue Date", () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2200),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: AppColors.kDarkestBlue,
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.kSkyBlue,
                              onPrimary: Colors.black,
                              surface: AppColors.kDarkestBlue,
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors
                                    .kSkyBlue, // Button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null && picked != DateTime.now()) {
                      controller.expiryDateController.text = picked.toIso8601String().split('T').first;
                    }
                  }, controller.expiryDateController),
                  SizedBox(height: 16),
                  buildTextField(Icons.edit_note_rounded,
                      "Please describe your issue in detail. Include any error messages or specific steps to reproduce the problem.", (){}, controller.descriptionController),
                  SizedBox(height: 24),
                  Text("Supporting Documents",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.kinput),
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.kDarkestBlue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Attach Doc  ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Optional",
                                    style: TextStyle(
                                      color: AppColors.kalert,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true);
                                if (path != null) {
                                  controller.setSelectedImagePath(path);
                                }
                              },
                              child: Obx(() => Text(
                                controller.selectedImagePath!.value.isNotEmpty
                                    ? "File Selected"
                                    : "Upload",
                                style: TextStyle(
                                  color: AppColors.kSkyBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              )),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Min 10MB, Upload only PDF, DOC, DOCX, JPG, PNG",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.kinput,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: AppColors.kinput, height: 1),
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
            color: AppColors.kDarkestBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(() => Checkbox(
                      value: controller.checkboxValue.value,
                      onChanged: (value) {
                        controller.checkboxValue.value = value!;
                      },
                      activeColor: AppColors.kSkyBlue,
                      checkColor: Colors.white,
                    ),),
                    Expanded(
                      child: Text(
                        "I confirm that all information provided is accurate and true to the best of my knowledge",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 4, // 40%
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.kSkyBlue),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.kDarkestBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.kSkyBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 6, // 60%
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (controller.checkboxValue.isTrue && controller.subjectController.text.isNotEmpty && controller.expiryDateController.text.isNotEmpty && controller.descriptionController.text.isNotEmpty) {
                            controller.addReportAnIssue();
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please tick the checkbox",
                              backgroundColor: AppColors.kalert,
                              colorText: Colors.white,
                            );
                          }
                        },
                        icon: Icon(Icons.send, color: Colors.white, size: 18),
                        label: Text("Submit Issue",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kSkyBlue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(IconData icon, String hint, Function? onTap, TextEditingController? controller) {
    return TextFormField(
      controller: controller,
      onTap: () => onTap?.call(),
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.kinput),
        hintText: hint,
        hintMaxLines: 4,
        hintStyle: TextStyle(color: AppColors.kinput),
        filled: false,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kinput),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
      ),
    );
  }
}
