import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherAnnouncements extends StatefulWidget {
  const TeacherAnnouncements({super.key});

  @override
  State<TeacherAnnouncements> createState() => _TeacherAnnouncementsState();
}

class _TeacherAnnouncementsState extends State<TeacherAnnouncements> {
  static const Color primaryColor = Color(0xFF1F3C88);

  final titleController = TextEditingController();
  final messageController = TextEditingController();

  Future<void> postAnnouncement() async {
    if (titleController.text.isEmpty ||
        messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/api/announcement/add"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "announcement_title": titleController.text,
          "message": messageController.text,
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Announcement posted successfully")),
        );

        titleController.clear();
        messageController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to post announcement")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server connection error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Announcements"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Announcement Title",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Message",
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: postAnnouncement,
              child: const Text("Post Announcement"),
            ),
          ],
        ),
      ),
    );
  }
}