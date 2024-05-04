class Task {
  const Task({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    this.endDate,
    required this.status,
  });

  final int id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool status;
}
