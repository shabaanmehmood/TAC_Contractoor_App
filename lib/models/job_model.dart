import 'package:tac/models/shift_model.dart';

class JobData {
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
  final double distance;
  final List<Shift> shifts;

  JobData({
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
    required this.distance,
    required this.shifts,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      responsibilities: json['responsibilities'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      noOfGuardsRequired: json['noOfGuardsRequired'],
      leaderRequired: json['leaderRequired'],
      payPerHour: json['payPerHour'],
      jobSOPs: json['jobSOPs'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      contractorId: json['contractorId'],
      contractorName: json['contractorName'],
      categoryName: json['categoryName'],
      premisesTypeName: json['premisesTypeName'],
      distance: (json['distance'] as num).toDouble(),
      shifts: (json['shifts'] as List)
          .map((item) => Shift.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'responsibilities': responsibilities,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'noOfGuardsRequired': noOfGuardsRequired,
      'leaderRequired': leaderRequired,
      'payPerHour': payPerHour,
      'jobSOPs': jobSOPs,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'contractorId': contractorId,
      'contractorName': contractorName,
      'categoryName': categoryName,
      'premisesTypeName': premisesTypeName,
      'distance': distance,
      'shifts': shifts.map((item) => item.toJson()).toList(),
    };
  }
}
