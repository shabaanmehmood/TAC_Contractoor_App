import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../models/userupdate_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../widhets/common widgets/buttons/adaptive_dialogue.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final UserController userController = Get.find<UserController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  List<String> genderOptions = ['Male', 'Female', 'Other'];
  String? selectedGender;

  @override
  void initState() {
    super.initState();

    final user = userController.userData.value;
    nameController.text = user!.name ?? '';
    emailController.text = user.email ?? '';
    dobController.text = user.dob ?? '';
    selectedGender = genderOptions.contains(user.gender) ? user.gender : null;

    contactController.text = user.phone ?? '';
    addressController.text = user.postalAddress ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    dobController.dispose();
    contactController.dispose();
    postalCodeController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: const Text("Edit Personal Information",
            style: TextStyle(
                color: AppColors.kWhite,
                fontSize: 17,
                fontWeight: FontWeight.w600)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Update Information according to your official document data.",
                        style: TextStyle(
                          color: AppColors.kWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: nameController,
                        label: "Full Name",
                        iconPath: AppAssets.kPer,
                        maxLength: 180,
                      ),
                      buildTextField(
                        controller: emailController,
                        label: "Email",
                        iconPath: AppAssets.kMail,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 180,
                      ),
                      buildDropdownField(
                        label: "Gender",
                        icon: Icons.person_outline,
                        value: selectedGender,
                        onChanged: (val) {
                          setState(() {
                            selectedGender = val!;
                          });
                        },
                      ),
                      buildTextField(
                        controller: dobController,
                        label: "Date of Birth",
                        iconPath: AppAssets.kCal,
                        readOnly: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  dialogBackgroundColor: AppColors.kDarkestBlue,
                                  colorScheme: ColorScheme.dark(
                                    primary: AppColors.kSkyBlue,
                                    onPrimary: Colors.black,
                                    surface: AppColors.kDarkestBlue,
                                    onSurface: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors
                                          .kSkyBlue, // Button text color
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              dobController.text =
                                  picked.toIso8601String().split('T').first;
                            });
                          }
                        },
                      ),
                      buildTextField(
                        controller: contactController,
                        label: "Contact Number",
                        iconPath: AppAssets.kNum,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      buildTextField(
                        maxLength: 6,
                        controller: postalCodeController,
                        label: "Postal Code",
                        iconPath: AppAssets.kLoc,
                        keyboardType: TextInputType.number,
                      ),
                      buildTextField(
                        controller: addressController,
                        label: "Address",
                        iconPath: AppAssets.kLoc,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(
                  color: AppColors.kinput,
                  height: 1,
                  thickness: 1,
                ),
                Container(
                  color: AppColors.kDarkestBlue,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 25,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.kSkyBlue),
                            foregroundColor: AppColors.kSkyBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 75,
                        child: ElevatedButton(
                          onPressed: () {
                            updatePersonalInfo();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kSkyBlue,
                            foregroundColor: AppColors.kBlack,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Update Information'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updatePersonalInfo() async {
    if (selectedGender == null) {
      Get.snackbar(
        "Missing Information",
        "Please select your gender before updating.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (postalCodeController.text.isEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please enter your postal code before updating.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final apiService = MyApIService();
    try {
      final userModel = UserUpdateModel(
        fullName: nameController.text,
        email: emailController.text,
        phone: contactController.text,
        postalAddress: addressController.text,
        masterSecurityLicense: userController.userData.value!.masterSecurityLicense!,
        dob: dobController.text,
        postalCode: postalCodeController.text,
        gender: selectedGender!.toLowerCase(),
      );

      final response = await apiService.updatePersonalInfo(
        userController.userData.value!.id!,
        userModel,
      );

      if (response.statusCode == 200) {
        debugPrint("data from API ${response.body}");
        await apiService.getUserByID(userController.userData.value!.id!);
        Get.back(result: true);
      } else {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String errorMessage = responseBody['message'] ?? 'Unknown error';

        // Show dialog with one line call
        await AdaptiveAlertDialogWidget.show(
          context,
          title: 'Update Failed',
          content: errorMessage,
          yesText: 'OK',
          showNoButton: false,
          onYes: () {
            // Optional: do something on OK pressed
          },
        );
        debugPrint("data from API ${response.body}");
        debugPrint('Error update personal info failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error Network error: ${e.toString()}');
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    String? iconPath, // <-- updated
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.kWhite),
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          counterText: "",
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.kinput),
          prefixIcon: iconPath != null
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    color: AppColors.kinput,
                  ),
                )
              : null,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.kinput),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.kSkyBlue),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    final genderOptions = ['Male', 'Female', 'Other'];

    return DropdownButtonFormField<String>(
      value: value,
      items: genderOptions.map((gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.kinput),
        prefixIcon: Icon(icon, color: AppColors.kinput),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kinput),
        ),
      ),
      dropdownColor: AppColors.kDarkBlue,
      style: const TextStyle(color: AppColors.kWhite),
      iconEnabledColor: AppColors.kinput,
    );
  }
}
