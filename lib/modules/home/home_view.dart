import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taccontractor/controllers/mapController.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/constants.dart';
import 'package:taccontractor/models/getUserById_model.dart';
import 'package:taccontractor/models/userdata_model.dart';
import 'package:taccontractor/modules/Guards/guards_view.dart';
import 'package:taccontractor/modules/alerts/notification_view.dart';
import 'package:taccontractor/modules/home/components/search_field.dart';
import 'package:taccontractor/modules/location/current_location.dart';
import 'package:taccontractor/modules/map/liveTrackingPage.dart';

import '../../controllers/user_controller.dart';
import '../../data/data/constants/app_colors.dart';
import '../../dataproviders/api_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final MapController controller = Get.put(MapController());
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(GuardsViewController());
    userController.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appBar(context),
            SizedBox(height: AppSpacing.tenVertical,),
            Obx(() {
              return Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: controller.userPath.isNotEmpty
                        ? controller.userPath.first
                        : LatLng(0, 0),
                    zoom: 20,
                  ),
                  markers: controller.markers.value,
                  onMapCreated: controller.setMapController,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  int selectedIndex = 0;
}

Widget _appBar(BuildContext context) {
  final UserController userController = Get.find<UserController>();
  final GuardsViewController guardsController = Get.find<GuardsViewController>(); // Find the controller here
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
    child: SizedBox(
      width: double.infinity, // Ensures full width
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents infinite height issue
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
                    mainAxisSize: MainAxisSize.min, // Prevent infinite height
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
              // Obx(() {
              //   final imagePath = userController.userData.value?.profileImages?.first.imageUrl;
              //   final imageUrl = MyApIService.fullImageUrl(imagePath);
              //   return Container(
              //     width: 34,
              //     height: 34,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(4),
              //       image: DecorationImage(
              //         image: imageUrl != null
              //             ? NetworkImage(imageUrl)
              //             : AssetImage(AppAssets.kUserPicture) as ImageProvider,
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //   );
              // }),
            ],
          ),
          SizedBox(height: AppSpacing.tenVertical),
          SearchField(
            isBorderBlue: true,
            isEnabled: false,
            text: 'Search for Security Guards',
            isIconColorBlue: false,
            icon2: AppAssets.kSearch,
            guardsController: guardsController, // Pass the found controller
          ),
        ],
      ),
    ),
  );
}

