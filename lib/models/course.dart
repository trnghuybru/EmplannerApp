class Course {
  const Course({
    this.id,
    this.semesterId,
    required this.name,
    this.colorCode,
    this.teacher,
    this.startDate,
    this.endDate,
  });

  final int? id;
  final int? semesterId;
  final String name;
  final String? colorCode;
  final String? teacher;
  final DateTime? startDate;
  final DateTime? endDate;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        semesterId: json['semester_id'],
        name: json['name'],
        colorCode: json['color_code'],
        teacher: json['teacher'],
        startDate: json['start_date'] != null
            ? DateTime.parse(json['start_date'])
            : null,
        endDate:
            json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'semester_id': semesterId,
        'name': name,
        'color_code': colorCode,
        'teacher': teacher,
        'start_date': startDate!.toIso8601String().split('T')[0],
        'end_date': endDate!.toIso8601String().split('T')[0],
      };

  Course copyWith({
    int? id,
    int? semesterId,
    String? name,
    String? colorCode,
    String? teacher,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Course(
      id: id ?? this.id,
      semesterId: semesterId ?? this.semesterId,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      teacher: teacher ?? this.teacher,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
