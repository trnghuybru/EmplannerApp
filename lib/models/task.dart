class Task {
  int id;
  String taskName;
  String? description;
  DateTime? endDate;
  int status;
  String type;
  int? examId;
  int courseId;
  String courseName;
  String colorCode;
  String semesterName;
  DateTime semesterStartDate;
  DateTime semesterEndDate;
  DateTime schoolYearsStartDate;
  DateTime schoolYearsEndDate;

  Task({
    required this.id,
    required this.taskName,
    this.description,
    this.endDate,
    required this.status,
    required this.type,
    this.examId,
    required this.courseId,
    required this.courseName,
    required this.colorCode,
    required this.semesterName,
    required this.semesterStartDate,
    required this.semesterEndDate,
    required this.schoolYearsStartDate,
    required this.schoolYearsEndDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      taskName: json['task_name'],
      description: json['description'],
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
      type: json['type'],
      courseId: json['course_id'],
      courseName: json['course_name'],
      colorCode: json['color_code'],
      semesterName: json['semester_name'],
      semesterStartDate: DateTime.parse(json['semester_start_date']),
      semesterEndDate: DateTime.parse(json['semester_end_date']),
      schoolYearsStartDate: DateTime.parse(json['school_years_start_date']),
      schoolYearsEndDate: DateTime.parse(json['school_years_end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_name': taskName,
      'description': description,
      'end_date': endDate!.toIso8601String(),
      'status': status,
      'type': type,
      'course_id': courseId,
      'course_name': courseName,
      'color_code': colorCode,
      'semester_name': semesterName,
      'semester_start_date': semesterStartDate.toIso8601String(),
      'semester_end_date': semesterEndDate.toIso8601String(),
      'school_years_start_date': schoolYearsStartDate.toIso8601String(),
      'school_years_end_date': schoolYearsEndDate.toIso8601String(),
    };
  }
}
