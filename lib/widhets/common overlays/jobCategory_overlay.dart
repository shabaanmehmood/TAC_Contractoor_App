import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/jobCategoriesModel.dart';

class JobCategoryController extends GetxController {
  var selectedJobCategoryOption = "".obs;
  var jobCategories = <JobCategoryModel>[].obs;
  var isLoading = false.obs;
  final myApiService = MyApIService();
  final UserController userController = Get.find<UserController>();

  void setJobCategoryOption(String option) {
    selectedJobCategoryOption.value = option;
    debugPrint('Selected Job Category: $option');
  }

  Future<void> fetchJobCategories(String userId) async {
    isLoading.value = true;
    try {
      final response = await myApiService.getJobCategories(userId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonList = jsonMap['data'];
        jobCategories.value = jsonList
            .map((json) => JobCategoryModel.fromJson(json))
            .toList();
      } else {
        jobCategories.clear();
        debugPrint('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      jobCategories.clear();
      debugPrint('Exception: $e');
    }
    isLoading.value = false;
  }
}

void showJobCategoryBottomSheet(BuildContext context, String userId) {
  final JobCategoryController jobCategoryController = Get.put(JobCategoryController());

  // Fetch categories when the bottom sheet opens
  jobCategoryController.fetchJobCategories(userId);

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
          if (jobCategoryController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (jobCategoryController.jobCategories.isEmpty) {
            return Center(child: Text("No categories found", style: TextStyle(color: Colors.white)));
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
                    "Job Category",
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
              // List of categories
              ...jobCategoryController.jobCategories.map((category) =>
                  _buildJobCategoryOption(jobCategoryController, category)
              ).toList(),
            ],
          );
        }),
      );
    },
  );
}

Widget _buildJobCategoryOption(JobCategoryController controller, JobCategoryModel category) {
  return Obx(() => Column(
    children: [
      ListTile(
        title: Text(category.name, style: TextStyle(color: Colors.white)),
        leading: Radio(
          value: category.id,
          groupValue: controller.selectedJobCategoryOption.value,
          onChanged: (val) {
            controller.setJobCategoryOption(val as String);
          },
          activeColor: AppColors.kSkyBlue,
        ),
        onTap: () {
          controller.setJobCategoryOption(category.id);
        },
      ),
      Divider(color: AppColors.kSkyBlue),
    ],
  ));
}
