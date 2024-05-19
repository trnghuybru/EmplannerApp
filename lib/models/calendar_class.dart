class CalendarClass {
  final int id;
  final int courseId;
  final String room;
  final String date;
  final String? dayOfWeek;
  final String startTime;
  final String endTime;
  final String courseName;
  final String teacher;
  final String colorCode;

  CalendarClass({
    required this.id,
    required this.courseId,
    required this.room,
    required this.date,
    this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.courseName,
    required this.teacher,
    required this.colorCode,
  });

  factory CalendarClass.fromJson(Map<String, dynamic> json) {
    return CalendarClass(
      id: json['id'],
      courseId: json['course_id'],
      room: json['room'],
      date: json['date'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      courseName: json['course_name'],
      teacher: json['teacher'],
      colorCode: json['color_code'],
    );
  }
}
