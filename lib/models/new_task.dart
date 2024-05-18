class NewTask {
  final int? id;
  final int courseId;
  final String name;
  final String? description;
  final DateTime? startDate;
  final DateTime endDate;
  final String type;
  final String? examId;
  final int? status;

  const NewTask({
    this.id,
    required this.courseId,
    required this.name,
    this.description,
    this.startDate,
    required this.endDate,
    required this.type,
    this.examId,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_id': courseId,
      'name': name,
      'description': description,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
      'type': type,
      'exam_id': examId,
      'status': status
    };
  }
}
