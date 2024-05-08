class ExamDashboard {
  final int id;
  final int courseId;
  final String name;
  final String startDate;
  final String startTime;
  final int duration;
  final String room;
  final String courseName;
  final String teacher;

  ExamDashboard({
    required this.id,
    required this.courseId,
    required this.name,
    required this.startDate,
    required this.startTime,
    required this.duration,
    required this.room,
    required this.courseName,
    required this.teacher,
  });

  factory ExamDashboard.fromJson(Map<String, dynamic> json) {
    return ExamDashboard(
      id: json['id'],
      courseId: json['course_id'],
      name: json['name'],
      startDate: json['start_date'],
      startTime: json['start_time'],
      duration: json['duration'],
      room: json['room'],
      courseName: json['course_name'],
      teacher: json['teacher'],
    );
  }
}
