import 'dart:convert';

class Shift {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final List<String> days;
  final String timePeriod;

  Shift({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.days,
    required this.timePeriod,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    // Defensive parsing for days, which may be a JSON string
    List<String> parsedDays = [];
    if (json['days'] is String) {
      try {
        parsedDays = List<String>.from(jsonDecode(json['days']));
      } catch (_) {
        parsedDays = [];
      }
    } else if (json['days'] is List) {
      parsedDays = List<String>.from(json['days']);
    }
    return Shift(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      days: parsedDays,
      timePeriod: json['timePeriod'] ?? '',
    );
  }
}
