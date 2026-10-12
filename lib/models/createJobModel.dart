import 'package:taccontractor/models/preferenceModel.dart';
import 'package:taccontractor/models/requiredLicenseModel.dart';
import 'package:taccontractor/models/shift_model.dart';

class CreateJobModel {
  final String title;
  final String payPerHour;
  final String categoryId;
  final String premisesTypeId;
  final String description;
  final String responsibilities;
  final String location;
  final String latitude;
  final String longitude;
  final String reportingManagerNumber;
  final String reportingManagerName;
  final String? minAge;
  final String? maxAge;
  final String minimumLevel;
  final String maximumLevel;
  final int noOfGuardsRequired;
  final String jobType;
  final bool leaderRequired;
  final String jobSOPs;
  final String contractorId;
  final List<RequiredLicense> requiredLicense;
  final String requiredSkills;
  final List<Shift> shifts;
  final Preferences preferences;
  // final String cardNumber;
  // final String expiryMonth;
  // final String expiryYear;
  // final String cvv;

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
    required this.reportingManagerNumber,
    required this.reportingManagerName,
    required this.minAge,
    required this.maxAge,
    required this.minimumLevel,
    required this.maximumLevel,
    required this.noOfGuardsRequired,
    required this.jobType,
    required this.leaderRequired,
    required this.jobSOPs,
    required this.contractorId,
    required this.requiredLicense,
    required this.requiredSkills,
    required this.shifts,
    required this.preferences,
    // required this.cardNumber,
    // required this.expiryMonth,
    // required this.expiryYear,
    // required this.cvv,
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
      'reportingManagerNumber': reportingManagerNumber,
      'reportingManagerName': reportingManagerName,
      if (minAge != null) 'minAge': minAge,
      if (maxAge != null) 'maxAge': maxAge,
      'minumumLevel': minimumLevel,
      'maximumLevel': maximumLevel,
      'noOfGuardsRequired': noOfGuardsRequired,
      'jobType': jobType,
      'leaderRequired': leaderRequired,
      'jobSOPs': jobSOPs,
      'contractorId': contractorId,
      'requiredLicenses': requiredLicense.map((l) => l.toJson()).toList(),
      'requiredSkills': requiredSkills,
      'shifts': shifts.map((shift) => shift.toJson()).toList(),
      'preferences': preferences.toJson(),
      // 'cardNumber': cardNumber,
      // 'expMonth': expiryMonth,
      // 'expYear': expiryYear,
      // 'cvc': cvv,
    };
  }
}
