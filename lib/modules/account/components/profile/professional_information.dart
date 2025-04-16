import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';

class EditProfessionalInfoScreen extends StatelessWidget {
  const EditProfessionalInfoScreen({super.key});

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
                      label: 'License Number', icon: Icons.credit_card),
                  const SizedBox(height: 14),
                  buildTextField(label: 'Expiry Date', icon: Icons.date_range),
                  const SizedBox(height: 14),
                  buildTextField(label: 'ABN', icon: Icons.business),
                  const SizedBox(height: 14),
                  buildTextField(
                    label: 'Preferred Work Location Address',
                    icon: Icons.location_on,
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
                    onPressed: () => Get.back(),
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

  Widget buildTextField({required String label, required IconData icon}) {
    return TextField(
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
      items: ['1', '2', '3', '4', '5']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (value) {},
    );
  }
}
