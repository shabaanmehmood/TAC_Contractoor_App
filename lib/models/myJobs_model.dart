// import 'package:flutter/material.dart';
// import 'package:taccontractor/models/shift_model.dart';

// class MyjobsModel {
//   final String jobId;
//   final String jobTitle;
//   final String jobDescription;
//   final String jobResponsibilities;
//   final String jobLocation;
//   final int noOfGuardsRequired;
//   final String payPerHour;
//   final String jobCreatedAt;
//   final String jobUpdatedAt;
//   final String contractorId;
//   final String contractorName;
//   final String categoryName;
//   final String premisesTypeName;
//   String? jobStatus;
//   final List<Shift> shifts;

//   MyjobsModel({
//     required this.jobId,
//     required this.jobTitle,
//     required this.jobDescription,
//     required this.jobResponsibilities ,
//     required this.jobLocation,
//     required this.noOfGuardsRequired,
//     required this.payPerHour,
//     required this.jobCreatedAt,
//     required this.jobUpdatedAt,
//     required this.contractorId,
//     required this.contractorName,
//     required this.categoryName,
//     required this.premisesTypeName,
//     this.jobStatus,
//     required this.shifts,
//   });

//   factory MyjobsModel.fromJson(Map<String, dynamic> json) {
//     return MyjobsModel(
//       jobId: json['jobId'],
//       jobTitle: json['jobTitle'],
//       jobDescription: json['jobDescription'],
//       jobResponsibilities: json['jobResponsibilities'],
//       jobLocation: json['jobLocation'],
//       noOfGuardsRequired: json['noOfGuardsRequired'],
//       payPerHour: json['payPerHour'],
//       jobCreatedAt: json['jobCreatedAt'],
//       jobUpdatedAt: json['jobUpdatedAt'],
//       contractorId: json['contractorId'],
//       contractorName: json['contractorName'],
//       categoryName: json['categoryName'],
//       premisesTypeName: json['premisesTypeName'],
//       jobStatus: json['jobStatus'],
//       shifts: (json['shifts'] as List)
//           .map((shiftJson) => Shift.fromJson(shiftJson))
//           .toList(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:taccontractor/models/shift_model.dart';

class MyjobsModel {
  final String jobId;
  final String jobTitle;
  final String jobDescription;
  final String jobResponsibilities;
  final String jobLocation;
  final int noOfGuardsRequired;
  final String payPerHour;
  final String jobCreatedAt;
  final String jobUpdatedAt;
  final String contractorId;
  final String contractorName;
  final String categoryName;
  final String premisesTypeName;
  String? jobStatus;
  final List<Shift> shifts;
  final List<Invoice> invoices; // Add this

  MyjobsModel({
    required this.jobId,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobResponsibilities,
    required this.jobLocation,
    required this.noOfGuardsRequired,
    required this.payPerHour,
    required this.jobCreatedAt,
    required this.jobUpdatedAt,
    required this.contractorId,
    required this.contractorName,
    required this.categoryName,
    required this.premisesTypeName,
    this.jobStatus,
    required this.shifts,
    required this.invoices, // Add this
  });

  factory MyjobsModel.fromJson(Map<String, dynamic> json) {
    return MyjobsModel(
      jobId: json['jobId'],
      jobTitle: json['jobTitle'],
      jobDescription: json['jobDescription'],
      jobResponsibilities: json['jobResponsibilities'],
      jobLocation: json['jobLocation'],
      noOfGuardsRequired: json['noOfGuardsRequired'],
      payPerHour: json['payPerHour'],
      jobCreatedAt: json['jobCreatedAt'],
      jobUpdatedAt: json['jobUpdatedAt'],
      contractorId: json['contractorId'],
      contractorName: json['contractorName'],
      categoryName: json['categoryName'],
      premisesTypeName: json['premisesTypeName'],
      jobStatus: json['jobStatus'],
      shifts: (json['shifts'] as List)
          .map((shiftJson) => Shift.fromJson(shiftJson))
          .toList(),
      invoices: (json['invoices'] as List?)
              ?.map((invoiceJson) => Invoice.fromJson(invoiceJson))
              .toList() ??
          [], // Add this
    );
  }
}

// Add Invoice Model
class Invoice {
  final String id;
  final String status;
  final String amount;
  final String currency;
  final String createdAt;
  final Contractor? contractor;

  Invoice({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.contractor,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      status: json['status'],
      amount: json['amount'],
      currency: json['currency'],
      createdAt: json['createdAt'],
      contractor: json['contractor'] != null
          ? Contractor.fromJson(json['contractor'])
          : null,
    );
  }
}

// Add Contractor Model
class Contractor {
  final String id;
  final String name;
  final String email;

  Contractor({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

