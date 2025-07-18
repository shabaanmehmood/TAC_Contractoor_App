import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Guard_details/hire-confirmation_bottomsheet.dart';
import 'package:taccontractor/modules/Guard_details/select_job_bottomSheet.dart';

class HireGuardConfirmationBottomSheet extends StatefulWidget {
  const HireGuardConfirmationBottomSheet({super.key});

  @override
  State<HireGuardConfirmationBottomSheet> createState() => _HireGuardConfirmationBottomSheetState();
}

class _HireGuardConfirmationBottomSheetState extends State<HireGuardConfirmationBottomSheet> {
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
          GestureDetector(
            onTap: () {
                  },
            child: Padding(
              padding: EdgeInsets.only(
                left: Get.width * 0.04,
                right: Get.width * 0.04,
                bottom: Get.height * 0.015,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04,
                  vertical: Get.width * 0.03,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kinput.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                ),
                child: Row(
                  children: [
                    // Profile Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Get.width * 0.02),
                      child: Image.asset(
                        'assets/userpicture.jpg',
                        width: Get.width * 0.18,
                        height: Get.width * 0.18,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: Get.width * 0.03),
            
                    // Right content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Badge and verified icon
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.02,
                                  vertical: Get.width * 0.01,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kGuardsCard,
                                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icon/Layer 2.png",
                                      width: Get.width * 0.035,
                                    ),
                                    SizedBox(width: Get.width * 0.01),
                                    Text(
                                      'Leader Guard',
                                      style: AppTypography.kBold10.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: Get.width * 0.015),
                              CircleAvatar(
                                radius: Get.width * 0.03,
                                backgroundColor: AppColors.kGuardsCard,
                                child: Icon(
                                  Icons.verified,
                                  size: Get.width * 0.04,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.005),
            
                          // Name
                          Text(
                            'Johsan Bill',
                            style: AppTypography.kBold18.copyWith(
                              color: AppColors.kWhite,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.003),
            
                          // Level & Rating
                          Row(
                            children: [
                              Text(
                                'Level 2',
                                style: AppTypography.kLight12.copyWith(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              SizedBox(width: Get.width * 0.02),
                              Icon(
                                Icons.star,
                                size: Get.width * 0.06,
                                color: Colors.cyanAccent,
                              ),
                              SizedBox(width: Get.width * 0.01),
                              Text(
                                '5.0',
                                style: AppTypography.kBold12.copyWith(
                                  color: AppColors.kWhite,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
          GestureDetector(
  onTap: () {
  // Close current bottom sheet
  Get.back();

  // Delay to ensure the previous one is fully dismissed
  Future.delayed(const Duration(milliseconds: 200), () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SelectJobBottomSheet(),
    );
  });
},

  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: AppColors.kSkyBlue, width: 2),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Search from open jobs...",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
        ),
        const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white54),
      ],
    ),
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
            onPressed: () {},
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
              onPressed: ( isConfirmed)
                  ? () {
                           showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const HireGuardBottomSheet(),
                        );  
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


