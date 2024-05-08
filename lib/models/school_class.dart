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
}
