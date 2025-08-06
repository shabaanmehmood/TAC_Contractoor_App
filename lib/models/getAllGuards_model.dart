class UsersResponse {
  final String? message;
  final int? status;
  final List<User>? data;

  UsersResponse({
    this.message,
    this.status,
    this.data,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
    message: json['message'] as String?,
    status: json['status'] as int?,
    data: json['data'] != null
        ? List<User>.from(json['data'].map((x) => User.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
    "data": data?.map((x) => x.toJson()).toList(),
  };
}

class User {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? postalAddress;
  final String? postalCode;
  final String? level;
  final String? professionalBadge;
  final String? masterSecurityLicense;
  final String? password;
  final String? role;
  final String? dob;
  final String? token;
  final bool? isVerified;
  final String? fcmToken;
  final String? gender;
  final String? appleId;
  final bool? isActive;
  final bool? isDeleted;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final List<ProfileImage>? profileImages;
  final PersonalDetails? personalDetails;
  final List<Document>? documents;

  User({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.postalAddress,
    this.postalCode,
    this.level,
    this.professionalBadge,
    this.masterSecurityLicense,
    this.password,
    this.role,
    this.dob,
    this.token,
    this.isVerified,
    this.fcmToken,
    this.gender,
    this.appleId,
    this.isActive,
    this.isDeleted,
    this.createdDate,
    this.updatedDate,
    this.profileImages,
    this.personalDetails,
    this.documents,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String?,
    fullName: json['fullName'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    postalAddress: json['postalAddress'] as String?,
    postalCode: json['postalCode'] as String?,
    level: json['level'] as String?,
    professionalBadge: json['professionalBadge'] as String?,
    masterSecurityLicense: json['masterSecurityLicense'] as String?,
    password: json['password'] as String?,
    role: json['role'] as String?,
    dob: json['dob'] as String?,
    token: json['token'] as String?,
    isVerified: json['isVerified'] as bool?,
    fcmToken: json['fcmToken'] as String?,
    gender: json['gender'] as String?,
    appleId: json['appleId'] as String?,
    isActive: json['isActive'] as bool?,
    isDeleted: json['isDeleted'] as bool?,
    createdDate: json['createdDate'] != null
        ? DateTime.parse(json['createdDate'])
        : null,
    updatedDate: json['updatedDate'] != null
        ? DateTime.parse(json['updatedDate'])
        : null,
    profileImages: json['profileImages'] != null
        ? List<ProfileImage>.from(
        json['profileImages'].map((x) => ProfileImage.fromJson(x)))
        : [],
    personalDetails: json['personalDetails'] != null
        ? PersonalDetails.fromJson(json['personalDetails'])
        : null,
    documents: json['documents'] != null
        ? List<Document>.from(
        json['documents'].map((x) => Document.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "phone": phone,
    "postalAddress": postalAddress,
    "postalCode": postalCode,
    "level": level,
    "professionalBadge": professionalBadge,
    "masterSecurityLicense": masterSecurityLicense,
    "password": password,
    "role": role,
    "dob": dob,
    "token": token,
    "isVerified": isVerified,
    "fcmToken": fcmToken,
    "gender": gender,
    "appleId": appleId,
    "isActive": isActive,
    "isDeleted": isDeleted,
    "createdDate": createdDate?.toIso8601String(),
    "updatedDate": updatedDate?.toIso8601String(),
    "profileImages": profileImages?.map((x) => x.toJson()).toList(),
    "personalDetails": personalDetails?.toJson(),
    "documents": documents?.map((x) => x.toJson()).toList(),
  };
}

class ProfileImage {
  final String? id;
  final String? imageUrl;
  final bool? isMain;
  final DateTime? createdDate;

  ProfileImage({
    this.id,
    this.imageUrl,
    this.isMain,
    this.createdDate,
  });

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
    id: json['id'] as String?,
    imageUrl: json['imageUrl'] as String?,
    isMain: json['isMain'] as bool?,
    createdDate: json['createdDate'] != null
        ? DateTime.parse(json['createdDate'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "imageUrl": imageUrl,
    "isMain": isMain,
    "createdDate": createdDate?.toIso8601String(),
  };
}

class PersonalDetails {
  final int? id;
  final int? yearsOfExperience;
  final String? licenseNumber;
  final String? licenseExpiryDate;
  final String? abn;
  final List<String>? preferredLocationAddresses;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final User? user; // Nested user within personalDetails

  PersonalDetails({
    this.id,
    this.yearsOfExperience,
    this.licenseNumber,
    this.licenseExpiryDate,
    this.abn,
    this.preferredLocationAddresses,
    this.createdDate,
    this.updatedDate,
    this.user,
  });

  factory PersonalDetails.fromJson(Map<String, dynamic> json) => PersonalDetails(
    id: json['id'] as int?,
    yearsOfExperience: json['yearsOfExperience'] as int?,
    licenseNumber: json['licenseNumber'] as String?,
    licenseExpiryDate: json['licenseExpiryDate'] as String?,
    abn: json['abn'] as String?,
    preferredLocationAddresses: json['preferredLocationAddresses'] != null
        ? List<String>.from(json['preferredLocationAddresses'])
        : [],
    createdDate: json['createdDate'] != null
        ? DateTime.parse(json['createdDate'])
        : null,
    updatedDate: json['updatedDate'] != null
        ? DateTime.parse(json['updatedDate'])
        : null,
    user: json['user'] != null ? User.fromJson(json['user']) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "yearsOfExperience": yearsOfExperience,
    "licenseNumber": licenseNumber,
    "licenseExpiryDate": licenseExpiryDate,
    "abn": abn,
    "preferredLocationAddresses": preferredLocationAddresses,
    "createdDate": createdDate?.toIso8601String(),
    "updatedDate": updatedDate?.toIso8601String(),
    "user": user?.toJson(),
  };
}

class Document {
  final String? id;
  final String? type;
  final String? fileUrl;
  final String? originalFileName;
  final String? documentNumber;
  final String? expiryDate;
  final bool? isVerified;
  final DateTime? createdDate;
  final DateTime? updatedDate;

  Document({
    this.id,
    this.type,
    this.fileUrl,
    this.originalFileName,
    this.documentNumber,
    this.expiryDate,
    this.isVerified,
    this.createdDate,
    this.updatedDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json['id'] as String?,
    type: json['type'] as String?,
    fileUrl: json['fileUrl'] as String?,
    originalFileName: json['originalFileName'] as String?,
    documentNumber: json['documentNumber'] as String?,
    expiryDate: json['expiryDate'] as String?,
    isVerified: json['isVerified'] as bool?,
    createdDate: json['createdDate'] != null
        ? DateTime.parse(json['createdDate'])
        : null,
    updatedDate: json['updatedDate'] != null
        ? DateTime.parse(json['updatedDate'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "fileUrl": fileUrl,
    "originalFileName": originalFileName,
    "documentNumber": documentNumber,
    "expiryDate": expiryDate,
    "isVerified": isVerified,
    "createdDate": createdDate?.toIso8601String(),
    "updatedDate": updatedDate?.toIso8601String(),
  };
}
