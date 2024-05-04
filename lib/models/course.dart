class Course {
  const Course({
    required this.id,
    required this.name,
    this.colorCode,
    required this.teacher,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final String name;
  final String? colorCode;
  final String teacher;
  final DateTime startDate;
  final DateTime endDate;
}
