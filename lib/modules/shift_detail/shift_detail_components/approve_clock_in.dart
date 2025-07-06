import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/shift_detail/shift_detail_components/guard_live_location.dart';
import 'package:taccontractor/modules/shift_detail/shift_detail_components/reject.dart';
import 'package:taccontractor/widhets/buttons/buttons/custom_text_button.dart';

class ApproveClockIn extends StatelessWidget {
  const ApproveClockIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.kDarkBlue,
       body:SafeArea(
        child:SingleChildScrollView(
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(height: Get.height * 0.04),

              /// Drag Handle
              Center(
                child: Container(
                  width: Get.width * 0.35,
                  height: 6,
                  margin: EdgeInsets.only(bottom: Get.height * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Get.height * 0.02, left: Get.height * 0.02,right: Get.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Approve Clock In",
                      style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                    ),
                       Row(
          children: [
            Image.asset(
              "assets/icon/timer.png",
              scale: Get.width * 0.0025,
              color: AppColors.kblueCard,
            ),
            SizedBox(width: 6),
            Text("12:00",
                style: AppTypography.kBold14
                    .copyWith(color: AppColors.kblueCard)),
          ],
        ),
                  ],
                ),
              ),
                SizedBox(height: Get.height * 0.02),
               Container(
            height: Get.height * 0.008,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.kblueCard.withOpacity(0.3),
              borderRadius: BorderRadius.circular(Get.width * 0.015),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kblueCard,
                  borderRadius: BorderRadius.circular(Get.width * 0.015),
                ),
              ),
            ),
          ),
             SizedBox(height: Get.height * 0.03),
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
          
              SizedBox(height: Get.height * 0.01),
                Padding(
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
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Guard Location",
                        style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                           
                          },
                          child: Container(
                                padding:
                                  EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: Get.width * 0.005),
                                            
                            decoration: BoxDecoration(
                              color: AppColors.kgreen.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(Get.width * 0.04),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                   Icon(Icons.check, color: AppColors.kgreen, size: 18),
                      SizedBox(width: 5),
                                  Text(
                                    "Matched Location",
                                    style: AppTypography.kBold12.copyWith(
                                      color: AppColors.kgreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                       SizedBox(height: Get.height * 0.005),         
                 Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.kgrey, size: 18),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                          style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
                        ),
                      ),
                    ],
                  ),
                            
                                   SizedBox(height: Get.width * 0.02),
                          Stack(
  children: [
    /// Background image
    ClipRRect(
      borderRadius: BorderRadius.circular(Get.width * 0.02),
      child: Image.asset(
        'assets/map.png',
        width: double.infinity,
        height: Get.height * 0.15,
        fit: BoxFit.cover,
      ),
    ),

    /// Button positioned at the bottom center of the image
    Positioned(
      bottom: 12, // space from bottom inside image
      left: 0,
      right: 0,
      child: Center(
        child:Container(
          margin: EdgeInsets.only(left: Get.width * 0.04,right: Get.width * 0.04),
          child: TextButton(
            onPressed: () {
              // Your action here
              Get.to(GuardLiveLocation());
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.kDarkestBlue, // background color
              minimumSize: Size(double.infinity, Get.height * 0.02), // full width and height
              padding: EdgeInsets.symmetric(vertical: Get.width * 0.03),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Get.width * 0.02), // optional rounded corners
              ),
            ),
            child: Text(
              "Track Live Activity",
              style: AppTypography.kBold16.copyWith(
                color: Colors.white, // text color
           
              ),
            ),
          ),
        )

      ),
    ),
  ],
)


                          
                      ],
                    ) ,
                  ),
                ),


                SizedBox(height: Get.height * 0.02),
                Padding(
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
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                                    'Guard Clock In Selfie',
                                    style: AppTypography.kBold16.copyWith(
                                      color: AppColors.kWhite,
                                    ),
                                  ),
                                   SizedBox(height: Get.width * 0.015),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                            child: Image.asset(
                              'assets/icon/Selfie image.png',
                            width: Get.width * 0.4,
                            height: Get.height * 0.18,
                            fit: BoxFit.cover,
                            ),
                          ),
                          
                      ],
                    ) ,
                  ),
                ),
                 /// Buttons Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: Row(
                  children: [
                    /// Cancel Button
                     Expanded(
                      child: GestureDetector(
                        onTap: () {
                         Get.to(RejectingShiftBottomSheet());
                        },
                        child: Container(
                          height: Get.height * 0.07,
                          decoration: BoxDecoration(
                            color: AppColors.kACardCancelled.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                          ),
                          child: Center(
                            child: Text(
                              "Reject",
                              style: AppTypography.kBold16.copyWith(
                                color: AppColors.kACardCancelled,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width * 0.04),

                    /// Cancel Shift Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                      
                        },
                        child: Container(
                          height: Get.height * 0.07,
                          decoration: BoxDecoration(
                            color: AppColors.kgreen.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                          ),
                          child: Center(
                            child: Text(
                              "Approve",
                              style: AppTypography.kBold16.copyWith(
                                color: AppColors.kgreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ) 
       )
    );
  }
}