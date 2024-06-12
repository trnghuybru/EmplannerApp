class Semester {
  const Semester({
    required this.id,
    this.schoolYearId,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final int? schoolYearId;
  final String name;
  final DateTime startDate;
  final DateTime endDate;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_year_id': schoolYearId,
      'name': name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'],
      schoolYearId: json['school_year_id'],
      name: json['name'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }
}
