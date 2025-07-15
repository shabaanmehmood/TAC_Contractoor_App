import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Guard_details/hiring_failed.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/custom_button_with_icon.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/custom_icon_button.dart';

class GuardDetailSucessfullScreen extends StatelessWidget {
  const GuardDetailSucessfullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    "Hiring Successful",
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
             SizedBox(height: Get.height * 0.08),
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
                'Guard Hired Successfully!',
                textAlign: TextAlign.center,
                style: AppTypography.kBold20
                    .copyWith(color: AppColors.kWhite),
              ),
                SizedBox(height: Get.height * 0.02),
              Text(
                "You've successfully hired Michael Richardson. We'll notify him of the assignment.",
                textAlign: TextAlign.center,
                style: AppTypography.kLight16
                    .copyWith(color: AppColors.kgrey),
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
              Container(
                margin: EdgeInsets.all(Get.width * 0.03),
                padding: EdgeInsets.all(Get.width * 0.03),
                decoration: BoxDecoration(
                  color: AppColors.kinput.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Get.width * 0.008),
                
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: Get.width * 0.005),
                     Text(
                          'Job Title',
                          style: AppTypography.kBold14
                              .copyWith(color: AppColors.kgrey),
                        ),
                         SizedBox(height: Get.width * 0.003),
                         Text(
                          'Security Escort for Actor – Airport to Residence',
                          style: AppTypography.kLight14
                              .copyWith(color: AppColors.kWhite),
                        ),
                   
                   
                    SizedBox(height: Get.width * 0.015),
                    Text(
                      'Start Date',
                      style: AppTypography.kBold14
                          .copyWith(color: AppColors.kgrey),
                    ),
                     SizedBox(height: Get.width * 0.015),
                    Text(
                      'Immediate',
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kWhite),
                    ),
                       
                  ],
                ),
              ),
              SizedBox(height:  Get.width * 0.04),
              Padding(
                padding: EdgeInsets.only( left: Get.height * 0.02,right: Get.height * 0.02),
          
                child: OutlinedButton(
                  onPressed: (){
                    Get.to(GuardHiringFailedScreen());      
                  },
                  style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.kSkyBlue), // Sky Blue border
                          foregroundColor: Colors.white, // Text and icon color
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                             
                          children: 
                 [
                   Text(
                      'Open Job',
                      style: AppTypography.kBold17
                          .copyWith(color: AppColors.kSkyBlue),
                    ),
                   
                    Icon(Icons.keyboard_arrow_right, color: AppColors.kSkyBlue,size:Get.width * 0.08),
                    
                  ]
                             
                  ),
                ),
              ),
              SizedBox(height:  Get.width * 0.04),
             Container(
              margin: EdgeInsets.all(Get.width * 0.03),
              child: CustomButtonWithIcon(
            title: "Back to Guards",
            onTap: () {
             Get.back();
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
      ),
    );
  }
}
