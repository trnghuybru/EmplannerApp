class Semester {
  const Semester({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
}
