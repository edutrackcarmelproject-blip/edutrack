import 'package:flutter/material.dart';

class StudentAnnouncements extends StatefulWidget {
  const StudentAnnouncements({super.key});

  @override
  State<StudentAnnouncements> createState() => _StudentAnnouncementsState();
}

class _StudentAnnouncementsState extends State<StudentAnnouncements> {
  String selectedSemester = "Semester 3";

  final List<String> semesters = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
  ];

  final List<Map<String, String>> announcements = [
    {
      "title": "Internal Exam Schedule",
      "description":
      "Internal exams will start from 20th March. Refer timetable for details.",
      "teacher": "HOD – CSE",
      "date": "12 Mar 2026",
      "type": "Important",
    },
    {
      "title": "Assignment Submission",
      "description":
      "DBMS Assignment 2 must be submitted before Friday.",
      "teacher": "Mr. Arun",
      "date": "10 Mar 2026",
      "type": "Assignment",
    },
    {
      "title": "Holiday Notice",
      "description":
      "College will remain closed on account of public holiday.",
      "teacher": "Principal",
      "date": "08 Mar 2026",
      "type": "General",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Announcements"),
        backgroundColor: const Color(0xFF1F3C88),
      ),
      body: Column(
        children: [
          _semesterSelector(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                return _announcementCard(announcements[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔽 SEMESTER DROPDOWN
  Widget _semesterSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField(
        value: selectedSemester,
        decoration: InputDecoration(
          labelText: "Select Semester",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        items: semesters
            .map(
              (s) => DropdownMenuItem(
            value: s,
            child: Text(s),
          ),
        )
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedSemester = value!;
          });
        },
      ),
    );
  }

  // 📄 ANNOUNCEMENT CARD
  Widget _announcementCard(Map<String, String> data, int index) {
    Color badgeColor;
    IconData icon;

    switch (data["type"]) {
      case "Important":
        badgeColor = Colors.red;
        icon = Icons.warning_amber;
        break;
      case "Assignment":
        badgeColor = Colors.orange;
        icon = Icons.assignment;
        break;
      default:
        badgeColor = Colors.blue;
        icon = Icons.campaign;
    }

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 100),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW
              Row(
                children: [
                  Icon(icon, color: badgeColor, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data["title"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      data["type"]!,
                      style: TextStyle(color: badgeColor),
                    ),
                    backgroundColor: badgeColor.withOpacity(0.1),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // DESCRIPTION
              Text(
                data["description"]!,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 14),

              // FOOTER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "By ${data["teacher"]}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    data["date"]!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
