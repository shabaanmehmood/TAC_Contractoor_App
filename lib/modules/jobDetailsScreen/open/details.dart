import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

import '../../../models/myJobs_model.dart';

Widget openDetailsWidget(MyjobsModel job) {
  return SingleChildScrollView(
    child: Column(
      children: [
         SizedBox(height: Get.height * 0.02),
    
                  // ✅ Fixed: Hired Guards Widget
                  Row(
                    children: [
                     Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.04,
        vertical: Get.width * 0.03,
      ),
      decoration: BoxDecoration(
        color: AppColors.kinput.withOpacity(0.5),
        borderRadius: BorderRadius.circular(Get.width * 0.01),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // align image with text top
        children: [
          // Left side: Text Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (job.noOfGuardsRequired ?? 0).toString(),
                style: AppTypography.kBold24.copyWith(color: AppColors.kSkyBlue),
              ),
              SizedBox(height: 4),
              Text('Guards Required', style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
            ],
          ),
    
          // Right side: Image
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                "assets/userpicture.jpg",
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
    ),
    
    
                  Padding(
    padding: EdgeInsets.symmetric(horizontal: Get.height * 0.01),
    child: Container(
      
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.04,
        vertical: Get.width * 0.03,
      ),
      decoration: BoxDecoration(
        color: AppColors.kinput.withOpacity(0.5),
        borderRadius: BorderRadius.circular(Get.width * 0.01),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // align image with text top
        children: [
          // Left side: Text Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (job.noOfGuardsRequired ?? 0).toString(),
                style: AppTypography.kBold24.copyWith(
                  color: AppColors.kalert,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Positions Open',
                style: AppTypography.kBold14.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
            ],
          ),
    
          // Right side: Image
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                "assets/userpicture.jpg",
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    ),
    ),
    
                    ],
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Container(
                     margin: EdgeInsets.symmetric(
                        horizontal: Get.height * 0.02),
                      padding: EdgeInsets.only(left: Get.width * 0.03,right:Get.width * 0.03,
              top:Get.width * 0.01,bottom: Get.width * 0.01
              ),
             decoration: BoxDecoration(
               color:AppColors.kinput.withOpacity(0.5) ,
              borderRadius: BorderRadius.circular(Get.width * 0.01)
             ),
              width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height * 0.01),
                        Text("Job Description", style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                        SizedBox(height: Get.height * 0.005),
                        Text(job.jobDescription ?? '', style: AppTypography.kBold14.copyWith(color: AppColors.kgrey)),
                        SizedBox(height: Get.height * 0.01),
                        Text("Responsibilities", style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                        SizedBox(height: Get.height * 0.005),
                        Text(job.jobResponsibilities ?? '', style: AppTypography.kBold14.copyWith(color: AppColors.kgrey)),
                      ],
                    ),
                  ),
    
                   SizedBox(height: Get.height * 0.01),
      ],
    ),
  );
}
