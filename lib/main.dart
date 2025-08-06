import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/dataproviders/notification_services/notification_handler.dart';
import 'package:taccontractor/dataproviders/notification_services/notification_services.dart';
import 'package:taccontractor/firebase_options.dart';
import 'package:taccontractor/modules/auth/auth_controller/google_signin_controller.dart';
import 'package:taccontractor/routes/app_routes.dart';
import 'controllers/user_controller.dart';
import 'data/data/constants/app_theme.dart';
import 'modules/Jobs/Create Jobs/company_info_controller.dart';

// Future<String> getInitialRoute() async {
//   final prefs = await SharedPreferences.getInstance();
//   final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//   final loginTime = prefs.getInt('loginTime');
//
//   if (!isLoggedIn || loginTime == null) {
//     return AppRoutes.getOnboardingRoute(); // User not logged in
//   }
//
//   final now = DateTime.now().millisecondsSinceEpoch;
//   if (now - loginTime < 4 * 60 * 60 * 1000) {
//     return AppRoutes.getLandingPageRoute(); // User logged in and session valid
//   } else {
//     // Session expired, clear stored session
//     await prefs.remove('isLoggedIn');
//     await prefs.remove('loginTime');
//     return AppRoutes.getOnboardingRoute();
//   }
// }


// Future bg_notification(RemoteMessage message)async{
//   if(message.notification!=null){
//     print("message received in background");
//   }
// }

// void main() async {

//   WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
//   await SystemChrome.setPreferredOrientations(
//     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
//   );
 
//   String? devToken=await FirebaseMessaging.instance.getToken();
//   print("Device Token: $devToken");

//    // Local Notifications
//   FirebaseMessaging.onBackgroundMessage(bg_notification);
//   NotificationServices.requestNotificationPermission();
//   NotificationServices.localNotiInit();

//   // FCM Handlers
//   NotificationHandlerController.initializeFCMHandlers();
//   await NotificationHandlerController.handleTerminatedState();


//   Get.put(UserController(), permanent: true);
//   Get.put(SetJobDetailsController());
//   // Get.put(SessionManagerController()); 
//   Get.put(GoogleSignInController()); // Register the controller

//   // final initialRoute = await getInitialRoute();
//   // runApp(Main(initialRoute: initialRoute,));
//   runApp(
//     Main(
//       initialRoute: AppRoutes.splashScreen,
//     ),
//   );
// }

// class Main extends StatelessWidget {
//   final String initialRoute;
//   Main({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     // final themeController = Get.put(ThemeController());
//     // debugPrint(themeController.theme);
//     return GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () {
//         FocusManager.instance.primaryFocus?.unfocus();
//       },
//       child: GetMaterialApp(
//         color: AppColors.kDarkBlue,
//         title: 'TAC',
//         debugShowCheckedModeBanner: false,
//         useInheritedMediaQuery: true,
//         // locale: DevicePreview.locale(context),
//         // builder: DevicePreview.appBuilder,
//         scrollBehavior: const ScrollBehavior()
//             .copyWith(physics: const BouncingScrollPhysics()),
//         defaultTransition: Transition.fadeIn,
//         // theme: AppTheme.lightTheme,
//         // darkTheme: AppTheme.darkTheme,
//         // themeMode: getThemeMode(themeController.theme),
//         // initialRoute: AppRoutes.getOnboardingRoute(),
//         initialRoute: AppRoutes.splashScreen,
//         getPages: AppRoutes.routes,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


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

  // ✅ Background handler registration MUST be BEFORE runApp()
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // ✅ Initialize Local Notifications
  NotificationServices.requestNotificationPermission();
  NotificationServices.localNotiInit();

  // ✅ FCM Foreground & Terminated State
  NotificationHandlerController.initializeFCMHandlers();
  await NotificationHandlerController.handleTerminatedState();

  // ✅ Dependency Injection
  Get.put(UserController(), permanent: true);
  Get.put(SetJobDetailsController());
  // Get.put(SessionManagerController()); 

  runApp(Main(initialRoute: AppRoutes.splashScreen));
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
        initialRoute: AppRoutes.splashScreen,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
