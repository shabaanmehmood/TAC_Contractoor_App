import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/constants.dart';
import 'package:taccontractor/modules/Jobs/Create%20Jobs/setJobDetailsScreen.dart';
import 'package:taccontractor/modules/account/components/logoutConstant.dart';
import 'package:taccontractor/modules/account/components/session_logout_controller.dart';
import 'package:taccontractor/modules/auth/auth_controller/google_signin_controller.dart';
import 'package:taccontractor/modules/auth/forget_password.dart';
import 'package:taccontractor/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../dataproviders/api_service.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/TextFormFieldWidget.dart';
import '../../widhets/common widgets/buttons/adaptive_dialogue.dart';
import '../../widhets/common widgets/buttons/password_field.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../../widhets/common widgets/buttons/primary_container.dart';

// class SignInViewController extends GetxController {
//   var passwordVisible = false.obs;

//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

//   void togglePasswordView() {
//     passwordVisible.value = !passwordVisible.value;
//   }

//   Future<void> saveLoginSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isLoggedIn', true);
//     await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
//   }

//   Future<void> submitSignIn(BuildContext context) async {
//     if (formKey.currentState!.validate()) {
//       final apiService = MyApIService(); // create instance
//       try{
//         final response = await apiService.login(
//           emailController.text.toString(),
//           passwordController.text.toString(),
//         );

//         if (response.statusCode == 200) {
//           debugPrint("data from API ${response.body}");
//           // await _sessionManagerController.saveLoginSession(); // <--- CALL IT HERE

//           Get.offAndToNamed(AppRoutes.getLandingPageRoute());
//           // await saveLoginSession();
//         } else {
//           debugPrint("data from API ${response.body}");
//           debugPrint("data from API ${response.body}");
//           final Map<String, dynamic> responseBody = jsonDecode(response.body);
//           final String errorMessage = responseBody['message'] ?? 'Unknown error';

//           // Show dialog with one line call
//           await AdaptiveAlertDialogWidget.show(
//             context,
//             title: 'Login Failed',
//             content: errorMessage,
//             yesText: 'OK',
//             showNoButton: false,
//             onYes: () {
//               // Optional: do something on OK pressed
//             },
//           );
//           debugPrint('Error login failed: ${response.body}');
//         }
//       }
//       catch(e){
//         debugPrint('Error Network error: ${e.toString()}');
//         await AdaptiveAlertDialogWidget.show(
//           context,
//           title: 'Network Error',
//           content: e.toString(),
//           yesText: 'OK',
//           showNoButton: false,
//         );
//       }
//     }
//   }

// }

class SignInViewController extends GetxController {
  String? fcmToken;
  var passwordVisible = false.obs;
  var rememberMe = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final String rememberEmailKey = AppConstants.rememberEmailKey;
  final String rememberPasswordKey = AppConstants.rememberPasswordKey;
  final String loginTimeKey = AppConstants.loginTimeKey;


  void togglePasswordView() {
    passwordVisible.value = !passwordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
    _initFCM();
    _listenForTokenRefresh();
  }

  Future<void> _initFCM() async {
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('Initial FCM Token: $fcmToken');
    } catch (e) {
      debugPrint('Failed to get FCM Token: $e');
    }
  }

  void _listenForTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('Refreshed FCM Token: $newToken');
      fcmToken = newToken;
      // You may want to update your server/backend here if user is logged in
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> _checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final loginTimestamp = prefs.getInt(loginTimeKey);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (loginTimestamp != null && (now  - loginTimestamp <= 8 * 60 * 60 * 1000)) {
      final rememberedEmail = prefs.getString(rememberEmailKey);
      final rememberedPassword = prefs.getString(rememberPasswordKey);

      if (rememberedEmail != null && rememberedPassword != null) {
        emailController.text = rememberedEmail;
        passwordController.text = rememberedPassword;

        await submitSignIn(Get.context!, fcmToken,  autoLogin: true);
      }
    } else {
      await prefs.remove(rememberEmailKey);
      await prefs.remove(rememberPasswordKey);
      await prefs.remove(loginTimeKey);

      emailController.clear();
      passwordController.clear();
      rememberMe.value = false;
      return;
    }
  }

  Future<bool> checkAutoLoginAndRedirect() async {
  final prefs = await SharedPreferences.getInstance();
  final loginTimestamp = prefs.getInt(loginTimeKey);
  final now = DateTime.now().millisecondsSinceEpoch;

  if (loginTimestamp != null && (now - loginTimestamp <= 8 * 60 * 60 * 1000)) {
    final rememberedEmail = prefs.getString(rememberEmailKey);
    final rememberedPassword = prefs.getString(rememberPasswordKey);

    if (rememberedEmail != null && rememberedPassword != null) {
      emailController.text = rememberedEmail;
      passwordController.text = rememberedPassword;

      final response = await MyApIService().login(
        rememberedEmail.trim(),
        rememberedPassword.trim(),
        fcmToken!,
      );

      if (response.statusCode == 200) {
        await prefs.setInt(loginTimeKey, DateTime.now().millisecondsSinceEpoch);
        Get.offAllNamed(AppRoutes.getLandingPageRoute());
        return true;
      }
    }
  }

  // Clear stale data
  await prefs.remove(rememberEmailKey);
  await prefs.remove(rememberPasswordKey);
  await prefs.remove(loginTimeKey);

  return false;
}


  Future<void> submitSignIn(BuildContext context, String? fcmToken, {bool autoLogin = false}) async {
    if (autoLogin || formKey.currentState!.validate()) {
      final apiService = MyApIService();

      try {
        final response = await apiService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
          fcmToken!,
        );

        if (response.statusCode == 200) {
          if (rememberMe.value || autoLogin) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(rememberEmailKey, emailController.text.trim());
            await prefs.setString(rememberPasswordKey, passwordController.text.trim());
            await prefs.setInt(loginTimeKey, DateTime.now().millisecondsSinceEpoch);
          }

          Get.offAndToNamed(AppRoutes.getLandingPageRoute());
        } else {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          final String errorMessage = responseBody['message'] ?? 'Unknown error';

          if (!autoLogin) {
            await AdaptiveAlertDialogWidget.show(
              context,
              title: 'Login Failed',
              content: errorMessage,
              yesText: 'OK',
              showNoButton: false,
            );
          }
        }
      } catch (e) {
        if (!autoLogin) {
          await AdaptiveAlertDialogWidget.show(
            context,
            title: 'Network Error',
            content: e.toString(),
            yesText: 'OK',
            showNoButton: false,
          );
        }
      }
    }
  }
}



class SignInView extends StatelessWidget {
  final SignInViewController controller = Get.put(SignInViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.kDarkBlue,
      body: Padding(
        padding: EdgeInsets.only(
            left: AppSpacing.twentyHorizontal,
            right: AppSpacing.twentyHorizontal,
            bottom: AppSpacing.fiveVertical
        ),
        child: Stack(
          children: [
            Positioned(
              top: Get.height * 0.08,
              child: Row(
                children: [
                  Image.asset(
                    AppAssets.kTacLogo,
                    height: Get.height * 0.07,
                    width: Get.width * 0.25,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: AppTypography.kBold24.copyWith(
                          color: AppColors.kWhite
                        )
                      ),
                      Text(
                        "Welcome Back!",
                        style: AppTypography.kLight14.copyWith(
                          color: Colors.grey
                        )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.23),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: controller.emailController,
                        hintText: 'johnsmith@gmail.com',
                        iconPath: AppAssets.kEmail,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(320)
                        ],
                        onChanged: (value) {
                          controller.formKey.currentState!.validate();
                        },
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.fifteenVertical),
                      Obx(() => CustomPasswordField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: controller.passwordController,
                        obscureText: !controller.passwordVisible.value,
                        hintText: '*********',
                        iconPath: AppAssets.kPassword,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(64)
                        ],
                        passwordVisible: controller.passwordVisible.value,
                        onPressed: (){
                          controller.togglePasswordView();
                        },
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.formKey.currentState!.validate();
                        },
                      )),
                      SizedBox(height: AppSpacing.tenVertical),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: 
                            // CheckboxListTile(
                            //   value: false,
                            //   onChanged: (value) {
                            //     // Handle checkbox state change
                            //   },
                            //   contentPadding: EdgeInsets.zero,
                            //   controlAffinity: ListTileControlAffinity.leading,
                            //   title: Text('Remember me', style: AppTypography.kLight14.copyWith(
                            //       color: AppColors.kWhite
                            //   ),),
                            // ),

                            Obx(() => CheckboxListTile(
                                  value: controller.rememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(
                                    'Remember me',
                                    style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                                  ),
                                )),

                          ),
                          Flexible(
                            child: TextButton(
                                onPressed: (){
                                  Get.to(() => ForgetPasswordView());
                                },
                                child: Text(
                                  'Forget Password',
                                  style: AppTypography.kBold16.copyWith(
                                      color: AppColors.kSkyBlue
                                  ),)),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.fifteenVertical,),
                      PrimaryButton(
                        color: AppColors.kSkyBlue,
                        onTap: () async {
                          // await controller.submitSignIn(context);
                          await controller.submitSignIn(context, controller.fcmToken);
                        },
                        text: 'Login',
                      ),
                      SizedBox(height: AppSpacing.twentyVertical,),
                      Center(
                        child: Text(
                          'OR',
                          style: AppTypography.kBold16.copyWith(
                            color: AppColors.kSkyBlue,
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.twentyVertical,),
                      PrimaryContainer(
                          width: double.maxFinite,
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.kGoogleLogo,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: AppSpacing.twentyHorizontal,),
                              GestureDetector(
                                onTap: () async {
                                  final googleAuthService = GoogleAuthService();
                                  await googleAuthService.signInWithGoogle();
                                  },
                                child: Text(
                                  'Continue with Google',
                                  style: AppTypography.kBold18.copyWith(
                                      color: AppColors.kWhite
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      SizedBox(height: AppSpacing.twentyVertical,),
                      PrimaryContainer(
                          width: double.maxFinite,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.kAppleLogo,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: AppSpacing.twentyHorizontal,),
                              Text(
                                'Continue with Apple',
                                style: AppTypography.kBold18.copyWith(
                                    color: AppColors.kWhite
                                ),
                              )
                            ],
                          )
                      ),
                      SizedBox(height: AppSpacing.thirtyVertical,),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: AppTypography.kBold16.copyWith(
                                    color: Colors.grey
                                ),
                              ),
                              TextButton(
                                onPressed: (){
                                  Get.toNamed(AppRoutes.getSelectRoute());
                                },
                                child: Text(
                                  'Create Account',
                                  style: AppTypography.kBold18.copyWith(
                                      color: AppColors.kSkyBlue
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            'Powered by TAC Solutions',
                            style: AppTypography.kLight14.copyWith(
                            color: Colors.grey
                        ),
                      ),
                        ],
                      ),
                     
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}