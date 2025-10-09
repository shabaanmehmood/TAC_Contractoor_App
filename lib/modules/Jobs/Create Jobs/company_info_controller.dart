import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/models/jobCategoriesModel.dart';
import 'package:taccontractor/models/jobPremisesModel.dart';

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
  var selectedJobCategoryOption = "".obs; // For storing the ID
  final jobDescription = 'description'.obs;
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
  var leaderRequired = false.obs; // Observable bool
  final cardNumberController = TextEditingController();
  final cardExpiryMonthController = TextEditingController();
  final cardExpiryYearController = TextEditingController();
  final cardCvvController = TextEditingController();

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
  var minimumLevel = 0.obs;
  var maximumLevel = 0.obs;
  var selectedSkills = <SkillModel>[].obs;
  var availableSkills = <SkillModel>[].obs;

  // Add this method to your controller class (e.g., JobCreationController)
  void clearAllFields() {
    // Clear TextEditingControllers
    jobTitle.clear();
    payPerHour.clear();
    jobResponsiblities.clear();
    siteLocation.clear();
    reportingManagerNumber.clear();
    reportingManager.clear();
    noOfGuardsRequired.clear();
    jobSOPs.clear();
    cardNumberController.clear();
    cardExpiryMonthController.clear();
    cardExpiryYearController.clear();
    cardCvvController.clear();
    jobAppearance.clear();

    // Reset Rx variables to their initial state
    jobDescription.value = 'description';
    leaderRequired.value = false;
    latitude.value = 0.0;
    longitude.value = 0.0;
    minExperience.value = 0;
    maxExperience.value = 0;
    minAge.value = 0;
    maxAge.value = 0;
    minimumLevel.value = 0;
    maximumLevel.value = 0;
    selectedSkills.clear(); // Assuming it's an RxList
    selectedLicenses.clear(); // Assuming it's an RxList
    shifts.clear(); // Assuming it's an RxList
    selectedCategory.value = ''; // Or to an initial default value
    selectedPremises.value = ""; // Or to an initial default value
    jobType.value = "recurring"; // Or to an initial default value
  }

  Future<void> getDeviceLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          "Error",
          "Location services are disabled. Please enable location services.",
          backgroundColor: AppColors.kDarkBlue,
          colorText: Colors.white,
        );
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            "Error",
            "Location permissions are denied",
            backgroundColor: AppColors.kDarkBlue,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Error",
          "Location permissions are permanently denied. Please enable them in settings.",
          backgroundColor: AppColors.kDarkBlue,
          colorText: Colors.white,
        );
        return;
      }

      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10), // Add timeout
      );

      // Store the location in observables
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Update the site location text field
      siteLocation.text =
          "Lat: ${latitude.value.toStringAsFixed(6)}, Lng: ${longitude.value.toStringAsFixed(6)}";

      // Optional: Show success message
      Get.snackbar(
        "Success",
        "Location retrieved successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      // Debug print to verify location is stored
      debugPrint(
          "Location stored - Lat: ${latitude.value}, Lng: ${longitude.value}");
    } catch (e) {
      debugPrint("Location error: $e");
      Get.snackbar(
        "Error",
        "Could not get location: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  var availableLicenses = <RequiredLicense>[].obs;
  var selectedLicenses = <RequiredLicense>[].obs;

  var availableCategories = <JobCategoryModel>[].obs;
  var selectedCategory = ''.obs;

  var availablePremises = <JobPremisesModel>[].obs;
  var selectedPremises = ''.obs;

  Future<void> fetchLicenses() async {
    try {
      final response = await MyApIService().getAllLicense();
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body)['data'];
        availableLicenses.value =
            jsonList.map((json) => RequiredLicense.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch licenses");
    }
  }

  Future<void> fetchRequiredSkills() async {
    try {
      final response = await myApiService
          .getRequiredSkills(); // Make sure this hits your skills endpoint
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonList = jsonMap['data'];
        availableSkills.value =
            jsonList.map((json) => SkillModel.fromJson(json)).toList();
      } else {
        availableSkills.clear();
        Get.snackbar("Error", "Failed to fetch skills");
      }
    } catch (e) {
      availableSkills.clear();
      Get.snackbar("Error", "Failed to fetch skills");
    }
  }

  Future<void> fetchJobCategories(String userId) async {
    try {
      final response = await myApiService.getJobCategories(userId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonList = jsonMap['data'];
        availableCategories.value =
            jsonList.map((json) => JobCategoryModel.fromJson(json)).toList();
        debugPrint(
            'Available Categories Ids: ${availableCategories.map((e) => e.id).toList()}');
      } else {
        availableCategories.clear();
        debugPrint('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      availableCategories.clear();
      debugPrint('Exception: $e');
    }
  }

  Future<Map<String, double>?> setLatLngFromAddress(String address) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1",
    );

    final response =
        await http.get(url, headers: {"User-Agent": "flutter-app"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);

        // Update the controller values
        latitude.value = lat;
        longitude.value = lon;

        // Also return the values
        return {'lat': lat, 'lon': lon};
      }
    }
    return null;
  }

  Future<void> fetchJobPremises(String userId) async {
    try {
      final response = await myApiService.getJobPremises(userId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final List<dynamic> jsonList = jsonMap['data'];
        availablePremises.value =
            jsonList.map((json) => JobPremisesModel.fromJson(json)).toList();
      } else {
        availablePremises.clear();
        debugPrint('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      availablePremises.clear();
      debugPrint('Exception: $e');
    }
  }

  // In your controller
  RxString jobType = 'recurring'.obs; // or 'One Time'
  RxList<Shift> shifts = <Shift>[].obs;

  bool get canAddShift => jobType.value == 'recurring' || shifts.isEmpty;

  final _uuid = Uuid();

  void addShifts(List<Shift> newShifts) {
    if (jobType.value == 'onetime') {
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
