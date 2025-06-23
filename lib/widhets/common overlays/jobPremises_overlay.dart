import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/jobCategoriesModel.dart';

import '../../models/jobPremisesModel.dart';

class JobPremisesController extends GetxController {
  var selectedJobPremisesOption = "".obs;
  var jobCategories = <JobPremisesModel>[].obs;
  var isLoading = false.obs;
  final myApiService = MyApIService();
  final UserController userController = Get.find<UserController>();

  void setJobPremisesOption(String option) {
    selectedJobPremisesOption.value = option;
    debugPrint('Selected Job Category: $option');
  }

  Future<void> fetchJobPremises(String userId) async {
    isLoading.value = true;
    try {
      final response = await myApiService.getJobPremises(userId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonList = jsonMap['data'];
        jobCategories.value = jsonList
            .map((json) => JobPremisesModel.fromJson(json))
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

void showJobPremisesBottomSheet(BuildContext context, String userId) {
  final JobPremisesController jobPremisesController = Get.put(JobPremisesController());

  // Fetch categories when the bottom sheet opens
  jobPremisesController.fetchJobPremises(userId);

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
          if (jobPremisesController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (jobPremisesController.jobCategories.isEmpty) {
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
              ...jobPremisesController.jobCategories.map((category) =>
                  _buildJobPremisesOption(jobPremisesController, category)
              ).toList(),
            ],
          );
        }),
      );
    },
  );
}

Widget _buildJobPremisesOption(JobPremisesController controller, JobPremisesModel category) {
  return Obx(() => Column(
    children: [
      ListTile(
        title: Text(category.name, style: TextStyle(color: Colors.white)),
        leading: Radio(
          value: category.id,
          groupValue: controller.selectedJobPremisesOption.value,
          onChanged: (val) {
            controller.setJobPremisesOption(val as String);
          },
          activeColor: AppColors.kSkyBlue,
        ),
        onTap: () {
          controller.setJobPremisesOption(category.id);
        },
      ),
      Divider(color: AppColors.kSkyBlue),
    ],
  ));
}
