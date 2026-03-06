import 'package:flutter/material.dart';

class ParentAssignments extends StatelessWidget {
  const ParentAssignments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assignments")),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text("Assignment ${index + 1}"),
              subtitle: const Text("Status: Submitted"),
            ),
          );
        },
      ),
    );
  }
}
