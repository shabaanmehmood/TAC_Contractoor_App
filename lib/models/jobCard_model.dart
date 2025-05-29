import 'job_model.dart';

class JobCardModel {
  final String jobTitle;
  final String perHourRate;
  final String companyName;
  final String rating;
  final String hiringTag;
  final String jobType;
  final String location;
  final String? distance;
  final String day;
  final String shiftTime;
  final String requiredPersons;
  final String jobDept;
  final JobData? jobData;

  JobCardModel({
    required this.jobTitle,
    required this.perHourRate,
    required this.companyName,
    required this.rating,
    required this.hiringTag,
    required this.jobType,
    required this.location,
    this.distance,
    required this.day,
    required this.shiftTime,
    required this.requiredPersons,
    required this.jobDept,
    this.jobData,
  });
}