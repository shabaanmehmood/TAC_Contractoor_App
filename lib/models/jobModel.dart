import 'package:taccontractor/models/premisesTypeModel.dart';
import 'package:taccontractor/models/shiftsModel.dart';

import 'categoryModel.dart';
import 'contractorModel.dart';

class Job {
  final String id;
  final String title;
  final String description;
  final String responsibilities;
  final String location;
  final int noOfGuardsRequired;
  final int leaderRequired;
  final String createdAt;
  final String jobSOPs;
  final String payPerHour;
  final String latitude;
  final String longitude;
  final String status;
  final String jobType;
  final String reportingManagerNumber;
  final String reportingManagerName;
  final String minAge;
  final String maxAge;
  final String minumumLevel;
  final String maximumLevel;
  final Category category;
  final PremisesType premisesType;
  final Contractor contractor;
  final List<Shift> shifts;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.responsibilities,
    required this.location,
    required this.noOfGuardsRequired,
    required this.leaderRequired,
    required this.createdAt,
    required this.jobSOPs,
    required this.payPerHour,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.jobType,
    required this.reportingManagerNumber,
    required this.reportingManagerName,
    required this.minAge,
    required this.maxAge,
    required this.minumumLevel,
    required this.maximumLevel,
    required this.category,
    required this.premisesType,
    required this.contractor,
    required this.shifts,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      responsibilities: json['responsibilities'] ?? '',
      location: json['location'] ?? '',
      noOfGuardsRequired: json['noOfGuardsRequired'] ?? 0,
      leaderRequired: json['leaderRequired'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      jobSOPs: json['jobSOPs'] ?? '',
      payPerHour: json['payPerHour'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      status: json['status'] ?? '',
      jobType: json['jobType'] ?? '',
      reportingManagerNumber: json['reportingManagerNumber'] ?? '',
      reportingManagerName: json['reportingManagerName'] ?? '',
      minAge: json['minAge'] ?? '',
      maxAge: json['maxAge'] ?? '',
      minumumLevel: json['minumumLevel'] ?? '',
      maximumLevel: json['maximumLevel'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      premisesType: PremisesType.fromJson(json['premisesType'] ?? {}),
      contractor: Contractor.fromJson(json['contractor'] ?? {}),
      shifts: (json['shifts'] as List<dynamic>? ?? [])
          .map((e) => Shift.fromJson(e))
          .toList(),
    );
  }
}
