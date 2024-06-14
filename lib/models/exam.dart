import 'package:emplanner/models/course.dart';
import 'package:emplanner/models/school_year.dart';
import 'package:emplanner/models/semester.dart';
import 'package:emplanner/models/task.dart';

class Exam {
  final int? id;
  final String name;
  final DateTime startDate;
  final String startTime;
  final int duration;
  final String room;
  final Course? course;
  final Semester? semester;
  final SchoolYear? schoolYear;
  final List<Task>? tasks;

  Exam({
    this.id,
    required this.name,
    required this.startDate,
    required this.startTime,
    required this.duration,
    required this.room,
    this.course,
    this.semester,
    this.schoolYear,
    this.tasks,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      name: json['name'],
      startDate: DateTime.parse(json['start_date']),
      startTime: json['start_time'],
      duration: json['duration'],
      room: json['room'],
      course: Course.fromJson(json['course']),
      semester: Semester.fromJson(json['semester']),
      schoolYear: SchoolYear.fromJson(json['school_year']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'duration': duration,
      'room': room,
      'course': course?.toJson(),
      'semester': semester?.toJson(),
      'school_year': schoolYear?.toJson(),
    };
  }
}
