import 'package:taccontractor/models/requiredLicenseModel.dart';
import 'package:taccontractor/models/required_skills.dart';

class Preferences {
  final List<RequiredLicense> requiredLicenses;
  final List<SkillModel> requiredSkills;
  final int minYearsExperience;
  final int maxYearsExperience;
  final String appearanceRequirements;

  Preferences({
    required this.requiredLicenses,
    required this.requiredSkills,
    required this.minYearsExperience,
    required this.maxYearsExperience,
    required this.appearanceRequirements,
  });

  Map<String, dynamic> toJson() {
    return {
      'requiredLicenses': requiredLicenses
          .map((license) => {'id': license.id, 'name': license.name})
          .toList(),
      'requiredSkills': requiredLicenses
          .map((skill) => {'id': skill.id, 'name': skill.name})
          .toList(),
      'minYearsExperience': minYearsExperience,
      'maxYearsExperience': maxYearsExperience,
      'appearanceRequirements': appearanceRequirements,
    };
  }
}
