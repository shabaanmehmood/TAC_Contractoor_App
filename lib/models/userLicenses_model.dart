import '../modules/account/components/License/license_type.dart';

class UserLicenses {
  String? id;
  String? licenseNumber;
  String? expiryDate;
  String? licenseDocumentPath;
  String? createdAt;
  LicenseType? licenseType;

  UserLicenses({
    this.id,
    this.licenseNumber,
    this.expiryDate,
    this.licenseDocumentPath,
    this.createdAt,
    this.licenseType,
  });

  UserLicenses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    licenseNumber = json['licenseNumber'];
    expiryDate = json['expiryDate'];
    licenseDocumentPath = json['licenseDocumentPath'];
    createdAt = json['createdAt'];
    licenseType = json['licenseType'] != null
        ? LicenseType.fromJson(json['licenseType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['licenseNumber'] = licenseNumber;
    data['expiryDate'] = expiryDate;
    data['licenseDocumentPath'] = licenseDocumentPath;
    data['createdAt'] = createdAt;
    if (licenseType != null) {
      data['licenseType'] = licenseType!.toJson();
    }
    return data;
  }
}
