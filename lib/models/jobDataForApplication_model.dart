import 'package:taccontractor/models/shift_model.dart';

class JobDataForApplication {
  final String id;
  final String title;
  final String description;
  final String responsibilities;
  final String location;
  final String latitude;
  final String longitude;
  final int noOfGuardsRequired;
  final int leaderRequired;
  final String payPerHour;
  final String jobSOPs;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String contractorId;
  final String contractorName;
  final String categoryName;
  final String premisesTypeName;
  final double? distance;
  final List<Shift> shifts;

  JobDataForApplication({
    required this.id,
    required this.title,
    required this.description,
    required this.responsibilities,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.noOfGuardsRequired,
    required this.leaderRequired,
    required this.payPerHour,
    required this.jobSOPs,
    required this.createdAt,
    required this.updatedAt,
    required this.contractorId,
    required this.contractorName,
    required this.categoryName,
    required this.premisesTypeName,
    this.distance,
    required this.shifts,
  });

  factory JobDataForApplication.fromJson(Map<String, dynamic> json) {
    return JobDataForApplication(
      id: json['id'] ?? '', // was 'jobId'
      title: json['title'] ?? '', // was 'jobTitle'
      description: json['description'] ?? '', // was 'jobDescription'
      responsibilities: json['responsibilities'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      noOfGuardsRequired: json['noOfGuardsRequired'] ?? 0,
      leaderRequired: json['leaderRequired'] ?? 0,
      payPerHour: json['payPerHour'] ?? '',
      jobSOPs: json['jobSOPs'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      contractorId: json['contractor']?['id'] ?? '',
      contractorName: json['contractor']?['name'] ?? '',
      categoryName: json['category']?['name'] ?? '',
      premisesTypeName: json['premisesType']?['name'] ?? '',
      distance: json['distance'] != null
          ? (json['distance'] is num
          ? (json['distance'] as num).toDouble()
          : double.tryParse(json['distance'].toString()))
          : null,
      shifts: (json['shifts'] as List<dynamic>? ?? [])
          .map((item) => Shift.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': id,
      'jobTitle': title,
      'jobDescription': description,
      'jobResponsibilities': responsibilities,
      'jobLocation': location,
      'jobLatitude': latitude,
      'jobLongitude': longitude,
      'noOfGuardsRequired': noOfGuardsRequired,
      'leaderRequired': leaderRequired,
      'payPerHour': payPerHour,
      'jobSOPs': jobSOPs,
      'jobCreatedAt': createdAt.toIso8601String(),
      'jobUpdatedAt': updatedAt.toIso8601String(),
      'contractorId': contractorId,
      'contractorName': contractorName,
      'categoryName': categoryName,
      'premisesTypeName': premisesTypeName,
      'distance': distance,
      'shifts': shifts.map((item) => item.toJson()).toList(),
    };
  }
}
