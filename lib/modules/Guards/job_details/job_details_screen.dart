import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/Guards/job_details/application_submitted.dart';
import 'package:tac/modules/Guards/job_details/application_submitted_error.dart';
import 'job_dummy_data.dart';

class JobDetailsScreen extends StatelessWidget {
  final Widget? bottomAction;

  const JobDetailsScreen({super.key, this.bottomAction});

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

  Widget _headerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                JobDummyData.jobTitle,
                style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              JobDummyData.payRate,
              style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: JobDummyData.tags
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(JobDummyData.actorName,
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(JobDummyData.role,
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
              const SizedBox(width: 6),
              const Icon(Icons.star, color: Colors.cyan, size: 16),
              const SizedBox(width: 2),
              Text("${JobDummyData.rating}",
                  style:
                      AppTypography.kBold14.copyWith(color: Colors.cyanAccent)),
              const SizedBox(width: 4),
              Text("(${JobDummyData.reviews} reviews)",
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset(AppAssets.kCal,
                  height: 18, width: 18, color: AppColors.kgrey),
              const SizedBox(width: 8),
              Text(JobDummyData.date,
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
              const SizedBox(width: 12),
              Image.asset(AppAssets.kTime, height: 18, color: AppColors.kinput),
              const SizedBox(width: 6),
              Text(JobDummyData.time,
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(AppAssets.kGen,
                  height: 18, width: 18, color: AppColors.kgrey),
              const SizedBox(width: 8),
              Text(JobDummyData.required,
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(AppAssets.kLoc,
                  height: 18, width: 18, color: AppColors.kgrey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(JobDummyData.address,
                    style: AppTypography.kLight14
                        .copyWith(color: AppColors.kWhite)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(AppAssets.kPath,
                  height: 18, width: 18, color: AppColors.kgrey),
              const SizedBox(width: 8),
              Text(JobDummyData.distance,
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kWhite)),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  AppAssets.kMap,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.kDarkestBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Get Directions",
                      style:
                          AppTypography.kBold14.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _descriptionAndResponsibilitiesCard() {
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
          Text(JobDummyData.jobDescription,
              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
          const SizedBox(height: 16),
          Text("Responsibilities",
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          const SizedBox(height: 8),
          ...JobDummyData.responsibilities.map((item) => Padding(
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
          ...JobDummyData.requirements.map((item) => Padding(
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
                onPressed: () {
                  Get.to(() => const ApplicationSubmittedScreenError());
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
}
