import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/controllers/user_controller.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/widhets/common%20overlays/uploadFile_overlay.dart';

import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';
//
// class AddLicenseController extends GetxController {
//   String selectedLicenseType = "";
//   String? selectedImagePath; // NEW: Store image path
//
//   final List<String> licenseTypes = [
//     'Security Guard',
//     'Fire Safety',
//     'CPR Certification',
//     'First Aid',
//     'Surveillance Training',
//   ];
//
//   void selectLicenseType(String type) {
//     selectedLicenseType = type;
//     update();
//   }
//
//   void setSelectedImagePath(String path) {
//     selectedImagePath = path;
//     update();
//   }
// }
//
// class AddLicenseScreen extends StatelessWidget {
//   AddLicenseScreen({super.key});
//
//   final AddLicenseController addLicenseController = Get.put(AddLicenseController());
//   final UploadFileController uploadFileController = Get.put(UploadFileController()); // Shared instance
//
//   void showLicenseTypeBottomSheet(BuildContext context) {
//     final controller = Get.find<AddLicenseController>();
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: AppColors.kDarkestBlue,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 12),
//               child: Text(
//                 "Select License Type",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             const Divider(color: Colors.white24),
//             ...controller.licenseTypes.map((type) {
//               final isSelected = type == controller.selectedLicenseType;
//               return ListTile(
//                 title: Text(
//                   type,
//                   style: TextStyle(
//                     color: isSelected ? AppColors.kSkyBlue : Colors.white,
//                     fontWeight:
//                     isSelected ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 ),
//                 onTap: () {
//                   controller.selectLicenseType(type);
//                   Get.back();
//                 },
//               );
//             }).toList(),
//             const SizedBox(height: 12),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.kDarkestBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Add License',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Container(
//             color: Colors.white.withOpacity(0.1),
//             height: 1,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
//             child: GetBuilder<AddLicenseController>(
//               builder: (controller) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Details",
//                       style: TextStyle(
//                         color: AppColors.kSkyBlue,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     buildDropdownField(
//                       controller.selectedLicenseType.isEmpty
//                           ? "Licenses Type"
//                           : controller.selectedLicenseType,
//                       Icons.folder_open,
//                           () => showLicenseTypeBottomSheet(context),
//                     ),
//                     const SizedBox(height: 16),
//                     buildTextField("License Number", Icons.badge),
//                     const SizedBox(height: 16),
//                     buildTextField("Expiry Date", Icons.calendar_today),
//                     const SizedBox(height: 24),
//                     const Text(
//                       "Scan Copy of License",
//                       style: TextStyle(
//                         color: AppColors.kSkyBlue,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                       decoration: BoxDecoration(
//                         color: AppColors.kJobCardColor,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(Icons.attach_file, color: AppColors.kinput, size: 20),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: const [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "Attach Doc",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       "Optional",
//                                       style: TextStyle(
//                                         color: AppColors.kalert,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 6),
//                                 Text(
//                                   "Min 10MB. Upload only PDF, DOC, DOCX, JPG, PNG",
//                                   style: TextStyle(
//                                     color: AppColors.kinput,
//                                     fontSize: 11,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: false);
//                               if (path != null) {
//                                 addLicenseController.setSelectedImagePath(path);
//                               }
//                             },
//                             child: const Text(
//                               "Upload",
//                               style: TextStyle(
//                                 color: AppColors.kSkyBlue,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               decoration: BoxDecoration(
//                 color: AppColors.kDarkestBlue,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     offset: const Offset(0, -1),
//                     blurRadius: 6,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Divider(color: Colors.white24, thickness: 1),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: OutlinedButton(
//                           onPressed: () => Get.back(),
//                           style: OutlinedButton.styleFrom(
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             side: const BorderSide(color: AppColors.kSkyBlue),
//                             foregroundColor: AppColors.kSkyBlue,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                           ),
//                           child: const Text("Cancel"),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         flex: 7,
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             if (addLicenseController.selectedImagePath != null) {
//                               await uploadFileController.uploadDocument(addLicenseController.selectedImagePath!);
//                               debugPrint("Success License uploaded successfully");
//                             } else {
//                               debugPrint("Error Please upload a license document.");
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                             backgroundColor: AppColors.kSkyBlue,
//                             foregroundColor: Colors.black,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                           ),
//                           child: const Text("Add License"),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildTextField(String hint, IconData icon) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, color: AppColors.kinput, size: 18),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 style: const TextStyle(color: Colors.white),
//                 cursorColor: AppColors.kinput,
//                 decoration: InputDecoration(
//                   hintText: hint,
//                   hintStyle: const TextStyle(color: AppColors.kinput),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const Divider(color: Colors.white24),
//       ],
//     );
//   }
//
//   Widget buildDropdownField(String text, IconData icon, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         decoration: BoxDecoration(
//           color: AppColors.kJobCardColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColors.kinput, size: 18),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             const Icon(Icons.keyboard_arrow_down, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AddLicenseController extends GetxController {
  String selectedLicenseType = ""; // Stores selected license ID
  String selectedLicenseName = ""; // Stores selected license name for display
  String? selectedImagePath; // Store image path
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  MyApIService apiService = MyApIService();
  final UserController userController = Get.find<UserController>();

  List<Map<String, dynamic>> licenses = [];

  // Fetch licenses from API
  Future<void> fetchLicenses() async {
    try {
      final response = await apiService.getAllLicense();
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        final List<dynamic> data = jsonResponse['data'];
        licenses = data.map((item) => item as Map<String, dynamic>).toList();
      }
      else {
        debugPrint('Request failed with status: ${response.statusCode}.');
        licenses = [];
      }
    } catch (e) {
      licenses = [];
    }
    update();
  }

  void addLicense() async {
    try{
      final response = await apiService.addSecurityLicense(
          licenseNumberController.text,
          expiryDateController.text,
          selectedLicenseType,
          userController.userData.value!.id!,
          selectedImagePath!,
        );
        if(response.statusCode == 201) {
          debugPrint("data from API ${response.body}");
          Get.offAndToNamed(AppRoutes.getLandingPageRoute());
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error Add Security License failed: ${response.body}');
        }
    }
    catch(e){
      debugPrint("Error: $e");
    }
  }

  void selectLicense(Map<String, dynamic> license) {
    selectedLicenseType = license['id'];
    selectedLicenseName = license['name'].toString().trim();
    update();
  }

  void setSelectedImagePath(String path) {
    selectedImagePath = path;
    update();
  }
}

class AddLicenseScreen extends StatelessWidget {
  AddLicenseScreen({Key? key}) : super(key: key);

  final AddLicenseController addLicenseController = Get.put(AddLicenseController());
  final UploadFileController uploadFileController = Get.put(UploadFileController());

  void showLicenseTypeBottomSheet(BuildContext context) async {
    final controller = Get.find<AddLicenseController>();
    await controller.fetchLicenses();
    Get.bottomSheet(
      Container(
        height: 300,
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
            Expanded(
              child: controller.licenses.isEmpty
                  ? const Center(
                child: Text(
                  "No licenses available",
                  style: TextStyle(color: Colors.white54),
                ),
              )
                  : ListView.builder(
                itemCount: controller.licenses.length,
                itemBuilder: (context, index) {
                  final license = controller.licenses[index];
                  final isSelected = license['id'] == controller.selectedLicenseType;
                  return ListTile(
                    title: Text(
                      license['name'].toString().trim(),
                      style: TextStyle(
                        color: isSelected ? AppColors.kSkyBlue : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      controller.selectLicense(license);
                      Get.back();
                    },
                  );
                },
              ),
            ),
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
                      addLicenseController.selectedLicenseName.isEmpty
                          ? "License Type"
                          : addLicenseController.selectedLicenseName,
                      Icons.folder_open,
                          () => showLicenseTypeBottomSheet(context),
                    ),
                    const SizedBox(height: 16),
                    buildTextField(controller.licenseNumberController, "License Number", Icons.badge),
                    const SizedBox(height: 16),
                    buildTextField(controller.expiryDateController, "Expiry Date", Icons.calendar_today),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.attach_file, color: AppColors.kinput, size: 20),
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
                            onTap: () async {
                              String? path = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true);
                              if (path != null) {
                                addLicenseController.setSelectedImagePath(path);
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          onPressed: () async {
                            if (addLicenseController.selectedLicenseType != null && addLicenseController.selectedLicenseType.isNotEmpty &&
                                addLicenseController.selectedImagePath != null && addLicenseController.selectedImagePath!.isNotEmpty
                                && addLicenseController.licenseNumberController.text.isNotEmpty && addLicenseController.expiryDateController.text.isNotEmpty) {
                              addLicenseController.addLicense();
                            } else {
                              debugPrint("Error: Please upload a license document.");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.kinput, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                cursorColor: AppColors.kinput,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: AppColors.kinput),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white24),
      ],
    );
  }

  Widget buildDropdownField(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.kJobCardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.kinput, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          ],
        ),
      ),
    );
  }
}