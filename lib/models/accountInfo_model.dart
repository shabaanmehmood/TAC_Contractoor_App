class AccountInfo {
  String? id;
  String? fullName;
  String? phoneNumber;
  String? designation;
  String? alternatePhoneNumber;
  String? workExperience;

  AccountInfo({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.designation,
    this.alternatePhoneNumber,
    this.workExperience,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) => AccountInfo(
    id: json['id'],
    fullName: json['fullName'],
    phoneNumber: json['phoneNumber'],
    designation: json['designation'],
    alternatePhoneNumber: json['alternatePhoneNumber'],
    workExperience: json['workExperience'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'designation': designation,
    'alternatePhoneNumber': alternatePhoneNumber,
    'workExperience': workExperience,
  };
}
