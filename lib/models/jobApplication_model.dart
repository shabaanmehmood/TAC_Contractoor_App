import 'package:taccontractor/models/applicationStatus_model.dart';
import 'package:taccontractor/models/jobDataForApplication_model.dart';

import 'guard_model.dart';
import 'jobModel.dart'; // As previously defined

class JobApplicationModel {
  final String applicationId;
  final DateTime appliedAt;
  final String statusId;
  final ApplicationStatus status;
  final Guard guard;
  final Job job;

  JobApplicationModel({
    required this.applicationId,
    required this.appliedAt,
    required this.statusId,
    required this.status,
    required this.guard,
    required this.job,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      applicationId: json['applicationId'] ?? '',
      appliedAt: DateTime.parse(json['appliedAt'] ?? DateTime.now().toIso8601String()),
      statusId: json['statusId'] ?? '',
      status: ApplicationStatus.fromJson(json['status'] ?? {}),
      guard: Guard.fromJson(json['guard'] ?? {}),
      job: Job.fromJson(json['job'] ?? {}),
    );
  }
}
