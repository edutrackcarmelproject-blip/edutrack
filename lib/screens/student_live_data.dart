import 'package:flutter/material.dart';

import '../services/api_service.dart';

class StudentLiveData extends StatefulWidget {
  const StudentLiveData({super.key});

  @override
  State<StudentLiveData> createState() => _StudentLiveDataState();
}

class _StudentLiveDataState extends State<StudentLiveData> {
  String semester = 'S3';
  String subject = 'Data Structures';
  final studentController = TextEditingController(text: 'Student 1');

  final List<String> semesters = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6'];
  final Map<String, List<String>> subjectsBySemester = {
    'S1': ['Maths I', 'Physics'],
    'S2': ['Maths II', 'Electronics'],
    'S3': ['Data Structures', 'OOPS'],
    'S4': ['DBMS', 'Operating Systems'],
    'S5': ['Computer Networks', 'AI'],
    'S6': ['Web Programming', 'ML'],
  };

  bool loading = false;
  Map<String, dynamic> payload = {};

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final data = await ApiService.getStudentDashboard(
        semester: semester,
        subject: subject,
        studentName: studentController.text.trim(),
      );
      setState(() => payload = data);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch student data')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  int _count(String key) => (payload[key] as List<dynamic>? ?? []).length;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Live Data')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: studentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Student Name',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: semester,
                        items: semesters
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            semester = value;
                            subject = subjectsBySemester[value]!.first;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Semester'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: subject,
                        items: subjectsBySemester[semester]!
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => subject = value);
                        },
                        decoration: const InputDecoration(labelText: 'Subject'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(onPressed: loadData, child: const Text('Load')),
                )
              ],
            ),
          ),
          if (loading) const LinearProgressIndicator(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _card('Assignments', _count('assignments')),
                _card('Announcements', _count('announcements')),
                _card('Attendance Days', _count('attendance')),
                _card('Marks', _count('marks')),
                _card('Assignment Grades', _count('assignment_grades')),
                _card('Timetable Rows', _count('timetable')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(String title, int count) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
