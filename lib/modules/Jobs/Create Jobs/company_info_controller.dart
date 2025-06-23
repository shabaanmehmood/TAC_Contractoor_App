import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';

import '../../../dataproviders/api_service.dart';
import '../../../models/requiredLicenseModel.dart';
import '../../../models/required_skills.dart';
import '../../../models/shift_model.dart';
import 'preferences_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class SetJobDetailsController extends GetxController {
  UserController userController = Get.find<UserController>();
  MyApIService myApiService = MyApIService();

  final formKey = GlobalKey<FormState>();
  var registeringAs = ''.obs;
  final jobTitle = TextEditingController();
  final payPerHour = TextEditingController();
  final jobCategory = TextEditingController();
  var selectedJobCategoryOption = "".obs;      // For storing the ID
  final jobDescription = TextEditingController();
  final jobResponsiblities = TextEditingController();
  final jobSOPs = TextEditingController();
  final noOfGuardsRequired = TextEditingController();
  final siteLocation = TextEditingController();
  final jobPremisesType = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  final reportingManager = TextEditingController();
  final reportingManagerNumber = TextEditingController();
  var leaderRequired = ''.obs;

  // ================= Preference controllers ==================

  final formKeyforpreference = GlobalKey<FormState>();
  final licenseRequired = TextEditingController();
  final jobAppearance = TextEditingController();
  final yearsOfExperience = TextEditingController();
  final level = TextEditingController();
  var ageLimit = '30'.obs;
  RxBool driving = false.obs;
  RxBool itSupport = false.obs;
  RxBool weaponUse = false.obs;

  // ================= Required Docs controllers ==================

  final formKeyfordocs = GlobalKey<FormState>();
  RxBool passport = false.obs;
  RxBool visaWorkingRights = false.obs;
  RxBool abn = false.obs;
  RxBool nationalCrimeCheck = false.obs;
  RxBool faceVideoSelfie = false.obs;
  RxBool securityLicense = false.obs;
  RxBool whiteCard = false.obs;
  RxBool rSA = false.obs;
  RxBool blueCard = false.obs;
  RxBool marineCardForPortSecurities = false.obs;
  RxBool yellowCard = true.obs;
  RxBool driverLicense = false.obs;
  RxBool cPrValid = false.obs;

  /// Existing controllers...
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var minExperience = 0.obs;
  var maxExperience = 0.obs;
  var minAge = 0.obs;
  var maxAge = 0.obs;
  var selectedSkills = <SkillModel>[].obs;
  var availableSkills = <SkillModel>[].obs;

  Future<void> getDeviceLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      siteLocation.text = "Lat: ${latitude.value}, Lng: ${longitude.value}";
    } catch (e) {
      Get.snackbar("Error", "Could not get location");
    }
  }

  var availableLicenses = <RequiredLicense>[].obs;
  var selectedLicenses = <RequiredLicense>[].obs;

  Future<void> fetchLicenses() async {
    try {
      final response = await MyApIService().getAllLicense();
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body)['data'];
        availableLicenses.value = jsonList
            .map((json) => RequiredLicense.fromJson(json))
            .toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch licenses");
    }
  }

  Future<void> fetchRequiredSkills() async {
    try {
      final response = await myApiService.getRequiredSkills(); // Make sure this hits your skills endpoint
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonList = jsonMap['data'];
        availableSkills.value = jsonList
            .map((json) => SkillModel.fromJson(json))
            .toList();
      } else {
        availableSkills.clear();
        Get.snackbar("Error", "Failed to fetch skills");
      }
    } catch (e) {
      availableSkills.clear();
      Get.snackbar("Error", "Failed to fetch skills");
    }
  }

  // In your controller
  RxString jobType = 'Recurring'.obs; // or 'One Time'
  RxList<Shift> shifts = <Shift>[].obs;

  bool get canAddShift => jobType.value == 'Recurring' || shifts.isEmpty;

  final _uuid = Uuid();

  void addShifts(List<Shift> newShifts) {
    if (jobType.value == 'One Time') {
      shifts.value = newShifts.take(1).toList();
    } else {
      shifts.addAll(newShifts);
    }
  }


  void removeShift(int index) {
    shifts.removeAt(index);
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegEx.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
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
      Get.to(PreferencesScreen());
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
