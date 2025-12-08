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
import 'package:location/location.dart';


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


  Get.put(MapController(), permanent: true); // <-- Add this line here
  // Get.put(GuardsViewController());
  // Get.put(SessionManagerController());


  // ✅ Check SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? biometricEnabled = prefs.getBool('biometric_login');
  bool liveLocationEnabled = prefs.getBool('live_location') ?? false;



  // ✅ Conditionally enable location
  if (liveLocationEnabled) {
    try {
      final location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
      }

      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
      }

      if (permission == PermissionStatus.granted && serviceEnabled) {
        Get.put(MapController(), permanent: true);
        debugPrint("📍 MapController initialized (Live Location ON)");
      } else {
        debugPrint("⚠️ Location permission denied or service off");
      }
    } catch (e) {
      debugPrint("⚠️ Auto-enable location failed: $e");
    }
  } else {
    Get.put(MapController(), permanent: true);
    debugPrint("📍 Live location disabled, MapController not initialized");
  }

  // ✅ Biometric Handling
  String initialRoute = AppRoutes.splashScreen;

  if (biometricEnabled == true) {
    bool authenticated = await _authenticateWithBiometrics();
    if (!authenticated) {
      initialRoute = AppRoutes.biometricLock;
    }
  }

  runApp(Main(initialRoute: initialRoute));
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


