import 'dart:convert';

class Shift {
  String? id;
  final String date;
  final List<String> days;
  String? timePeriod;
  final String startTime;
  final String endTime;
  final bool? isOvernight;

  Shift({
    this.id,
    required this.date,
    required this.days,
    this.timePeriod,
    required this.startTime,
    required this.endTime,
    this.isOvernight,
  });

  @override
  String toString() {
    return 'Shift(id: $id, date: $date, days: $days, startTime: $startTime, endTime: $endTime)';
  }

  factory Shift.fromJson(Map<String, dynamic> json) {
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
      id: json['id'],
      date: json['date'],
      days: parsedDays,
      timePeriod: json['timePeriod'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isOvernight: json['isOvernight'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'days': days,
      'timePeriod': timePeriod,
      'startTime': startTime,
      'endTime': endTime,
      'isOvernight': isOvernight ?? false,
    };
  }
}
