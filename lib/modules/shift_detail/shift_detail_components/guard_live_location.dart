import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class GuardLiveLocation extends StatelessWidget {
  const GuardLiveLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: AppColors.kDarkBlue,
       body: SafeArea(
        child:SingleChildScrollView(
          child: Column(
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
                  "Guard Live Location",
                  style: AppTypography.kBold20.copyWith(color: AppColors.kWhite),
                ),
              ],
            ),
          ), 
          Padding(
  padding: EdgeInsets.only(left: Get.width * 0.02, right: Get.width * 0.005),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(Get.width * 0.02),
    child: Image.asset(
      'assets/map.png',
      width: double.infinity,
      height: Get.height * 0.85, 
      fit: BoxFit.cover,
    ),
  ),
),

            ],
          ),
        ) 
       ),
    );
  }
}