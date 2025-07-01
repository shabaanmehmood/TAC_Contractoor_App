import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

import '../../../models/myJobs_model.dart';
import '../../jobDetailsScreen/inProgress/jobDetailsScreen.dart';
 
 Widget jobInProgressCardWidget({required MyjobsModel job}) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ContractorInprogressJobDetailsScreen(
          job: job,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(left: Get.width * 0.04),
        padding: EdgeInsets.all(Get.width * 0.04),
        decoration: BoxDecoration(
           border: Border.all(
            width: Get.width * 0.005,
            color: AppColors.kalert.withOpacity(0.6),
          ),
          color: AppColors.kalert.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.jobTitle,
                    style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                  ),
                ),
                Text(
                  'CHECK',
                  style: AppTypography.kBold16.copyWith(color: AppColors.kalert),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.01),

            /// Location & Radius
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.kgrey, size: 18),
                SizedBox(width: 5),
                Text(
                  job.jobLocation,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                ),
                Spacer(),
                Text(
                  job.premisesTypeName,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.008),

            /// Date & Time
            Row(
              children: [
                Image.asset("assets/icon/jobCalender.png",scale: Get.width * 0.0025,color: AppColors.kgrey),

                SizedBox(width: 5),
                Text(
                  job.shifts[0].date,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                ),
                Spacer(),
                    Image.asset("assets/icon/time.png",scale: Get.width * 0.0025,color: AppColors.kgrey),

                SizedBox(width: 5),
                Text(
                  '${job.shifts[0].startTime} - ${job.shifts[0].endTime}',
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.015),

            Container(
              padding: EdgeInsets.only(left: Get.width * 0.03,right:Get.width * 0.03,
              top:Get.width * 0.01,bottom: Get.width * 0.01
              ),
             decoration: BoxDecoration(
               color:AppColors.kInProgressCard.withOpacity(0.3) ,
              borderRadius: BorderRadius.circular(Get.width * 0.01)
             ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
              job.shifts[0].timePeriod! == "AM" ? "Morning Shift" : "Evening Shift",
                          style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                        ),

                Row(
                  children: [
              Image.asset("assets/icon/time.png",scale: Get.width * 0.0025,color: AppColors.kWhite),
               SizedBox(width: 3),
                Text(
                  job.shifts[0].startTime,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                ),
                  ],
                )

                ],
              ),
            ),
             SizedBox(height:  Get.width * 0.03,),
            Container(
        padding: EdgeInsets.only(
      left: Get.width * 0.03,
      right: Get.width * 0.03,
      top: Get.width * 0.01,
      bottom: Get.width * 0.02,
        ),
        decoration: BoxDecoration(
      color: AppColors.kInProgressCard,
      borderRadius: BorderRadius.circular(Get.width * 0.01),
        ),
        width: double.infinity,
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Wrapping text that can go to second line
        Expanded(
          child: Text(
            "Guard waiting for clock in approval. Open to accept.",
            style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
        ),
        SizedBox(width: Get.width * 0.03),
       CircleAvatar(
        radius: 15,
        backgroundColor: Colors.transparent, // optional if you want no background
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


          ],
        ),
      ),
    );
  }