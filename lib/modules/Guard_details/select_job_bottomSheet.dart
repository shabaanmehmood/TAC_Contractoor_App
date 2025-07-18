import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class SelectJobBottomSheet extends StatefulWidget {
  const SelectJobBottomSheet({super.key});

  @override
  State<SelectJobBottomSheet> createState() => _SelectJobBottomSheetState();
}

class _SelectJobBottomSheetState extends State<SelectJobBottomSheet> {
  String? selectedJob;

  final List<Map<String, String>> jobs = [
    {"title": "Corporate Office Security – \$25/hr", "subtitle": "3 Guards Needed"},
    {"title": "Event Security Tech Company – \$12/hr", "subtitle": "5 Guards Needed"},
    {"title": "New Product Launch – \$33/hr", "subtitle": "25 Guards Needed"},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
         color: AppColors.kDarkBlue,
      
        child: Padding(
          padding: EdgeInsets.only(
            left: Get.width * 0.05,
            right: Get.width * 0.05,
            top: Get.height * 0.02,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adapts to content height
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Image.asset(
                          AppAssets.kBack,
                          fit: BoxFit.contain,
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Active Jobs",
                        style: AppTypography.kBold18.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      "Done",
                      style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.kgrey, // Updated to blue border
              ),
              SizedBox(height: Get.height * 0.025),
        
              /// Job List
              ListView.builder(
                itemCount: jobs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  final jobValue = '${job["title"]}-$index';
        
                  return RadioListTile<String>(
                    activeColor: AppColors.kSkyBlue,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: jobValue,
                    groupValue: selectedJob,
                    onChanged: (value) {
                      setState(() {
                        selectedJob = value;
                      });
                    },
                    title: Text(
                      job["title"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Get.width * 0.038,
                      ),
                    ),
                    subtitle: Text(
                      job["subtitle"]!,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: Get.width * 0.035,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
