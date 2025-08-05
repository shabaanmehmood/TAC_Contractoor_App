import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taccontractor/modules/account/components/logout.dart';
import 'package:taccontractor/routes/app_routes.dart'; // Import AppRoutes for navigation

class SessionManagerController extends GetxController with WidgetsBindingObserver {
 
  final LogoutController _logoutController = Get.find<LogoutController>();
 
  static const int sessionTimeoutHours = 4;
  static const int sessionTimeoutMilliseconds = sessionTimeoutHours * 60 * 60 * 1000;

  @override
  void onInit() {
    super.onInit();
    
    WidgetsBinding.instance.addObserver(this);
    
    _checkLoginSession();
  }

  @override
  void onClose() {
    
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
  
    if (state == AppLifecycleState.resumed) {
     
      debugPrint('App resumed. Checking login session...');
      _checkLoginSession();
    }
  }

    Future<void> saveLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
       await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
    debugPrint('Login session saved at: ${DateTime.now()}');
  }

    Future<void> _checkLoginSession() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    final int? loginTime = prefs.getInt('loginTime');

    debugPrint('Session Check: isLoggedIn=$isLoggedIn, loginTime=$loginTime');

       if (isLoggedIn == true && loginTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final timeElapsed = currentTime - loginTime;

      if (timeElapsed >= sessionTimeoutMilliseconds) {
              debugPrint('Session timed out (${Duration(milliseconds: timeElapsed)} elapsed). Logging out...');
               await _logoutController.logout();
             await _logoutController.clearLoginSession();
      } else {
               final Duration remainingTime = Duration(milliseconds: sessionTimeoutMilliseconds - timeElapsed);
        debugPrint('Session is active. Time remaining: ${remainingTime.inMinutes.remainder(60)}m ${remainingTime.inSeconds.remainder(60)}s');

               if (Get.currentRoute == AppRoutes.getSignInRoute()) {
          debugPrint('Session active and on sign-in page. Navigating to landing page.');
          Get.offAndToNamed(AppRoutes.getLandingPageRoute());
        }
      }
    } else {
           debugPrint('User not logged in or login time not found. Clearing any partial session data.');
      if (isLoggedIn == true || loginTime != null) {
        await _logoutController.clearLoginSession();
      }
 
      if (Get.currentRoute != AppRoutes.getSignInRoute()) {
         debugPrint('User not logged in. Navigating to sign-in page.');
         Get.offAllNamed(AppRoutes.getSignInRoute());
      }
    }
  }
}
