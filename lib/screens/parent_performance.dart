import 'package:flutter/material.dart';
import 'theme_controller.dart';


class ParentPerformance extends StatefulWidget {
  const ParentPerformance({super.key});

  static const Color primaryColor = Color(0xFF1F3C88);

  @override
  State<ParentPerformance> createState() => _ParentPerformanceState();
}

class _ParentPerformanceState extends State<ParentPerformance> {
  String? selectedSubject;

  final List<Map<String, dynamic>> subjects = const [
    {"subject": "Mathematics", "teacher": "Mr. Sharma"},
    {"subject": "Physics", "teacher": "Ms. Verma"},
    {"subject": "Computer Science", "teacher": "Mr. Singh"},
    {"subject": "English", "teacher": "Mrs. Kapoor"},
  ];

  final Map<String, dynamic> mockData = const {
    "Mathematics": {
      "attendance": 88,
      "tests": [
        {"name": "Test 1", "marks": 78},
        {"name": "Test 2", "marks": 82},
      ],
      "assignments": [
        {"name": "Assignment 1", "submitted": true},
        {"name": "Assignment 2", "submitted": false},
      ],
    },
    "Physics": {
      "attendance": 92,
      "tests": [
        {"name": "Test 1", "marks": 85},
      ],
      "assignments": [
        {"name": "Assignment 1", "submitted": true},
        {"name": "Assignment 2", "submitted": true},
      ],
    },
    "Computer Science": {
      "attendance": 95,
      "tests": [
        {"name": "Midterm", "marks": 90},
        {"name": "Final", "marks": 92},
      ],
      "assignments": [
        {"name": "Project 1", "submitted": true},
      ],
    },
    "English": {
      "attendance": 89,
      "tests": [
        {"name": "Grammar Test", "marks": 80},
      ],
      "assignments": [
        {"name": "Essay 1", "submitted": true},
        {"name": "Essay 2", "submitted": false},
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    // Show subject list if no subject selected
    if (selectedSubject == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Performance"),
          backgroundColor: ParentPerformance.primaryColor,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                  ParentPerformance.primaryColor.withOpacity(0.1),
                  child: Text(
                    subject["subject"][0],
                    style: const TextStyle(
                        color: ParentPerformance.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(subject["subject"]),
                subtitle: Text("Teacher: ${subject["teacher"]}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  setState(() {
                    selectedSubject = subject["subject"];
                  });
                },
              ),
            );
          },
        ),
      );
    }

    // Show subject performance if subject selected
    final data = mockData[selectedSubject]!;

    return Scaffold(
      appBar: AppBar(
        title: Text("$selectedSubject Performance"),
        backgroundColor: ParentPerformance.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedSubject = null;
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attendance
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.check_circle,
                    color: Colors.green, size: 28),
                title: const Text("Attendance"),
                trailing: Text("${data["attendance"]}%"),
              ),
            ),

            // Internal Tests
            const Text(
              "Internal Tests",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...List.generate(data["tests"].length, (i) {
              final test = data["tests"][i];
              return ListTile(
                leading:
                const Icon(Icons.bar_chart, color: ParentPerformance.primaryColor),
                title: Text(test["name"]),
                trailing: Text("${test["marks"]}"),
              );
            }),
            const SizedBox(height: 16),

            // Assignments
            const Text(
              "Assignments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...List.generate(data["assignments"].length, (i) {
              final assignment = data["assignments"][i];
              return ListTile(
                leading: Icon(
                  assignment["submitted"]
                      ? Icons.assignment_turned_in
                      : Icons.assignment_late,
                  color: assignment["submitted"] ? Colors.green : Colors.red,
                ),
                title: Text(assignment["name"]),
                trailing: Text(
                  assignment["submitted"] ? "Submitted" : "Pending",
                  style: TextStyle(
                      color:
                      assignment["submitted"] ? Colors.green : Colors.red),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

