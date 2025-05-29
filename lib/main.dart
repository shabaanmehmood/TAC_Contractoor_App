import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/routes/app_routes.dart';

import 'controllers/user_controller.dart';
import 'data/data/constants/app_theme.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  Get.put(UserController(), permanent: true);
  // final initialRoute = await getInitialRoute();
  // runApp(Main(initialRoute: initialRoute,));
  runApp(
    Main(
      initialRoute: AppRoutes.onboarding,
    ),
  );
}

class Main extends StatelessWidget {
  final String initialRoute;
  Main({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // final themeController = Get.put(ThemeController());
    // debugPrint(themeController.theme);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
        color: AppColors.kDarkBlue,
        title: 'TAC',
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        scrollBehavior: const ScrollBehavior()
            .copyWith(physics: const BouncingScrollPhysics()),
        defaultTransition: Transition.fadeIn,
        // theme: AppTheme.lightTheme,
        // darkTheme: AppTheme.darkTheme,
        // themeMode: getThemeMode(themeController.theme),
        // initialRoute: AppRoutes.getOnboardingRoute(),
        initialRoute: AppRoutes.onboarding,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
