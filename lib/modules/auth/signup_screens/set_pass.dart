import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/signUpModelForContractor.dart';
import 'package:taccontractor/modules/auth/signup_screens/document_upload_screen.dart';

import '../../../dataproviders/api_service.dart';
import '../../../models/signUpModelForCompany.dart';
import '../../../routes/app_routes.dart';
import '../../../widhets/common widgets/buttons/adaptive_dialogue.dart';
import 'company_info_controller.dart';

class SetPasswordScreen extends StatefulWidget {
  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final CompanyInfoController companyInfoController = Get.put(CompanyInfoController());
  final DocumentInfoController documentInfoController = Get.put(DocumentInfoController());

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  var isContractor = ''.obs;

  @override
  void initState() {
    super.initState();
    isContractor.value = companyInfoController.registeringAs.value;
  }

  InputDecoration _passwordInputDecoration(
      String hintText, bool obscure, VoidCallback toggleVisibility) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.kDarkestBlue,
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Icon(Icons.lock, color: AppColors.ktextlight, size: 20),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.ktextlight,
        ),
        onPressed: toggleVisibility,
      ),
      hintText: hintText,
      hintStyle: AppTypography.kLight14.copyWith(color: AppColors.kinput),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue, width: 1.5),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
    );
  }

  // ✅ Call this for the company
  Future<void> submitSignupForCompany() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        debugPrint("password do not match");
        return;
      }

      final apiService = MyApIService(); // create instance
      try{
        final signUpModelForCompany = SignUpModelForCompany(
          registeringAs: companyInfoController.registeringAs.value,
          name: companyInfoController.companyName.text,
          email: companyInfoController.companyEmail.text,
          phone: companyInfoController.phone.text,
          postalAddress: companyInfoController.postalAddress.text,
          masterSecurityLicense: companyInfoController.license.text,
          australianBusinessNumber: companyInfoController.abn.text,
          australianCompanyNumber: companyInfoController.acn.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          passport: documentInfoController.passportFile.value,
          whiteCard: (documentInfoController.whiteCardFile.value?.isNotEmpty ?? false)
              ? documentInfoController.whiteCardFile.value
              : null,
          visaWorkingRights: documentInfoController.visaForWorkingRightsFile.value,
          securityLicense: documentInfoController.securityLicenseFile.value,
          abn: (documentInfoController.abnFile.value?.isNotEmpty ?? false)
              ? documentInfoController.abnFile.value
              : null,
          nationalCrimeCheck: documentInfoController.nationalCrimePoliceCheckFile.value,
        );

        final response = await apiService.signUpForCompany(
            SignUpModelForCompany: signUpModelForCompany
        );


          // final response = await apiService.signUpForCompany(
          //   registeringAs: companyInfoController.registeringAs.value,
          //   email: companyInfoController.companyEmail.text,
          //   Name: companyInfoController.companyName.text,
          //   phone: companyInfoController.phone.text,
          //   postalAddress: companyInfoController.postalAddress.text,
          //   masterLicense: companyInfoController.license.text,
          //   austraLianBusinessNumber: companyInfoController.abn.text,
          //   australianCompanyNumber: companyInfoController.acn.text,
          //   password: passwordController.text,
          //   confirmPassword: confirmPasswordController.text,
          //   // dob: companyInfoController.dob.text,
          //   role: companyInfoController.role.text ,
          //   // gender: companyInfoController.genderController.text,
          //   passport: documentInfoController.passportFile.value,
          //   whiteCard: documentInfoController.whiteCardFile.value,
          //   visaWorkingRights: documentInfoController.visaForWorkingRightsFile.value,
          //   securityLicense: documentInfoController.securityLicenseFile.value,
          //   nationalCrimeCheck: documentInfoController.nationalCrimePoliceCheckFile.value,
          //   abn: documentInfoController.abnFile.value,
          // );
          if (response.statusCode == 200) {
            debugPrint("data from API ${response.body}");
            Get.offAndToNamed(AppRoutes.getLandingPageRoute());
            // await saveLoginSession();
          } else {
            debugPrint('Error Signup failed: ${response.body}');
            debugPrint("data from API ${response.body}");
            final Map<String, dynamic> responseBody = jsonDecode(response.body);
            final String errorMessage = responseBody['message'] ?? 'Unknown error';

            // Show dialog with one line call
            await AdaptiveAlertDialogWidget.show(
              context,
              title: 'Signup Failed',
              content: errorMessage,
              yesText: 'OK',
              showNoButton: false,
              onYes: () {
                // Optional: do something on OK pressed
              },
            );
            debugPrint('Error signup failed: ${response.body}');
          }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
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

  // ✅ Call this for the contractor
  Future<void> submitSignupForContractor() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        debugPrint("password do not match");
        return;
      }

      final apiService = MyApIService(); // create instance
      // try{
        //   final response = await apiService.signUpForContractor(
        //     registeringAs: companyInfoController.registeringAs.value,
        //     email: companyInfoController.companyEmail.text,
        //     Name: companyInfoController.companyName.text,
        //     phone: companyInfoController.phone.text,
        //     postalAddress: companyInfoController.postalAddress.text,
        //     // masterLicense: companyInfoController.license.text,
        //     austraLianBusinessNumber: companyInfoController.abn.text,
        //     // australianCompanyNumber: companyInfoController.acn.text,
        //     password: passwordController.text,
        //     confirmPassword: confirmPasswordController.text,
        //     dob: companyInfoController.dob.text,
        //     // role: companyInfoController.role.text ,
        //     gender: companyInfoController.genderController.text,
        //     passport: documentInfoController.passportFile.value,
        //     whiteCard: documentInfoController.whiteCardFile.value,
        //     visaWorkingRights: documentInfoController.visaForWorkingRightsFile.value,
        //     securityLicense: documentInfoController.securityLicenseFile.value,
        //     nationalCrimeCheck: documentInfoController.nationalCrimePoliceCheckFile.value,
        //     abn: documentInfoController.abnFile.value,
        //   );
        try{
          companyInfoController.dob.text = '01-01-2000'; // Default date for contractor, can be changed later
          final signUpModelForIndividual = SignUpModelForIndividual(
            registeringAs: companyInfoController.registeringAs.value,
            name: companyInfoController.companyName.text,
            email: companyInfoController.companyEmail.text,
            phone: companyInfoController.phone.text,
            postalAddress: companyInfoController.postalAddress.text,
            australianBusinessNumber: companyInfoController.abn.text,
            password: passwordController.text,
            confirmPassword: confirmPasswordController.text,
            passport: documentInfoController.passportFile.value,
            whiteCard: (documentInfoController.whiteCardFile.value?.isNotEmpty ?? false)
                ? documentInfoController.whiteCardFile.value
                : null,
            visaWorkingRights: documentInfoController.visaForWorkingRightsFile.value,
            securityLicense: documentInfoController.securityLicenseFile.value,
            nationalCrimeCheck: documentInfoController.nationalCrimePoliceCheckFile.value,
            abn: (documentInfoController.abnFile.value?.isNotEmpty ?? false)
                ? documentInfoController.abnFile.value
                : null,
            gender: companyInfoController.genderController.text,
            dob: companyInfoController.dob.text,
          );

          final response = await apiService.signUpForContractor(
            SignUpModelForIndividual: signUpModelForIndividual,
          );

          if (response.statusCode == 200) {
            debugPrint("data from API ${response.body}");
            Get.offAndToNamed(AppRoutes.getLandingPageRoute());
            // await saveLoginSession();
          } else {
            debugPrint('Error Signup failed: ${response.body}');
          }
      }
      catch(e){
        debugPrint('Error Network error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(AppAssets.kTacLogo, height: 60),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Create Account",
                          style: AppTypography.kBold24
                              .copyWith(color: Colors.white)),
                      Text("Get Yourself Registered",
                          style: AppTypography.kLight16
                              .copyWith(color: AppColors.ktextlight)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  StepTab(title: "Account Info", isCompleted: true),
                  StepTab(title: "Documents", isCompleted: true),
                  StepTab(title: "Set Password", isCurrent: true),
                ],
              ),
              const SizedBox(height: 20),
              Text("Set Password",
                  style: AppTypography.kBold18.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          decoration: _passwordInputDecoration(
                            "Set Password",
                            _obscurePassword,
                            () => setState(() {
                              _obscurePassword = !_obscurePassword;
                            }),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: _passwordInputDecoration(
                            "Confirm Password",
                            _obscureConfirmPassword,
                            () => setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            }),
                          ),
                          validator: (value) {
                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                  color: AppColors.ktextlight, thickness: 1, height: 0),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.kSkyBlue, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Back',
                        style: AppTypography.kBold16
                            .copyWith(color: AppColors.kSkyBlue)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if(companyInfoController.registeringAs.value == 'Company') {
                          submitSignupForCompany();
                        } else if(companyInfoController.registeringAs.value == 'contractor') {
                          submitSignupForContractor();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("Create Account",
                          style: AppTypography.kBold16
                              .copyWith(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepTab extends StatelessWidget {
  final String title;
  final bool isCurrent;
  final bool isCompleted;

  const StepTab({
    required this.title,
    this.isCurrent = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor = isCompleted
        ? AppColors.kSkyBlue
        : isCurrent
            ? AppColors.kWhite
            : AppColors.ktextlight.withOpacity(0.2);

    double progressValue = isCompleted
        ? 1
        : isCurrent
            ? 0.5
            : 0.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: AppColors.ktextlight.withOpacity(0.2),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTypography.kBold14.copyWith(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
