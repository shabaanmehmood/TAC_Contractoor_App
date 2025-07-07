import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/custom_button_with_icon.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/custom_icon_button.dart';

import '../../models/myJobs_model.dart';

class ContractorReviewSubmittedScreen extends StatelessWidget {
  final MyjobsModel job;
  final double rating;
  final String review;
  ContractorReviewSubmittedScreen({super.key, required this.job, required this.rating, required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
            padding: EdgeInsets.only(top: Get.height * 0.02, left: Get.height * 0.02),
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                   Get.back();
                  },
                  child: Image.asset(
                    AppAssets.kBack,
                    height: Get.height * 0.07,
                    width: Get.width * 0.07,
                    fit: BoxFit.contain,
                    color: AppColors.kgrey,
                  ),
                ),
                SizedBox(width: Get.width * 0.04),
                Text(
                  "Share Your Review",
                  style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                ),
              ],
            ),
          ),

          /// Divider
          Container(
            width: double.infinity,
            height: Get.width * 0.002,
            color: AppColors.kgrey,
          ),
           SizedBox(height: Get.height * 0.15),
            Container(
              padding: EdgeInsets.all(Get.width * 0.01),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Get.width * 0.008),
                color: AppColors.kgreenCard.withOpacity(0.5)

              ),
              child: Icon(Icons.check,
                  size: Get.width * 0.14, color: Colors.greenAccent),
            ),
             SizedBox(height: Get.height * 0.03),
            Text(
              'Your review has been\nsuccessfully submitted!',
              textAlign: TextAlign.center,
              style: AppTypography.kBold20
                  .copyWith(color: AppColors.kWhite),
            ),
            SizedBox(height: Get.height * 0.03),
            Container(
              margin: EdgeInsets.all(Get.width * 0.03),
              padding: EdgeInsets.only(left: Get.width * 0.015,right: Get.width * 0.015,top: Get.width * 0.003,bottom: Get.width * 0.003),
              decoration: BoxDecoration(
                color: AppColors.kinput.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Get.width * 0.008),
              
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        job.jobTitle,
                        style: AppTypography.kLight12
                            .copyWith(color: AppColors.kWhite),
                      ),
                       SizedBox(width: Get.width * 0.003),
                  Row(
                    children: [
                      Icon(Icons.star,
                          size: Get.width * 0.06, color: AppColors.kSkyBlue),
                      SizedBox(width: Get.width * 0.003),
                      Text(                          rating.toString(),
                          style: AppTypography.kLight12
                              .copyWith(color: AppColors.kWhite)),
                    ],
                  ),
                    ],
                  ),
                 
                  SizedBox(height: Get.width * 0.015),
                  Text(
                    review,
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kgrey),
                  ),
                ],
              ),
            ),
            SizedBox(height:  Get.width * 0.04),
           Container(
            margin: EdgeInsets.all(Get.width * 0.03),
            child: CustomButtonWithIcon(
  title: "Back to Jobs",
  onTap: () {
    // Your navigation logic here
  },
  
  icon: Icons.arrow_back_ios,         // Pass icon data directly
  iconOnRight: false,                 // Icon on left (default)
  backgroundColor:AppColors.kSkyBlue,      // Optional: set button color
)
           )
            // CustomIconButton(
            //   color: AppColors.kPrimary,
            //   icon: Icon(Icons.arrow_back_ios),
            // iconColor: AppColors.kBlack,
            //   size:Get.width * 0.04 ,

            //   onTap: (){

            // }),
            // ElevatedButton(
            //   onPressed: () {
            //     Get.back(); // Back to Jobs
            //   },
            //   style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColors.kSkyBlue,
            //       padding: EdgeInsets.symmetric(
            //           vertical: 14, horizontal: 32),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10))),
            //   child: Text('Back to Jobs',
            //       style: AppTypography.kBold16
            //           .copyWith(color: AppColors.kBlack)),
            // ),
          ],
        ),
      ),
    );
  }
}
