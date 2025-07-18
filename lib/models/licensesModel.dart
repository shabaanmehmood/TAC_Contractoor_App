class License {
  final String licenseNumber;
  final String expiryDate;
  final String licenseDocumentPath;
  final String licenseType;

  License({
    required this.licenseNumber,
    required this.expiryDate,
    required this.licenseDocumentPath,
    required this.licenseType,
  });

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      licenseNumber: json['licenseNumber'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      licenseDocumentPath: json['licenseDocumentPath'] ?? '',
      licenseType: json['licenseType'] ?? '',
    );
  }
}
