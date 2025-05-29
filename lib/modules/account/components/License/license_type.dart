class LicenseType {
  String? id;
  String? name;
  String? licenseBasicPic;
  String? createdAt;
  String? updatedAt;

  LicenseType({
    this.id,
    this.name,
    this.licenseBasicPic,
    this.createdAt,
    this.updatedAt,
  });

  LicenseType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licenseBasicPic = json['licenseBasicPic'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['licenseBasicPic'] = licenseBasicPic;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
