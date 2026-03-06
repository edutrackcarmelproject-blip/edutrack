import 'package:flutter/material.dart';

class ParentMarks extends StatelessWidget {
  const ParentMarks({super.key});

  @override
  Widget build(BuildContext context) {
    final marks = [
      {"subject": "Maths", "marks": 78},
      {"subject": "Physics", "marks": 85},
      {"subject": "CS", "marks": 92},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Marks")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: marks.length,
        itemBuilder: (context, index) {
          final item = marks[index];
          return Card(
            child: ListTile(
              title: Text(item["subject"].toString()),
              trailing: Text(item["marks"].toString()),
            ),
          );
        },
      ),
    );
  }
}
