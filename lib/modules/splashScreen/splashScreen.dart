import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/modules/auth/sign_in_view.dart';
import 'package:taccontractor/modules/onboarding/onboarding_view.dart';
import 'package:taccontractor/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  final List<String> _images = [
    'assets/splash_Logo1.png',
    'assets/logoforhomescreen.png',
    'assets/splash_Logo2.png',
  ];

  @override
  void initState() {
    super.initState();
    _startImageSequence();
  }

  void _startImageSequence() async {
    for (int i = 0; i < _images.length; i++) {
      setState(() {
        _currentImageIndex = i;
      });
      await Future.delayed(Duration(seconds: 1));
    }

    // Show splash for a total of 3+ seconds
    await Future.delayed(Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();

     bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      if (isFirstTime) {
        Get.to(() => OnboardingView());
      } else {
        final signInController = Get.put(SignInViewController(), permanent: true);
        bool isLoggedIn = await signInController.checkAutoLoginAndRedirect();
        Get.back();
        if (!isLoggedIn) {
          Get.toNamed(AppRoutes.getSignInRoute());
        }
      }

    // final signInController = Get.put(SignInViewController(), permanent: true);
    // bool isLoggedIn = await signInController.checkAutoLoginAndRedirect();
    // Get.back(); 
    // if (!isLoggedIn) {
    //   Get.to(() => OnboardingView());
    // }
  }

  @override
Widget build(BuildContext context) {
  // Dynamic sizing based on current index
  double height = _currentImageIndex == 0 ? Get.height * 0.3 : Get.height * 0.9;
  double width = _currentImageIndex == 0 ? Get.width * 0.35 : Get.width * 0.8;

  return Scaffold(
    backgroundColor: AppColors.kDarkBlue,
    body: Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: SizedBox(
          key: ValueKey<int>(_currentImageIndex), // important for AnimatedSwitcher
          height: height,
          width: width,
          child: Image.asset(
            _images[_currentImageIndex],
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
  );
}

}
