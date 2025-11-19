// Add this model for guard locations response
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taccontractor/dataproviders/api_service.dart';

class GuardLocationResponse {
  final String message;
  final int status;
  final List<GuardLocationData> data;

  GuardLocationResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory GuardLocationResponse.fromJson(Map<String, dynamic> json) {
    return GuardLocationResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => GuardLocationData.fromJson(item))
              .toList()
          : [],
    );
  }
}

class GuardLocationData {
  final GuardInfo guard;
  final GuardLocation location;
  final JobInfo job;
  final ContractorInfo contractor;
  final ShiftInfo shift;

  GuardLocationData({
    required this.guard,
    required this.location,
    required this.job,
    required this.contractor,
    required this.shift,
  });

  factory GuardLocationData.fromJson(Map<String, dynamic> json) {
    return GuardLocationData(
      guard: GuardInfo.fromJson(json['guard']),
      location: GuardLocation.fromJson(json['location']),
      job: JobInfo.fromJson(json['job']),
      contractor: ContractorInfo.fromJson(json['contractor']),
      shift: ShiftInfo.fromJson(json['shift']),
    );
  }
}

class GuardInfo {
  final String id;
  final String name;
  final String email;
  final List<String> images;
  final String rating;
  final String level;

  GuardInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.images,
    required this.rating,
    required this.level,
  });

  factory GuardInfo.fromJson(Map<String, dynamic> json) {
    return GuardInfo(
      id: json['id'] ?? '',

      name: json['name'] ?? '',
      email: json['email'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      rating: json['rating']?.toString() ?? '', // <-- FIXED HERE
      level: json['level']?.toString() ?? '',
    );
  }

  String get profileImageUrl {
    if (images.isEmpty) return 'assets/userpicture.jpg';
    final imagePath = images.first;
    if (imagePath.startsWith('http')) return imagePath;
    return '${MyApIService.imageBaseUrlMap}$imagePath';
  }
}

class GuardLocation {
  final String latitude;
  final String longitude;
  final DateTime updatedAt;

  GuardLocation({
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory GuardLocation.fromJson(Map<String, dynamic> json) {
    return GuardLocation(
      latitude: json['latitude'] ?? '0.0',
      longitude: json['longitude'] ?? '0.0',
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  LatLng get latLng => LatLng(
        double.tryParse(latitude) ?? 0.0,
        double.tryParse(longitude) ?? 0.0,
      );
}

class JobInfo {
  final String id;
  final String title;
  final String description;

  JobInfo({
    required this.id,
    required this.title,
    required this.description,
  });

  factory JobInfo.fromJson(Map<String, dynamic> json) {
    return JobInfo(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ContractorInfo {
  final String id;
  final String name;
  final String email;
  final List<String> images;

  ContractorInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.images,
  });

  factory ContractorInfo.fromJson(Map<String, dynamic> json) {
    return ContractorInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}

class ShiftInfo {
  final String id;
  final String startTime;
  final String endTime;

  ShiftInfo({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  factory ShiftInfo.fromJson(Map<String, dynamic> json) {
    return ShiftInfo(
      id: json['id'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }

  String get formattedTiming {
    return '$startTime - $endTime';
  }
}
