import 'dart:convert';

import 'package:http/http.dart' as http;

import '../auth_storage.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  static Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$baseUrl$path').replace(queryParameters: query);

  static Future<Map<String, String>> _jsonHeaders({bool auth = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (!auth) return headers;

    final token = await AuthStorage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static List<dynamic> _decodeListResponse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic> && decoded['data'] is List) {
      return decoded['data'] as List<dynamic>;
    }
    return decoded as List<dynamic>;
  }

  
  static Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await http.post(
      _uri('/api/auth/login'),
      headers: await _jsonHeaders(auth: false),
      body: jsonEncode({'email': usernameOrEmail, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Login failed');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final data = decoded['data'] as Map<String, dynamic>? ?? {};
    final token = data['token']?.toString();
    final user = data['user'] as Map<String, dynamic>? ?? {};
    final role = user['role']?.toString() ?? '';
    if (token != null && token.isNotEmpty && role.isNotEmpty) {
      await AuthStorage.saveAuth(token, role);
    }
    return decoded;
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http.post(
      _uri('/api/auth/change-password'),
      headers: await _jsonHeaders(),
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }
static Future<List<dynamic>> getAnnouncements() async {
    final response = await http.get(
      _uri('/api/student/announcements'),
      headers: await _jsonHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch announcements');
    }

    return _decodeListResponse(response.body);
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
      headers: await _jsonHeaders(),
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

    final response = await http.get(
      _uri(path, query.isEmpty ? null : query),
      headers: await _jsonHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch assignments');
    }

    return _decodeListResponse(response.body);
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
      headers: await _jsonHeaders(),
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
      headers: await _jsonHeaders(),
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
      headers: await _jsonHeaders(),
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
      headers: await _jsonHeaders(),
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
    final response = await http.get(
      _uri('/api/dashboard/teacher', {
        'semester': semester,
        'subject': subject,
      }),
      headers: await _jsonHeaders(),
    );

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
    final response = await http.get(
      _uri('/api/dashboard/student', {
        'semester': semester,
        'subject': subject,
        'student_name': studentName,
      }),
      headers: await _jsonHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch student dashboard');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
