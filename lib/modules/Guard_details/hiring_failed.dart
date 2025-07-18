import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Guard_details/hire-confirmation_bottomsheet.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/custom_button_with_icon.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/custom_icon_button.dart';

class GuardHiringFailedScreen extends StatelessWidget {
  const GuardHiringFailedScreen({super.key});

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
                    "Hiring Failed",
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
                  color: AppColors.kRed.withOpacity(0.5)
          
                ),
                child: Icon(Icons.error_outline,
                    size: Get.width * 0.14, color: AppColors.kRed),
              ),
               SizedBox(height: Get.height * 0.03),
              Text(
                'Hiring Failed!',
                textAlign: TextAlign.center,
                style: AppTypography.kBold20
                    .copyWith(color: AppColors.kWhite),
              ),
                SizedBox(height: Get.height * 0.02),
              Text(
                "We encountered an error while processing your request. Please try again later.",
                textAlign: TextAlign.center,
                style: AppTypography.kLight16
                    .copyWith(color: AppColors.kgrey),
              ),
              SizedBox(height: Get.height * 0.03),
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
                          'Error Code',
                          style: AppTypography.kBold14
                              .copyWith(color: AppColors.kgrey),
                        ),
                         SizedBox(height: Get.width * 0.003),
                         Text(
                          'ERR_NETWORK_FAILED',
                          style: AppTypography.kLight14
                              .copyWith(color: AppColors.kWhite),
                        ),
                   
                   
                    SizedBox(height: Get.width * 0.015),
                    Text(
                      'Suggested Action',
                      style: AppTypography.kBold14
                          .copyWith(color: AppColors.kgrey),
                    ),
                     SizedBox(height: Get.width * 0.015),
                    Text(
                      'Check your internet connection or contact support.',
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
                     
  
                  },
                  style: OutlinedButton.styleFrom(
                     backgroundColor: AppColors.kRed.withOpacity(0.5),
              
                          side:  BorderSide(color: AppColors.kRed.withOpacity(0.5)), // Sky Blue bo
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                             
                          children: 
                 [
                   Text(
                      'Retry',
                      style: AppTypography.kBold18
                          .copyWith(color: AppColors.kRed),
                    ),
                   
                    Icon(Icons.refresh, color: AppColors.kRed,size:Get.width * 0.08),
                    
                  ]
                             
                  ),
                ),
              ),
              SizedBox(height:  Get.width * 0.04),
           
          
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
