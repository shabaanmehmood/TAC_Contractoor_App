import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';

class BankDetailModel {
  final String bankName;
  final String accountTitle;
  final String accountNumber;
  final String iban;
  final String expiryDate;

  BankDetailModel({
    required this.bankName,
    required this.accountTitle,
    required this.accountNumber,
    required this.iban,
    required this.expiryDate,
  });
}

class DummyBankDetails {
  static List<BankDetailModel> getList() {
    return [
      BankDetailModel(
        bankName: 'Allied Bank Limited',
        accountTitle: 'Ashar Atique',
        accountNumber: '5386 6012 3412 3456',
        iban: 'PK12ABCD1234567890123456',
        expiryDate: '12 / 33',
      ),
      BankDetailModel(
        bankName: 'Habib Bank Limited',
        accountTitle: 'Ashar Atique',
        accountNumber: '1234 5678 9012 3456',
        iban: 'PK34HBL1234567890123456',
        expiryDate: '01 / 30',
      ),
    ];
  }
}

class BankDetailsScreen extends StatelessWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final banks = DummyBankDetails.getList();
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.kWhite, // ← change back button color here
        ),
        title: const Text('Bank Details',
            style: TextStyle(color: AppColors.kWhite)),
        actions: [
          TextButton(
            onPressed: () => Get.to(() => const AddBankDetailsScreen()),
            child:
                const Text('Add', style: TextStyle(color: AppColors.kSkyBlue)),
          )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white24, height: 1),
        ),
      ),
      body: banks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white38, size: 64),
                  SizedBox(height: 12),
                  Text('No bank details found',
                      style: TextStyle(color: Colors.white54)),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: banks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (_, index) => buildBankCard(context, banks[index]),
              ),
            ),
    );
  }

  Widget buildBankCard(BuildContext context, BankDetailModel data) {
    return Stack(
      children: [
        Container(
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [AppColors.kSkyBlue, AppColors.kPrimary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    data.bankName,
                    style: const TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.account_balance,
                      color: AppColors.kWhite, size: 28),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                data.accountNumber,
                style: const TextStyle(
                  color: AppColors.kSkyBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("VALID",
                              style: TextStyle(
                                  color: AppColors.ktextlight,
                                  fontSize: 10,
                                  letterSpacing: 1)),
                          const Text("THRU",
                              style: TextStyle(
                                  color: AppColors.ktextlight,
                                  fontSize: 10,
                                  letterSpacing: 1)),
                          const SizedBox(height: 4),
                          Text(
                            data.expiryDate,
                            style: const TextStyle(
                              color: AppColors.kWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.accountTitle,
                    style: const TextStyle(
                      color: AppColors.kWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => Container(
                decoration: const BoxDecoration(
                  color: AppColors.kDarkBlue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: AppColors.kWhite),
                      title: const Text('Edit',
                          style: TextStyle(color: AppColors.kWhite)),
                      onTap: () {
                        Get.back();
                        Get.snackbar('Edit', 'Edit feature coming soon',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.kgrey,
                            colorText: AppColors.kWhite);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete_outline,
                          color: AppColors.kRed),
                      title: const Text('Delete',
                          style: TextStyle(color: AppColors.kRed)),
                      onTap: () {
                        Get.back();
                        Get.snackbar('Deleted', 'Bank detail deleted',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.kRed,
                            colorText: AppColors.kWhite);
                      },
                    ),
                  ],
                ),
              ),
            ),
            child: const Icon(Icons.more_vert, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class AddBankDetailsScreen extends StatefulWidget {
  const AddBankDetailsScreen({super.key});

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  final bankNameController = TextEditingController();
  final accountTitleController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ibanController = TextEditingController();
  final expiryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.kWhite, // ← change back button color here
        ),
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        title: const Text('Add Bank Details',
            style: TextStyle(color: AppColors.kWhite)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white24, height: 1),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  customField(
                      Icons.account_balance, 'Bank Name', bankNameController),
                  customField(
                      Icons.person, 'Account Title', accountTitleController),
                  customField(
                      Icons.numbers, 'Account Number', accountNumberController),
                  customField(Icons.credit_card, 'IBAN', ibanController),
                  customField(
                      Icons.calendar_today, 'Expiry Date', expiryController),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.kDarkestBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.kWhite,
                      side: const BorderSide(color: AppColors.kWhite),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 7,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        'Success',
                        'Bank details added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.kgreen,
                        colorText: AppColors.kWhite,
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kSkyBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      minimumSize: const Size.fromHeight(56),
                    ),
                    child: const Text(
                      'Add Bank',
                      style: TextStyle(color: AppColors.kDarkestBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customField(
      IconData icon, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          style: const TextStyle(color: AppColors.kWhite),
          cursorColor: AppColors.kWhite,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.ktextlight, fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.ktextlight, size: 18),
            border: InputBorder.none,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
          ),
        ),
        const Divider(color: AppColors.kSkyBlue, thickness: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}
