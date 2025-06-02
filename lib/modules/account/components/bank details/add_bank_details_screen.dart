import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/controllers/user_controller.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';

import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';

class BankDetailsController extends GetxController {
  final formKey = GlobalKey<FormState>();

  UserController userController = Get.find<UserController>();

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountTitleController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController ibanController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();

  Future<void> submitBankDetails() async {
    if (formKey.currentState!.validate()) {
      final apiService = MyApIService();
      try {
        final response = await apiService.addBankDetails(
          bankNameController.text,
          accountTitleController.text,
          accountNumberController.text,
          ibanController.text,
          expiryDateController.text,
          userController.userData.value!.id!,
        );

        if (response.statusCode == 201) {
          await apiService.getUserByID(userController.userData.value!.id!);
          Get.back(result: true);
        } else {

        }
      } catch (e) {
      }
    } else {
    }
  }
}

class AddBankDetailsScreen extends StatefulWidget {
  AddBankDetailsScreen({super.key});

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  final BankDetailsController controller = Get.put(BankDetailsController());
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text("Add Bank Details",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Details",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    buildTextField("Bank Name", Icons.account_balance,
                        controller.bankNameController, () {}),
                    const SizedBox(height: 14),
                    buildTextField("Account Title", Icons.person_outline,
                        controller.accountTitleController, () {}),
                    const SizedBox(height: 14),
                    buildTextField("Account Number", Icons.credit_card,
                        controller.accountNumberController, () {}),
                    const SizedBox(height: 14),
                    buildTextField("IBAN", Icons.numbers,
                        controller.ibanController, () {}),
                    const SizedBox(height: 14),
                    buildTextField("Expiry Date", Icons.calendar_month_outlined,
                        controller.expiryDateController, () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
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
                          controller.expiryDateController.text =
                              picked.toIso8601String().split('T').first;
                        }
                      },),
                  ],
                ),
              ),
            ),
          ),
          const Divider(color: Colors.grey, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.kSkyBlue,
                      side: const BorderSide(color: AppColors.kSkyBlue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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
                      print("Button tapped");
                      controller.submitBankDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kSkyBlue,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Add Bank"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, IconData icon,
      TextEditingController fieldController, Function? onTap) {
    return TextFormField(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      controller: fieldController,
      cursorColor: AppColors.kSkyBlue,
      cursorErrorColor: Colors.red,
      style: const TextStyle(color: AppColors.kWhite),
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kSkyBlue),
        ),
        contentPadding: const EdgeInsets.all(15),
        isDense: true,
        fillColor: AppColors.kWhite,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(15),
          child: Icon(icon, color: Colors.grey),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $hint';
        }
        return null;
      },
    );
  }
}