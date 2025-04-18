import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../models/userupdate_model.dart';
import '../../../../routes/app_routes.dart';

class EditProfessionalInfoScreen extends StatefulWidget {
  const EditProfessionalInfoScreen({super.key});

  @override
  State<EditProfessionalInfoScreen> createState() => _EditProfessionalInfoScreenState();
}

class _EditProfessionalInfoScreenState extends State<EditProfessionalInfoScreen> {
  final UserController userController = Get.find<UserController>();

  String? selectedExperience;
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController expiryDate = TextEditingController();
  final TextEditingController abnNumber = TextEditingController();
  final TextEditingController preferredWorkLocation = TextEditingController();

  Future<void> updateProfessionalInfo() async {
    final apiService = MyApIService(); // create instance
    try{
      final userModel = UserUpdateModel(
        yearsOfExperience: selectedExperience,
        licenseNumber: licenseNumber.text,
        abn: abnNumber.text,
        preferredLocationAddresses: [preferredWorkLocation.text],
      );

      final response = await apiService.updatePersonalInfo(
        userController.userData.value!.id!,
        userModel,
      );

      if (response.statusCode == 200) {
        debugPrint("data from API ${response.body}");
        await apiService.getUserByID(userController.userData.value!.id!);
        Get.offAndToNamed(AppRoutes.getLandingPageRoute());
      } else {
        debugPrint("data from API ${response.body}");
        debugPrint('Error update professional info failed: ${response.body}');
      }
    }
    catch(e){
      debugPrint('Error Network error: ${e.toString()}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Professional Information',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update information according to your official document data.',
                    style: TextStyle(
                      color: AppColors.kWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Years of Experience Dropdown
                  buildDropdownField(
                      label: 'Years of Experience', icon: Icons.work),

                  const SizedBox(height: 14),
                  buildTextField(
                      label: 'License Number', icon: Icons.credit_card, controller: licenseNumber),
                  const SizedBox(height: 14),
                  buildTextField(label: 'Expiry Date', icon: Icons.date_range, controller: expiryDate),
                  const SizedBox(height: 14),
                  buildTextField(label: 'ABN', icon: Icons.business, controller: abnNumber),
                  const SizedBox(height: 14),
                  buildTextField(
                    label: 'Preferred Work Location Address',
                    icon: Icons.location_on,
                    controller: preferredWorkLocation,
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.kinput, thickness: 1),
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
                    onPressed: () => {
                      updateProfessionalInfo(),
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
    );
  }

  Widget buildTextField({required String label, required IconData icon, TextEditingController? controller}) {
    return TextField(
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
    );
  }

  Widget buildDropdownField({required String label, required IconData icon}) {
    return DropdownButtonFormField<String>(
      dropdownColor: const Color(0xFF1F2937),
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
      style: const TextStyle(color: AppColors.kWhite),
      iconEnabledColor: AppColors.kinput,
      value: null,
      items: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '10+']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedExperience = value;
        });
      },
    );
  }
}
