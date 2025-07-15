import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/find_jobs/components/bottom_sheet.dart';

class AdvancedFilterScreen extends StatefulWidget {
  @override
  State<AdvancedFilterScreen> createState() => _AdvancedFilterScreenState();
}

class _AdvancedFilterScreenState extends State<AdvancedFilterScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool useCurrentLocation = true;
  bool verifiedProfiles = true;

  double minAge = 20;
  double maxAge = 45;

  int selectedGuardType = -1;
  int selectedAvailability = -1;
  int selectedExperience = -1;
  int selectedRating = -1;

  final guardTypes = ['All', 'Leader', 'Normal Guards'];
  final availabilityTimes = ['Morning', 'Afternoon', 'Evening', 'Night'];
  final experiences = ['10+', '5+', '4-5', '2-4', '1-2', '0-1'];
  final ratings = ['5', '4+', '3+', '2+', '1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
       appBar: AppBar(
        backgroundColor: AppColors.kDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
        title:  Text(
                          "Advanced Filters",
                          style: AppTypography.kBold21
                              .copyWith(color: AppColors.kWhite),
                        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 2,
            thickness: 1.5,
            color: AppColors.kgrey.withOpacity(0.4),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Get.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
                 
        
              /// Location
              _buildInputField(
                controller: locationController,
                hintText: 'Enter Location',
                icon: Icons.location_on,
                readOnly: false,
              ),
              SizedBox(height: Get.height * 0.025),
        
              /// Date
              _buildInputField(
                controller: dateController,
                hintText: 'Availability Date',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
              ),
              SizedBox(height: Get.height * 0.025),
        
              /// Toggles
              _buildToggleRow('Use Current Location', useCurrentLocation, (val) => setState(() => useCurrentLocation = val)),
              SizedBox(height: Get.height * 0.02),
              _buildToggleRow('Verified Profiles', verifiedProfiles, (val) => setState(() => verifiedProfiles = val)),
              SizedBox(height: Get.height * 0.03),
        
              /// Age Range
              Container(
                padding: EdgeInsets.all(Get.width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    RangeSlider(
                      values: RangeValues(minAge, maxAge),
                      min: 20,
                      max: 45,
                      divisions: 5,
                      activeColor: AppColors.kSkyBlue,
                      inactiveColor: Colors.grey.shade700,
                      onChanged: (values) {
                        setState(() {
                          minAge = values.start;
                          maxAge = values.end;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${minAge.toInt()}y", style: AppTypography.kLight14.copyWith(color: Colors.white)),
                        Text("${(minAge + maxAge) ~/ 2}y", style: AppTypography.kLight14.copyWith(color: Colors.white)),
                        Text("${maxAge.toInt()}y", style: AppTypography.kLight14.copyWith(color: Colors.white)),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.03),
        
              /// Chips
              _buildCustomChips('Guard Type', guardTypes, selectedGuardType, (i) => setState(() => selectedGuardType = i)),
              _buildCustomChips('Availability Time', availabilityTimes, selectedAvailability, (i) => setState(() => selectedAvailability = i)),
              _buildCustomChips('Years of Experience', experiences, selectedExperience, (i) => setState(() => selectedExperience = i)),
              _buildCustomChips('Rating', ratings, selectedRating, (i) => setState(() => selectedRating = i)),
        
              SizedBox(height: Get.height * 0.03),
        
              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedGuardType = -1;
                          selectedAvailability = -1;
                          selectedExperience = -1;
                          selectedRating = -1;
                          useCurrentLocation = true;
                          verifiedProfiles = true;
                          minAge = 20;
                          maxAge = 45;
                          locationController.clear();
                          dateController.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.kSkyBlue),
                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.018),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Reset All', style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue)),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.04),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                      
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        padding: EdgeInsets.symmetric(vertical: Get.height * 0.018),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Apply Filters', style: AppTypography.kBold16.copyWith(color: AppColors.kBlack)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Text Field
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTypography.kLight14.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.kLight14.copyWith(color: Colors.white60),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.kSkyBlue)),
        prefixIcon: Icon(icon, color: Colors.white70),
      ),
    );
  }

  /// Toggle
  Widget _buildToggleRow(String title, bool value, Function(bool) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.016,
        horizontal: Get.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.kBold14.copyWith(color: Colors.white)),
          Switch(
            value: value,
            activeColor: AppColors.kSkyBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  /// Custom Chips
  Widget _buildCustomChips(String title, List<String> items, int selected, Function(int) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Get.height * 0.02),
        Text(title, style: AppTypography.kBold16.copyWith(color: Colors.white)),
        SizedBox(height: Get.height * 0.01),
        Wrap(
          spacing: Get.width * 0.02,
          runSpacing: Get.height * 0.01,
          children: List.generate(items.length, (index) {
            final isSelected = index == selected;
            return GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.03,
                  vertical: Get.height * 0.012,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.kSkyBlue : AppColors.kDarkBlue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.kSkyBlue),
                ),
                child: Text(
                  items[index],
                  style: AppTypography.kBold12.copyWith(
                    color: isSelected ? AppColors.kBlack : Colors.white,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
