import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taccontractor/controllers/mapController.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/dataproviders/notification_services/notification_services.dart';
import 'package:taccontractor/modules/Guards/guards_view.dart';
import 'package:taccontractor/modules/alerts/notification_view.dart';
import 'package:taccontractor/modules/community/community_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:taccontractor/modules/home/components/search_field.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_colors.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationServices.openPendingCommunityNotification();
      NotificationServices.openPendingSupportNotification();
    });
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          children: [
            _homeAppBar(),
            Expanded(child: const CommunityView(showAppBar: false)),
          ],
        ),
      ),
    );
  }

  Widget _homeAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Row(
          children: [
            Image.asset(
              AppAssets.kTacLogo,
              height: Get.height * 0.045,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            Text(
              'Community',
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Open Google Maps',
              color: AppColors.kPrimary,
              icon: const Icon(Icons.map_outlined),
              onPressed: () => Get.to<void>(() => GoogleMapScreen()),
            ),
            IconButton(
              focusColor: AppColors.kPrimary,
              color: AppColors.kPrimary,
              tooltip: 'Notifications',
              icon: SvgPicture.asset(
                width: 35,
                height: 35,
                AppAssets.kAlerts,
              ),
              onPressed: () => Get.to<void>(() => NotificationScreen()),
            ),
            const SizedBox(width: 8),
            Builder(
              builder: (_) {
                final profileImages =
                    userController.userData.value?.profileImages;
                final mainImage = profileImages
                    ?.firstWhereOrNull((img) => img.isMain == true);
                final imageUrl =
                    (mainImage?.image != null && mainImage!.image!.isNotEmpty)
                        ? '${MyApIService.imageBaseUrl}/${mainImage.image}'
                        : null;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: (imageUrl != null && imageUrl.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: AppColors.kJobCardColor,
                              child: const Center(
                                child: SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.kSkyBlue,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) => Image.asset(
                              AppAssets.kUserPicture,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            AppAssets.kUserPicture,
                            fit: BoxFit.cover,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleMapScreen extends StatelessWidget {
  GoogleMapScreen({super.key});

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
                            : const LatLng(-25.2744, 133.7751),
                        zoom: 4.5,
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
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              // Guard image with cached network image and skeleton placeholder
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: guard.guard.profileImageUrl.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: guard.guard.profileImageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Container(
                                            color: const Color(0xFF1B284F),
                                            child: const Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: AppColors.kSkyBlue,
                                                ),
                                              ),
                                            ),
                                          ),
                                          errorWidget: (_, __, ___) => Image.asset(
                                            "assets/userpicture.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          "assets/userpicture.jpg",
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
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back to community',
            icon: const Icon(Icons.arrow_back, color: AppColors.kWhite),
            onPressed: Get.back,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: SearchField(
              isBorderBlue: true,
              isEnabled: false,
              text: 'Search for Security Guards',
              isIconColorBlue: false,
              icon2: AppAssets.kSearch,
              guardsController: guardsController,
            ),
          ),
        ],
      ),
    );
  }
}
