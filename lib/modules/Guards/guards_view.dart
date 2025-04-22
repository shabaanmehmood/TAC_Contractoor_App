import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/home/components/search_field.dart';
import 'package:tac/widhets/common%20widgets/buttons/job_card.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_colors.dart';
import '../../dataproviders/api_service.dart';
import '../alerts/notification_view.dart';
import 'dummy_data.dart';

class GuardsView extends StatefulWidget {
  const GuardsView({super.key});

  @override
  State<GuardsView> createState() => _GuardsViewState();
}

class _GuardsViewState extends State<GuardsView> {

  String selectedFilter = "All"; // Default filter

  @override
  Widget build(BuildContext context) {
    List<JobCard> filteredList = selectedFilter == "All" ?
    jobList : jobList.where((job) => job.jobDept == selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(context),
              SizedBox(height: AppSpacing.tenVertical,),
              Text('Available Guards', style: AppTypography.kBold20.copyWith(
                color: AppColors.kWhite
              ),),
              SizedBox(height: AppSpacing.fiveVertical,),
              Wrap(
                spacing: 10.0,
                children: [
                  _buildFilterChip("All"),
                  _buildFilterChip("Armed"),
                  _buildFilterChip("Event"),
                  _buildFilterChip("Corporate"),
                ],
              ),
              SizedBox(height: AppSpacing.tenVertical,),
              Flexible(
                child: ListView.separated(
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) => SizedBox(height: AppSpacing.fiveVertical),
                  itemBuilder: (context, index) {
                    final job = filteredList[index]; // Extract job object
                    return JobCard(
                      jobTitle: job.jobTitle,
                      perHourRate: job.perHourRate,
                      companyName: job.companyName,
                      rating: job.rating,
                      hiringTag: job.hiringTag,
                      jobType: job.jobType,
                      location: job.location,
                      distance: job.distance,
                      day: job.day,
                      shiftTime: job.shiftTime,
                      requiredPersons: job.requiredPersons,
                      jobDept: job.jobDept,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // BUILD FILTER CHIPS
  Widget _buildFilterChip(String label) {
    return FilterChip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.kSkyBlue
        )
      ),
      label: Text(label,),
      selected: selectedFilter == label,
      onSelected: (bool selected) {
        setState(() {
          selectedFilter = label;
        });
      },
      backgroundColor: AppColors.kDarkBlue, // Unselected chips will have Dark Blue background
      selectedColor: AppColors.kSkyBlue, // Selected chip color
      disabledColor: AppColors.kDarkBlue, // Ensure disabled chips also have Dark Blue background
      showCheckmark: false, // No checkmark inside the chip
      surfaceTintColor: Colors.transparent, // Prevent unwanted overlay effects
      labelStyle: AppTypography.kBold14.copyWith(
        color: selectedFilter == label ? Colors.white : AppColors.kSkyBlue, // White text when selected, SkyBlue otherwise
      ),
    );
  }

  int selectedIndex = 0;
}

Widget _appBar(BuildContext context) {
  final userController = Get.find<UserController>();
  return Column(
    children: [
      Row(
        children: [
          Builder(
            builder: (BuildContext context) {
              return Image.asset(
                AppAssets.kTacHomeScreenLogo,
                height: Get.height * 0.07,
                width: Get.width * 0.25,
                fit: BoxFit.contain,
              );
            },
          ),
          const Spacer(),
          Stack(
            children: [
              Column(
                children: [
                  IconButton(
                    focusColor: AppColors.kPrimary,
                    color: AppColors.kPrimary,
                    icon: SvgPicture.asset(
                        width: 35,
                        height: 35,
                        AppAssets.kAlerts
                    ),
                    onPressed: () {
                      Get.to<void>(() => NotificationScreen());                    },
                  ),
                  // const Text(
                  //   "Alerts",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: AppColors.kWhite,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 10,),
          Obx(() {
            final imagePath = userController.userData.value?.profileImages?.first.imageUrl;
            // userController.userData.value?.profileImages?.first.imageUrl
            final imageUrl = MyApIService.fullImageUrl(imagePath);
            return Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: imageUrl != null
                      ? NetworkImage(imageUrl)
                      : AssetImage(AppAssets.kUserPicture) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ],
      ),
      SizedBox(height: AppSpacing.tenVertical,),
      SearchField(
        isBorderBlue: false,
        isIconColorBlue: false,
        icon2: AppAssets.kSearch,
        text: 'Search for Security Guards',
      ),
    ],
  );
}

