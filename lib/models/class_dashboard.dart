class ClassDashboard {
  final int id;
  final int courseId;
  final String room;
  final String date;
  final String? dayOfWeek;
  final String startTime;
  final String courseName;
  final String teacher;

  ClassDashboard({
    required this.id,
    required this.courseId,
    required this.room,
    required this.date,
    this.dayOfWeek,
    required this.startTime,
    required this.courseName,
    required this.teacher,
  });

  factory ClassDashboard.fromJson(Map<String, dynamic> json) {
    return ClassDashboard(
      id: json['id'],
      courseId: json['course_id'],
      room: json['room'],
      date: json['date'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      courseName: json['course_name'],
      teacher: json['teacher'],
    );
  }
}
