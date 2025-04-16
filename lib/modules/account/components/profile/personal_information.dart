import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';

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
  final String role = 'user';
  final String fcmToken = 'sampleToken';

  String? selectedGender;

  @override
  void initState() {
    super.initState();

    // Load data from UserController and set into controllers
    final user = userController.userData.value; // Or however you access it
    nameController.text = user!.fullName ?? '';
    emailController.text = user.email ?? '';
    dobController.text = user.dob ?? '';
    genderController.text = user.gender ?? '';
    contactController.text = user.phone ?? '';
    postalCodeController.text = '';
    addressController.text = user.postalAddress ?? '';
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
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
            style: TextStyle(color: AppColors.kWhite, fontSize: 17)),
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
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                          controller: nameController,
                          label: "Full Name",
                          icon: Icons.person),
                      buildTextField(
                          controller: emailController,
                          label: "Email",
                          icon: Icons.email),
                      buildDropdownField(
                          label: "Gender",
                          icon: Icons.person_outline,
                          value: selectedGender,
                          onChanged: (val) {
                            setState(() {
                              selectedGender = val!;
                            });
                          }),
                      buildTextField(
                          controller: dobController,
                          label: "Date of Birth",
                          icon: Icons.calendar_today),
                      buildTextField(
                          controller: contactController,
                          label: "Contact Number",
                          icon: Icons.phone),
                      buildTextField(
                          controller: postalCodeController,
                          label: "Postal Code",
                          icon: Icons.location_on),
                      buildTextField(
                          controller: addressController,
                          label: "Address",
                          icon: Icons.home),
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
    final apiService = MyApIService(); // create instance
    try{
      final response = await apiService.updatePersonalInfo(
        userController.userData.value!.id!,
        nameController.text,
        emailController.text,
        contactController.text,
        addressController.text,
        userController.userData.value!.masterSecurityLicense!,
        userController.userData.value!.password!,
        role,
        dobController.text,
        selectedGender!,
        fcmToken,
      );

      if (response.statusCode == 200) {
        debugPrint("data from API ${response.body}");
        Get.offAndToNamed(AppRoutes.getProfilePageRoute());
      } else {
        debugPrint("data from API ${response.body}");
        debugPrint('Error update personal info failed: ${response.body}');
      }
    }
    catch(e){
      debugPrint('Error Network error: ${e.toString()}');
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.kWhite),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.kinput),
          prefixIcon: Icon(icon, color: AppColors.kinput),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: const Color(0xFF1F2937),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.kinput),
          prefixIcon: Icon(icon, color: AppColors.kinput),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.kinput),
          ),
        ),
        style: const TextStyle(color: AppColors.kWhite),
        iconEnabledColor: AppColors.kinput,
        items: const [
          DropdownMenuItem(value: 'male', child: Text("male")),
          DropdownMenuItem(value: 'female', child: Text("female")),
          DropdownMenuItem(value: 'other', child: Text("other")),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
