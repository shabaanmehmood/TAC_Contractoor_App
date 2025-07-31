
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:taccontractor/modules/Guards/guards_view.dart';
import 'package:taccontractor/modules/Guards/job_details/job_details_screen.dart';
import 'package:taccontractor/modules/account/account.dart';
import 'package:taccontractor/modules/account/components/profile/profile_screen.dart';
import 'package:taccontractor/modules/auth/sign_up_view.dart';
import 'package:taccontractor/modules/auth/sign_in_view.dart';
import 'package:taccontractor/modules/jobDetailsScreen/open/jobDetailsScreen.dart';
import 'package:taccontractor/modules/landing_page/landing_page.dart';
import 'package:taccontractor/modules/myJobs/myJobsScreen.dart';
import 'package:taccontractor/modules/splashScreen/splashScreen.dart';

import '../modules/auth/signup_screens/select_account_type_screen.dart';
import '../modules/onboarding/onboarding_view.dart';

class AppRoutes {
  static String splashScreen = '/';
  static String onboarding = '/onboarding';
  // static String welcome = '/auth';
  static String signIn = '/sign-in';
  static String select = '/SelectAccountTypeScreen';
  static String signUp = '/sign-up';
  static String landing = '/landing-page';
  static String settings = '/settings';
  static String profile = '/profile';
  static String guards = '/guards';
  

  static List<GetPage> routes = [
    GetPage<Route<dynamic>>(
      name: splashScreen,
      page: () =>SplashScreen(),
    ),
    GetPage<Route<dynamic>>(
      name: onboarding,
      page: () =>OnboardingView(),
    ),
    // GetPage<Route<dynamic>>(
    //   name: welcome,
    //   page: () => WelcomeView(),
    // ),
    GetPage<Route<dynamic>>(
      name: signIn,
      page: () => SignInView(),
    ),
    GetPage<Route<dynamic>>(
      name: select,
      page: () => const SelectAccountTypeScreen(),
    ),
    GetPage<Route<dynamic>>(
      name: landing,
      page: () => const LandingPage(),
    ),
    GetPage<Route<dynamic>>(
      name: profile,
      page: () => const AccountScreen(),
    ),
    GetPage<Route<dynamic>>(
      name: guards,
      page: () => const GuardsView(),
    ),

    // GetPage<Route<dynamic>>(
    //   name: settings,
    //   page: () => const SettingsView(),
    // ),
  ];

  static String getOnboardingRoute() => onboarding;
  // static String getWelcomeRoute() => welcome;
  static String getSignInRoute() => signIn;
  static String getSelectRoute() => select;
  static String getLandingPageRoute() => landing;
  static String getSettingPageRoute() => settings;
  static String getProfilePageRoute() => profile;
  static String getGuardsPageRoute() => guards;
}
