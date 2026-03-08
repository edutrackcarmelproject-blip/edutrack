import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  static Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  static Future<List<dynamic>> getAnnouncements() async {
    final response = await http.get(_uri('/api/student/announcements'));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch announcements');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return decoded['data'] as List<dynamic>;
    }
    return decoded as List<dynamic>;
  }

  static Future<bool> addAnnouncement(
    String title,
    String message, {
    int? subjectId,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'message': message,
    };

    if (subjectId != null) {
      body['subject_id'] = subjectId;
    }

    final response = await http.post(
      _uri('/api/announcements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<List<dynamic>> getAssignments({
    String? semester,
    String? subject,
  }) async {
    final query = <String, String>{};
    String path = '/api/assignments';
    if (semester != null && subject != null) {
      path = '/api/assignments/filter';
      query['semester'] = semester;
      query['subject'] = subject;
    }

    final response = await http.get(_uri(path, query.isEmpty ? null : query));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch assignments');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return decoded['data'] as List<dynamic>;
    }
    return decoded as List<dynamic>;
  }

  static Future<bool> addAssignment({
    required String semester,
    required String subject,
    required String title,
    required String description,
    required String dueDate,
  }) async {
    final response = await http.post(
      _uri('/api/assignments/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'semester': semester,
        'subject': subject,
        'assignment_title': title,
        'description': description,
        'due_date': dueDate,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> submitAttendance({
    required String attendanceDate,
    required String semester,
    required String subject,
    required List<String> presentStudents,
    required List<String> absentStudents,
  }) async {
    final response = await http.post(
      _uri('/api/attendance'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'attendance_date': attendanceDate,
        'semester': semester,
        'subject': subject,
        'present_students': presentStudents,
        'absent_students': absentStudents,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> saveMarks({
    required String semester,
    required String subject,
    required List<Map<String, dynamic>> marksList,
  }) async {
    final response = await http.post(
      _uri('/api/marks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'semester': semester,
        'subject': subject,
        'marksList': marksList,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  static Future<bool> addTimetable({
    required String semester,
    required String subject,
    required String day,
    required String time,
  }) async {
    final response = await http.post(
      _uri('/api/timetable/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'semester': semester,
        'subject': subject,
        'day': day,
        'time': time,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }


  static Future<Map<String, dynamic>> getTeacherDashboard({
    required String semester,
    required String subject,
  }) async {
    final response = await http.get(_uri('/api/dashboard/teacher', {
      'semester': semester,
      'subject': subject,
    }));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch teacher dashboard');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getStudentDashboard({
    required String semester,
    required String subject,
    required String studentName,
  }) async {
    final response = await http.get(_uri('/api/dashboard/student', {
      'semester': semester,
      'subject': subject,
      'student_name': studentName,
    }));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch student dashboard');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
