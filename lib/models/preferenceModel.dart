import 'package:taccontractor/models/requiredLicenseModel.dart';
import 'package:taccontractor/models/required_skills.dart';

class Preferences {
  final int minYearsExperience;
  final int maxYearsExperience;
  final String appearanceRequirements;

  Preferences({
    required this.minYearsExperience,
    required this.maxYearsExperience,
    required this.appearanceRequirements,
  });

  Map<String, dynamic> toJson() {
    return {
      'minYearsExperience': minYearsExperience,
      'maxYearsExperience': maxYearsExperience,
      'appearanceRequirements': appearanceRequirements,
    };
  }
}
