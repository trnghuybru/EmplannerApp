import 'package:flutter/material.dart';

class SchoolClass {
  const SchoolClass({
    required this.id,
    required this.room,
    this.date,
    this.dayOfWeek,
    required this.startTime,
    this.endTime,
  });

  final int id;
  final String room;
  final DateTime? date;
  final String? dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay? endTime;

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'],
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
      'id': id,
      'room': room,
      'date': date?.toIso8601String(),
      'dayOfWeek': dayOfWeek,
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': endTime != null
          ? {'hour': endTime!.hour, 'minute': endTime!.minute}
          : null,
    };
  }
}
