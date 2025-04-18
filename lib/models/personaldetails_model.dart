class PersonalDetails {
  int? id;
  int? yearsOfExperience;
  String? licenseNumber;
  String? abn;
  List<String>? preferredLocationAddresses;
  String? createdDate;
  String? updatedDate;

  PersonalDetails({
    this.id,
    this.yearsOfExperience,
    this.licenseNumber,
    this.abn,
    this.preferredLocationAddresses,
    this.createdDate,
    this.updatedDate,
  });

  PersonalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yearsOfExperience = json['yearsOfExperience'];
    licenseNumber = json['licenseNumber'];
    abn = json['abn'];
    preferredLocationAddresses = json['preferredLocationAddresses'] != null
        ? List<String>.from(json['preferredLocationAddresses'])
        : null;
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['yearsOfExperience'] = yearsOfExperience;
    data['licenseNumber'] = licenseNumber;
    data['abn'] = abn;
    data['preferredLocationAddresses'] = preferredLocationAddresses;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    return data;
  }
}
