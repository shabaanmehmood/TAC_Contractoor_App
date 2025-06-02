import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/checkin/jobcheckin/job_checkin_screen.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/job_card.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/myJob_card.dart';
import 'check_in_controller.dart';
import 'dummy_data.dart'; // Import the dummy data file

class CheckInPage extends StatelessWidget {
  final CheckInController controller = Get.put(CheckInController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.kDarkestBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.kJobCardColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confirm Your Check-in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.kTimer,
                            width: 24,
                            height: 24,
                            color: AppColors.kSkyBlue,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '28:10',
                            style: TextStyle(
                              color: AppColors.kSkyBlue,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.1,
                backgroundColor: AppColors.kgshade,
                color: AppColors.kgreen,
                minHeight: 4,
              ),
              SizedBox(height: 20),
              _infoCard(
                title: 'Job Details',
                subtitle: DummyData.jobTitle,
                location: DummyData.jobLocation,
                time: DummyData.jobTime,
              ),
              SizedBox(height: 12),
              _infoCard(
                title: 'Your Location',
                subtitle: '',
                location: DummyData.userLocation,
                match: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: controller.isChecked.value,
                    onChanged: controller.toggleCheck,
                    side: BorderSide(color: AppColors.kSkyBlue),
                    activeColor: AppColors.kSkyBlue,
                  ),
                  Expanded(
                    child: Text(
                      'I acknowledge my duty at this location and understand my responsibilities for this shift.',
                      style:
                          TextStyle(color: AppColors.ktextlight, fontSize: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.kSkyBlue),
                        foregroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      onPressed: () => Get.back(),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 7,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      onPressed: () {
                        if (controller.isChecked.value) {
                          Get.to(JobCheckinScreen());

                          // check-in logic
                        } else {
                          Get.snackbar(
                            "Acknowledgement Required",
                            "Please check the box to confirm.",
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Text('Confirm Check-in'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String subtitle,
    String? location,
    String? time,
    bool match = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              if (match)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('✓ Matched Location',
                      style: TextStyle(color: Colors.green, fontSize: 12)),
                )
            ],
          ),
          if (location != null && location.isNotEmpty) ...[
            SizedBox(height: 8),
            Row(
              children: [
                Image.asset(
                  AppAssets.kLoc,
                  width: 16,
                  height: 16,
                  color: Colors.white60, // Optional tint to match your design
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                )
              ],
            ),
          ],
          if (time != null) ...[
            SizedBox(height: 4),
            Row(
              children: [
                Image.asset(
                  AppAssets.kCal,
                  width: 16,
                  height: 16,
                  color: Colors.white60, // Optional: applies a white tint
                ),
                SizedBox(width: 4),
                Text('Today',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(width: 8),
                Image.asset(
                  AppAssets.kTime,
                  width: 16,
                  height: 16,
                  color: Colors.white60, // Optional: applies a white tint
                ),
                SizedBox(width: 4),
                Text(time,
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            )
          ]
        ],
      ),
    );
  }
}
