import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Guard_details/successfull_screen.dart';

class HireGuardBottomSheet extends StatefulWidget {
  const HireGuardBottomSheet({super.key});

  @override
  State<HireGuardBottomSheet> createState() => _HireGuardBottomSheetState();
}

class _HireGuardBottomSheetState extends State<HireGuardBottomSheet> {
  String? selectedJob;
  bool isConfirmed = false;

  final List<Map<String, String>> jobs = [
    {"title": "Corporate Office Security – \$25/hr", "subtitle": "3 Guards Needed"},
    {"title": "Corporate Office Security – \$25/hr", "subtitle": "3 Guards Needed"},
    {"title": "Event Security Tech Company – \$12/hr", "subtitle": "5 Guards Needed"},
    {"title": "New Product Launch – \$33/hr", "subtitle": "25 Guards Needed"},
    {"title": "New Product Launch – \$33/hr", "subtitle": "25 Guards Needed"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B2A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
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
          Text(
            "Hire Guard",
            style: TextStyle(
              fontSize: Get.width * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Container(
            width: double.infinity,
            height: Get.width * 0.002,
            color: AppColors.kgrey,
          ),
          SizedBox(height: Get.height * 0.02),
          Text(
            "Select the job you want to hire for.",
            style: TextStyle(
              fontSize: Get.width * 0.045,
              color: Colors.white,
            ),
          ),
          SizedBox(height: Get.height * 0.025),
          TextField(
            decoration: InputDecoration(
              hintText: "Search among open jobs...",
              hintStyle: const TextStyle(color: Colors.white54),
              suffixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: Colors.white10,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.02),

          /// Job List
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                final jobValue = '${job["title"]}-$index'; // Ensure uniqueness

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
          ),

          SizedBox(height: Get.height * 0.01),

          Center(
            child: Text(
              "Or",
              style: TextStyle(color: Colors.white60, fontSize: Get.width * 0.04),
            ),
          ),
          SizedBox(height: Get.height * 0.015),

          /// Create New Job Button
          OutlinedButton(
            onPressed: () {
             
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.kSkyBlue),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.kSkyBlue, size: Get.width * 0.08),
                const SizedBox(width: 8),
                Text(
                  'Create New Job',
                  style: AppTypography.kBold17.copyWith(color: AppColors.kSkyBlue),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.015),

          /// Checkbox
          Row(
            children: [
              Checkbox(
                value: isConfirmed,
                onChanged: (val) {
                  setState(() {
                    isConfirmed = val ?? false;
                  });
                },
                activeColor: AppColors.kSkyBlue,
                side: const BorderSide(color: Colors.white60),
              ),
              Expanded(
                child: Text(
                  "I confirm that I want to hire Michael Richardson.",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.01),

          /// Confirm Hire Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (selectedJob != null && isConfirmed)
                  ? () {
                      Get.to(GuardDetailSucessfullScreen()); // or navigate to success screen
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kSkyBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledBackgroundColor: AppColors.kSkyBlue.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm Hire',
                    style: AppTypography.kBold18.copyWith(color: AppColors.kBlack),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Icon(Icons.check, color: AppColors.kBlack, size: Get.width * 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


