class NewTask {
  final int? id;
  final int courseId;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String? examId;

  const NewTask({
    this.id,
    required this.courseId,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.examId,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'type': type,
      'exam_id': examId,
    };
  }
}
