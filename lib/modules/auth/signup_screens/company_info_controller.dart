import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/modules/auth/signup_screens/set_pass.dart';

import 'document_upload_screen.dart';

import '../../../data/data/helpers/validators.dart';

class CompanyInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  var registeringAs = ''.obs;
  final companyName = TextEditingController();
  final companyEmail = TextEditingController();
  final phone = TextEditingController();
  final postalAddress = TextEditingController();
  final license = TextEditingController();
  final abn = TextEditingController();
  final acn = TextEditingController();
  final genderController = TextEditingController();
  final dob = TextEditingController();
  final role = TextEditingController();

  void pickGender() async {
    final selected = await Get.bottomSheet(
      Container(
        color: AppColors.kDarkestBlue,
        child: Wrap(
          children: ['Male', 'Female', 'Other'].map((gender) {
            return ListTile(
              title: Text(
                gender,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                genderController.text = gender.toLowerCase();
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    return AppValidators.validateEmail(value);
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Enter a 10-digit phone number';
    }
    return null;
  }

  String? validateABN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ABN is required';
    }
    if (value.length != 11 || !RegExp(r'^\d{11}$').hasMatch(value)) {
      return 'ABN must be 11 digits';
    }
    return null;
  }

  String? validateACN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'ACN is required';
    }
    if (value.length != 9 || !RegExp(r'^\d{9}$').hasMatch(value)) {
      return 'ACN must be 9 digits';
    }
    return null;
  }

  void onContinue() {
    if (formKey.currentState!.validate()) {
      Get.to(() => const SetPasswordScreen());
    }
  }

  // @override
  // void onClose() {
  //   companyName.dispose();
  //   companyEmail.dispose();
  //   phone.dispose();
  //   postalAddress.dispose();
  //   license.dispose();
  //   abn.dispose();
  //   acn.dispose();
  //   super.onClose();
  // }
}
