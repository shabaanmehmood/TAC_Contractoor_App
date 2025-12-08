import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class LocationSearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(Map<String, dynamic>) onLocationSelected;
  final Function(String) onSearchChanged;
  final RxList<dynamic> suggestions;
  final RxBool isSearching;
  final String hintText;

  const LocationSearchField({
    Key? key,
    required this.controller,
    required this.onLocationSelected,
    required this.onSearchChanged,
    required this.suggestions,
    required this.isSearching,
    this.hintText = "Site Location",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive sizing based on screen width
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isLargeTablet = MediaQuery.of(context).size.width >= 900;

    return Theme(
      data: Theme.of(context).copyWith(
        // Customize input field theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.kDarkestBlue,
          contentPadding: EdgeInsets.symmetric(
            vertical: isTablet ? 22 : 18,
            horizontal: isTablet ? 20 : 16,
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.kSkyBlue, width: 1.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.kSkyBlue, width: 2),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.kSkyBlue),
          ),
          hintStyle: AppTypography.kLight14.copyWith(
            color: AppColors.kinput,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              TextFormField(
                style: TextStyle(
                  color: AppColors.kWhite,
                  fontSize: isTablet ? 16 : 14,
                ),
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: isTablet ? 48 : 40,
                  ),
                  // No suffix icon for loading indicator
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      right: isTablet ? 12 : 8,
                      left: isTablet ? 12 : 8,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.kSkyBlue,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: (value) {
                  onSearchChanged(value);
                  // Also trigger manual geocoding as fallback
                  if (value.length > 3) {
                    // You can call the manual geocoding here if needed
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Site location is required';
                  }
                  return null;
                },
              ),

              // Removed the progress indicator position
            ],
          ),

          // Suggestions List with responsive design
          Obx(() {
            if (suggestions.isEmpty) return const SizedBox();

            return Container(
              margin: EdgeInsets.only(top: isTablet ? 8 : 4),
              decoration: BoxDecoration(
                color: AppColors.kDarkBlue,
                borderRadius: BorderRadius.circular(isTablet ? 12 : 8),
                border: Border.all(color: AppColors.kSkyBlue.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: isTablet ? 12 : 8,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: isLargeTablet
                    ? 350
                    : isTablet
                        ? 300
                        : 250,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: suggestions.length > 5 ? 5 : suggestions.length,
                itemBuilder: (context, index) {
                  final prediction = suggestions[index];
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: AppColors.kSkyBlue.withOpacity(0.2),
                    ),
                    child: ListTile(
                      dense: !isTablet,
                      minLeadingWidth: isTablet ? 32 : 24,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 20 : 16,
                        vertical: isTablet ? 8 : 4,
                      ),
                      leading: Icon(
                        Icons.location_on,
                        color: AppColors.kSkyBlue,
                        size: isTablet ? 22 : 18,
                      ),
                      title: Text(
                        prediction['description'] ?? '',
                        style: AppTypography.kLight14.copyWith(
                          color: AppColors.kWhite,
                          fontSize: isTablet ? 15 : 14,
                        ),
                        maxLines: isTablet ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => onLocationSelected(prediction),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
