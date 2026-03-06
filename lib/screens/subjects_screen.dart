import 'package:flutter/material.dart';
import 'subject_details_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  String selectedSemester = "Semester 3";

  final List<String> semesters = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
  ];

  final List<Map<String, String>> subjects = [
    {"name": "DBMS", "code": "CS301", "teacher": "Mr. Arun"},
    {"name": "Operating Systems", "code": "CS302", "teacher": "Ms. Priya"},
    {"name": "Computer Networks", "code": "CS303", "teacher": "Dr. Kumar"},
    {"name": "AI", "code": "CS304", "teacher": "Mr. Rahul"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Subjects"),
        backgroundColor: const Color(0xFF1F3C88),
      ),
      body: Column(
        children: [
          _semesterDropdown(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return _subjectCard(subjects[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _semesterDropdown() {
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
            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedSemester = value!;
          });
        },
      ),
    );
  }

  Widget _subjectCard(Map<String, String> subject, int index) {
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
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          title: Text(
            subject["name"]!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${subject["code"]} • ${subject["teacher"]}",
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubjectDetailsScreen(subject: subject),
              ),
            );
          },
        ),
      ),
    );
  }
}
