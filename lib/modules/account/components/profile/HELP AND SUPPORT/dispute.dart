// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/controllers/user_controller.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
// import 'package:taccontractor/widhets/common%20overlays/uploadFile_overlay.dart';

// import '../../../../../dataproviders/api_service.dart';
// import '../../../../../models/createDisputeModel.dart';
// import '../../../../../models/job_model.dart';
// import '../../../../../routes/app_routes.dart';

// class DisputeController extends GetxController {
//   final UserController userController = Get.find();
//   final selectedDisputeType = ''.obs;
//   final agreeToTerms = false.obs;
//   String? base64image;
//   final base64Images = ''.obs;
//   final String jobId = '33327a6f-b49f-43a8-b1e7-61e53ea256a8';
//   JobData? jobData;

//   static const List<Map<String, String>> disputeTypes = [
//     {'label': 'Job Related', 'value': 'jobRelated'},
//     {'label': 'Earning Related', 'value': 'earningRelated'},
//   ];
//   final TextEditingController dateOfIncidentController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController transactionIdController = TextEditingController();
//   final TextEditingController transactionDateController = TextEditingController();
//   final TextEditingController disputeAmountController = TextEditingController();

//   // Validation method
//   bool validateFields() {
//     if (selectedDisputeType.value.isEmpty) {
//       Get.snackbar('Error', 'Please select a dispute type',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (dateOfIncidentController.text.isEmpty) {
//       Get.snackbar('Error', 'Please enter the date of incident',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (descriptionController.text.isEmpty) {
//       Get.snackbar('Error', 'Please describe your issue in detail',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (selectedDisputeType.value == 'earningRelated') {
//       if (transactionIdController.text.isEmpty) {
//         Get.snackbar('Error', 'Please enter the transaction ID',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return false;
//       }
//       if (transactionDateController.text.isEmpty) {
//         Get.snackbar('Error', 'Please enter the transaction date',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return false;
//       }
//       if (disputeAmountController.text.isEmpty) {
//         Get.snackbar('Error', 'Please enter the dispute amount',
//             backgroundColor: Colors.red, colorText: Colors.white);
//         return false;
//       }
//     }
//     if (base64Images.value.isEmpty) {
//       Get.snackbar('Error', 'Please upload a supporting document',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     if (!agreeToTerms.value) {
//       Get.snackbar('Error', 'You must agree to the terms and conditions',
//           backgroundColor: Colors.red, colorText: Colors.white);
//       return false;
//     }
//     return true;
//   }

//   Future<void> submitDispute() async {
//     if (!validateFields()) return;

//     final apiService = MyApIService();
//     try {
//       final createDisputeModel = CreateDisputeModel(
//         disputeType: selectedDisputeType.value == 'jobRelated' ? 'job' : 'transaction',
//         contractorId: userController.userData.value!.id!,
//         dateOfIncident: dateOfIncidentController.text,
//         description: descriptionController.text,
//         jobId: jobId,
//         supportingDocument: base64Images.value,
//         transactionId: transactionIdController.text.isNotEmpty
//             ? transactionIdController.text
//             : null,
//         transactionDate: transactionDateController.text.isNotEmpty
//             ? transactionDateController.text
//             : null,
//         disputeAmount: disputeAmountController.text.isNotEmpty
//             ? disputeAmountController.text
//             : null,
//       );

//       final response = await apiService.addDispute(createDisputeModel);
//       if (response.statusCode == 200) {
//         debugPrint("data from API ${response.body}");
//         Get.back();
//       } else {
//         debugPrint("data from API ${response.body}");
//         debugPrint('Error Add dispute failed: ${response.body}');
//       }
//     } catch (e) {
//       debugPrint('Error Network error: ${e.toString()}');
//     }
//   }
// }

// class DisputeScreen extends StatelessWidget {
//   DisputeScreen({super.key});

//   DisputeController controller = Get.put(DisputeController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkestBlue,
//       appBar: AppBar(
//         backgroundColor: AppColors.kDarkestBlue,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kWhite),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Dispute',
//           style: TextStyle(
//               color: AppColors.ktextlight,
//               fontSize: 18,
//               fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: Obx(() => Stack(
//             children: [
//               SingleChildScrollView(
//                 padding: const EdgeInsets.fromLTRB(16, 12, 16, 180),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("Details",
//                         style: TextStyle(
//                             color: AppColors.kWhite,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 16),
//                     _buildInputField(
//                       icon: Icons.warning_amber_rounded,
//                       hint: controller.selectedDisputeType.value.isEmpty
//                           ? 'Select Dispute Type'
//                           : DisputeController.disputeTypes
//                           .firstWhere((type) => type['value'] == controller.selectedDisputeType.value)['label']!,
//                       isDropdown: true,
//                       onTap: () => _showDisputeTypeBottomSheet(context),
//                     ),
//                     const Divider(color: AppColors.kPrimary),
//                     const SizedBox(height: 16),
//                     _buildInputField(
//                       icon: Icons.work_outline,
//                       hint: "Select Job",
//                       isDropdown: true,
//                       onTap: () {},
//                     ),
//                     const Divider(color: AppColors.kPrimary),
//                     const SizedBox(height: 16),
//                     _buildInputField(
//                         icon: Icons.calendar_today_outlined,
//                         hint: "Date of Incident",
//                         controller: controller.dateOfIncidentController,
//                       onTap: () async {
//                         final picked = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(1900),
//                           lastDate: DateTime(2200),
//                           builder: (context, child) {
//                             return Theme(
//                               data: Theme.of(context).copyWith(
//                                 dialogBackgroundColor: AppColors.kDarkestBlue,
//                                 colorScheme: ColorScheme.dark(
//                                   primary: AppColors.kSkyBlue,
//                                   onPrimary: Colors.black,
//                                   surface: AppColors.kDarkestBlue,
//                                   onSurface: Colors.white,
//                                 ),
//                                 textButtonTheme: TextButtonThemeData(
//                                   style: TextButton.styleFrom(
//                                     foregroundColor: AppColors
//                                         .kSkyBlue, // Button text color
//                                   ),
//                                 ),
//                               ),
//                               child: child!,
//                             );
//                           },
//                         );
//                         if (picked != null && picked != DateTime.now()) {
//                           controller.dateOfIncidentController.text = picked.toIso8601String().split('T').first;
//                         }
//                       },
//                     ),
//                     const Divider(color: AppColors.kPrimary),
//                     const SizedBox(height: 16),
//                     _buildInputField(
//                         icon: Icons.edit_outlined,
//                         hint: "Please describe your issue in detail.",
//                         controller: controller.descriptionController,
//                         maxLines: null),
//                     const Divider(color: AppColors.kPrimary),
//                     if (controller.selectedDisputeType.value ==
//                         'earningRelated') ...[
//                       const SizedBox(height: 24),
//                       const Text("Transaction Information",
//                           style: TextStyle(
//                               color: AppColors.kWhite,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 16),
//                       _buildInputField(
//                           icon: Icons.numbers,
//                           hint: "Enter transaction ID",
//                           controller: controller.transactionIdController),
//                       const Divider(color: AppColors.kPrimary),
//                       const SizedBox(height: 16),
//                       _buildInputField(
//                           icon: Icons.calendar_month,
//                           hint: "Transaction Date",
//                           controller: controller.transactionDateController,
//                         onTap: () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime(2200),
//                             builder: (context, child) {
//                               return Theme(
//                                 data: Theme.of(context).copyWith(
//                                   dialogBackgroundColor: AppColors.kDarkestBlue,
//                                   colorScheme: ColorScheme.dark(
//                                     primary: AppColors.kSkyBlue,
//                                     onPrimary: Colors.black,
//                                     surface: AppColors.kDarkestBlue,
//                                     onSurface: Colors.white,
//                                   ),
//                                   textButtonTheme: TextButtonThemeData(
//                                     style: TextButton.styleFrom(
//                                       foregroundColor: AppColors
//                                           .kSkyBlue, // Button text color
//                                     ),
//                                   ),
//                                 ),
//                                 child: child!,
//                               );
//                             },
//                           );
//                           if (picked != null && picked != DateTime.now()) {
//                             controller.transactionDateController.text = picked.toIso8601String().split('T').first;
//                           }
//                         }
//                       ),
//                       const Divider(color: AppColors.kPrimary),
//                       const SizedBox(height: 16),
//                       _buildInputField(
//                           icon: Icons.attach_money,
//                           hint: "Dispute Amount",
//                           controller: controller.disputeAmountController),
//                       const Divider(color: AppColors.kPrimary),
//                     ],
//                     const SizedBox(height: 24),
//                     const Text("Supporting Documents",
//                         style: TextStyle(
//                             color: AppColors.kWhite,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 12),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: AppColors.kJobCardColor,
//                         borderRadius: BorderRadius.circular(6),
//                       ),
//                       child: Row(
//                         children: [
//                           const Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Attach Doc",
//                                     style: TextStyle(
//                                         color: AppColors.kWhite,
//                                         fontWeight: FontWeight.bold)),
//                                 SizedBox(height: 4),
//                                 Text(
//                                     "Min 10MB. Upload only PDF, DOC, DOCX, JPG, PNG",
//                                     style: TextStyle(
//                                         color: AppColors.kinput, fontSize: 9)),
//                               ],
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () async {
//                               final UploadFileController uploadFileController = Get.put(UploadFileController());
//                               final String? base64Image = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true);
//                               if (base64Image != null) {
//                                 controller.base64Images.value = base64Image;
//                                 controller.base64image = base64Image;
//                               }
//                             },
//                             child: Obx(
//                               () => Text(
//                                 controller.base64Images.value.isNotEmpty
//                                     ? 'File Selected'
//                                     : 'Upload',
//                                 style: const TextStyle(
//                                     color: AppColors.kSkyBlue,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//                   color: AppColors.kDarkestBlue,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Divider(color: AppColors.kinput),
//                       Row(
//                         children: [
//                           Obx(() => Checkbox(
//                                 value: controller.agreeToTerms.value,
//                                 onChanged: (value) =>
//                                     controller.agreeToTerms.value = value!,
//                                 activeColor: AppColors.kSkyBlue,
//                               )),
//                           const Expanded(
//                             child: Text(
//                                 "I agree to the terms and conditions and confirm that all information provided is accurate",
//                                 style: TextStyle(
//                                     color: AppColors.kinput, fontSize: 10.5)),
//                           )
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Expanded(
//                             flex: 4,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16),
//                                 backgroundColor: Colors.transparent,
//                                 side:
//                                     const BorderSide(color: AppColors.kSkyBlue),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8)),
//                               ),
//                               onPressed: () => Get.back(),
//                               child: const Text('Close',
//                                   style: TextStyle(
//                                       color: AppColors.kSkyBlue, fontSize: 12)),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             flex: 6,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 16),
//                                 backgroundColor: AppColors.kSkyBlue,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 controller.submitDispute();
//                               },
//                               child: const Text('Submit Dispute',
//                                   style: TextStyle(color: AppColors.kDarkBlue)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           )),
//     );
//   }

//   void _showDisputeTypeBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.kDarkBlue,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//       ),
//       builder: (_) {
//         return Obx(() => Container(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Select Dispute Type',
//                             style: TextStyle(
//                                 color: AppColors.kWhite,
//                                 fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                   const Divider(color: AppColors.kinput),
//                   ...DisputeController.disputeTypes.map((typeMap) {
//                     return Column(
//                       children: [
//                         ListTile(
//                           leading: Radio<String>(
//                             value: typeMap['value']!,  // Use internal value
//                             groupValue: controller.selectedDisputeType.value,
//                             onChanged: (value) {
//                               controller.selectedDisputeType.value = value!;
//                               Navigator.pop(context);
//                             },
//                             activeColor: AppColors.kSkyBlue,
//                           ),
//                           title: Text(
//                             typeMap['label']!,
//                             style: const TextStyle(color: AppColors.kWhite),
//                           ),
//                           onTap: () {
//                             controller.selectedDisputeType.value = typeMap['value']!;
//                             Navigator.pop(context);
//                           },
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Divider(color: AppColors.kinput),
//                         ),
//                       ],
//                     );
//                   }).toList(),

//                 ],
//               ),
//             ));
//       },
//     );
//   }

//   Widget _buildInputField({
//     required IconData icon,
//     required String hint,
//     TextEditingController? controller,
//     bool readOnly = false,
//     int? maxLines,
//     bool isDropdown = false,
//     VoidCallback? onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 14),
//             child: Icon(icon, color: AppColors.kSkyBlue, size: 20),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: IgnorePointer(
//               ignoring: onTap != null,
//               child: TextField(
//                 controller: controller,
//                 maxLines: maxLines,
//                 readOnly: readOnly || onTap != null,
//                 style: const TextStyle(color: AppColors.kWhite, fontSize: 13),
//                 decoration: InputDecoration(
//                   hintText: hint,
//                   hintStyle:
//                       const TextStyle(color: AppColors.kinput, fontSize: 13),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                   isDense: true,
//                   suffixIcon: isDropdown
//                       ? const Icon(Icons.keyboard_arrow_down_rounded,
//                           color: AppColors.kinput)
//                       : null,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class DisputeScreen2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DisputeScreen();
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/widhets/common%20overlays/uploadFile_overlay.dart';
import 'dart:convert';

import '../../../../../dataproviders/api_service.dart';
import '../../../../../models/createDisputeModel.dart';
import '../../../../../models/job_model.dart';
import '../../../../../routes/app_routes.dart';

class DisputeController extends GetxController {
  final UserController userController = Get.find();
  final selectedDisputeType = ''.obs;
  final selectedJobId = ''.obs;
  final selectedJobTitle = ''.obs;
  final agreeToTerms = false.obs;
  final jobsList = <JobData>[].obs;
  final isLoadingJobs = false.obs;
  String? base64image;
  final base64Images = ''.obs;
  final String defaultJobId = '33327a6f-b49f-43a8-b1e7-61e53ea256a8';
  JobData? jobData;

  static const List<Map<String, String>> disputeTypes = [
    {'label': 'Job Related', 'value': 'jobRelated'},
    {'label': 'Earning Related', 'value': 'earningRelated'},
  ];
  final TextEditingController dateOfIncidentController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController transactionIdController = TextEditingController();
  final TextEditingController transactionDateController = TextEditingController();
  final TextEditingController disputeAmountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoadingJobs.value = true;
      final apiService = MyApIService();
      
      final response = await apiService.getJobsList();
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final dataList = json['data'] as List;
        
        jobsList.value = dataList.map((jobJson) => JobData.fromJson(jobJson)).toList();
        debugPrint('Jobs fetched successfully: ${jobsList.length} jobs');
      } else {
        debugPrint('Error fetching jobs: ${response.statusCode} - ${response.body}');
        jobsList.clear();
      }
      
    } catch (e) {
      debugPrint('Error fetching jobs: ${e.toString()}');
      jobsList.clear();
    } finally {
      isLoadingJobs.value = false;
    }
  }

  // Validation method
  bool validateFields() {
    if (selectedDisputeType.value.isEmpty) {
      Get.snackbar('Error', 'Please select a dispute type',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    // Only validate job selection if jobs are available
    if (jobsList.isNotEmpty && selectedJobId.value.isEmpty) {
      Get.snackbar('Error', 'Please select a job',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (dateOfIncidentController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter the date of incident',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please describe your issue in detail',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (selectedDisputeType.value == 'earningRelated') {
      if (transactionIdController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter the transaction ID',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
      if (transactionDateController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter the transaction date',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
      if (disputeAmountController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter the dispute amount',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    }
    if (base64Images.value.isEmpty) {
      Get.snackbar('Error', 'Please upload a supporting document',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (!agreeToTerms.value) {
      Get.snackbar('Error', 'You must agree to the terms and conditions',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  Future<void> submitDispute() async {
    if (!validateFields()) return;

    final apiService = MyApIService();
    try {
      final createDisputeModel = CreateDisputeModel(
        disputeType: selectedDisputeType.value == 'jobRelated' ? 'job' : 'transaction',
        contractorId: userController.userData.value!.id!,
        dateOfIncident: dateOfIncidentController.text,
        description: descriptionController.text,
        jobId: jobsList.isNotEmpty && selectedJobId.value.isNotEmpty 
            ? selectedJobId.value 
            : defaultJobId,
        supportingDocument: base64Images.value,
        transactionId: transactionIdController.text.isNotEmpty
            ? transactionIdController.text
            : null,
        transactionDate: transactionDateController.text.isNotEmpty
            ? transactionDateController.text
            : null,
        disputeAmount: disputeAmountController.text.isNotEmpty
            ? disputeAmountController.text
            : null,
      );

      final response = await apiService.addDispute(createDisputeModel);
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");
      
      if (response.statusCode == 200) {
        // Parse the response to check the status in the body
        final responseBody = jsonDecode(response.body);
        final status = responseBody['status'];
        
        if (status == 200) {
          debugPrint("Dispute created successfully");
          
          // Clear form first
          _clearForm();
          
          // Navigate back first
          Get.back();
          
          // Show success message with delay to ensure navigation is complete
          Future.delayed(Duration(milliseconds: 500), () {
            Get.snackbar(
              'Success', 
              'Dispute submitted successfully',
              backgroundColor: Colors.green, 
              colorText: Colors.white,
              duration: Duration(seconds: 3),
              snackPosition: SnackPosition.TOP,
              margin: EdgeInsets.all(16),
            );
          });
        } else {
          debugPrint("API returned error status: $status");
          Get.snackbar(
            'Error', 
            responseBody['message'] ?? 'Failed to submit dispute. Please try again.',
            backgroundColor: Colors.red, 
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        debugPrint("HTTP error: ${response.statusCode} - ${response.body}");
        
        Get.snackbar(
          'Error', 
          'Failed to submit dispute. Please try again.',
          backgroundColor: Colors.red, 
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      debugPrint('Error Network error: ${e.toString()}');
      
      Get.snackbar(
        'Error', 
        'Network error. Please check your connection and try again.',
        backgroundColor: Colors.red, 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _clearForm() {
    selectedDisputeType.value = '';
    selectedJobId.value = '';
    selectedJobTitle.value = '';
    agreeToTerms.value = false;
    base64Images.value = '';
    base64image = null;
    dateOfIncidentController.clear();
    descriptionController.clear();
    transactionIdController.clear();
    transactionDateController.clear();
    disputeAmountController.clear();
  }
}

class DisputeScreen extends StatelessWidget {
  DisputeScreen({super.key});

  DisputeController controller = Get.put(DisputeController());

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
          'Dispute',
          style: TextStyle(
              color: AppColors.ktextlight,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Details",
                        style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildInputField(
                      icon: Icons.warning_amber_rounded,
                      hint: controller.selectedDisputeType.value.isEmpty
                          ? 'Select Dispute Type'
                          : DisputeController.disputeTypes
                          .firstWhere((type) => type['value'] == controller.selectedDisputeType.value)['label']!,
                      isDropdown: true,
                      onTap: () => _showDisputeTypeBottomSheet(context),
                    ),
                    const Divider(color: AppColors.kPrimary),
                    const SizedBox(height: 16),
                    _buildInputField(
                      icon: Icons.work_outline,
                      hint: controller.jobsList.isEmpty
                          ? 'No jobs available (using default)'
                          : controller.selectedJobTitle.value.isEmpty
                              ? 'Select Job'
                              : controller.selectedJobTitle.value,
                      isDropdown: controller.jobsList.isNotEmpty,
                      onTap: controller.jobsList.isNotEmpty 
                          ? () => _showJobSelectionBottomSheet(context)
                          : null,
                    ),
                    const Divider(color: AppColors.kPrimary),
                    const SizedBox(height: 16),
                    _buildInputField(
                        icon: Icons.calendar_today_outlined,
                        hint: "Date of Incident",
                        controller: controller.dateOfIncidentController,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2200),
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
                        if (picked != null && picked != DateTime.now()) {
                          controller.dateOfIncidentController.text = picked.toIso8601String().split('T').first;
                        }
                      },
                    ),
                    const Divider(color: AppColors.kPrimary),
                    const SizedBox(height: 16),
                    _buildInputField(
                        icon: Icons.edit_outlined,
                        hint: "Please describe your issue in detail.",
                        controller: controller.descriptionController,
                        maxLines: null),
                    const Divider(color: AppColors.kPrimary),
                    if (controller.selectedDisputeType.value ==
                        'earningRelated') ...[
                      const SizedBox(height: 24),
                      const Text("Transaction Information",
                          style: TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildInputField(
                          icon: Icons.numbers,
                          hint: "Enter transaction ID",
                          controller: controller.transactionIdController),
                      const Divider(color: AppColors.kPrimary),
                      const SizedBox(height: 16),
                      _buildInputField(
                          icon: Icons.calendar_month,
                          hint: "Transaction Date",
                          controller: controller.transactionDateController,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2200),
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
                          if (picked != null && picked != DateTime.now()) {
                            controller.transactionDateController.text = picked.toIso8601String().split('T').first;
                          }
                        }
                      ),
                      const Divider(color: AppColors.kPrimary),
                      const SizedBox(height: 16),
                      _buildInputField(
                          icon: Icons.attach_money,
                          hint: "Dispute Amount",
                          controller: controller.disputeAmountController),
                      const Divider(color: AppColors.kPrimary),
                    ],
                    const SizedBox(height: 24),
                    const Text("Supporting Documents",
                        style: TextStyle(
                            color: AppColors.kWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Attach Doc",
                                    style: TextStyle(
                                        color: AppColors.kWhite,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text(
                                    "Min 10MB. Upload only PDF, DOC, DOCX, JPG, PNG",
                                    style: TextStyle(
                                        color: AppColors.kinput, fontSize: 9)),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final UploadFileController uploadFileController = Get.put(UploadFileController());
                              final String? base64Image = await uploadFileController.showUploadFileBottomSheet(context, returnBase64: true);
                              if (base64Image != null) {
                                controller.base64Images.value = base64Image;
                                controller.base64image = base64Image;
                              }
                            },
                            child: Obx(
                              () => Text(
                                controller.base64Images.value.isNotEmpty
                                    ? 'File Selected'
                                    : 'Upload',
                                style: const TextStyle(
                                    color: AppColors.kSkyBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  color: AppColors.kDarkestBlue,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(color: AppColors.kinput),
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: controller.agreeToTerms.value,
                                onChanged: (value) =>
                                    controller.agreeToTerms.value = value!,
                                activeColor: AppColors.kSkyBlue,
                              )),
                          const Expanded(
                            child: Text(
                                "I agree to the terms and conditions and confirm that all information provided is accurate",
                                style: TextStyle(
                                    color: AppColors.kinput, fontSize: 10.5)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.transparent,
                                side:
                                    const BorderSide(color: AppColors.kSkyBlue),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => Get.back(),
                              child: const Text('Close',
                                  style: TextStyle(
                                      color: AppColors.kSkyBlue, fontSize: 12)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 6,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: AppColors.kSkyBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                controller.submitDispute();
                              },
                              child: const Text('Submit Dispute',
                                  style: TextStyle(color: AppColors.kDarkBlue)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  void _showDisputeTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kDarkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return Obx(() => Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Dispute Type',
                            style: TextStyle(
                                color: AppColors.kWhite,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.kinput),
                  ...DisputeController.disputeTypes.map((typeMap) {
                    return Column(
                      children: [
                        ListTile(
                          leading: Radio<String>(
                            value: typeMap['value']!,
                            groupValue: controller.selectedDisputeType.value,
                            onChanged: (value) {
                              controller.selectedDisputeType.value = value!;
                              Navigator.pop(context);
                            },
                            activeColor: AppColors.kSkyBlue,
                          ),
                          title: Text(
                            typeMap['label']!,
                            style: const TextStyle(color: AppColors.kWhite),
                          ),
                          onTap: () {
                            controller.selectedDisputeType.value = typeMap['value']!;
                            Navigator.pop(context);
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(color: AppColors.kinput),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ));
      },
    );
  }

  void _showJobSelectionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kDarkBlue,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return Obx(() => Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Job',
                            style: TextStyle(
                                color: AppColors.kWhite,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.kinput),
                  
                  if (controller.isLoadingJobs.value) ...[
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.kSkyBlue,
                        ),
                      ),
                    ),
                  ] else if (controller.jobsList.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.work_off_outlined,
                            color: AppColors.kinput,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No Jobs Available',
                            style: TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'You don\'t have any jobs to dispute at the moment.',
                            style: TextStyle(
                              color: AppColors.kinput,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              controller.fetchJobs();
                            },
                            child: const Text(
                              'Refresh',
                              style: TextStyle(
                                color: AppColors.kSkyBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.jobsList.length,
                        itemBuilder: (context, index) {
                          final job = controller.jobsList[index];
                          return Column(
                            children: [
                              ListTile(
                                leading: Radio<String>(
                                  value: job.id,
                                  groupValue: controller.selectedJobId.value,
                                  onChanged: (value) {
                                    controller.selectedJobId.value = value!;
                                    controller.selectedJobTitle.value = job.title;
                                    Navigator.pop(context);
                                  },
                                  activeColor: AppColors.kSkyBlue,
                                ),
                                title: Text(
                                  job.title,
                                  style: const TextStyle(color: AppColors.kWhite),
                                ),
                                onTap: () {
                                  controller.selectedJobId.value = job.id;
                                  controller.selectedJobTitle.value = job.title;
                                  Navigator.pop(context);
                                },
                              ),
                              if (index < controller.jobsList.length - 1)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Divider(color: AppColors.kinput),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ));
      },
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    TextEditingController? controller,
    bool readOnly = false,
    int? maxLines,
    bool isDropdown = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Icon(icon, color: AppColors.kSkyBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: IgnorePointer(
              ignoring: onTap != null,
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                readOnly: readOnly || onTap != null,
                style: const TextStyle(color: AppColors.kWhite, fontSize: 13),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle:
                      const TextStyle(color: AppColors.kinput, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  isDense: true,
                  suffixIcon: isDropdown
                      ? const Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.kinput)
                      : null,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DisputeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisputeScreen();
  }
}