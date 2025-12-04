import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/models/latestguard.dart';
import 'package:taccontractor/models/nearbyjob.dart';

class MapController extends GetxController {
  var markers = <Marker>{}.obs;
  var mapController = Rxn<GoogleMapController>();
  var userPath = <LatLng>[].obs;
  var jobPath = <LatLng>[].obs;
  String? darkMapStyle;
  var isLoading = true.obs;
  final myApiService = MyApIService();
  Timer? _periodicUpdateTimer;
  LatLng? _currentUserLocation;
  final Rx<GuardLocationData?> selectedGuard = Rx<GuardLocationData?>(null);
  final userController = Get.find<UserController>();
  // Track camera position manually
  CameraPosition? _currentCameraPosition;
  var _isFirstLoad = true;

  @override
  void onInit() {
    super.onInit();
    loadMapStyle();
    _initializeApp();
    _startPeriodicUpdates();
  }

  Future<void> _initializeApp() async {
    await loadMapStyle();
    await requestAndSaveLocation();
  }

  @override
  void onClose() {
    _periodicUpdateTimer?.cancel();
    mapController.value?.dispose();
    super.onClose();
  }

  void _startPeriodicUpdates() {
    _periodicUpdateTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_currentUserLocation != null) {
        fetchUserLocations(
          _currentUserLocation!.latitude.toStringAsFixed(4),
          _currentUserLocation!.longitude.toStringAsFixed(4),
        );
      }
    });
  }

  void onMarkerTapped(GuardLocationData guard) {
    selectedGuard.value = guard;
  }

  void updateCameraPosition(CameraPosition position) {
    _currentCameraPosition = position;
    print(
        "📍 Camera updated: ${position.target.latitude}, ${position.target.longitude}, zoom: ${position.zoom}");
  }

  Future<void> loadMapStyle() async {
    try {
      darkMapStyle =
          await rootBundle.loadString('assets/map_style/map_style.json');
      print("✅ Map style loaded successfully");
      _applyMapStyle();
    } catch (e) {
      print("❌ Failed to load map style: $e");
    }
  }

  void _applyMapStyle() {
    if (darkMapStyle != null && mapController.value != null) {
      try {
        mapController.value!.setMapStyle(darkMapStyle);
        print("🎨 Map style applied successfully");
      } catch (e) {
        print("❌ Error applying map style: $e");
      }
    }
  }

  Future<double> getJobLocation(String latitude, String longitude) async {
    Location location = Location();

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.deniedForever) {
      throw Exception('Location permissions permanently denied.');
    }
    if (permissionGranted != PermissionStatus.granted) {
      throw Exception('Location permission denied.');
    }

    try {
      final userLocation = await location.getLocation();
      final LatLng userLatLng = LatLng(
        userLocation.latitude ?? 0.0,
        userLocation.longitude ?? 0.0,
      );

      final LatLng jobLocation = LatLng(
        double.parse(latitude),
        double.parse(longitude),
      );

      jobPath.value = [jobLocation];

      final double jobDistance = _calculateDistance(
        userLatLng.latitude,
        userLatLng.longitude,
        jobLocation.latitude,
        jobLocation.longitude,
      );

      if (mapController.value != null) {
        await _safeAnimateCamera(CameraUpdate.newLatLng(jobLocation));
      }

      return jobDistance;
    } catch (e) {
      print('Error fetching location: $e');
      return -1;
    }
  }

  Future<void> _safeAnimateCamera(CameraUpdate update) async {
    try {
      if (mapController.value != null) {
        await mapController.value!.animateCamera(update);
      }
    } catch (e) {
      print('Camera animation failed: $e');
      try {
        if (mapController.value != null) {
          await mapController.value!.moveCamera(update);
        }
      } catch (e2) {
        print('Move camera also failed: $e2');
      }
    }
  }

  Future<void> requestAndSaveLocation() async {
    isLoading.value = true;
    Location location = Location();

    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled.');
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied.');
        }
      }
      if (permissionGranted == PermissionStatus.deniedForever) {
        throw Exception('Location permissions permanently denied.');
      }

      final userLocation = await location.getLocation();
      _currentUserLocation =
          LatLng(userLocation.latitude ?? 0.0, userLocation.longitude ?? 0.0);

      userPath.value = [_currentUserLocation!];

      if (_isFirstLoad && mapController.value != null) {
        final double zoom = _currentCameraPosition?.zoom ?? 15.0;
        await _safeAnimateCamera(
          CameraUpdate.newLatLngZoom(_currentUserLocation!, zoom),
        );
        _isFirstLoad = false;
      }

      await fetchUserLocations(
        (userLocation.latitude ?? 0.0).toStringAsFixed(4),
        (userLocation.longitude ?? 0.0).toStringAsFixed(4),
      );
    } catch (e) {
      print('Error fetching location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Remove this complex method entirely and replace with:
  Future<void> updateMarkersWithoutMovingCamera(Set<Marker> newMarkers) async {
    // Simply update markers without camera manipulation
    markers.value = newMarkers;
  }

// Also modify the fetchUserLocations method to remove camera restoration:
  Future<void> fetchUserLocations(String latitude, String longitude) async {
    try {
      final GuardLocationResponse? guardResponse =
          await myApiService.getLatestGuardLocations();

      if (guardResponse == null) {
        print('No guard locations response received');
        return;
      }

      print('API response: ${guardResponse.data.length} guards found');

      final newMarkers = <Marker>{};
      String imgurl = 'assets/a.jpg';

      if (_currentUserLocation != null) {
        if (userController.userData.value != null) {
          final userData = userController.userData.value!;
          final profileImages = userData.profileImages;

          final mainImage =
              profileImages?.firstWhereOrNull((img) => img.isMain == true);
          final imageToUse = mainImage ?? profileImages?.firstOrNull;

          if (imageToUse != null && imageToUse.image != null) {
            imgurl = MyApIService.imageBaseUrlMap + imageToUse.image!;
          } else {
            imgurl = "assets/a.jpg";
          }
        }

        final userIcon = await _createUserMarker(imgurl);
        newMarkers.add(
          Marker(
            markerId: const MarkerId('user_location'),
            position: _currentUserLocation!,
            icon: userIcon,
            infoWindow: const InfoWindow(title: 'You (Contractor)'),
          ),
        );
      }

      for (final guardLocation in guardResponse.data) {
        final LatLng position = guardLocation.location.latLng;

        if (position.latitude == 0.0 && position.longitude == 0.0) continue;

        String guardImageUrl = guardLocation.guard.images.isNotEmpty
            ? guardLocation.guard.profileImageUrl
            : "assets/userpicture.jpg";

        final customMarkerIcon = await _createCustomMarker(
          guardImageUrl,
          guardLocation.guard.name,
        );

        newMarkers.add(
          Marker(
            markerId: MarkerId('guard_${guardLocation.guard.id}'),
            position: position,
            icon: customMarkerIcon ??
                BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
            onTap: () => onMarkerTapped(guardLocation),
          ),
        );
      }

      // SIMPLIFIED: Just update markers without camera manipulation
      markers.value = newMarkers;
    } catch (e) {
      print("❌ Error fetching guard locations: $e");
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  Future<void> refreshMap() async {
    if (_currentUserLocation != null) {
      await fetchUserLocations(
        _currentUserLocation!.latitude.toStringAsFixed(4),
        _currentUserLocation!.longitude.toStringAsFixed(4),
      );
    }
  }

  Future<void> centerOnUserLocation() async {
    if (_currentUserLocation != null && mapController.value != null) {
      await _safeAnimateCamera(
        CameraUpdate.newLatLngZoom(_currentUserLocation!, 15.0),
      );
    }
  }

  void clearSelectedGuard() {
    selectedGuard.value = null;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Future<BitmapDescriptor> _createImageMarker(
  //   String imageUrl, {
  //   double size = 150,
  //   String? overlayText,
  // }) async {
  //   ui.Image? finalImage;
  //   ui.Image? frameImage;

  //   try {
  //     Uint8List imageBytes;

  //     // COMMENTED OUT NETWORK IMAGE LOADING - USING ONLY ASSET IMAGES
  //     // if (imageUrl.startsWith('http')) {
  //     //   try {
  //     //     imageBytes =
  //     //         (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
  //     //             .buffer
  //     //             .asUint8List();
  //     //   } catch (e) {
  //     //     print("❌ Failed to load network image: $e, falling back to asset");
  //     //     imageBytes = (await rootBundle.load("assets/userpicture.jpg"))
  //     //         .buffer
  //     //         .asUint8List();
  //     //   }
  //     // } else {
  //     //   try {
  //     //     imageBytes = (await rootBundle.load(imageUrl)).buffer.asUint8List();
  //     //   } catch (e) {
  //     //     print(
  //     //         "❌ Failed to load asset image: $e, falling back to default asset");
  //     //     imageBytes = (await rootBundle.load("assets/userpicture.jpg"))
  //     //         .buffer
  //     //         .asUint8List();
  //     //   }
  //     // }

  //     // ALWAYS load from assets
  //     try {
  //       imageBytes = (await rootBundle.load(imageUrl)).buffer.asUint8List();
  //       print("✅ Loaded asset image: $imageUrl");
  //     } catch (e) {
  //       print(
  //           "❌ Failed to load asset image: $e, falling back to default asset");
  //       imageBytes = (await rootBundle.load("assets/userpicture.jpg"))
  //           .buffer
  //           .asUint8List();
  //     }

  //     final ui.Codec codec = await ui.instantiateImageCodec(
  //       imageBytes,
  //       targetWidth: size.toInt(),
  //       targetHeight: size.toInt(),
  //     );
  //     final ui.FrameInfo frameInfo = await codec.getNextFrame();
  //     frameImage = frameInfo.image;

  //     final bool hasBadge = overlayText != null && overlayText.isNotEmpty;
  //     final double badgeHeight = 35.0;
  //     final double badgeWidth = size * 0.9;
  //     final double totalHeight = size + (hasBadge ? badgeHeight + 8 : 0);
  //     final double totalWidth = size;

  //     final ui.PictureRecorder recorder = ui.PictureRecorder();
  //     final Canvas canvas = Canvas(recorder);

  //     final double centerX = size / 2;
  //     final double imageCenterY = size / 2;

  //     final Paint circlePaint = Paint()..color = const Color(0xFF4CAF50);
  //     canvas.drawCircle(Offset(centerX, imageCenterY), size / 2, circlePaint);

  //     final Rect imageRect = Rect.fromCircle(
  //       center: Offset(centerX, imageCenterY),
  //       radius: (size / 2) - 4,
  //     );

  //     canvas.save();
  //     canvas.clipPath(Path()..addOval(imageRect));
  //     paintImage(
  //       canvas: canvas,
  //       rect: imageRect,
  //       image: frameImage,
  //       fit: BoxFit.cover,
  //     );
  //     canvas.restore();

  //     if (hasBadge) {
  //       final double badgeLeft = (size - badgeWidth) / 2;
  //       final double badgeTop = size + 4;

  //       final Paint badgePaint = Paint()..color = const Color(0xFF4CAF50);
  //       final Rect badgeRect =
  //           Rect.fromLTWH(badgeLeft, badgeTop, badgeWidth, badgeHeight);
  //       canvas.drawRRect(
  //         RRect.fromRectAndRadius(badgeRect, const Radius.circular(8)),
  //         badgePaint,
  //       );

  //       final textStyle = ui.TextStyle(
  //         color: Color(0xFFFFFFFF),
  //         fontSize: 16,
  //         fontWeight: FontWeight.bold,
  //       );

  //       final paragraphBuilder = ui.ParagraphBuilder(
  //         ui.ParagraphStyle(
  //           textAlign: TextAlign.center,
  //           maxLines: 1,
  //         ),
  //       )
  //         ..pushStyle(textStyle)
  //         ..addText(overlayText!);

  //       final paragraph = paragraphBuilder.build();
  //       paragraph.layout(ui.ParagraphConstraints(width: badgeWidth - 8));

  //       canvas.drawParagraph(
  //         paragraph,
  //         Offset(
  //           badgeLeft + (badgeWidth - paragraph.width) / 2,
  //           badgeTop + (badgeHeight - paragraph.height) / 2,
  //         ),
  //       );
  //     }

  //     finalImage = await recorder
  //         .endRecording()
  //         .toImage(totalWidth.toInt(), totalHeight.toInt());
  //     final ByteData? pngBytes =
  //         await finalImage.toByteData(format: ui.ImageByteFormat.png);

  //     if (pngBytes == null) {
  //       throw Exception('Failed to convert image to bytes');
  //     }

  //     print("✅ Guard marker created with badge: $overlayText");
  //     return BitmapDescriptor.fromBytes(pngBytes.buffer.asUint8List());
  //   } catch (e) {
  //     print("❌ Error creating guard marker: $e");
  //     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  //   } finally {
  //     finalImage?.dispose();
  //     frameImage?.dispose();
  //   }
  // }
  Future<BitmapDescriptor> _createImageMarker(
    String imageUrl, {
    double size = 150,
    String? overlayText,
  }) async {
    ui.Image? finalImage;
    ui.Image? frameImage;

    try {
      Uint8List imageBytes;

      // Check if image is from API (HTTP URL) and try to load it
      if (imageUrl.startsWith('http')) {
        try {
          print("🔄 Loading API image: $imageUrl");
          imageBytes =
              (await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl))
                  .buffer
                  .asUint8List();
          print("✅ Successfully loaded API image");
        } catch (e) {
          print("❌ Failed to load API image: $e, falling back to asset");
          // Fall back to asset image if API image fails
          imageBytes = (await rootBundle.load("assets/userpicture.jpg"))
              .buffer
              .asUint8List();
        }
      } else {
        // Load from assets (local image)
        try {
          imageBytes = (await rootBundle.load(imageUrl)).buffer.asUint8List();
          print("✅ Loaded asset image: $imageUrl");
        } catch (e) {
          print(
              "❌ Failed to load asset image: $e, falling back to default asset");
          imageBytes = (await rootBundle.load("assets/userpicture.jpg"))
              .buffer
              .asUint8List();
        }
      }

      // Rest of your existing image processing code...
      final ui.Codec codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: size.toInt(),
        targetHeight: size.toInt(),
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      frameImage = frameInfo.image;

      final bool hasBadge = overlayText != null && overlayText.isNotEmpty;
      final double badgeHeight = 35.0;
      final double badgeWidth = size * 0.9;
      final double totalHeight = size + (hasBadge ? badgeHeight + 8 : 0);
      final double totalWidth = size;

      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      final double centerX = size / 2;
      final double imageCenterY = size / 2;

      final Paint circlePaint = Paint()..color = const Color(0xFF4CAF50);
      canvas.drawCircle(Offset(centerX, imageCenterY), size / 2, circlePaint);

      final Rect imageRect = Rect.fromCircle(
        center: Offset(centerX, imageCenterY),
        radius: (size / 2) - 4,
      );

      canvas.save();
      canvas.clipPath(Path()..addOval(imageRect));
      paintImage(
        canvas: canvas,
        rect: imageRect,
        image: frameImage,
        fit: BoxFit.cover,
      );
      canvas.restore();

      if (hasBadge) {
        final double badgeLeft = (size - badgeWidth) / 2;
        final double badgeTop = size + 4;

        final Paint badgePaint = Paint()..color = const Color(0xFF4CAF50);
        final Rect badgeRect =
            Rect.fromLTWH(badgeLeft, badgeTop, badgeWidth, badgeHeight);
        canvas.drawRRect(
          RRect.fromRectAndRadius(badgeRect, const Radius.circular(8)),
          badgePaint,
        );

        final textStyle = ui.TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );

        final paragraphBuilder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        )
          ..pushStyle(textStyle)
          ..addText(overlayText!);

        final paragraph = paragraphBuilder.build();
        paragraph.layout(ui.ParagraphConstraints(width: badgeWidth - 8));

        canvas.drawParagraph(
          paragraph,
          Offset(
            badgeLeft + (badgeWidth - paragraph.width) / 2,
            badgeTop + (badgeHeight - paragraph.height) / 2,
          ),
        );
      }

      finalImage = await recorder
          .endRecording()
          .toImage(totalWidth.toInt(), totalHeight.toInt());
      final ByteData? pngBytes =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);

      if (pngBytes == null) {
        throw Exception('Failed to convert image to bytes');
      }

      print("✅ Guard marker created with badge: $overlayText");
      return BitmapDescriptor.fromBytes(pngBytes.buffer.asUint8List());
    } catch (e) {
      print("❌ Error creating guard marker: $e");
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    } finally {
      finalImage?.dispose();
      frameImage?.dispose();
    }
  }

  Future<BitmapDescriptor> _createUserMarker(String imageUrl) async {
    return await _createImageMarker(imageUrl, size: 160);
  }

  Future<BitmapDescriptor?> _createCustomMarker(
      String imageUrl, String guardName) async {
    return await _createImageMarker(
      imageUrl,
      size: 160,
      overlayText: "🛡️ $guardName",
    );
  }

  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
    _applyMapStyle();

    // Future.delayed(Duration(milliseconds: 100), _applyMapStyle);
    // Future.delayed(Duration(milliseconds: 500), _applyMapStyle);
  }

  CameraPosition? get currentCameraPosition => _currentCameraPosition;
}
