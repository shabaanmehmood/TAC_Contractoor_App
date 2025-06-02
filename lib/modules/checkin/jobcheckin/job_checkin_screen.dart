import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dummy_data.dart';
import 'job_checkin_controller.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/checkin/jobcheckin/job_checkin_screen.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/job_card.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/myJob_card.dart';

class JobCheckinScreen extends StatelessWidget {
  final controller = Get.put(JobCheckinController());

  JobCheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack, width: 24, height: 24),
          onPressed: () => Navigator.of(context).pop(), // or Get.back()
        ),
        title: const Text(
          'Job Details',
          style: TextStyle(color: AppColors.kWhite, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Need Support?',
                style: TextStyle(color: AppColors.kSkyBlue),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    dummyJob['title']!,
                    style: const TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  dummyJob['rate']!,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Job Details Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(dummyJob['name']!,
                          style: const TextStyle(
                              color: AppColors.kWhite,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      Text(dummyJob['role']!,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: AppColors.ktextlight, size: 16),
                      const SizedBox(width: 6),
                      Text(dummyJob['date']!,
                          style: const TextStyle(color: AppColors.ktextlight)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time,
                          color: AppColors.ktextlight, size: 16),
                      const SizedBox(width: 6),
                      Text(dummyJob['time']!,
                          style: const TextStyle(color: AppColors.ktextlight)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        "Job Details",
                        style: TextStyle(
                          color: AppColors.kSkyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        AppAssets.kShare,
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.klightalert,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            size: 14, color: AppColors.kalert),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: const Text(
                            "Job will start once you submit your selfie.",
                            style: TextStyle(
                                color: AppColors.kalert, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Selfie Check-in Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1F2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Take a Selfie for Check-In Verification",
                    style: TextStyle(
                        color: AppColors.kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please take a selfie to confirm your presence at the job location. Ensure your face is clearly visible.",
                    style: TextStyle(color: AppColors.kgrey),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0xFF2E3142),
                          child: Image.asset(
                            AppAssets.kCam,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kSkyBlue,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: controller.takeSelfie,
                              child: Text(
                                controller.isSelfieTaken.value
                                    ? "Selfie Submitted"
                                    : "Take Selfie",
                                style: const TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
