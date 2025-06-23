import 'package:taccontractor/models/preferenceModel.dart';
import 'package:taccontractor/models/shift_model.dart';

class CreateJobModel {
  final String title;
  final String payPerHour;
  final String categoryId;
  final String premisesTypeId;
  final String description;
  final String responsibilities;
  final String location;
  final double latitude;
  final double longitude;
  final int noOfGuardsRequired;
  final bool leaderRequired;
  final String jobSOPs;
  final String contractorId;
  final List<Shift> shifts;
  final Preferences preferences;

  CreateJobModel({
    required this.title,
    required this.payPerHour,
    required this.categoryId,
    required this.premisesTypeId,
    required this.description,
    required this.responsibilities,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.noOfGuardsRequired,
    required this.leaderRequired,
    required this.jobSOPs,
    required this.contractorId,
    required this.shifts,
    required this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'payPerHour': payPerHour,
      'categoryId': categoryId,
      'premisesTypeId': premisesTypeId,
      'description': description,
      'responsibilities': responsibilities,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'noOfGuardsRequired': noOfGuardsRequired,
      'leaderRequired': leaderRequired,
      'jobSOPs': jobSOPs,
      'contractorId': contractorId,
      'shifts': shifts.map((shift) => shift.toJson()).toList(),
      'preferences': preferences.toJson(),
    };
  }
}
