import 'package:flutter/material.dart';

import '../services/api_service.dart';

class TeacherLiveData extends StatefulWidget {
  const TeacherLiveData({super.key});

  @override
  State<TeacherLiveData> createState() => _TeacherLiveDataState();
}

class _TeacherLiveDataState extends State<TeacherLiveData> {
  String semester = 'S3';
  String subject = 'Data Structures';

  final List<String> semesters = ['S1', 'S2', 'S3', 'S4', 'S5', 'S6'];
  final Map<String, List<String>> subjectsBySemester = {
    'S1': ['Maths I', 'Physics'],
    'S2': ['Maths II', 'Electronics'],
    'S3': ['Data Structures', 'OOPS'],
    'S4': ['DBMS', 'Operating Systems'],
    'S5': ['Computer Networks', 'AI'],
    'S6': ['Web Programming', 'ML'],
  };

  bool loading = true;
  Map<String, dynamic> payload = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final data = await ApiService.getTeacherDashboard(semester: semester, subject: subject);
      setState(() => payload = data);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load teacher dashboard data')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  int _count(String key) => (payload[key] as List<dynamic>? ?? []).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Live Data')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
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
                      loadData();
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
                      loadData();
                    },
                    decoration: const InputDecoration(labelText: 'Subject'),
                  ),
                ),
              ],
            ),
          ),
          if (loading) const LinearProgressIndicator(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _card('Assignments', _count('assignments')),
                  _card('Announcements', _count('announcements')),
                  _card('Attendance Records', _count('attendance')),
                  _card('Marks Entries', _count('marks')),
                  _card('Assignment Grades', _count('assignment_grades')),
                  _card('Timetable Rows', _count('timetable')),
                ],
              ),
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
        trailing: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Text(count.toString()),
        ),
      ),
    );
  }
}
