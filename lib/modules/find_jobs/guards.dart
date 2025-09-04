// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/data/data/constants/app_assets.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
// import 'package:taccontractor/data/data/constants/app_typography.dart';
// import 'package:taccontractor/modules/find_jobs/components/all.dart';
// import 'package:taccontractor/modules/find_jobs/components/all_archive.dart';
// import 'package:taccontractor/modules/find_jobs/components/notification.dart';

// class AvailableGuardsScreen extends StatefulWidget {
//   @override
//   State<AvailableGuardsScreen> createState() => _AvailableGuardsScreenState();
// }

// class _AvailableGuardsScreenState extends State<AvailableGuardsScreen> {
//   final List<String> tabs = ["All", "Armed", "Event", "Corporate"];
//   int selectedIndex = 0;

//   bool showArchive = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               vertical: Get.width * 0.04, horizontal: Get.width * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Top Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         AppAssets.kTacLogo,
//                         height: Get.height * 0.05,
//                         width: Get.width * 0.2,
//                         fit: BoxFit.contain,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         "Guards",
//                         style: AppTypography.kBold24
//                             .copyWith(color: AppColors.kWhite),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.to(NotificationsScreen());
//                         },
//                         child: SvgPicture.asset(
//                           "assets/icon/notification.svg",
//                           width: 24,
//                           color: AppColors.kSkyBlue,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Image.asset(
//                         "assets/icon/plus.png",
//                         width: 24,
//                         color: AppColors.kSkyBlue,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               SizedBox(height: Get.height * 0.02),

//               /// Search Row + Toggle Icon
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       style: const TextStyle(color: AppColors.kgrey),
//                       decoration: InputDecoration(
//                         hintText: "Search for security jobs...",
//                         hintStyle:
//                             TextStyle(color: AppColors.kgrey, fontSize: 16),
//                         fillColor: AppColors.kDarkBlue,
//                         filled: true,
//                         suffixIcon: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Image.asset("assets/icon/search.png"),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: Get.width * 0.03,
//                           horizontal: Get.width * 0.04,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Get.width * 0.04),
//                           borderSide: const BorderSide(
//                               width: 0.8, color: AppColors.kgrey),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Get.width * 0.09),
//                           borderSide: const BorderSide(
//                               width: 0.04, color: AppColors.kgrey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),

//                   /// Toggle Archive Icon
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         showArchive = !showArchive;
//                       });
//                     },
//                     child: Image.asset(
//                       showArchive
//                           ? "assets/icon/archieve.png"
//                           : "assets/icon/save.png",
//                       width: 24,
//                       color: AppColors.kSkyBlue,
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 10),

//               /// Section Title
//               Text(
//                 showArchive ? "Archived Guards" : "Available Guards",
//                 style:
//                     AppTypography.kBold20.copyWith(color: AppColors.kWhite),
//               ),

//               SizedBox(height: 10),

//               /// Tab Buttons
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: List.generate(tabs.length, (index) {
//                     final isSelected = selectedIndex == index;
//                     return Padding(
//                       padding: EdgeInsets.only(right: Get.width * 0.02),
//                       child: OutlinedButton(
//                         onPressed: () {
//                           setState(() {
//                             selectedIndex = index;
//                           });
//                         },
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: isSelected
//                               ? AppColors.kSkyBlue
//                               : Colors.transparent,
//                           side: BorderSide(color: AppColors.kSkyBlue),
//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(Get.width * 0.02),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: Get.width * 0.03,
//                             vertical: Get.width * 0.01,
//                           ),
//                         ),
//                         child: Text(
//                           tabs[index],
//                           style: AppTypography.kBold16.copyWith(
//                             color: isSelected
//                                 ? AppColors.kBlack
//                                 : AppColors.kWhite,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),

//               SizedBox(height: 10),

//               /// Job List (Toggle between AllGuards and AllArchieveGuards)
//               Expanded(
//                 child: showArchive ? AllArchieveGuards() : AllGuards(),
//               ),
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
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/guardsList_model.dart';
import 'package:taccontractor/modules/alerts/notification_view.dart';
import 'package:taccontractor/modules/find_jobs/components/all.dart';
import 'package:taccontractor/modules/find_jobs/components/all_archive.dart';
import 'package:taccontractor/modules/find_jobs/components/notification.dart';

import '../../models/jobMinimal_model.dart';
import 'guardsListController.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../data/data/constants/app_assets.dart';
import '../../../data/data/constants/app_colors.dart';
import '../../../data/data/constants/app_typography.dart';
import '../../../dataproviders/api_service.dart';
import '../../../models/guardsList_model.dart';
import '../../../models/jobMinimal_model.dart';
import '../../controllers/user_controller.dart';

class AvailableGuardsScreen extends StatelessWidget {
  AvailableGuardsScreen({Key? key}) : super(key: key);

  final GuardsController c = Get.put(GuardsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Get.width * 0.04, horizontal: Get.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              SizedBox(height: Get.height * 0.02),
              _searchBar(),
              SizedBox(height: 10),
              Text(
                "Available Guards",
                style: AppTypography.kBold20.copyWith(color: AppColors.kWhite),
              ),
              SizedBox(height: 10),
              Expanded(child: _buildGuardList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Image.asset(AppAssets.kTacLogo,
              height: Get.height * 0.05, width: Get.width * 0.2),
          SizedBox(width: 8),
          Text("Guards",
              style: AppTypography.kBold24.copyWith(color: AppColors.kWhite)),
        ],
      ),
      Row(
        children: [
          GestureDetector(
            onTap: () => Get.to(() => NotificationScreen()),
            child: SvgPicture.asset("assets/icon/notification.svg",
                width: 28, color: AppColors.kSkyBlue),
          ),
        ],
      ),
    ],
  );

  Widget _searchBar() => TextFormField(
    style: const TextStyle(color: AppColors.kgrey),
    decoration: InputDecoration(
      hintText: "Search for security jobs...",
      hintStyle: TextStyle(color: AppColors.kgrey, fontSize: 16),
      fillColor: AppColors.kDarkBlue,
      filled: true,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset("assets/icon/search.png"),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: Get.width * 0.03,
        horizontal: Get.width * 0.04,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Get.width * 0.04),
        borderSide: const BorderSide(width: 0.8, color: AppColors.kgrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Get.width * 0.09),
        borderSide: const BorderSide(width: 0.04, color: AppColors.kgrey),
      ),
    ),
    onChanged: c.searchText,
  );

  Widget _buildGuardList() => Obx(() {
    if (c.isLoading.value) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.kSkyBlue));
    }
    if (c.guards.isEmpty) {
      return Center(
          child: Text("No guards found",
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)));
    }

    return RefreshIndicator(
      onRefresh: c.fetchGuards,
      color: AppColors.kSkyBlue,
      child: ListView.builder(
        itemCount: c.filtered.length,
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        itemBuilder: (_, index) {
          final g = c.filtered[index];
          final imageUrl = g.profilePicture.isEmpty
              ? null
              : '${MyApIService.imageBaseUrl}/${g.profilePicture}';

          return Padding(
            padding: EdgeInsets.only(bottom: Get.height * 0.015),
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
                    child: imageUrl == null
                        ? Image.asset("assets/userpicture.jpg",
                        width: Get.width * 0.18,
                        height: Get.width * 0.18,
                        fit: BoxFit.cover)
                        : Image.network(imageUrl,
                        width: Get.width * 0.18,
                        height: Get.width * 0.18,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                            "assets/userpicture.jpg",
                            width: Get.width * 0.18,
                            height: Get.width * 0.18,
                            fit: BoxFit.cover)),
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
                                    borderRadius: BorderRadius.circular(
                                        Get.width * 0.02),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/icon/Layer 2.png",
                                          width: Get.width * 0.035),
                                      SizedBox(width: Get.width * 0.01),
                                      Text(
                                        g.professionalBadge,
                                        style: AppTypography.kBold10
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: Get.width * 0.015),
                                if (g.isVerified)
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
                              g.fullName,
                              style: AppTypography.kBold18
                                  .copyWith(color: AppColors.kWhite),
                            ),
                            Text(
                              "Level ${g.level}",
                              style: AppTypography.kLight12
                                  .copyWith(color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                        Positioned(
                          top: Get.height * 0.02,
                          right: 0,
                          child: _JobDropdownButton(guard: g),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  });
}

/// Dropdown that uses the passed guard
class _JobDropdownButton extends StatelessWidget {
  final GuardsList guard;
  const _JobDropdownButton({required this.guard});

  @override
  Widget build(BuildContext context) {
    final GuardsController c = Get.find();
    final MyApIService apiService = MyApIService();

    return Obx(() {
      return DropdownButtonHideUnderline(
        child: DropdownButton<JobMinimal>(
          menuWidth: Get.width * 0.5,
          iconSize: 0,
          dropdownColor: AppColors.kDarkBlue,
          borderRadius: BorderRadius.circular(8),
          hint: ElevatedButton(
            onPressed: c.loadJobs,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kSkyBlue,
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text('Hire',
                style: AppTypography.kBold12.copyWith(color: Colors.black)),
          ),
          onChanged: (JobMinimal? job) async {
            if (job == null) return;

            final confirmed = await Get.dialog<bool>(
              _ConfirmDialog(
                jobTitle: job.jobTitle,
                guardName: guard.fullName,
              ),
            );
            if (confirmed != true) return;

            final res = await apiService.directHire(
              c.userController.userData.value!.id!,
              guard.id,
              job.jobId,
              job.shiftIds,
            );

            if (res.statusCode == 200) {
              Get.snackbar(
                'Hired',
                'Successfully hired ${guard.fullName} for ${job.jobTitle}',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } else {
              Get.snackbar(
                'Error',
                'Could not hire – ${res.body}',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          items: c.jobs.map<DropdownMenuItem<JobMinimal>>((job) {
            return DropdownMenuItem<JobMinimal>(
              value: job,
              child: Text(job.jobTitle,
                  style: AppTypography.kBold14.copyWith(color: Colors.white)),
            );
          }).toList(),
        ),
      );
    });
  }
}

/// Confirmation dialog
class _ConfirmDialog extends StatelessWidget {
  final String jobTitle;
  final String guardName;
  const _ConfirmDialog({required this.jobTitle, required this.guardName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.kDarkBlue,
      title: Text('Confirm Hire',
          style: AppTypography.kBold18.copyWith(color: Colors.white)),
      content: Text(
        'Are you sure you want to hire $guardName for\n"$jobTitle"?',
        style: AppTypography.kLight16.copyWith(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text('Cancel',
              style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kSkyBlue,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: () => Get.back(result: true),
          child: Text('Confirm',
              style: AppTypography.kBold14.copyWith(color: Colors.black)),
        ),
      ],
    );
  }
}