import 'package:flutter/material.dart';

class SchoolClass {
  const SchoolClass({
    required this.room,
    this.date,
    this.dayOfWeek,
    required this.startTime,
    this.endTime,
  });

  final String room;
  final DateTime? date;
  final String? dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      room: json['room'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      dayOfWeek: json['dayOfWeek'],
      startTime: TimeOfDay(
        hour: json['startTime']['hour'],
        minute: json['startTime']['minute'],
      ),
      endTime: json['endTime'] != null
          ? TimeOfDay(
              hour: json['endTime']['hour'],
              minute: json['endTime']['minute'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room': room,
      'date': date?.toIso8601String().split('T')[0],
      'dayOfWeek': dayOfWeek,
      'startTime': "${startTime.hour},${startTime.minute}",
      'endTime': endTime != null ? "${endTime!.hour}:${endTime!.minute}" : null,
    };
  }
}
