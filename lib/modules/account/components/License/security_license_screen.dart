import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/models/userLicenses_model.dart';
import '../../../../controllers/user_controller.dart';
import '../../../../data/data/constants/app_assets.dart';
import '../../../../dataproviders/api_service.dart';
import 'add_license_screen.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/models/bankDetails_model.dart';

import '../../../../controllers/user_controller.dart';
import '../../../../dataproviders/api_service.dart';
import '../../../../routes/app_routes.dart';

class SecurityLicenseScreen extends StatefulWidget {
  SecurityLicenseScreen({super.key});

  @override
  State<SecurityLicenseScreen> createState() => _SecurityLicenseScreenState();
}

class _SecurityLicenseScreenState extends State<SecurityLicenseScreen> {
  final userController = Get.find<UserController>();
  late Future<List<UserLicenses>> userLicensesDetailsFuture;

  @override
  void initState() {
    super.initState();
    userLicensesDetailsFuture = fetchuserLicensesDetails();
  }

  Future<List<UserLicenses>> fetchuserLicensesDetails() async {
    final apiService = MyApIService();
    final userId = Get.find<UserController>().userData.value?.id ?? '';
    final response = await apiService.getUserSecurityLicenses(userId);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final dataList = jsonResponse['data'];
      if (dataList != null && dataList is List) {
        return dataList.map((item) => UserLicenses.fromJson(item)).toList();
      } else {
        debugPrint('Invalid data format: $dataList');
        return [];
      }
    } else {
      debugPrint('Failed to fetch user Licenses: ${response.statusCode}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.kWhite),
        title: const Text('Licenses', style: TextStyle(color: AppColors.kWhite)),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => AddLicenseScreen())?.then((_) {
                setState(() {
                  userLicensesDetailsFuture = fetchuserLicensesDetails();
                });
              });
            },
            child: const Text('Add License', style: TextStyle(color: AppColors.kSkyBlue)),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.white24, height: 1),
        ),
      ),
      body: FutureBuilder<List<UserLicenses>>(
        future: userLicensesDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading security licenses',
                style: TextStyle(color: Colors.white54),
              ),
            );
          } else {
            final securityLicenseList = snapshot.data ?? [];

            if (securityLicenseList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.credit_card_outlined, color: Colors.white38, size: 64),
                    SizedBox(height: 12),
                    Text('No security licenses found', style: TextStyle(color: Colors.white54)),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: securityLicenseList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final licenseData = securityLicenseList[index];
                  return buildLicenseCard(
                    title: licenseData.licenseType?.name ?? 'License Type',
                    number: licenseData.licenseNumber ?? 'License Number',
                    expiry: licenseData.expiryDate ?? 'Expiry Date',
                    status: 'Active',
                    statusColor: Colors.green,
                    badgeColor: AppColors.kDarkBlue,
                    showUpdate: false,
                    imageUrl: licenseData.licenseDocumentPath,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildLicenseCard({
    required String title,
    required String number,
    required String expiry,
    required String status,
    required Color statusColor,
    required Color badgeColor,
    bool showUpdate = false,
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
          // Row 1: Image + Status Badge + Optional Update Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: licenseImageWidget(imageUrl),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (fileExtension.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      fileExtension.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              if (showUpdate)
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(
                      color: AppColors.kSkyBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: License Title
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ktextlight,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),

          // Row 3: License Number
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),

          // Row 4: Expiry Date (right aligned)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Expiry Date   $expiry",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget licenseImageWidget(String? imageUrl) {
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
        iconData = Icons.credit_card;
        iconColor = Colors.orange;
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