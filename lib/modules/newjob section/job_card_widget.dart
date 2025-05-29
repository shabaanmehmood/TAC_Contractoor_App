// import 'package:flutter/material.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'job_model.dart';

// class JobCardWidget extends StatelessWidget {
//   final JobModel job;

//   const JobCardWidget({super.key, required this.job});

//   Color _getCardColor() {
//     switch (job.status) {
//       case 'In Progress':
//         return AppColors.kgreen.withOpacity(0.15);
//       case 'Awaiting':
//         return AppColors.kalert.withOpacity(0.15);
//       case 'Cancelled':
//         return Colors.red.withOpacity(0.15);
//       default:
//         return AppColors.kJobCardColor;
//     }
//   }

//   Color _getLabelColor() {
//     switch (job.status) {
//       case 'In Progress':
//         return AppColors.kgreen;
//       case 'Awaiting':
//         return AppColors.kalert;
//       case 'Cancelled':
//         return AppColors.kRed;
//       default:
//         return AppColors.kSkyBlue;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(AppSpacing.fifteenVertical),
//       decoration: BoxDecoration(
//         color: _getCardColor(),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(job.title,
//               style: AppTypography.kBold16.copyWith(color: Colors.white)),
//           SizedBox(height: 5),
//           Text(job.guardName,
//               style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
//           SizedBox(height: 5),
//           Text(job.location,
//               style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
//           SizedBox(height: 5),
//           Text(job.distance,
//               style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
//           SizedBox(height: 5),
//           Text(job.time,
//               style: AppTypography.kLight14.copyWith(color: AppColors.kinput)),
//           if (job.price.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text(job.price,
//                   style: AppTypography.kBold16
//                       .copyWith(color: AppColors.kSkyBlue)),
//             ),
//           if (job.showButton && job.buttonText != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 10),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _getLabelColor(),
//                   minimumSize: Size(double.infinity, 40),
//                 ),
//                 onPressed: () {},
//                 child: Text(job.buttonText!,
//                     style: AppTypography.kBold14.copyWith(color: Colors.white)),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
