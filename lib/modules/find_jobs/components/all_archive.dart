// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
// import 'package:taccontractor/data/data/constants/app_typography.dart';

// Widget AllArchieveGuards() {
//   return GridView.builder(
//     padding: EdgeInsets.all(Get.width * 0.04),
//     shrinkWrap: true,
//     physics: NeverScrollableScrollPhysics(),
//     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//       crossAxisCount: 2,
//       childAspectRatio: 0.75,
//       crossAxisSpacing: Get.width * 0.04,
//       mainAxisSpacing: Get.height * 0.02,
//     ),
//     itemCount: 10,
//     itemBuilder: (context, index) {
//       return Stack(
//         children: [
//           /// Background Card with Image
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               image: DecorationImage(
//                 image: AssetImage('assets/userpicture.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.2),
//                     Colors.black.withOpacity(0.4),
//                     Colors.black.withOpacity(0.6),
//                   ],
//                 ),
//               ),
//               padding: EdgeInsets.all(Get.width * 0.035),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Level and Rating Row
//                   Row(
//                     children: [
//                       Text(
//                         'Level 2',
//                         style: AppTypography.kLight11.copyWith(
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(width: 6),
//                       Icon(Icons.star, color: Colors.cyanAccent, size: 14),
//                       SizedBox(width: 2),
//                       Text(
//                         '5.0',
//                         style: AppTypography.kBold10.copyWith(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 6),

//                   /// Name and Verified Badge
//                   Row(
//                     children: [
//                       Text(
//                         'Johsan Bill',
//                         style: AppTypography.kBold14.copyWith(
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(width: 4),
//                       Icon(
//                         Icons.verified,
//                         size: 16,
//                         color: Colors.white,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           /// Top-right Action Icon
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white.withOpacity(0.1),
//               ),
//               padding: EdgeInsets.all(6),
//               child:Image.asset(
//                                     "assets/icon/Layer 2.png",
//                                     width: Get.width * 0.035,
//                                   ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }


// all_archieve_guards.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/find_jobs/components/dummy_data.dart';

Widget AllArchieveGuards({required String type}) {
  // Filter logic: show all if type is "All"
  final filteredGuards = type == "All"
      ? dummyGuards
      : dummyGuards.where((guard) => guard["type"] == type).toList();

  if (filteredGuards.isEmpty) {
    return Center(
      child: Text(
        "No archived guards available.",
        style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
      ),
    );
  }

  return GridView.builder(
    padding: EdgeInsets.all(Get.width * 0.04),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      crossAxisSpacing: Get.width * 0.04,
      mainAxisSpacing: Get.height * 0.02,
    ),
    itemCount: filteredGuards.length,
    itemBuilder: (context, index) {
      final guard = filteredGuards[index];

      return Stack(
        children: [
          /// Background Image with Gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(guard["image"]),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
              padding: EdgeInsets.all(Get.width * 0.035),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Level & Rating
                  Row(
                    children: [
                      Text(
                        guard["level"],
                        style: AppTypography.kLight11.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.star, color: Colors.cyanAccent, size: 14),
                      SizedBox(width: 2),
                      Text(
                        guard["rating"].toString(),
                        style: AppTypography.kBold10.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),

                  /// Name & Verified
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          guard["name"],
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.kBold14.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      if (guard["verified"])
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Top-right Action Icon
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              padding: EdgeInsets.all(6),
              child: Image.asset(
                "assets/icon/Layer 2.png",
                width: Get.width * 0.035,
              ),
            ),
          ),
        ],
      );
    },
  );
}
