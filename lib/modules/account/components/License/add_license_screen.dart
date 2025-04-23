import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/widhets/common%20overlays/uploadFile_overlay.dart';

import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';

class AddLicenseController extends GetxController {
  String selectedLicenseType = "";

  final List<String> licenseTypes = [
    'Security Guard',
    'Fire Safety',
    'CPR Certification',
    'First Aid',
    'Surveillance Training',
  ];

  void selectLicenseType(String type) {
    selectedLicenseType = type;
    update(); // notify UI widgets that use `GetBuilder`
  }
}

class AddLicenseScreen extends StatelessWidget {
  AddLicenseScreen({super.key});

  final AddLicenseController addLicenseController = Get.put(AddLicenseController());

  void showLicenseTypeBottomSheet(BuildContext context) {
    final controller = Get.find<AddLicenseController>();
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: AppColors.kDarkestBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Select License Type",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const Divider(color: Colors.white24),
            ...controller.licenseTypes.map((type) {
              final isSelected = type == controller.selectedLicenseType;
              return ListTile(
                title: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? AppColors.kSkyBlue : Colors.white,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  controller.selectLicenseType(type);
                  Get.back();
                },
              );
            }).toList(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add License',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: GetBuilder<AddLicenseController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                        color: AppColors.kSkyBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 14),
                    buildDropdownField(
                      controller.selectedLicenseType.isEmpty
                          ? "Licenses Type"
                          : controller.selectedLicenseType,
                      Icons.folder_open,
                          () => showLicenseTypeBottomSheet(context),
                    ),
                    const SizedBox(height: 16),
                    buildTextField("License Number", Icons.badge),
                    const SizedBox(height: 16),
                    buildTextField("Expiry Date", Icons.calendar_today),
                    const SizedBox(height: 24),
                    const Text(
                      "Scan Copy of License",
                      style: TextStyle(
                        color: AppColors.kSkyBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.attach_file,
                              color: AppColors.kinput, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Row(
                                  children: [
                                    Text(
                                      "Attach Doc",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Optional",
                                      style: TextStyle(
                                        color: AppColors.kalert,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Min 10MB. Upload only PDF, DOC, DOCX, JPG, PNG",
                                  style: TextStyle(
                                    color: AppColors.kinput,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async{
                              final UploadFileController uploadFileController = Get.find();
                              String? imagePath = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: false);
                              if (imagePath != null) {
                                await uploadFileController.uploadDocument(imagePath);
                              }
                            },
                            child: const Text(
                              "Upload",
                              style: TextStyle(
                                color: AppColors.kSkyBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.kDarkestBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, -1),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            side: const BorderSide(color: AppColors.kSkyBlue),
                            foregroundColor: AppColors.kSkyBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 7,
                        child: ElevatedButton(
                          onPressed: () {
                            // Save license
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: AppColors.kSkyBlue,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Add License"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.kinput, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: AppColors.kSkyBlue,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hint,
                  hintStyle: const TextStyle(color: AppColors.kinput),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        const Divider(color: AppColors.kSkyBlue, thickness: 1),
      ],
    );
  }

  Widget buildDropdownField(String hint, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.kinput, size: 18),
              const SizedBox(width: 8),
              Text(
                hint,
                style: const TextStyle(
                  color: AppColors.kinput,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.kSkyBlue, thickness: 1),
        ],
      ),
    );
  }
}