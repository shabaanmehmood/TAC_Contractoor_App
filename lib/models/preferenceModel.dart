import 'package:taccontractor/models/requiredLicenseModel.dart';
import 'package:taccontractor/models/required_skills.dart';

class Preferences {
  final int? minYearsExperience;
  final int? maxYearsExperience;
  final String appearanceRequirements;

  Preferences({
    this.minYearsExperience,
    this.maxYearsExperience,
    required this.appearanceRequirements,
  });

  Map<String, dynamic> toJson() {
    return {
      if (minYearsExperience != null) 'minYearsExperience': minYearsExperience,
      if (maxYearsExperience != null) 'maxYearsExperience': maxYearsExperience,
      'appearanceRequirements': appearanceRequirements,
    };
  }
}
