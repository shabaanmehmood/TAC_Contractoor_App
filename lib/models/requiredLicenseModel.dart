class RequiredLicense {
  final String id;
  final String name;
  final String? licenseBasicPic;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RequiredLicense({
    required this.id,
    required this.name,
    this.licenseBasicPic,
    this.createdAt,
    this.updatedAt,
  });

  factory RequiredLicense.fromJson(Map<String, dynamic> json) {
    return RequiredLicense(
      id: json['id'],
      name: json['name'],
      licenseBasicPic: json['licenseBasicPic'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'licenseBasicPic': licenseBasicPic,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
