import 'package:flutter/material.dart';

import '../services/api_service.dart';

class TeacherAttendance extends StatefulWidget {
  const TeacherAttendance({super.key});

  @override
  State<TeacherAttendance> createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {
 codex/assist-with-backend-implementation-zaxooy
  String semester = 'S1';
  String subject = '';

  Map<String, List<String>> semesterSubjects = {
    'S1': ['Maths I', 'Physics'],
    'S2': ['Maths II', 'Electronics'],
    'S3': ['Data Structures', 'OOPS'],
    'S4': ['DBMS', 'Operating Systems'],
    'S5': ['Computer Networks', 'AI'],
    'S6': ['Web Programming', 'ML']

  String semester = '1';
  String subject = '';

  Map<String, List<String>> semesterSubjects = {
    '1': ['Mathematics', 'Physics'],
    '2': ['C Programming', 'Digital Electronics'],
    '3': ['Data Structures', 'OOP'],
    '4': ['Operating System', 'DBMS'],
    '5': ['Computer Networks', 'Software Engineering'],
    '6': ['Machine Learning', 'Cloud Computing']
 main
  };

  List<String> subjects = [];

  final List<Map<String, dynamic>> students = [
    {'name': 'Student 1', 'present': false},
    {'name': 'Student 2', 'present': false},
    {'name': 'Student 3', 'present': false},
    {'name': 'Student 4', 'present': false},
    {'name': 'Student 5', 'present': false},
  ];

  @override
  void initState() {
    super.initState();
    subjects = semesterSubjects[semester]!;
    subject = subjects.first;
  }

  Future<void> submitAttendance() async {
    List<String> presentStudents = [];
    List<String> absentStudents = [];

    for (var student in students) {
      if (student['present']) {
        presentStudents.add(student['name']);
      } else {
        absentStudents.add(student['name']);
      }
    }

    final ok = await ApiService.submitAttendance(
      attendanceDate: DateTime.now().toString().split(' ')[0],
      semester: semester,
      subject: subject,
      presentStudents: presentStudents,
      absentStudents: absentStudents,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Attendance Submitted' : 'Error submitting attendance'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Attendance'),
        backgroundColor: const Color(0xFF1F3C88),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: semester,
              decoration: const InputDecoration(labelText: 'Semester'),
              items: const [
codex/assist-with-backend-implementation-zaxooy
                DropdownMenuItem(value: 'S1', child: Text('S1')),
                DropdownMenuItem(value: 'S2', child: Text('S2')),
                DropdownMenuItem(value: 'S3', child: Text('S3')),
                DropdownMenuItem(value: 'S4', child: Text('S4')),
                DropdownMenuItem(value: 'S5', child: Text('S5')),
                DropdownMenuItem(value: 'S6', child: Text('S6')),

                DropdownMenuItem(value: '1', child: Text('Sem 1')),
                DropdownMenuItem(value: '2', child: Text('Sem 2')),
                DropdownMenuItem(value: '3', child: Text('Sem 3')),
                DropdownMenuItem(value: '4', child: Text('Sem 4')),
                DropdownMenuItem(value: '5', child: Text('Sem 5')),
                DropdownMenuItem(value: '6', child: Text('Sem 6')),
 main
              ],
              onChanged: (value) {
                setState(() {
                  semester = value!;
                  subjects = semesterSubjects[semester]!;
                  subject = subjects.first;
                });
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: subject,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: subjects
                  .map((sub) => DropdownMenuItem(value: sub, child: Text(sub)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  subject = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Mark Attendance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: CheckboxListTile(
                      title: Text(students[index]['name']),
                      value: students[index]['present'],
                      onChanged: (value) {
                        setState(() {
                          students[index]['present'] = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF060F49),
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('Submit Attendance'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
