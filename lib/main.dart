import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:taccontractor/controllers/mapController.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/dataproviders/notification_services/notification_handler.dart';
import 'package:taccontractor/dataproviders/notification_services/notification_services.dart';
import 'package:taccontractor/firebase_options.dart';
import 'package:taccontractor/modules/Guards/guards_view.dart';
import 'package:taccontractor/modules/auth/auth_controller/google_signin_controller.dart';
import 'package:taccontractor/routes/app_routes.dart';
import 'controllers/user_controller.dart';
import 'data/data/constants/app_theme.dart';
import 'modules/Jobs/Create Jobs/company_info_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart'; // ✅ Already present

// ✅ Top-level background handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // required in background isolate
  print("📩 Background message received: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Register background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  NotificationServices.requestNotificationPermission();
  NotificationServices.localNotiInit();

  // ✅ Handle FCM States
  NotificationHandlerController.initializeFCMHandlers();
  await NotificationHandlerController.handleTerminatedState();

  // ✅ Dependency Injection
  Get.put(UserController(), permanent: true);
  Get.put(SetJobDetailsController());

  // ✅ Check SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? biometricEnabled = prefs.getBool('biometric_login');
  bool liveLocationEnabled = prefs.getBool('live_location') ?? false;

  // ✅ Biometric Handling
  String initialRoute = AppRoutes.splashScreen;

  if (biometricEnabled == true) {
    bool authenticated = await _authenticateWithBiometrics();
    if (!authenticated) {
      initialRoute = AppRoutes.biometricLock;
    }
  }

  runApp(Main(initialRoute: initialRoute));

  // The disclosure needs a mounted Flutter context before any permission request.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (liveLocationEnabled) {
      await _initializeLocationWithDisclosure();
    } else {
      Get.put(MapController(), permanent: true);
      debugPrint("📍 Live location disabled, MapController initialized");
    }
  });
}

// ✅ New function to handle location with prominent disclosure
Future<void> _initializeLocationWithDisclosure() async {
  try {
    // First check if location service is enabled
    final location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        debugPrint("⚠️ Location service not enabled");
        Get.put(MapController(), permanent: true);
        return;
      }
    }

    final PermissionStatus backgroundStatus =
        await Permission.locationAlways.status;
    debugPrint("📍 Background permission status: $backgroundStatus");

    // Explain background use before either location permission prompt.
    if (!backgroundStatus.isGranted &&
        (backgroundStatus.isDenied || backgroundStatus.isRestricted)) {
      final bool userConsented = await showProminentDisclosureForLocation();
      if (!userConsented) {
        debugPrint("⚠️ User declined background location after disclosure");
        Get.put(MapController(), permanent: true);
        return;
      }
    }

    PermissionStatus permissionStatus = await Permission.location.status;
    debugPrint("📍 Foreground permission status: $permissionStatus");

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.location.request();
      debugPrint("📍 Foreground permission after request: $permissionStatus");
    }

    if (permissionStatus.isGranted) {
      if (backgroundStatus.isDenied || backgroundStatus.isRestricted) {
        final PermissionStatus result =
            await Permission.locationAlways.request();
        debugPrint("📍 Background permission after disclosure: $result");

        if (result.isGranted) {
          debugPrint("✅ Background location permission granted");
        } else {
          debugPrint(
              "⚠️ Background location permission denied after disclosure");
        }
      } else if (backgroundStatus.isGranted) {
        debugPrint("✅ Background location permission already granted");
      }

      // ✅ Initialize MapController regardless (use with available permissions)
      Get.put(MapController(), permanent: true);
      debugPrint("📍 MapController initialized successfully");
    } else {
      // Foreground permission denied
      debugPrint("⚠️ Foreground location permission denied");
      Get.put(MapController(), permanent: true);
    }
  } catch (e) {
    debugPrint("⚠️ Location initialization failed: $e");
    // Still initialize MapController to avoid null errors
    if (!Get.isRegistered<MapController>()) {
      Get.put(MapController(), permanent: true);
    }
  }
}

// ✅ Prominent Disclosure Dialog for Background Location
Future<bool> showProminentDisclosureForLocation() async {
  Completer<bool> completer = Completer<bool>();

  // Get context from GetX navigation - ensure it's available
  BuildContext? context = Get.context;

  // If context is null, try to get it from the navigator
  context ??= Get.key?.currentContext;

  if (context == null) {
    debugPrint("⚠️ No context available for disclosure dialog");
    return false;
  }

  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.blue.shade700),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Location Access Required',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'This app needs location access for guard monitoring and attendance verification:',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✓ Verify you are at your assigned work site',
                      style: TextStyle(fontSize: 13, height: 1.8),
                    ),
                    Text(
                      '✓ Track working hours and attendance',
                      style: TextStyle(fontSize: 13, height: 1.8),
                    ),
                    Text(
                      '✓ Prevent clock-in/out fraud',
                      style: TextStyle(fontSize: 13, height: 1.8),
                    ),
                    Text(
                      '✓ Ensure accurate payroll processing',
                      style: TextStyle(fontSize: 13, height: 1.8),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.orange.shade700, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '⚠️ Background Location Tracking',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This app needs to access your location even when the app is in the background or closed to:',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Detect when you leave the worksite unexpectedly',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    Text(
                      '• Maintain accurate attendance records',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    Text(
                      '• Ensure security compliance for client billing',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                '🔒 Your location data is secure and only used for work verification purposes.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              completer.complete(false);
              Navigator.pop(context);
            },
            child: Text(
              'Continue Without Location',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              completer.complete(true);
              Navigator.pop(context);
            },
            icon: Icon(Icons.location_on),
            label: Text('Enable Location Tracking'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    },
  );

  return completer.future;
}

// ✅ Biometric Authentication Function
Future<bool> _authenticateWithBiometrics() async {
  final LocalAuthentication auth = LocalAuthentication();

  try {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    if (!canAuthenticate) {
      debugPrint('⚠️ Device does not support biometrics');
      return true; // Allow access if device doesn't support biometrics
    }

    final bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Please authenticate to access the app',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: false,
      ),
    );

    return didAuthenticate;
  } on PlatformException catch (e) {
    debugPrint('⚠️ Biometric authentication error: $e');
    return false;
  }
}

class Main extends StatelessWidget {
  final String initialRoute;
  const Main({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        color: AppColors.kDarkBlue,
        title: 'TAC',
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        scrollBehavior: const ScrollBehavior().copyWith(
          physics: const BouncingScrollPhysics(),
        ),
        defaultTransition: Transition.fadeIn,
        initialRoute: initialRoute,
        getPages: AppRoutes.routes,
        theme: ThemeData(
          fontFamily: GoogleFonts.outfit().fontFamily,
          textTheme: GoogleFonts.outfitTextTheme(),
          primaryTextTheme: GoogleFonts.outfitTextTheme(),
          useMaterial3: true,
        ),
      ),
    );
  }
}
