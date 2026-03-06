import 'package:flutter/material.dart';

class ParentAttendance extends StatelessWidget {
  const ParentAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {"subject": "CNE", "percent": 85},
      {"subject": "ST", "percent": 78},
      {"subject": "PROJECT", "percent": 92},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Card(
            child: ListTile(
              title: Text(item["subject"].toString()),
              trailing: Text("${item["percent"]}%"),
            ),
          );
        },
      ),
    );
  }
}
