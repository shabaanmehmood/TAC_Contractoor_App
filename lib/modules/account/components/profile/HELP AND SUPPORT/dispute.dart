import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/widhets/common%20overlays/uploadFile_overlay.dart';

import '../../../../../dataproviders/api_service.dart';
import '../../../../../models/createDisputeModel.dart';
import '../../../../../models/job_model.dart';
import '../../../../../routes/app_routes.dart';

class DisputeController extends GetxController {
  final UserController userController = Get.find();
  final selectedDisputeType = ''.obs;
  final agreeToTerms = false.obs;
  String? base64image;
  final base64Images = ''.obs;
  final String jobId = '33327a6f-b49f-43a8-b1e7-61e53ea256a8';
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

  Future<void> submitDispute() async {
    final apiService = MyApIService(); // create instance
    try{
      if(selectedDisputeType.value == 'jobRelated'){
        final createDisputeModel = CreateDisputeModel(
          disputeType: 'job',
          contractorId: userController.userData.value!.id!,
          dateOfIncident: dateOfIncidentController.text,
          description: descriptionController.text,
          jobId: jobId,
          supportingDocument: base64Images.value,
          transactionId: (transactionIdController.text.isNotEmpty)
              ? transactionIdController.text
              : null,
          transactionDate: (transactionDateController.text.isNotEmpty)
              ? transactionDateController.text
              : null,
          disputeAmount: (disputeAmountController.text.isNotEmpty)
              ? disputeAmountController.text
              : null,
        );
        final response = await apiService.addDispute(
          //   jobId,
          //   dateOfIncidentController.text,
          //   descriptionController.text,
          //   transactionIdController.text,
          //   transactionDateController.text,
          //   disputeAmountController.text,
          //   userController.userData.value!.id!,
          //   base64Images.value,
          // 'job',
          // // selectedDisputeType.value,
          // jobId,
          // dateOfIncidentController.text,
          // descriptionController.text,
          // userController.userData.value!.id!,
          // base64Images.value,
          // null,
          // null,
          // null,
          createDisputeModel
        );
        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.back();
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error Add dispute failed: ${response.body}');
        }
      }
      else if (selectedDisputeType.value == 'earningRelated'){
        final createDisputeModel = CreateDisputeModel(
          disputeType: 'transaction',
          contractorId: userController.userData.value!.id!,
          dateOfIncident: dateOfIncidentController.text,
          description: descriptionController.text,
          jobId: jobId,
          supportingDocument: base64Images.value,
          transactionId: (transactionIdController.text.isNotEmpty)
              ? transactionIdController.text
              : null,
          transactionDate: (transactionDateController.text.isNotEmpty)
              ? transactionDateController.text
              : null,
          disputeAmount: (disputeAmountController.text.isNotEmpty)
              ? disputeAmountController.text
              : null,
        );
        final response = await apiService.addDispute(
          // 'transaction',
          // // selectedDisputeType.value,
          // jobId,
          // dateOfIncidentController.text,
          // descriptionController.text,
          // transactionIdController.text,
          // transactionDateController.text,
          // disputeAmountController.text,
          // userController.userData.value!.id!,
          // base64Images.value,
          createDisputeModel
        );
        if (response.statusCode == 200) {
          debugPrint("data from API ${response.body}");
          Get.back();
        } else {
          debugPrint("data from API ${response.body}");
          debugPrint('Error Add dispute failed: ${response.body}');
        }
      }
    }
    catch(e){
      debugPrint('Error Network error: ${e.toString()}');
    }
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
                      hint: "Select Job",
                      isDropdown: true,
                      onTap: () {},
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
                                if (controller.base64Images.isNotEmpty && controller.agreeToTerms.value == true) {
                                  controller.submitDispute();
                                }
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
                            value: typeMap['value']!,  // Use internal value
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
