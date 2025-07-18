import 'documentsModel.dart';
import 'licensesModel.dart';

class Guard {
  final String id;
  final String name;
  final String email;
  final String postalAddress;
  final String professionalBadge;
  final String masterSecurityLicense;
  final String gender;
  final List<Document> documents;
  final List<License> licenses;
  final List<String> profileImages;

  Guard({
    required this.id,
    required this.name,
    required this.email,
    required this.postalAddress,
    required this.professionalBadge,
    required this.masterSecurityLicense,
    required this.gender,
    required this.documents,
    required this.licenses,
    required this.profileImages,
  });

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      postalAddress: json['postalAddress'] ?? '',
      professionalBadge: json['professionalBadge'] ?? '',
      masterSecurityLicense: json['masterSecurityLicense'] ?? '',
      gender: json['gender'] ?? '',
      documents: (json['documents'] as List<dynamic>? ?? [])
          .map((e) => Document.fromJson(e))
          .toList(),
      licenses: (json['licenses'] as List<dynamic>? ?? [])
          .map((e) => License.fromJson(e))
          .toList(),
      profileImages: (json['profileImages'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
