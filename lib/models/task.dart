class Task {
  int id;
  String? taskName;
  String? description;
  DateTime? endDate;
  int status;
  String? type;
  int? examId;
  int courseId;
  String courseName;
  String? colorCode;
  String? semesterName;
  DateTime? semesterStartDate;
  DateTime? semesterEndDate;
  DateTime? schoolYearsStartDate;
  DateTime? schoolYearsEndDate;
  String? name;

  Task({
    required this.id,
    this.taskName,
    this.description,
    this.endDate,
    required this.status,
    this.type,
    this.examId,
    required this.courseId,
    required this.courseName,
    this.colorCode,
    this.semesterName,
    this.semesterStartDate,
    this.semesterEndDate,
    this.schoolYearsStartDate,
    this.schoolYearsEndDate,
    this.name,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      taskName: json['task_name'],
      name: json['name'],
      description: json['description'],
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      status: json['status'],
      type: json['type'],
      examId: json['exam_id'],
      courseId: json['course_id'],
      courseName: json['course_name'],
      colorCode: json['color_code'],
      semesterName: json['semester_name'],
      semesterStartDate: json['semester_start_date'] != null
          ? DateTime.parse(json['semester_start_date'])
          : null,
      semesterEndDate: json['semester_end_date'] != null
          ? DateTime.parse(json['semester_end_date'])
          : null,
      schoolYearsStartDate: json['school_years_start_date'] != null
          ? DateTime.parse(json['school_years_start_date'])
          : null,
      schoolYearsEndDate: json['school_years_end_date'] != null
          ? DateTime.parse(json['school_years_end_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_name': taskName,
      'description': description,
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'type': type,
      'exam_id': examId,
      'course_id': courseId,
      'course_name': courseName,
      'color_code': colorCode,
      'semester_name': semesterName,
      'semester_start_date': semesterStartDate?.toIso8601String(),
      'semester_end_date': semesterEndDate?.toIso8601String(),
      'school_years_start_date': schoolYearsStartDate?.toIso8601String(),
      'school_years_end_date': schoolYearsEndDate?.toIso8601String(),
    };
  }
}
