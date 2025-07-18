class ApplicationStatus {
  final String status;
  final String? reason;

  ApplicationStatus({
    required this.status,
    this.reason,
  });

  factory ApplicationStatus.fromJson(Map<String, dynamic> json) {
    return ApplicationStatus(
      status: json['status'] ?? '',
      reason: json['reason'],
    );
  }
}
