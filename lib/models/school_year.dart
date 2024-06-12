class SchoolYear {
  const SchoolYear({
    this.id,
    required this.startDate,
    required this.endDate,
  });

  final int? id;
  final DateTime startDate;
  final DateTime endDate;

  factory SchoolYear.fromJson(Map<String, dynamic> json) {
    return SchoolYear(
      id: json['id'] as int,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
