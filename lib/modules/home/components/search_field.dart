import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/constants.dart';
import 'package:taccontractor/modules/fiilters/advanced_filters.dart';
import 'package:taccontractor/modules/fiilters/sort_overlay.dart';
import 'package:taccontractor/modules/search/search_view.dart';

import '../../../widhets/common widgets/buttons/primary_container.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

// class SearchField extends StatelessWidget {
//   final TextEditingController? controller;
//   final void Function(String)? onChanged;
//   final String? text;
//   final String? leadingIcon;
//   final String? icon1;
//   final String? icon2;
//   final bool isIconColorBlue;
//   final bool isEnabled;
//
//   const SearchField({
//     this.leadingIcon,
//     this.icon1,
//     this.icon2,
//     this.text,
//     this.controller,
//     this.onChanged,
//     this.isEnabled = false,
//     required this.isIconColorBlue,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => const SearchView());
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: AppSpacing.fifteenHorizontal),
//         color: Colors.transparent, // Ensure it's tappable
//         child: ListTile(
//           tileColor: Colors.grey[800], // Slightly darker grey for contrast
//           leading: leadingIcon != null
//               ? SvgPicture.asset(
//             leadingIcon!,
//             width: 22,
//             height: 22,
//             color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
//           )
//               : null,
//           title: Text(
//             text ?? 'Search',
//             style: AppTypography.kLight16.copyWith(
//               color: Colors.grey,
//             ),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min, // Fix infinite width issue
//             children: [
//               if (icon1 != null) // Avoid errors if icon is null
//                 SvgPicture.asset(
//                   icon1!,
//                   color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
//                   height: 22,
//                   width: 22,
//                 ),
//               const SizedBox(width: 10),
//               if (icon2 != null) // Corrected: Now using icon2
//                 SvgPicture.asset(
//                   icon2!,
//                   color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
//                   height: 22,
//                   width: 22,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

import '../../Guards/guards_view.dart';

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? text;
  final String? leadingIcon;
  final String? icon1;
  final String? icon2;
  final bool isIconColorBlue;
  final bool isBorderBlue;
  final bool isEnabled;

  const SearchField({
    this.leadingIcon,
    this.icon1,
    this.icon2,
    this.text,
    this.controller,
    this.onChanged,
    this.isEnabled = false,
    required this.isIconColorBlue,
    required this.isBorderBlue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isEnabled) {
          // Only navigate if the field is not enabled (in guards_view.dart)
          Get.to(() => SearchView())?.then((value) {
            // Refresh guards view if needed
            final guardsController = Get.find<GuardsViewController>();
            guardsController.update();
          });
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: SizedBox(
          height: 55,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            enabled: isEnabled,
            style: AppTypography.kLight14.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: text ?? 'Search',
              hintStyle: AppTypography.kLight14.copyWith(color: Colors.grey),
              filled: true,
              fillColor: AppColors.kDarkBlue,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isBorderBlue ? AppColors.kSkyBlue : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.kSkyBlue,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: leadingIcon != null
                  ? Image.asset(
                AppAssets.kSearch,
                height: 22,
                width: 22,
                color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
              )
                  : null,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon1 != null)
                    IconButton(
                      icon: Image.asset(
                        icon1!,
                        height: 22,
                        width: 22,
                        color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
                      ),
                      onPressed: () {
                        if (controller != null) controller!.clear();
                        if (onChanged != null) onChanged!('');
                      },
                    ),
                  if (icon2 != null && isEnabled)
                    IconButton(
                      icon: Image.asset(
                        icon2!,
                        height: 22,
                        width: 22,
                        color: isIconColorBlue ? AppColors.kSkyBlue : Colors.grey,
                      ),
                      onPressed: () {
                        Get.to(() => const AdvancedFiltersView())?.then((selectedFilters) {
                          if (selectedFilters != null && selectedFilters is List<String>) {
                            final searchController = Get.find<SearchViewController>();
                            // Clear previous filters
                            searchController.appliedFilters.clear();
                            // Add new filters
                            for (String filter in selectedFilters) {
                              searchController.addFilter(filter);
                            }
                          }
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}