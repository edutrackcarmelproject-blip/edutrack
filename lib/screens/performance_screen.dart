import 'package:flutter/material.dart';
import 'theme_controller.dart';


class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data (later comes from backend)
    final List<Map<String, dynamic>> performanceData = [
      {
        "subject": "Data Structures",
        "attendance": 85,
        "marks": 78,
      },
      {
        "subject": "Operating Systems",
        "attendance": 92,
        "marks": 88,
      },
      {
        "subject": "DBMS",
        "attendance": 74,
        "marks": 65,
      },
      {
        "subject": "Computer Networks",
        "attendance": 90,
        "marks": 91,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Performance"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: performanceData.length,
        itemBuilder: (context, index) {
          final item = performanceData[index];
          final grade = calculateGrade(item["marks"]);

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["subject"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      infoTile("Attendance", "${item["attendance"]}%"),
                      infoTile("Marks", "${item["marks"]}"),
                      infoTile("Grade", grade),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget infoTile(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String calculateGrade(int marks) {
    if (marks >= 90) return "A+";
    if (marks >= 80) return "A";
    if (marks >= 70) return "B";
    if (marks >= 60) return "C";
    if (marks >= 50) return "D";
    return "F";
  }
}
