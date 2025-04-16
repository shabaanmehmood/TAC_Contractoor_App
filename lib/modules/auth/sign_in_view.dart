import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/constants.dart';
import 'package:tac/modules/auth/forget_password.dart';
import 'package:tac/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/data/constants/app_assets.dart';
import '../../dataproviders/api_service.dart';
import '../../models/onboarding.dart';
import '../../widhets/common widgets/buttons/TextFormFieldWidget.dart';
import '../../widhets/common widgets/buttons/password_field.dart';
import '../../widhets/common widgets/buttons/primary_button.dart';
import '../../widhets/common widgets/buttons/primary_container.dart';

class SignInViewController extends GetxController {
  var passwordVisible = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void togglePasswordView() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<void> submitSignIn() async {
    if (formKey.currentState!.validate()) {
      final apiService = MyApIService(); // create instance
      try{
        final response = await apiService.login(
          emailController.text.toString(),
          passwordController.text.toString(),
        );

        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.offAndToNamed(AppRoutes.getLandingPageRoute());
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error login failed: ${response.body}');
        }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
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
                            child: CheckboxListTile(
                              value: false,
                              onChanged: (value) {
                                // Handle checkbox state change
                              },
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text('Remember me', style: AppTypography.kLight14.copyWith(
                                  color: AppColors.kWhite
                              ),),
                            ),
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
                        onTap: () {
                          controller.submitSignIn();
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
                              Text(
                                'Continue with Google',
                                style: AppTypography.kBold18.copyWith(
                                    color: AppColors.kWhite
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
                              Get.toNamed(AppRoutes.getSignUpRoute());
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
