// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tac/data/data/constants/app_assets.dart';
// import 'package:tac/data/data/constants/app_colors.dart';
// import 'package:tac/data/data/constants/app_spacing.dart';
// import 'package:tac/data/data/constants/app_typography.dart';
// import 'package:tac/modules/account/components/License/add_license_screen.dart';
//
// import '../../controllers/user_controller.dart';
// import '../../dataproviders/api_service.dart';
// import '../../models/profileImages_model.dart';
// import '../../models/userupdate_model.dart';
// import '../../routes/app_routes.dart';
//
// class UploadFileController extends GetxController {
//   final ImagePicker imagePicker = ImagePicker();
//   final UserController userController = Get.find<UserController>();
//   final AddLicenseController addLicenseController = Get.put(AddLicenseController());
//
//   Future<void> updateFile(String base64Image) async {
//     final apiService = MyApIService();
//
//     try {
//       final userModel = UserUpdateModel(
//         profileImages: [
//           ProfileImages(
//             imageUrl: base64Image,
//             isMain: true,
//             // createdDate: DateTime.now().toString(),
//           ),
//         ],
//       );
//
//       final response = await apiService.updatePersonalInfo(
//         userController.userData.value!.id!,
//         userModel,
//       );
//
//       if (response.statusCode == 200) {
//         debugPrint("Data from API: ${response.body}");
//         final userdata = await apiService.getUserByID(userController.userData.value!.id!);
//         debugPrint('Raw user response: ${userdata.body}');
//         Get.offAndToNamed(AppRoutes.getLandingPageRoute());
//       } else {
//         debugPrint("Error response: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint('Network error: ${e.toString()}');
//     }
//   }
//
//   Future<void> uploadDocument(String filePath) async {
//     final apiService = MyApIService();
//
//     try {
//       final response = await apiService.uploadFile(
//         userController.userData.value!.id!,
//         addLicenseController.selectedLicenseType,
//         filePath,
//       );
//
//       if (response.statusCode == 201) {
//         debugPrint("Document uploaded successfully");
//         await apiService.getUserByID(userController.userData.value!.id!);
//         Get.offAndToNamed(AppRoutes.getProfilePageRoute());
//       } else {
//         final responseBody = await response.stream.bytesToString();
//         debugPrint("Upload failed: $responseBody");
//       }
//     } catch (e) {
//       debugPrint('Network error: ${e.toString()}');
//     }
//   }
// }
//
//   Future<String?> uploadFromGallery(bool base64conversion) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       File imageFile = File(image.path);
//       final imagePath = image.path;
//       if(base64conversion){
//         List<int> imageBytes = await imageFile.readAsBytes();
//         String base64Image = base64Encode(imageBytes);
//
//         if (kDebugMode) {
//           print('Camera image base64: $base64Image');
//         }
//
//         return base64Image;
//       }
//       else{
//         return imagePath;
//       }
//     } else {
//       if (kDebugMode) {
//         print('No image captured from camera.');
//       }
//       return null;
//     }
//   }
//
//   Future<String?> uploadFromCamera(bool base64conversion) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.camera);
//
//     if (image != null) {
//       File imageFile = File(image.path);
//       final imagePath = image.path;
//       if(base64conversion){
//         List<int> imageBytes = await imageFile.readAsBytes();
//         String base64Image = base64Encode(imageBytes);
//
//         if (kDebugMode) {
//           print('Camera image base64: $base64Image');
//         }
//
//         return base64Image;
//       }
//       else{
//         return imagePath;
//       }
//     } else {
//       if (kDebugMode) {
//         print('No image captured from camera.');
//       }
//       return null;
//     }
//   }
//
//   String? base64Image;
//
//   void showUploadFileBottomSheet(BuildContext context, bool base64conversion, bool uploadFileAPI) {
//     final UploadFileController controller = Get.put(UploadFileController());
//     showModalBottomSheet(
//       context: context,
//       enableDrag: true,
//       isDismissible: true,
//       useSafeArea: true,
//       isScrollControlled: true,
//       backgroundColor: AppColors.kDarkBlue,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Divider(
//                 color: Colors.grey,
//                 thickness: 5,
//                 indent: 140,
//                 endIndent: 140,
//               ),
//               // Title & Done Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Upload File",
//                     style: AppTypography.kBold18.copyWith(
//                         color: AppColors.kWhite
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => Get.back(),
//                     child: Text("Close", style: AppTypography.kBold16.copyWith(
//                       color: AppColors.kSkyBlue,
//                     )),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSpacing.tenVertical),
//               // Sorting Options
//               _buildUploadOption("Upload from Gallery", () async {
//                 base64Image = await uploadFromGallery(base64conversion);
//                 if (base64Image != null) {
//                   debugPrint('Base64 Image: $base64Image');
//                   uploadFileAPI == true
//                       ? await controller.uploadDocument(base64Image!)
//                       : await controller.updateFile(base64Image!);
//                 }
//               }),
//               Divider(color: AppColors.kSkyBlue),
//               _buildUploadOption("Upload from Camera", () async {
//                 base64Image = await uploadFromCamera(base64conversion);
//                 if (base64Image != null) {
//                   debugPrint('Base64 Image: $base64Image');
//                   uploadFileAPI == true
//                       ? await controller.uploadDocument(base64Image!)
//                       : await controller.updateFile(base64Image!);
//                 }
//               }),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildUploadOption(String option, Function()? onTap) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(option, style: TextStyle(color: Colors.white)),
//           leading: Icon(
//             Icons.file_copy_outlined,
//             color: AppColors.kSkyBlue,
//           ),
//           onTap: onTap,
//         ),
//       ],
//     );
//   }


import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/account/components/License/add_license_screen.dart';

import '../../controllers/user_controller.dart';
import '../../dataproviders/api_service.dart';
import '../../models/profileImages_model.dart';
import '../../models/userupdate_model.dart';
import '../../routes/app_routes.dart';

class UploadFileController extends GetxController {
  final ImagePicker imagePicker = ImagePicker();
  final UserController userController = Get.find<UserController>();
  final AddLicenseController addLicenseController = Get.put(AddLicenseController());

  /// Picks image from gallery and returns base64 string or file path
  Future<String?> pickImageFromGallery({bool returnBase64 = false}) async {
    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      debugPrint('No image selected from gallery.');
      return null;
    }
    if (returnBase64) {
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);
      if (kDebugMode) {
        print('Gallery image base64: $base64Image');
      }
      return base64Image;
    } else {
      return image.path;
    }
  }

  /// Picks image from camera and returns base64 string or file path
  Future<String?> pickImageFromCamera({bool returnBase64 = false}) async {
    final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      debugPrint('No image captured from camera.');
      return null;
    }
    if (returnBase64) {
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);
      if (kDebugMode) {
        print('Camera image base64: $base64Image');
      }
      return base64Image;
    } else {
      return image.path;
    }
  }

  /// Update user profile image with base64 string
  Future<void> updateFile(String base64Image) async {
    final apiService = MyApIService();

    try {
      final userModel = UserUpdateModel(
        profileImages: [
          ProfileImages(
            imageUrl: base64Image,
            isMain: true,
          ),
        ],
      );

      final response = await apiService.updatePersonalInfo(
        userController.userData.value!.id!,
        userModel,
      );

      if (response.statusCode == 200) {
        debugPrint("Data from API: ${response.body}");
        final userdata = await apiService.getUserByID(userController.userData.value!.id!);
        debugPrint('Raw user response: ${userdata.body}');
        Get.offAndToNamed(AppRoutes.getLandingPageRoute());
      } else {
        debugPrint("Error response: ${response.body}");
      }
    } catch (e) {
      debugPrint('Network error: ${e.toString()}');
    }
  }

  /// Upload document file by path
  Future<void> uploadDocument(String filePath) async {
    final apiService = MyApIService();

    try {
      final response = await apiService.uploadFile(
        userController.userData.value!.id!,
        addLicenseController.selectedLicenseType,
        filePath,
      );

      if (response.statusCode == 201) {
        debugPrint("Document uploaded successfully");
        await apiService.getUserByID(userController.userData.value!.id!);
        Get.offAndToNamed(AppRoutes.getProfilePageRoute());
      } else {
        final responseBody = await response.stream.bytesToString();
        debugPrint("Upload failed: $responseBody");
      }
    } catch (e) {
      debugPrint('Network error: ${e.toString()}');
    }
  }

  /// Show bottom sheet to pick image and return base64 or path
  Future<String?> showUploadFileBottomSheet(BuildContext context, {bool returnBase64 = false}) async {
    final UploadFileController controller = Get.put(UploadFileController());

    return await showModalBottomSheet<String>(
      context: context,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                color: Colors.grey,
                thickness: 5,
                indent: 140,
                endIndent: 140,
              ),
              // Title & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upload File",
                    style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(null),
                    child: Text(
                      "Close",
                      style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.tenVertical),
              // Upload from Gallery option
              _buildUploadOption("Upload from Gallery", () async {
                final result = await controller.pickImageFromGallery(returnBase64: returnBase64);
                Navigator.of(context).pop(result);
              }),
              Divider(color: AppColors.kSkyBlue),
              // Upload from Camera option
              _buildUploadOption("Upload from Camera", () async {
                final result = await controller.pickImageFromCamera(returnBase64: returnBase64);
                Navigator.of(context).pop(result);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadOption(String option, Function()? onTap) {
    return ListTile(
      title: Text(option, style: const TextStyle(color: Colors.white)),
      leading: const Icon(
        Icons.file_copy_outlined,
        color: AppColors.kSkyBlue,
      ),
      onTap: onTap,
    );
  }
}
