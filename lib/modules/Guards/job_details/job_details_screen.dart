import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taccontractor/controllers/mapController.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/Guards/job_details/application_submitted.dart';
import 'package:taccontractor/modules/Guards/job_details/application_submitted_error.dart';
import '../../../dataproviders/api_service.dart';
import '../../../models/job_model.dart';
import '../../../widhets/common widgets/buttons/adaptive_dialogue.dart';
import 'CloseJobBottomSheet.dart';
import 'WithdrawJobBottomSheet.dart';
import 'job_dummy_data.dart';

// class JobDetailsScreen extends StatelessWidget {
//   final Widget? bottomAction;
//
//   const JobDetailsScreen({super.key, this.bottomAction});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.kDarkestBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: AppColors.kWhite),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           "Job Details",
//           style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Divider(
//             height: 1,
//             thickness: 1,
//             color: AppColors.kgrey.withOpacity(0.3),
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(bottom: 70),
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _headerSection(),
//                   const SizedBox(height: 16),
//                   _jobInfoCard(),
//                   const SizedBox(height: 16),
//                   _descriptionAndResponsibilitiesCard(),
//                   const SizedBox(height: 16),
//                   _requirementsCard(),
//                 ],
//               ),
//             ),
//           ),
//           bottomAction ?? _applyNowButton(),
//         ],
//       ),
//     );
//   }
//
//   Widget _headerSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Text(
//                 JobDummyData.jobTitle,
//                 style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               JobDummyData.payRate,
//               style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: JobDummyData.tags
//               .map((tag) => Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: AppColors.kJobCardColor,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       tag,
//                       style: AppTypography.kLight14
//                           .copyWith(color: AppColors.kgrey),
//                     ),
//                   ))
//               .toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _jobInfoCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(JobDummyData.actorName,
//               style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
//           const SizedBox(height: 4),
//           Row(
//             children: [
//               Text(JobDummyData.role,
//                   style:
//                       AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
//               const SizedBox(width: 6),
//               const Icon(Icons.star, color: Colors.cyan, size: 16),
//               const SizedBox(width: 2),
//               Text("${JobDummyData.rating}",
//                   style:
//                       AppTypography.kBold14.copyWith(color: Colors.cyanAccent)),
//               const SizedBox(width: 4),
//               Text("(${JobDummyData.reviews} reviews)",
//                   style:
//                       AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Image.asset(AppAssets.kCal,
//                   height: 18, width: 18, color: AppColors.kgrey),
//               const SizedBox(width: 8),
//               Text(JobDummyData.date,
//                   style:
//                       AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
//               const SizedBox(width: 12),
//               Image.asset(AppAssets.kTime, height: 18, color: AppColors.kinput),
//               const SizedBox(width: 6),
//               Text(JobDummyData.time,
//                   style:
//                       AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Image.asset(AppAssets.kGen,
//                   height: 18, width: 18, color: AppColors.kgrey),
//               const SizedBox(width: 8),
//               Text(JobDummyData.required,
//                   style:
//                       AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Image.asset(AppAssets.kLoc,
//                   height: 18, width: 18, color: AppColors.kgrey),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(JobDummyData.address,
//                     style: AppTypography.kLight14
//                         .copyWith(color: AppColors.kWhite)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Image.asset(AppAssets.kPath,
//                   height: 18, width: 18, color: AppColors.kgrey),
//               const SizedBox(width: 8),
//               Text(JobDummyData.distance,
//                   style:
//                       AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.asset(
//                   AppAssets.kMap,
//                   height: 140,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Positioned.fill(
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 70, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: AppColors.kDarkestBlue,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       "Get Directions",
//                       style:
//                           AppTypography.kBold14.copyWith(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _descriptionAndResponsibilitiesCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Job Description",
//               style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
//           const SizedBox(height: 8),
//           Text(JobDummyData.jobDescription,
//               style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
//           const SizedBox(height: 16),
//           Text("Responsibilities",
//               style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
//           const SizedBox(height: 8),
//           ...JobDummyData.responsibilities.map((item) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 2),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("• ",
//                         style: TextStyle(color: AppColors.kgrey, fontSize: 14)),
//                     Expanded(
//                       child: Text(item,
//                           style: AppTypography.kLight14
//                               .copyWith(color: AppColors.kgrey)),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
//
//   Widget _requirementsCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Requirements",
//               style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
//           const SizedBox(height: 8),
//           ...JobDummyData.requirements.map((item) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 2),
//                 child: Row(
//                   children: [
//                     const Text("• ",
//                         style: TextStyle(color: AppColors.kgrey, fontSize: 14)),
//                     Expanded(
//                       child: Text(item,
//                           style: AppTypography.kLight14
//                               .copyWith(color: AppColors.kgrey)),
//                     ),
//                   ],
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
//
//   Widget _applyNowButton() {
//     return Positioned(
//       bottom: 0,
//       left: 0,
//       right: 0,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             color: AppColors.kBlack,
//             child: Divider(
//               height: 1,
//               thickness: 1,
//               color: AppColors.kgrey.withOpacity(0.3),
//             ),
//           ),
//           Container(
//             color: AppColors.kBlack,
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//             child: SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Get.to(() => const ApplicationSubmittedScreenError());
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.kSkyBlue,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "Apply Now",
//                       style: AppTypography.kBold16
//                           .copyWith(color: AppColors.kDarkBlue),
//                     ),
//                     const SizedBox(width: 8),
//                     Image.asset(
//                       AppAssets.kSend,
//                       height: 18,
//                       width: 18,
//                       color: AppColors.kDarkBlue,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class JobDetailsScreen extends StatelessWidget {
  MapController mapController = Get.put(MapController());
  UserController userController = Get.put(UserController());
  final JobData? jobData;
  final Widget? bottomAction;
  bool hasApplied = false;
  final apiService = MyApIService(); // create instance

  Future<void> applyJob(JobData jobData) async {
    try {
      final response = await apiService.applyJob(
        userController.userData!.value!.id!,
        jobData!.id,
        jobData!.shifts.map((shift) => shift.id).toList(),
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'] ?? 'Pending Employer Review';
        Get.to(() => ApplicationSubmittedScreen(jobdata: jobData, message: message));
        // await saveLoginSession();
      } else {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'] ?? 'Try Again Later';
        debugPrint("data from API ${response.body}");
        Get.to(() => ApplicationSubmittedScreenError(jobData: jobData, message: message));
        // final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // final String errorMessage = responseBody['message'] ?? 'Unknown error';
        //
        // // Show dialog with one line call
        // await AdaptiveAlertDialogWidget.show(
        //   context,
        //   title: 'Login Failed',
        //   content: errorMessage,
        //   yesText: 'OK',
        //   showNoButton: false,
        //   onYes: () {
        //     // Optional: do something on OK pressed
        //   },
        // );
        // debugPrint('Error login failed: ${response.body}');
      }
    }
    catch (e) {
      debugPrint('Error Network error: ${e.toString()}');
      // await AdaptiveAlertDialogWidget.show(
      //   context,
      //   title: 'Network Error',
      //   content: e.toString(),
      //   yesText: 'OK',
      //   showNoButton: false,
      // );
    }
  }

  JobDetailsScreen({Key? key, this.jobData, this.bottomAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Job Details",
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.kgrey.withOpacity(0.3),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerSection(),
                  const SizedBox(height: 16),
                  _jobInfoCard(),
                  const SizedBox(height: 16),
                  _descriptionAndResponsibilitiesCard(),
                  const SizedBox(height: 16),
                  _requirementsCard(),
                ],
              ),
            ),
          ),
          bottomAction ?? _applyNowButton(),
        ],
      ),
    );
  }
  //
  // void _showCancelOrWithdrawOverlay(String jobId) async {
  //   final statusResponse = await apiService.getJobApplicationStatus(jobId);
  //   if (statusResponse.statusCode == 200) {
  //     final statusData = jsonDecode(statusResponse.body);
  //     final isApproved = statusData['approved'] as bool? ?? false;
  //
  //     if (isApproved) {
  //       // Show cancel job overlay
  //       Get.bottomSheet(const CloseJobBottomSheet());
  //     } else {
  //       // Show withdraw job overlay (create this widget similarly to CloseJobBottomSheet)
  //       Get.bottomSheet(const WithdrawJobBottomSheet());
  //     }
  //   } else {
  //     Get.snackbar('Error', 'Failed to get job application status');
  //   }
  // }
  //

  Widget _headerSection() {
    final title = jobData?.title ?? JobDummyData.jobTitle;
    final payRate = jobData != null ? '\$${jobData!.payPerHour}/hr' : JobDummyData.payRate;

    // Create tags from job data if available
    final List<String> tags = jobData != null
        ? [jobData!.categoryName, jobData!.premisesTypeName]
        : JobDummyData.tags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              payRate,
              style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags
              .map((tag) => Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.kJobCardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: AppTypography.kLight14
                  .copyWith(color: AppColors.kgrey),
            ),
          ))
              .toList(),
        ),
      ],
    );
  }

  Widget _jobInfoCard() {
    final actorName = jobData?.contractorName ?? JobDummyData.actorName;
    final role = jobData?.categoryName ?? JobDummyData.role;

    // Format date string
    String dateStr = JobDummyData.date;
    if (jobData != null && jobData!.shifts.isNotEmpty) {
      dateStr = jobData!.shifts.first.date;
    }

    // Format time string
    String timeStr = JobDummyData.time;
    if (jobData != null && jobData!.shifts.isNotEmpty) {
      final shift = jobData!.shifts.first;
      timeStr = '${_formatTime(shift.startTime)} - ${_formatTime(shift.endTime)}';
    }

    // Format required guards
    final required = jobData != null
        ? '${jobData!.noOfGuardsRequired} Guards Required'
        : JobDummyData.required;

    // Location
    final address = jobData?.location ?? JobDummyData.address;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(actorName,
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(role,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
              const SizedBox(width: 6),
              const Icon(Icons.star, color: Colors.cyan, size: 16),
              const SizedBox(width: 2),
              Text("${JobDummyData.rating}",
                  style: AppTypography.kBold14.copyWith(color: Colors.cyanAccent)),
              const SizedBox(width: 4),
              Text("(${JobDummyData.reviews} reviews)",
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset(AppAssets.kCal,
                  height: 18, width: 18, color: AppColors.kgrey),
              const SizedBox(width: 8),
              Text(dateStr,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
              const SizedBox(width: 12),
              Image.asset(AppAssets.kTime, height: 18, color: AppColors.kinput),
              const SizedBox(width: 6),
              Text(timeStr,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(AppAssets.kGen,
                  height: 18, width: 18, color: AppColors.kgrey),
              const SizedBox(width: 8),
              Text(required,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(AppAssets.kLoc,
                  height: 18, width: 18, color: AppColors.kgrey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(address,
                    style: AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<double>(
            future: mapController.getJobLocation(jobData!.latitude, jobData!.longitude),
            builder: (context, snapshot) {
              return Row(
                children: [
                  Image.asset(AppAssets.kPath,
                      height: 18, width: 18, color: AppColors.kgrey),
                  const SizedBox(width: 8),
                  Text(
                    snapshot.hasData
                        ? '${snapshot.data!.truncate()} miles away'
                        : 'Calculating distance...',
                    style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            child: Obx(() {
              if (mapController.jobPath.isEmpty) {
                return Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: AppColors.kSkyBlue,
                    ),
                  ),
                );
              }
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: mapController.jobPath.first,
                  zoom: 15,
                ),
                markers: mapController.markers.value,
                onMapCreated: mapController.setMapController,
              );
            }),
          ),
        ],
      ),
    );
  }
  Widget _descriptionAndResponsibilitiesCard() {
    final description = jobData?.description ?? JobDummyData.jobDescription;

    // Use responsibilities from job data if available, otherwise use dummy data
    final List<String> responsibilities = jobData?.responsibilities != null
        ? jobData!.responsibilities!
        .split('\n')
        .where((item) => item.trim().isNotEmpty)
        .toList()
        : JobDummyData.responsibilities;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Job Description",
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          const SizedBox(height: 8),
          Text(description,
              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
          const SizedBox(height: 16),
          Text("Responsibilities",
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          const SizedBox(height: 8),
          ...responsibilities.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("• ",
                    style: TextStyle(color: AppColors.kgrey, fontSize: 14)),
                Expanded(
                  child: Text(item,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _requirementsCard() {
    // Use dummy requirements since API doesn't provide them
    final requirements = JobDummyData.requirements;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Requirements",
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          const SizedBox(height: 8),
          ...requirements.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Text("• ",
                    style: TextStyle(color: AppColors.kgrey, fontSize: 14)),
                Expanded(
                  child: Text(item,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey)),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _applyNowButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.kBlack,
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.kgrey.withOpacity(0.3),
            ),
          ),
          Container(
            color: AppColors.kBlack,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await applyJob(jobData!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Apply Now",
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kDarkBlue),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      AppAssets.kSend,
                      height: 18,
                      width: 18,
                      color: AppColors.kDarkBlue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format time
  String _formatTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) return timeStr;

      int hour = int.parse(parts[0]);
      final minute = parts[1];
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      return '$hour:$minute $period';
    } catch (e) {
      return timeStr;
    }
  }
}
