import 'package:flutter/material.dart';

class StudentAssignmentsScreen extends StatefulWidget {
  const StudentAssignmentsScreen({super.key});

  @override
  State<StudentAssignmentsScreen> createState() =>
      _StudentAssignmentsScreenState();
}

class _StudentAssignmentsScreenState
    extends State<StudentAssignmentsScreen> {
  final List<Map<String, dynamic>> assignments = [
    {
      "subject": "CNE",
      "teacher": "Mr. Rajesh",
      "title": "LAN Cable Report",
      "description": "Explain types of LAN cables with diagrams.",
      "dueDate": "20 Dec 2025",
      "status": "Pending",
      "marks": null,
    },
    {
      "subject": "ES",
      "teacher": "Ms. Anitha",
      "title": "MSME Assignment",
      "description": "Write about MSME schemes in India.",
      "dueDate": "18 Dec 2025",
      "status": "Submitted",
      "marks": 18,
    },
    {
      "subject": "PROJECT",
      "teacher": "Dr. Kumar",
      "title": "SRS Document",
      "description": "Prepare Software Requirement Specification.",
      "dueDate": "22 Dec 2025",
      "status": "Pending",
      "marks": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("My Assignments"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final a = assignments[index];
          return _assignmentCard(a);
        },
      ),
    );
  }

  Widget _assignmentCard(Map<String, dynamic> a) {
    final bool isSubmitted = a["status"] == "Submitted";

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SUBJECT + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  a["subject"],
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                Chip(
                  label: Text(a["status"]),
                  backgroundColor: isSubmitted
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                ),
              ],
            ),

            const SizedBox(height: 6),

            // TITLE
            Text(
              a["title"],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // TEACHER
            Text(
              "By ${a["teacher"]}",
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 8),

            // DESCRIPTION
            Text(
              a["description"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            // DUE DATE
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14),
                const SizedBox(width: 6),
                Text("Due: ${a["dueDate"]}"),
              ],
            ),

            const SizedBox(height: 12),

            // MARKS (if available)
            if (a["marks"] != null)
              Text(
                "Marks: ${a["marks"]}/20",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

            const SizedBox(height: 12),

            // UPLOAD BUTTON
            if (!isSubmitted)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showUploadOptions();
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Upload"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Capture using Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Camera upload coming soon");
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text("Choose from Files"),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("File picker coming soon");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
