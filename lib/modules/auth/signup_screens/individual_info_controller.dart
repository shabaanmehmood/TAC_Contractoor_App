import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/modules/auth/signup_screens/document_upload_screen.dart';

class IndividualInfoController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final postalController = TextEditingController();
  final abnController = TextEditingController();

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
                genderController.text = gender;
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone is required';
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value))
      return 'Enter a valid 10-digit phone number';
    return null;
  }

  String? validateABN(String? value) {
    if (value == null || value.trim().isEmpty) return 'ABN is required';
    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) return 'ABN must be 11 digits';
    return null;
  }

  void onContinue() {
    if (formKey.currentState!.validate()) {
      Get.to(DocumentInfoScreen());
    }
    // No else clause, so no popup/snackbar
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    postalController.dispose();
    abnController.dispose();
    super.onClose();
  }
}
