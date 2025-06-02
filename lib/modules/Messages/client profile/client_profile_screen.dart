import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'dummy_client_profile_data.dart';

class ClientProfileScreen extends StatelessWidget {
  final ClientProfileController controller = Get.put(ClientProfileController());

  ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final job = controller.job.value;

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack, width: 24, height: 24),
          onPressed: () => Get.back(),
        ),
        title: const Text("Client’s Profile",
            style: TextStyle(color: AppColors.kWhite)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// Profile Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: AssetImage(AppAssets.kUserPicture),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(
                          5,
                          (_) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.5, vertical: 4),
                            child: Icon(Icons.star,
                                size: 17, color: AppColors.kPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.clientName,
                            style: AppTypography.kBold16
                                .copyWith(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(job.clientRole,
                            style: AppTypography.kLight14
                                .copyWith(color: Colors.white70)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text("${job.rating}",
                                style: AppTypography.kBold14
                                    .copyWith(color: Colors.white)),
                            const SizedBox(width: 4),
                            Text("(${job.reviewCount} reviews)",
                                style: AppTypography.kLight14
                                    .copyWith(color: Colors.white60)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Contracts",
                      style:
                          AppTypography.kBold14.copyWith(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.kPrimary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Details",
                      style: AppTypography.kBold14
                          .copyWith(color: AppColors.kWhite),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Job Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.kGreenS.withOpacity(0.06),
                border: Border.all(color: AppColors.kgreen),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(job.title,
                            style: AppTypography.kBold14
                                .copyWith(color: Colors.white)),
                      ),
                      Text("In Progress",
                          style: AppTypography.kBold14
                              .copyWith(color: AppColors.kgreen)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dates
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Started",
                                style: AppTypography.kLight14
                                    .copyWith(color: Colors.white)),
                            Text(job.startDate,
                                style: AppTypography.kBold14
                                    .copyWith(color: Colors.white)),
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Ended",
                                style: AppTypography.kLight14
                                    .copyWith(color: Colors.white)),
                            Text(job.endDate,
                                style: AppTypography.kBold14
                                    .copyWith(color: Colors.white)),
                          ]),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text("Location",
                      style:
                          AppTypography.kBold14.copyWith(color: Colors.white)),
                  Text(job.location,
                      style:
                          AppTypography.kLight14.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),

                  Text("Distance",
                      style:
                          AppTypography.kBold14.copyWith(color: Colors.white)),
                  Text(job.distance,
                      style:
                          AppTypography.kLight14.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),

                  Text("Morning Shift",
                      style:
                          AppTypography.kBold14.copyWith(color: Colors.white)),
                  Text(job.shiftTime,
                      style:
                          AppTypography.kLight14.copyWith(color: Colors.white)),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.kgreen),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Text("View Job",
                          style: AppTypography.kBold14
                              .copyWith(color: AppColors.kgreen)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 75),

            // Block Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRedS,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    Text("Block User",
                        style: AppTypography.kBold14
                            .copyWith(color: AppColors.kRed)),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      AppAssets.kBlock,
                      width: 18,
                      height: 18,
                      color: AppColors
                          .kRed, // Only apply if the asset supports tinting
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
