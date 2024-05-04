import 'dart:convert';

import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

void _getClassExam() async {
  try {
    final url = Uri.http('10.0.2.2:8000', '/api/dashboard/get_classes_exams');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  } catch (e) {}
}

final classExamDashboardProvider = Provider((ref) {
  return;
});
