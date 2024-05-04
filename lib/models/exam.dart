import 'package:flutter/material.dart';

class Exam {
  const Exam({
    required this.id,
    required this.name,
    required this.startDate,
    required this.startTime,
    required this.room,
  });

  final int id;
  final String name;
  final DateTime startDate;
  final TimeOfDay startTime;
  final String room;
}
