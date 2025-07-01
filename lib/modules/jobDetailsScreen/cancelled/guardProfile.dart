import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class CancelledGuardProfileScreen extends StatelessWidget {
  const CancelledGuardProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.02),

              /// Header
              Padding(
               padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Guard Profile", style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
                    GestureDetector(
                       onTap: () {
                        Navigator.pop(context);
                },
                      child: Text("View Profile", style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue))),
                  ],
                ),
              ),

              SizedBox(height: Get.height * 0.015),
              Container(
                width: double.infinity,
                height: Get.width * 0.002,
                color: AppColors.kgrey,
              ),
              SizedBox(height: Get.height * 0.02),

              /// Guard Card
              Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    Image.asset("assets/icon/Layer 2.png", width: Get.width * 0.035),
                                    SizedBox(width: Get.width * 0.01),
                                    Text('Leader Guard', style: AppTypography.kBold10.copyWith(color: Colors.white)),
                                  ],
                                ),
                              ),
                              SizedBox(width: Get.width * 0.015),
                              CircleAvatar(
                                radius: Get.width * 0.03,
                                backgroundColor: AppColors.kGuardsCard,
                                child: Icon(Icons.verified, size: Get.width * 0.04, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.005),
                          Text('Johsan Bill', style: AppTypography.kBold18.copyWith(color: AppColors.kWhite)),
                          SizedBox(height: Get.height * 0.003),
                          Row(
                            children: [
                              Text('Level 2', style: AppTypography.kLight12.copyWith(color: Colors.grey.shade400)),
                              SizedBox(width: Get.width * 0.02),
                              Icon(Icons.star, size: Get.width * 0.06, color: Colors.cyanAccent),
                              SizedBox(width: Get.width * 0.01),
                              Text('5.0', style: AppTypography.kBold12.copyWith(color: AppColors.kWhite)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Get.height * 0.02),

              /// Assigned Location
              Container(
                 margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                width: double.infinity,
                padding: EdgeInsets.all(Get.width * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.kinput.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Assigned Location", style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.kgrey, size: Get.width * 0.05),
                        SizedBox(width: Get.width * 0.02),
                        Expanded(
                          child: Text(
                            "2972 Westheimer Rd. Santa Ana, Illinois 85486",
                            style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: Get.height * 0.02),

              /// Performance Stats
              Container(
                 margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                width: double.infinity,
                padding: EdgeInsets.all(Get.width * 0.04),
                decoration: BoxDecoration(
                  color: AppColors.kinput.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Performance Stats", style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                    SizedBox(height: Get.height * 0.02),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: Get.height * 0.015,
                      crossAxisSpacing: Get.width * 0.03,
                      childAspectRatio: 2,
                      children: [
                        _buildStatCard("Punctuality Rate", "100%"),
                        _buildStatCard("Absents", "0"),
                        _buildStatCard("Total Hours", "186 Hrs."),
                        _buildStatCard("Total Earning Till Now", "\$500"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(Get.width * 0.035),
      decoration: BoxDecoration(
        border: Border.all(width: Get.width * 0.001, color: AppColors.kWhite.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Add this to avoid overflow in child
        children: [
          Text(title, style: AppTypography.kLight11.copyWith(color: AppColors.kWhite)),
          SizedBox(height: Get.height * 0.008),
          Text(value, style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
        ],
      ),
    );
  }
}
