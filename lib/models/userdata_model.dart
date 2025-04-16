import 'package:tac/models/profileImages_model.dart';

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
  String? fullName;
  String? email;
  String? phone;
  String? postalAddress;
  String? masterSecurityLicense;
  String? password;
  String? role;
  String? dob;
  Null? token;
  bool? isVerified;
  String? fcmToken;
  String? gender;
  bool? isActive;
  bool? isDeleted;
  String? createdDate;
  String? updatedDate;
  List<ProfileImages>? profileImages;
  Null? personalDetails;

  Data(
      {this.id,
        this.fullName,
        this.email,
        this.phone,
        this.postalAddress,
        this.masterSecurityLicense,
        this.password,
        this.role,
        this.dob,
        this.token,
        this.isVerified,
        this.fcmToken,
        this.gender,
        this.isActive,
        this.isDeleted,
        this.createdDate,
        this.updatedDate,
        this.profileImages,
        this.personalDetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    postalAddress = json['postalAddress'];
    masterSecurityLicense = json['masterSecurityLicense'];
    password = json['password'];
    role = json['role'];
    dob = json['dob'];
    token = json['token'];
    isVerified = json['isVerified'];
    fcmToken = json['fcmToken'];
    gender = json['gender'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    if (json['profileImages'] != null) {
      profileImages = <ProfileImages>[];
      json['profileImages'].forEach((v) {
        profileImages!.add(new ProfileImages.fromJson(v));
      });
    }
    personalDetails = json['personalDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['postalAddress'] = this.postalAddress;
    data['masterSecurityLicense'] = this.masterSecurityLicense;
    data['password'] = this.password;
    data['role'] = this.role;
    data['dob'] = this.dob;
    data['token'] = this.token;
    data['isVerified'] = this.isVerified;
    data['fcmToken'] = this.fcmToken;
    data['gender'] = this.gender;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    if (this.profileImages != null) {
      data['profileImages'] =
          this.profileImages!.map((v) => v.toJson()).toList();
    }
    data['personalDetails'] = this.personalDetails;
    return data;
  }
}
