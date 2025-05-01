// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'job_status_screen.dart';

// class JobStatusScreenError extends StatelessWidget {
//   const JobStatusScreenError({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: AppSpacing.twentyHorizontal),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(height: AppSpacing.twentyVertical),
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () => Get.back(),
//                               child: Image.asset(AppAssets.kBack, height: 24),
//                             ),
//                             SizedBox(width: 12),
//                             Text(
//                               "Job Cancelled",
//                               style: AppTypography.kBold20
//                                   .copyWith(color: AppColors.kWhite),
//                             )
//                           ],
//                         ),
//                         SizedBox(height: AppSpacing.thirtyVertical),
//                         Container(
//                           height: 60,
//                           width: 60,
//                           decoration: BoxDecoration(
//                             color: Colors.red.shade100,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(Icons.close, size: 36, color: Colors.red),
//                         ),
//                         SizedBox(height: AppSpacing.twentyVertical),
//                         Text(
//                           "Your job has been cancelled by contractor.",
//                           textAlign: TextAlign.center,
//                           style: AppTypography.kBold18
//                               .copyWith(color: AppColors.kWhite),
//                         ),
//                         SizedBox(height: AppSpacing.thirtyVertical),
//                         _JobDetailsCard(),
//                         SizedBox(height: AppSpacing.twentyVertical),
//                         _ShiftDetailsCard(),
//                         SizedBox(height: AppSpacing.twentyVertical),
//                       ],
//                     ),
//                   ),
//                 ),
//                 _BottomActionButtons(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _JobDetailsCard() => const JobStatusScreenSuccess()._JobDetailsCard();
//   Widget _ShiftDetailsCard() =>
//       const JobStatusScreenSuccess()._ShiftDetailsCard();
//   Widget _BottomActionButtons() =>
//       const JobStatusScreenSuccess()._BottomActionButtons();
// }
