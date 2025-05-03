class Shift {
  final String date;
  final List<String> days;
  final String startTime;
  final String endTime;

  Shift({
    required this.date,
    required this.days,
    required this.startTime,
    required this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      date: json['date'],
      days: List<String>.from(json['days']),
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'days': days,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
