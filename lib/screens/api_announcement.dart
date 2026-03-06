import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> addAnnouncement(String title, String message) async {
var baseUrl;
final response = await http.post(
Uri.parse('$baseUrl/api/announcement/add'),
headers: {'Content-Type': 'application/json'},
body: jsonEncode({
'announcement_title': title,
'message': message,
}),
);

return response.statusCode == 201;
}
