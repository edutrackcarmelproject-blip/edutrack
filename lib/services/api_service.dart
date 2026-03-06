import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> addAnnouncement(String title, String message) async {
  const String baseUrl = "http://10.0.2.2:5000";

  final response = await http.post(
    Uri.parse('$baseUrl/api/announcement/add'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'announcement_title': title,
      'message': message,
    }),
  );

  print("STATUS CODE: ${response.statusCode}");
  print("RESPONSE BODY: ${response.body}");

  return response.statusCode == 201;
}