import 'package:flutter/material.dart';

import '../services/api_service.dart';

class TeacherAnnouncements extends StatefulWidget {
  const TeacherAnnouncements({super.key});

  @override
  State<TeacherAnnouncements> createState() => _TeacherAnnouncementsState();
}

class _TeacherAnnouncementsState extends State<TeacherAnnouncements> {
  static const Color primaryColor = Color(0xFF1F3C88);

  final titleController = TextEditingController();
  final messageController = TextEditingController();
  bool posting = false;

  Future<void> postAnnouncement() async {
    if (titleController.text.isEmpty || messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => posting = true);
    try {
      final ok = await ApiService.addAnnouncement(
        titleController.text.trim(),
        messageController.text.trim(),
      );

      if (ok) {
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
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server connection error")),
      );
    } finally {
      if (mounted) setState(() => posting = false);
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
              decoration: const InputDecoration(labelText: "Announcement Title"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Message"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: posting ? null : postAnnouncement,
              child: Text(posting ? "Posting..." : "Post Announcement"),
            ),
          ],
        ),
      ),
    );
  }
}
