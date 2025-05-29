import 'package:flutter/material.dart';

class ProfileModel {
  final String fullName;
  final String email;
  final String phone;
  final String dob;
  final String postcode;
  final String gender;
  final String address;

  final String licenceType;
  final String licenceNumber;
  final String classId;
  final String expiryDate;
  final String badge;
  final String level;
  final String experience;
  final String professionalAddress;
  final String abn;

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.postcode,
    required this.gender,
    required this.address,
    required this.licenceType,
    required this.licenceNumber,
    required this.classId,
    required this.expiryDate,
    required this.badge,
    required this.professionalAddress,
    required this.level,
    required this.experience,
    required this.abn,
  });
}

class ProfileDummyData {
  static ProfileModel getDummyProfile() {
    return ProfileModel(
        fullName: "John Smith",
        email: "john@email.com",
        phone: " +44 625 437 943",
        dob: "26 Aug 1995",
        postcode: "0672",
        gender: "Male",
        address: "4517 Washington Ave, Manchester, Kentucky 39495",
        licenceType: "Level 2 Licence",
        licenceNumber: "123456789 (Class MA)",
        classId: "4379",
        expiryDate: "01/09/2024",
        badge: "Leader",
        professionalAddress: "4517 Washington Ave, Manchester, Kentucky 39495",
        level: "2",
        experience: '5',
        abn: "12 345 67890");
  }
}
