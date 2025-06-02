import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/location/search_location_overlay.dart';
import 'package:taccontractor/widhets/buttons/buttons/buttons.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/TextFormFieldWidget.dart';

class CurrentLocationOverlayController extends GetxController {
  var useCurrentLocation = true.obs;
  void toggleUseCurrentLocation() {
    useCurrentLocation.value = !useCurrentLocation.value;
    update();
  }

  TextEditingController addressController = TextEditingController();
  TextEditingController jobRadiusController = TextEditingController();
}

void showCurrentLocationBottomSheet(BuildContext context) {
  CurrentLocationOverlayController controller = Get.put(CurrentLocationOverlayController());

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    isDismissible: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: AppColors.kDarkBlue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              color: Colors.grey,
              thickness: 5,
              indent: 100,
              endIndent: 100,
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            Row(
              children: [
                Text(
                  "Edit Your Address",
                  style: AppTypography.kBold18.copyWith(
                    color: AppColors.kWhite
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                style: ListTileStyle.list,
                leading: Icon(Icons.location_on_outlined, color: AppColors.kSkyBlue),
                title: Text(
                  "Falcons Solutions Pvt. Ltd.",
                  style: AppTypography.kBold16.copyWith(
                    color: AppColors.kWhite
                  ),
                ),
                subtitle: Text(
                  "Perth, Australia",
                  style: AppTypography.kLight14.copyWith(
                    color: Colors.grey
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    showSearchLocationBottomSheet(context);
                  },
                  child: Text(
                    "Edit",
                    style: AppTypography.kBold18.copyWith(
                      color: AppColors.kSkyBlue
                    ),
                  ),
              ),
            )
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15 ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(31, 41, 55, 1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Use Current Location", style: AppTypography.kBold16.copyWith(
                      color: AppColors.kWhite
                  )),
                  Switch(
                    thumbColor: WidgetStatePropertyAll(Colors.black),
                    value: controller.useCurrentLocation.value,
                    onChanged: (value) {
                      controller.toggleUseCurrentLocation();
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller.addressController,
              cursorColor: AppColors.kSkyBlue,
              cursorErrorColor: Colors.red,
              style: const TextStyle(color: AppColors.kWhite),
              decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
                contentPadding: const EdgeInsets.all(15),
                isDense: true,
                fillColor: AppColors.kWhite,
                hintText: "Floor / Unit",
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: AppSpacing.tenVertical),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: controller.jobRadiusController,
              cursorColor: AppColors.kSkyBlue,
              cursorErrorColor: Colors.red,
              style: const TextStyle(color: AppColors.kWhite),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
                contentPadding: EdgeInsets.all(15),
                isDense: true,
                fillColor: AppColors.kWhite,
                hintText: "Job Search Radius",
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            PrimaryButton(
              text: "Save & Continue",
              onTap: () {
                // Handle save action
                Get.back();
              },
              color: AppColors.kSkyBlue,
            )
          ],
        ),
      );
    },
  );
}

