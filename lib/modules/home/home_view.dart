import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taccontractor/controllers/mapController.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/modules/Guards/guards_view.dart';
import 'package:taccontractor/modules/alerts/notification_view.dart';
import 'package:taccontractor/modules/home/components/search_field.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_colors.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final MapController controller = Get.put(MapController(), permanent: true);
  final UserController userController = Get.find<UserController>();
  final GuardsViewController guardsController = Get.put(GuardsViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context),
            SizedBox(height: AppSpacing.tenVertical),
            Expanded(
              child: Stack(
                children: [
                  // Google Map
                  Obx(() {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.userPath.isNotEmpty
                            ? controller.userPath.first
                            : const LatLng(33.6844, 73.0479),
                        zoom: 18,
                      ),
                      markers: controller.markers,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      onMapCreated: (GoogleMapController mapController) {
                        if (controller.userPath.isNotEmpty) {
                          print(controller.userPath.first);
                        }
                        controller.setMapController(mapController);
                        controller.requestAndSaveLocation();
                      },
                      onCameraMove: (position) {
                        controller.updateCameraPosition(position);
                      },
                      onTap: (LatLng position) {
                        controller.clearSelectedGuard();
                      },
                    );
                  }),

                  // Loading indicator
                  // Obx(() {
                  //   return controller.isLoading.value
                  //       ? Center(
                  //           child: CircularProgressIndicator(
                  //             color: AppColors.kPrimary,
                  //           ),
                  //         )
                  //       : const SizedBox.shrink();
                  // }),

                  // Selected GUARD overlay - ONLY NAME, IMAGE, RATING
                  Obx(() {
                    final guard = controller.selectedGuard.value;
                    if (guard == null) return const SizedBox.shrink();

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          // Prevent the tap from propagating to the map
                        },
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF0B132B),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              // Guard image from assets (ALWAYS assets/a.jpg)
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                    image: AssetImage("assets/userpicture.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              SizedBox(width: 12),

                              // Guard name and static rating ONLY
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Guard name
                                    Text(
                                      guard.guard.name, // Guard name
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Static rating
                                    Text(
                                      "Level ${guard.guard.level}", // ALWAYS show this static rating
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    // Static rating
                                    Text(
                                      "⭐ ${guard.guard.rating}", // ALWAYS show this static rating
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Close button
                              IconButton(
                                onPressed: () {
                                  controller.clearSelectedGuard();
                                },
                                icon: Icon(Icons.close,
                                    color: Colors.white, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
      // Refresh button
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     controller.refreshMap();
      //   },
      //   backgroundColor: AppColors.kPrimary,
      //   child: Icon(Icons.refresh, color: Colors.white),
      // ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppAssets.kTacHomeScreenLogo,
                      height: Get.height * 0.045,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Home',
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kWhite),
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          focusColor: AppColors.kPrimary,
                          color: AppColors.kPrimary,
                          icon: SvgPicture.asset(
                            width: 35,
                            height: 35,
                            AppAssets.kAlerts,
                          ),
                          onPressed: () {
                            Get.to<void>(() => NotificationScreen());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: AssetImage(AppAssets.kUserPicture),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),
            SearchField(
              isBorderBlue: true,
              isEnabled: false,
              text: 'Search for Security Guards',
              isIconColorBlue: false,
              icon2: AppAssets.kSearch,
              guardsController: guardsController,
            ),
          ],
        ),
      ),
    );
  }
}
