import 'package:taccontractor/models/personaldetails_model.dart';
import 'package:taccontractor/models/profileImages_model.dart';
import 'package:taccontractor/models/userLicenses_model.dart';

import 'accountInfo_model.dart';
import 'bankDetails_model.dart';
import 'documents_model.dart';

class UserDataModel {
  String? message;
  Data? data;
  int? status;

  UserDataModel({this.message, this.data, this.status});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['status'] = status;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  String? email;
  String? password;
  String? role;
  String? dob;
  String? token;
  bool? isVerified;
  bool? isActive;
  String? phone;
  String? gender;
  String? appleId;
  String? fcmToken;
  bool? isDeleted;
  String? registeringAs;
  String? postalAddress;
  String? postalCode;
  String? masterSecurityLicense;
  String? australianBusinessNumber;
  String? australianCompanyNumber;
  String? createdAt;  // Changed from createdDate
  String? updatedAt;  // Changed from updatedDate
  AccountInfo? accountInfo;
  List<PersonalDetails>? personalDetails;  // Changed from single object to list
  List<ProfileImages>? profileImages;
  List<Documents>? documents;
  List<BankDetails>? bankDetails;
  List<UserLicenses>? userLicenses;

  Data({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.dob,
    this.token,
    this.isVerified,
    this.phone,
    this.gender,
    this.appleId,
    this.isActive,
    this.fcmToken,
    this.isDeleted,
    this.postalAddress,
    this.postalCode,
    this.registeringAs,
    this.masterSecurityLicense,
    this.australianBusinessNumber,
    this.australianCompanyNumber,
    this.createdAt,
    this.updatedAt,
    this.accountInfo,
    this.personalDetails,
    this.profileImages,
    this.documents,
    this.bankDetails,
    this.userLicenses,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    postalAddress = json['postalAddress'];
    postalCode = json['postalCode'];
    masterSecurityLicense = json['masterSecurityLicense'];
    password = json['password'];
    role = json['role'];
    dob = json['dob'];
    token = json['token'];
    isVerified = json['isVerified'];
    fcmToken = json['fcmToken'];
    gender = json['gender'];
    registeringAs = json['registeringAs'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];  // Corrected field name
    updatedAt = json['updatedAt'];  // Corrected field name
    appleId = json['appleId'];
    australianBusinessNumber = json['australianBusinessNumber'];
    australianCompanyNumber = json['australianCompanyNumber'];
    accountInfo = json['accountInfo'] != null
        ? AccountInfo.fromJson(json['accountInfo'])
        : null;

    if (json['profileImages'] != null) {
      profileImages = <ProfileImages>[];
      json['profileImages'].forEach((v) {
        profileImages!.add(ProfileImages.fromJson(v));
      });
    }

    if (json['personalDetails'] != null) {
      personalDetails = <PersonalDetails>[];
      json['personalDetails'].forEach((v) {
        personalDetails!.add(PersonalDetails.fromJson(v));
      });
    }

    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    if (json['bankDetails'] != null) {
      bankDetails = <BankDetails>[];
      json['bankDetails'].forEach((v) {
        bankDetails!.add(BankDetails.fromJson(v));
      });
    }
    if (json['userLicenses'] != null) {
      userLicenses = <UserLicenses>[];
      json['userLicenses'].forEach((v) {
        userLicenses!.add(UserLicenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;  // Changed from fullName to name
    data['email'] = email;
    data['phone'] = phone;
    data['postalAddress'] = postalAddress;
    data['postalCode'] = postalCode;
    data['masterSecurityLicense'] = masterSecurityLicense;
    data['password'] = password;
    data['role'] = role;
    data['dob'] = dob;
    data['token'] = token;
    data['isVerified'] = isVerified;
    data['fcmToken'] = fcmToken;
    data['registeringAs'] = registeringAs;
    data['gender'] = gender;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;  // Corrected field name
    data['updatedAt'] = updatedAt;  // Corrected field name
    data['appleId'] = appleId;

    if (profileImages != null) {
      data['profileImages'] = profileImages!.map((v) => v.toJson()).toList();
    }

    if (personalDetails != null) {
      data['personalDetails'] = personalDetails!.map((v) => v.toJson()).toList();
    }

    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }

    if (bankDetails != null) {
      data['bankDetails'] = bankDetails!.map((v) => v.toJson()).toList();
    }

    if (userLicenses != null) {
      data['userLicenses'] = userLicenses!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
