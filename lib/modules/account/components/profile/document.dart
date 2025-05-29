import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../models/userDocument_model.dart';
import '../../../../models/userLicenses_model.dart';
import '../../../../widhets/common overlays/uploadFile_overlay.dart';

// class DocumentsController extends GetxController {
//   var documents = <Map<String, dynamic>>[
//     {
//       'title': 'Passport',
//       'verified': true,
//       'image': 'assets/userpicture.jpg', // Replace with actual path
//     },
//     {
//       'title': 'Police Verification',
//       'verified': false,
//       'image': '',
//     }
//   ].obs;
// }
//
// class DocumentScreen extends StatelessWidget {
//   DocumentScreen({super.key});
//
//   final DocumentsController controller = Get.put(DocumentsController());
//   final UserController userController = Get.find<UserController>(); // Add this line
//   final UploadFileController uploadFileController = Get.put(UploadFileController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.kDarkestBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: AppColors.kWhite),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text('Documents',
//             style: TextStyle(color: AppColors.kWhite, fontSize: 16)),
//         centerTitle: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//         child: Obx(() {
//           return Column(
//             children: controller.documents.map((doc) {
//               final String title = doc['title'] as String;
//               final bool verified = doc['verified'] as bool;
//
//               return Padding(
//                 padding: const EdgeInsets.only(top: 6, bottom: 16),
//                 child: verified
//                     ? buildVerifiedCard(title)
//                     : buildUploadCard(title),
//               );
//             }).toList(),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget buildVerifiedCard(String title) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: AppColors.kinput, width: 0.5),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         color: AppColors.kWhite,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18)),
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.kgreen.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(7),
//                   ),
//                   child: const Text('Verified',
//                       style: TextStyle(
//                           color: AppColors.kgreen,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold)),
//                 )
//               ],
//             ),
//           ),
//           // Image from userController
//           Padding(
//             padding:
//             const EdgeInsets.only(top: 0, left: 12, right: 12, bottom: 12),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(6),
//               child: Obx(() {
//                 final imagePath =
//                     userController.userData.value?.profileImages?.first.imageUrl;
//                 final imageUrl = MyApIService.fullImageUrl(imagePath);
//                 return Image(
//                   image: imageUrl != null
//                       ? NetworkImage(imageUrl)
//                       : AssetImage(AppAssets.kUserPicture)
//                   as ImageProvider,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: 200,
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildUploadCard(String title) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.kJobCardColor,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: AppColors.kgrey.withOpacity(0.3), width: 0.8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Row with Icon and Add
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Circular Icon
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.kSkyBlue.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.insert_drive_file,
//                     color: AppColors.kSkyBlue, size: 20),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   String? path = await uploadFileController.showUploadFileBottomSheet(Get.context!, returnBase64: false);
//                   if (path != null) {
//                     await uploadFileController.uploadDocument(
//                       userId: userController.userData.value!.id,
//                       fileType: 'passport',
//                       path,
//                     );
//                   }
//                 },
//                 child: const Text(
//                   'Add',
//                   style: TextStyle(
//                     color: AppColors.kSkyBlue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//
//           // Title text
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.w900,
//               fontSize: 14,
//               color: AppColors.kinput,
//             ),
//           ),
//           const SizedBox(height: 6),
//
//           // Description
//           const Text(
//             'Upload a clear and recent profile picture (JPG, PNG, max 5MB).',
//             style: TextStyle(
//               fontSize: 9,
//               color: AppColors.ktextlight,
//               height: 1.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final userController = Get.find<UserController>();
  final uploadFileController = Get.put(UploadFileController());
  late Future<List<UserDocument>> userDocumentsFuture;

  @override
  void initState() {
    super.initState();
    userDocumentsFuture = fetchUserDocuments();
  }

  Future<List<UserDocument>> fetchUserDocuments() async {
    final apiService = MyApIService();
    final userId = Get.find<UserController>().userData.value?.id ?? '';
    final response = await apiService.getUserDocuments(userId);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final dataList = jsonResponse['data'];
      if (dataList != null && dataList is List) {
        final documents = dataList.map((item) => UserDocument.fromJson(item)).toList();
        // Sort by creation date (newest first)
        documents.sort((a, b) =>
            (b.createdDate ?? '').compareTo(a.createdDate ?? '')
        );
        return documents;
      } else {
        debugPrint('Invalid data format: $dataList');
        return [];
      }
    } else {
      debugPrint('Failed to fetch user documents: ${response.statusCode}');
      return [];
    }
  }

  void refreshDocuments() {
    setState(() {
      userDocumentsFuture = fetchUserDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        title: const Text('Documents', style: TextStyle(color: AppColors.kWhite)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white24, height: 1),
        ),
      ),
      body: FutureBuilder<List<UserDocument>>(
        future: userDocumentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading documents',
                style: TextStyle(color: Colors.white54),
              ),
            );
          } else {
            final documentsList = snapshot.data ?? [];

            // Check if passport and police verification documents exist
            bool hasPassport = documentsList.any((doc) => doc.type?.toLowerCase() == 'passport');
            bool hasPoliceVerification = documentsList.any((doc) => doc.type?.toLowerCase() == 'police verification');

            // Prepare list items including required upload cards
            List<Widget> listItems = [];

            // Add passport upload card if needed
            if (!hasPassport) {
              listItems.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: buildUploadCard('Passport'),
                ),
              );
            }

            // Add police verification upload card if needed
            if (!hasPoliceVerification) {
              listItems.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: buildUploadCard('Police Verification'),
                ),
              );
            }

            // Add existing documents
            if (documentsList.isEmpty && hasPassport && hasPoliceVerification) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined, color: Colors.white38, size: 64),
                    SizedBox(height: 12),
                    Text('No documents found', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              );
            }

            // Add document cards for existing documents
            for (var document in documentsList) {
              listItems.add(
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: buildDocumentCard(
                    title: document.type ?? 'Unknown Document',
                    imageUrl: document.fileUrl,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(children: listItems),
            );
          }
        },
      ),
    );
  }

  Widget buildUploadCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.kgrey.withOpacity(0.3), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with Icon and Add
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Circular Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kSkyBlue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.insert_drive_file,
                    color: AppColors.kSkyBlue, size: 20),
              ),
              GestureDetector(
                onTap: () async {
                  String? path = await uploadFileController.showUploadFileBottomSheet(Get.context!, returnBase64: false);
                  if (path != null) {
                    await uploadFileController.uploadDocument(
                      userId: userController.userData.value!.id,
                      fileType: title.toLowerCase(),
                      path,
                    );
                    refreshDocuments(); // Refresh after upload
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    color: AppColors.kSkyBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title text
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: AppColors.kinput,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            'Upload a clear copy of your ${title.toLowerCase()} document (PDF, JPG, PNG, max 5MB).',
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.ktextlight,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDocumentCard({
    required String title,
    String? imageUrl,
  }) {
    final fileExtension = imageUrl != null ? _getFileExtension(imageUrl).toLowerCase() : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kDarkBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Image + Type
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: documentImageWidget(imageUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.ktextlight,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (fileExtension.isNotEmpty)
                      Text(
                        fileExtension.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.kDarkBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget documentImageWidget(String? imageUrl) {
    if (imageUrl == null) {
      return _buildFileTypeIcon('unknown');
    }

    final fullImageUrl = MyApIService.fullImageUrl(imageUrl);
    final fileExtension = _getFileExtension(imageUrl).toLowerCase();

    // Check if the file is an image
    if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension)) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(fullImageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Show icon based on file type
      return _buildFileTypeIcon(fileExtension);
    }
  }

  String _getFileExtension(String fileUrl) {
    final parts = fileUrl.split('.');
    return parts.length > 1 ? parts.last : '';
  }

  Widget _buildFileTypeIcon(String fileType) {
    IconData iconData;
    Color iconColor;

    switch (fileType) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'doc':
      case 'docx':
        iconData = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        iconData = Icons.table_chart;
        iconColor = Colors.green;
        break;
      case 'txt':
        iconData = Icons.text_snippet;
        iconColor = Colors.amber;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.kDarkBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}