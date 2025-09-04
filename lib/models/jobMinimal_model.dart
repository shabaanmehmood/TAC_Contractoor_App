class JobMinimal {
  final String jobId;
  final String jobTitle;
  final List<String> shiftIds;

  JobMinimal({
    required this.jobId,
    required this.jobTitle,
    required this.shiftIds,
  });

  factory JobMinimal.fromJson(Map<String, dynamic> json) {
    final shifts = (json['shifts'] as List? ?? [])
        .map((e) => e['id'] as String)
        .toList();
    return JobMinimal(
      jobId: json['jobId'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      shiftIds: shifts,
    );
  }

  static List<JobMinimal> fromApiResponse(Map<String, dynamic> json) {
    final jobs = json['data']['data'] as List;
    return jobs.map((e) => JobMinimal.fromJson(e)).toList();
  }
}