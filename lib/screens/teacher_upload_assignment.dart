import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherUploadAssignment extends StatefulWidget {
  const TeacherUploadAssignment({super.key});

  @override
  State<TeacherUploadAssignment> createState() =>
      _TeacherUploadAssignmentState();
}

class _TeacherUploadAssignmentState extends State<TeacherUploadAssignment> {
  String selectedSemester = 'S3';
  String selectedSubject = 'Data Structures';
  DateTime? dueDate;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  final List<String> semesters = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6'];

  final Map<String, List<String>> subjectsBySemester = {
    'S1': ['Maths I', 'Physics'],
    'S2': ['Maths II', 'Electronics'],
    'S3': ['Data Structures', 'OOPS'],
    'S4': ['DBMS', 'Operating Systems'],
    'S5': ['Computer Networks', 'AI'],
    'S6': ['Web Programming', 'ML'],
  };

  List assignments = [];

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  // 🔥 FETCH ASSIGNMENTS FROM BACKEND
  Future<void> fetchAssignments() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:5000/api/assignments"),
      );

      if (response.statusCode == 200) {
        setState(() {
          assignments = jsonDecode(response.body);
        });
      } else {
        print("Failed to load assignments");
      }
    } catch (e) {
      print("Error fetching assignments: $e");
    }
  }

  // 🔥 PUBLISH ASSIGNMENT
  Future<void> publishAssignment() async {
    if (titleController.text.isEmpty || dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all required fields")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/api/assignments/add"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "semester": selectedSemester,
          "subject": selectedSubject,
          "assignment_title": titleController.text,
          "description": descController.text,
          "due_date": dueDate!.toIso8601String().split("T")[0],
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Assignment saved to database")),
        );

        titleController.clear();
        descController.clear();
        dueDate = null;

        await fetchAssignments(); // 🔥 Refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save assignment")),
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
      appBar: AppBar(title: const Text("Assignments")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CREATE ASSIGNMENT CARD
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Create Assignment",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    /// Semester
                    DropdownButtonFormField<String>(
                      value: selectedSemester,
                      items: semesters
                          .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSemester = value!;
                          selectedSubject =
                              subjectsBySemester[value]!.first;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: "Semester",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    /// Subject
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      items: subjectsBySemester[selectedSemester]!
                          .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSubject = value!;
                        });
                      },
                      decoration: const InputDecoration(
                          labelText: "Subject",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    /// Title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          labelText: "Assignment Title",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    /// Description
                    TextField(
                      controller: descController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),

                    /// Due Date
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        dueDate == null
                            ? "Select Due Date"
                            : "Due: ${dueDate!.day}/${dueDate!.month}/${dueDate!.year}",
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 180)),
                        );
                        if (picked != null) {
                          setState(() {
                            dueDate = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    /// Publish Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.upload),
                        label: const Text("Publish Assignment"),
                        onPressed: publishAssignment,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// Published Assignments
            const Text(
              "Published Assignments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            assignments.isEmpty
                ? const Text("No assignments created yet")
                : Column(
              children: assignments.map((a) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(a["assignment_title"]),
                    subtitle: Text(
                      "${a["subject"]} • ${a["semester"]}\nDue: ${a["due_date"]}",
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
