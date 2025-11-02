
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/myJobs_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class OpenInvoiceScreen extends StatelessWidget {
  final MyjobsModel job;

  const OpenInvoiceScreen({Key? key, required this.job}) : super(key: key);

  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.kgrey;
    }
  }

  Future<void> downloadInvoicePDF(Invoice invoice) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Invoice ID: ${invoice.id}',
                        style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                      ),
                      pw.Text(
                        'Date: ${formatDate(invoice.createdAt)}',
                        style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),

                // Contractor Info
                if (invoice.contractor != null) ...[
                  pw.Text(
                    'Bill To:',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(invoice.contractor!.name, style: pw.TextStyle(fontSize: 12)),
                  pw.Text(invoice.contractor!.email, style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 30),
                ],

                // Job Details
                pw.Container(
                  padding: pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Job Details',
                        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 15),
                      _buildPdfRow('Job Title:', job.jobTitle),
                      _buildPdfRow('Location:', job.jobLocation),
                      _buildPdfRow('Pay Rate:', '\$${job.payPerHour}/hr'),
                      _buildPdfRow('Category:', job.categoryName),
                      _buildPdfRow('Premises Type:', job.premisesTypeName),
                    ],
                  ),
                ),
                pw.SizedBox(height: 30),

                // Invoice Amount
                pw.Container(
                  padding: pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Amount:',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '\$${invoice.amount} ${invoice.currency.toUpperCase()}',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Status
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: pw.BoxDecoration(
                        color: invoice.status.toLowerCase() == 'paid'
                            ? PdfColors.green100
                            : PdfColors.orange100,
                        borderRadius: pw.BorderRadius.circular(20),
                      ),
                      child: pw.Text(
                        'Status: ${invoice.status.toUpperCase()}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: invoice.status.toLowerCase() == 'paid'
                              ? PdfColors.green900
                              : PdfColors.orange900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Get the directory to save the file
      Directory? directory;
      if (Platform.isAndroid) {
        // For Android 10+ (API 29+), use app-specific directory that doesn't require permissions
        directory = await getExternalStorageDirectory();
        // Try to save in public Downloads folder
        final downloadsPath = '/storage/emulated/0/Download';
        final downloadsDir = Directory(downloadsPath);
        if (await downloadsDir.exists()) {
          directory = downloadsDir;
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      // Create file name with timestamp
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'Invoice_${invoice.id.substring(0, 8)}_$timestamp.pdf';
      final file = File('${directory!.path}/$fileName');

      // Save the PDF file
      await file.writeAsBytes(await pdf.save());

      return; // Success - file saved
    } catch (e) {
      rethrow; // Let the caller handle the error
    }
  }

  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.02, left: Get.height * 0.02),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      AppAssets.kBack,
                      height: Get.height * 0.07,
                      width: Get.width * 0.07,
                      fit: BoxFit.contain,
                      color: AppColors.kgrey,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.04),
                  Text(
                    "Invoice Details",
                    style:
                        AppTypography.kBold20.copyWith(color: AppColors.kWhite),
                  ),
                ],
              ),
            ),

            /// Divider
            Container(
              width: double.infinity,
              height: Get.width * 0.002,
              color: AppColors.kgrey,
            ),

            SizedBox(height: Get.height * 0.02),

            /// Invoice List
            Expanded(
              child: job.invoices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 80,
                            color: AppColors.kgrey.withOpacity(0.5),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "No Invoices Available",
                            style: AppTypography.kBold18.copyWith(
                              color: AppColors.kgrey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                      itemCount: job.invoices.length,
                      itemBuilder: (context, index) {
                        final invoice = job.invoices[index];
                        return _buildInvoiceCard(invoice);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceCard(Invoice invoice) {
    return Container(
      margin: EdgeInsets.only(bottom: Get.height * 0.02),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.kCard.withOpacity(0.9),
        border: Border.all(
          width: Get.width * 0.001,
          color: AppColors.kgrey,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice #${invoice.id.substring(0, 8)}',
                      style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ID: ${invoice.id}',
                      style: AppTypography.kLight12.copyWith(
                        color: AppColors.kgrey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.03,
                  vertical: Get.width * 0.015,
                ),
                decoration: BoxDecoration(
                  color: getStatusColor(invoice.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                  border: Border.all(
                    color: getStatusColor(invoice.status),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  invoice.status.toUpperCase(),
                  style: AppTypography.kBold12.copyWith(
                    color: getStatusColor(invoice.status),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: Get.height * 0.02),
          
          // Divider
          Container(
            height: 1,
            color: AppColors.kgrey.withOpacity(0.3),
          ),
          
          SizedBox(height: Get.height * 0.02),

          // Amount Section
          Container(
            padding: EdgeInsets.all(Get.width * 0.04),
            decoration: BoxDecoration(
              color: AppColors.kSkyBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.kSkyBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount:',
                  style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                ),
                Text(
                  '\$${invoice.amount} ${invoice.currency.toUpperCase()}',
                  style: AppTypography.kBold20.copyWith(color: Colors.cyanAccent),
                ),
              ],
            ),
          ),

          SizedBox(height: Get.height * 0.015),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.kgrey, size: 16),
              SizedBox(width: 8),
              Text(
                'Created: ${formatDate(invoice.createdAt)}',
                style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
              ),
            ],
          ),

          // Contractor Info
          if (invoice.contractor != null) ...[
            SizedBox(height: Get.height * 0.02),
            Container(
              height: 1,
              color: AppColors.kgrey.withOpacity(0.3),
            ),
            SizedBox(height: Get.height * 0.015),
            Text(
              'Contractor Details',
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
            ),
            SizedBox(height: Get.height * 0.01),
            Row(
              children: [
                Icon(Icons.person, color: AppColors.kgrey, size: 16),
                SizedBox(width: 8),
                Text(
                  invoice.contractor!.name,
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.008),
            Row(
              children: [
                Icon(Icons.email, color: AppColors.kgrey, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    invoice.contractor!.email,
                    style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: Get.height * 0.02),

          // Job Information
          Container(
            padding: EdgeInsets.all(Get.width * 0.03),
            decoration: BoxDecoration(
              color: AppColors.kinput.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job Information',
                  style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                ),
                SizedBox(height: Get.height * 0.01),
                _buildInfoRow('Job Title:', job.jobTitle),
                _buildInfoRow('Location:', job.jobLocation),
                _buildInfoRow('Pay Rate:', '\$${job.payPerHour}/hr'),
                _buildInfoRow('Category:', job.categoryName),
                _buildInfoRow('Premises Type:', job.premisesTypeName),
              ],
            ),
          ),

          SizedBox(height: Get.height * 0.02),

          // Download Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  Get.dialog(
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: AppColors.kSkyBlue),
                          SizedBox(height: 16),
                          Text(
                            'Downloading Invoice...',
                            style: AppTypography.kBold14.copyWith(
                              color: AppColors.kWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                    barrierDismissible: false,
                  );

                  await downloadInvoicePDF(invoice);
                  
                  Get.back(); // Close loading dialog

                  Get.snackbar(
                    "Success",
                    "Invoice downloaded successfully to Downloads folder",
                    backgroundColor: Colors.green.withOpacity(0.2),
                    colorText: Colors.green,
                    snackPosition: SnackPosition.BOTTOM,
                    icon: Icon(Icons.check_circle, color: Colors.green),
                    duration: Duration(seconds: 4),
                  );
                } catch (e) {
                  Get.back(); // Close loading dialog
                  
                  Get.snackbar(
                    "Error",
                    "Failed to download invoice: ${e.toString()}",
                    backgroundColor: AppColors.kRed.withOpacity(0.2),
                    colorText: AppColors.kRed,
                    snackPosition: SnackPosition.BOTTOM,
                    icon: Icon(Icons.error, color: AppColors.kRed),
                    duration: Duration(seconds: 4),
                  );
                }
              },
              icon: Icon(Icons.file_download, size: 20),
              label: Text(
                "Download Invoice PDF",
                style: AppTypography.kBold14,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kSkyBlue,
                foregroundColor: AppColors.kBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Get.width * 0.02),
                ),
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.018),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.height * 0.008),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.3,
            child: Text(
              label,
              style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.kLight14.copyWith(
                color: AppColors.kWhite.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}