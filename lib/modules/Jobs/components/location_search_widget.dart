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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextFormField(
              style: const TextStyle(color: AppColors.kWhite),
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.kDarkestBlue,
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
                hintText: hintText,
                counter: const Offstage(),
                hintStyle:
                    AppTypography.kLight14.copyWith(color: AppColors.kinput),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue, width: 1.5),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue, width: 2),
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.kSkyBlue),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Obx(() => isSearching.value
                  ? const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.kSkyBlue),
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.location_on,
                      color: AppColors.kSkyBlue,
                      size: 20,
                    )),
            ),
          ],
        ),

        // Suggestions List
        Obx(() {
          if (suggestions.isEmpty) return const SizedBox();

          return Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppColors.kDarkBlue,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.kSkyBlue.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length > 5 ? 5 : suggestions.length,
              itemBuilder: (context, index) {
                final prediction = suggestions[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on,
                      color: AppColors.kSkyBlue, size: 20),
                  title: Text(
                    prediction['description'] ?? '',
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kWhite),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => onLocationSelected(prediction),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
