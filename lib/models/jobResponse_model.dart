import 'job_model.dart';

class NearbyJobsResponse {
  final String message;
  final int status;
  final List<JobData> data;

  NearbyJobsResponse({
    required this.message,
    required this.status,
    required this.data,
  });

  factory NearbyJobsResponse.fromJson(Map<String, dynamic> json) {
    return NearbyJobsResponse(
      message: json['message'],
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => JobData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
