import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/alerts/notification_view.dart';
import 'package:tac/modules/home/components/search_field.dart';
import 'package:tac/modules/location/current_location_overlay.dart';

import '../../data/data/constants/app_colors.dart';

class CurrentLocationView extends StatefulWidget {
  const CurrentLocationView({super.key});

  @override
  State<CurrentLocationView> createState() => _CurrentLocationViewState();
}

class _CurrentLocationViewState extends State<CurrentLocationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context),
            SizedBox(height: AppSpacing.tenVertical,),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  showCurrentLocationBottomSheet(context);
                },
                child: Image.asset(
                  AppAssets.kMapPicture,
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  int selectedIndex = 0;
}

Widget _appBar(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.fifteenHorizontal),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: (){
            Get.back(
                canPop: true
            );
          },
          label: Text('Current Location', style: AppTypography.kBold18.copyWith(
              color: AppColors.kWhite
          ),),
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey,),
        ),
      ],
    ),
  );
}
