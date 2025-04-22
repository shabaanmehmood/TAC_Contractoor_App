import 'dart:convert';

import 'package:tac/models/profileImages_model.dart';

class UserUpdateModel {
  String? fullName;
  String? email;
  String? phone;
  String? postalAddress;
  String? masterSecurityLicense;
  String? password;
  String? role;
  String? dob;
  String? gender;
  String? fcmToken;
  String? appleId;
  int? yearsOfExperience;
  String? licenseNumber;
  String? abn;
  List<String>? preferredLocationAddresses;
  List<ProfileImages>? profileImages; // 👈 Add this line

  UserUpdateModel({
    this.fullName,
    this.email,
    this.phone,
    this.postalAddress,
    this.masterSecurityLicense,
    this.password,
    this.role,
    this.dob,
    this.gender,
    this.fcmToken,
    this.appleId,
    this.yearsOfExperience,
    this.licenseNumber,
    this.abn,
    this.preferredLocationAddresses,
    this.profileImages, // 👈 Add this too
  });

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (postalAddress != null) 'postalAddress': postalAddress,
      if (masterSecurityLicense != null) 'masterSecurityLicense': masterSecurityLicense,
      if (password != null) 'password': password,
      if (role != null) 'role': role,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
      if (fcmToken != null) 'fcmToken': fcmToken,
      if (appleId != null) 'appleId': appleId,
      if (yearsOfExperience != null)
        'personalDetails': {
          'yearsOfExperience': yearsOfExperience,
          if (licenseNumber != null) 'licenseNumber': licenseNumber,
          if (abn != null) 'abn': abn,
          if (preferredLocationAddresses != null)
            'preferredLocationAddresses': preferredLocationAddresses,
        },
      if (profileImages != null)
        'profileImages': profileImages!.map((img) => img.toJson()).toList(), // 👈 Added line
    };
  }
}
