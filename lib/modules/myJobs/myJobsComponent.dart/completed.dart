import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/feedback/SubmitReviewScreen.dart';
import 'package:taccontractor/modules/jobDetailsScreen/completed/jobDetailsScreen.dart';

import '../../../models/myJobs_model.dart';

Widget jobCompletedCardWidget({required MyjobsModel job}) {
  return GestureDetector(
    onTap: () {
      Get.to(() => ContractorCompletedJobDetailsScreen(
            job: job,
          ));
    },
    child: Container(
      margin: EdgeInsets.only(left: Get.width * 0.04),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.kCard.withOpacity(0.9),
        border: Border.all(
          width: Get.width * 0.001,
          color: AppColors.kgrey,
        ),
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
                  style:
                      AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                ),
              ),
              Text(
                '\$${job.payPerHour}/hr',
                style: AppTypography.kBold18.copyWith(color: Colors.cyanAccent),
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
              Image.asset("assets/icon/jobCalender.png",
                  scale: Get.width * 0.0025, color: AppColors.kgrey),
              SizedBox(width: 5),
              Text(
                job.shifts[0].date,
                style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
              ),
              Spacer(),
              Image.asset("assets/icon/time.png",
                  scale: Get.width * 0.0025, color: AppColors.kgrey),
              SizedBox(width: 5),
              Text(
                '${job.shifts[0].startTime.substring(0, 5)} - ${job.shifts[0].endTime.substring(0, 5)}',
                style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.015),

          Container(
            padding: EdgeInsets.only(
                left: Get.width * 0.03,
                right: Get.width * 0.03,
                top: Get.width * 0.01,
                bottom: Get.width * 0.01),
            decoration: BoxDecoration(
                color: AppColors.kinput.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Get.width * 0.01)),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Guards",
                  style: AppTypography.kBold14.copyWith(color: AppColors.kgrey),
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors
                              .transparent, // optional if you want no background
                          child: ClipOval(
                            child: Image.asset(
                              "assets/userpicture.jpg",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.04),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors
                                .transparent, // optional if you want no background
                            child: ClipOval(
                              child: Image.asset(
                                "assets/userpicture.jpg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        //  Padding(
                        //    padding:  EdgeInsets.only(left:Get.width * 0.08,),
                        //    child: CircleAvatar(
                        //         backgroundColor: AppColors.kSkyBlue,
                        //         radius: 15,
                        //         child: Icon(Icons.person,
                        //         color: AppColors.kBlack,
                        //                      size: Get.width * 0.05,)),
                        //  )

                        Padding(
                          padding: EdgeInsets.only(
                            left: Get.width * 0.08,
                          ),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors
                                .transparent, // optional if you want no background
                            child: ClipOval(
                              child: Image.asset(
                                "assets/userpicture.jpg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: Get.width * 0.03,
          ),
          Container(
            padding: EdgeInsets.only(
                left: Get.width * 0.03,
                right: Get.width * 0.03,
                top: Get.width * 0.01,
                bottom: Get.width * 0.01),
            decoration: BoxDecoration(
                color: AppColors.kinput.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Get.width * 0.01)),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job.shifts[0].timePeriod! == "AM" ? "Morning" : "Evening",
                  style: AppTypography.kBold14.copyWith(color: AppColors.kgrey),
                ),

                // Icon(Icons.access_time, color: AppColors.kgrey, size: 18),
                Row(
                  children: [
                    Image.asset("assets/icon/time.png",
                        scale: Get.width * 0.0025, color: AppColors.kgrey),
                    SizedBox(width: 3),
                    Text(
                      '${job.shifts[0].startTime.substring(0, 5)} - ${job.shifts[0].endTime.substring(0, 5)}',
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors
                              .transparent, // optional if you want no background
                          child: ClipOval(
                            child: Image.asset(
                              "assets/userpicture.jpg",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.04),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors
                                .transparent, // optional if you want no background
                            child: ClipOval(
                              child: Image.asset(
                                "assets/userpicture.jpg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        //  Padding(
                        //    padding:  EdgeInsets.only(left:Get.width * 0.08,),
                        //    child: CircleAvatar(
                        //         backgroundColor: AppColors.kSkyBlue,
                        //         radius: 15,
                        //         child: Icon(Icons.person,
                        //         color: AppColors.kBlack,
                        //                      size: Get.width * 0.05,)),
                        //  )

                        Padding(
                          padding: EdgeInsets.only(
                            left: Get.width * 0.08,
                          ),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors
                                .transparent, // optional if you want no background
                            child: ClipOval(
                              child: Image.asset(
                                "assets/userpicture.jpg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: Get.width * 0.03,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Get.to(() => ContractorSubmitReviewScreen(
                  job: job,
                ));
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.kACardSurface, // Inside fill
                side: BorderSide(color: AppColors.kSkyBlue), // Border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04,
                  vertical: Get.width * 0.015,
                ),
              ),
              child: Text(
                "Share Feedback",
                style: AppTypography.kBold18.copyWith(
                  color: AppColors.kSkyBlue, // Text color
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
