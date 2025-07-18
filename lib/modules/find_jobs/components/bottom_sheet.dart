import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

void showFilterSortBottomSheet(BuildContext context, Function(String) onSelected) {
  final options = [
    'Highest to Lowest Rating',
    'Lowest to Highest Rating',
    'Most Relevant',
    'Most Recent',
  ];

  int selectedIndex = 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: AppColors.kDarkBlue,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06,
              vertical: Get.height * 0.03,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sort By",
                      style: AppTypography.kBold18.copyWith(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        onSelected(options[selectedIndex]);
                        Get.back();
                      },
                      child: Text(
                        "Done",
                        style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.02),
                Divider(color: Colors.white38, thickness: 1),
                SizedBox(height: Get.height * 0.01),

                /// Options with Divider
                ...List.generate(options.length, (index) {
                  return Column(
                    children: [
                      RadioListTile(
                        value: index,
                        groupValue: selectedIndex,
                        activeColor: AppColors.kSkyBlue,
                        onChanged: (val) {
                          setState(() {
                            selectedIndex = val!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          options[index],
                          style: AppTypography.kBold14.copyWith(color: Colors.white),
                        ),
                      ),
                      if (index < options.length - 1)
                        Divider(
                          color: AppColors.kSkyBlue.withOpacity(0.5),
                          thickness: 1,
                          indent: Get.width * 0.02,
                          endIndent: Get.width * 0.02,
                        ),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      );
    },
  );
}
