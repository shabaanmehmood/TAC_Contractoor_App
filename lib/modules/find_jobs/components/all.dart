import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/find_jobs/components/dummy_data.dart';

class FilteredGuards extends StatelessWidget {
  final String type;

  const FilteredGuards({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Filter logic based on type (All, Armed, Event, Corporate)
    final filteredGuards = type == "All"
        ? dummyGuards
        : dummyGuards.where((guard) => guard["type"] == type).toList();

    if (filteredGuards.isEmpty) {
      return Center(
        child: Text(
          "No guards available.",
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredGuards.length,
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
      itemBuilder: (context, index) {
        final guard = filteredGuards[index];
        final String name = guard["name"];
        final String image = guard["image"];
        final String role = guard["role"];
        final String level = guard["level"];
        final double rating = guard["rating"];
        final bool verified = guard["verified"];

        return Padding(
          padding: EdgeInsets.only(
              // left: Get.width * 0.04,
              // right: Get.width * 0.04,
              bottom: Get.height * 0.015),
          child: Container(
            padding: EdgeInsets.all(Get.width * 0.03),
            decoration: BoxDecoration(
              color: AppColors.kinput.withOpacity(0.5),
              borderRadius: BorderRadius.circular(Get.width * 0.02),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                  child: Image.asset(
                    image,
                    width: Get.width * 0.18,
                    height: Get.width * 0.18,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: Get.width * 0.03),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.02,
                                    vertical: Get.width * 0.01),
                                decoration: BoxDecoration(
                                  color: AppColors.kGuardsCard,
                                  borderRadius:
                                      BorderRadius.circular(Get.width * 0.02),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/icon/Layer 2.png",
                                      width: Get.width * 0.035,
                                    ),
                                    SizedBox(width: Get.width * 0.01),
                                    Text(
                                      role,
                                      style: AppTypography.kBold10
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: Get.width * 0.015),
                              if (verified)
                                CircleAvatar(
                                  radius: Get.width * 0.03,
                                  backgroundColor: AppColors.kGuardsCard,
                                  child: Icon(Icons.verified,
                                      size: Get.width * 0.04,
                                      color: Colors.white),
                                ),
                            ],
                          ),
                          Text(
                            name,
                            style: AppTypography.kBold18
                                .copyWith(color: AppColors.kWhite),
                          ),
                          Row(
                            children: [
                              Text(level,
                                  style: AppTypography.kLight12.copyWith(
                                      color: Colors.grey.shade400)),
                              SizedBox(width: Get.width * 0.02),
                              Icon(Icons.star,
                                  size: Get.width * 0.06,
                                  color: Colors.cyanAccent),
                              SizedBox(width: Get.width * 0.01),
                              Text(rating.toStringAsFixed(1),
                                  style: AppTypography.kBold12
                                      .copyWith(color: AppColors.kWhite)),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: Get.height * 0.02,
                        right: 0,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kSkyBlue,
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.04,
                                vertical: Get.height * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text('Hire',
                              style: AppTypography.kBold12
                                  .copyWith(color: AppColors.kBlack)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
