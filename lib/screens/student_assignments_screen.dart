import 'package:flutter/material.dart';

import '../services/api_service.dart';

class StudentAssignmentsScreen extends StatefulWidget {
  const StudentAssignmentsScreen({super.key});

  @override
  State<StudentAssignmentsScreen> createState() => _StudentAssignmentsScreenState();
}

class _StudentAssignmentsScreenState extends State<StudentAssignmentsScreen> {
  String selectedSemester = 'S3';
  String selectedSubject = 'Data Structures';
  final studentNameController = TextEditingController(text: 'Student 1');

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
  List<dynamic> assignments = [];
  List<dynamic> assignmentGrades = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);
    try {
      final dashboard = await ApiService.getStudentDashboard(
        semester: selectedSemester,
        subject: selectedSubject,
        studentName: studentNameController.text.trim(),
      );

      setState(() {
        assignments = dashboard['assignments'] as List<dynamic>? ?? [];
        assignmentGrades = dashboard['assignment_grades'] as List<dynamic>? ?? [];
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load assignment data')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(title: const Text('My Assignments')),
      body: Column(
        children: [
          _filters(),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: loadData,
                    child: assignments.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 160),
                              Center(child: Text('No assignments available')),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: assignments.length,
                            itemBuilder: (context, index) {
                              final a = assignments[index] as Map<String, dynamic>;
                              final grade = _findGrade(a['assignment_title']?.toString() ?? '');
                              return _assignmentCard(a, grade);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: studentNameController,
            decoration: const InputDecoration(
              labelText: 'Student name (must match backend data)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedSemester,
                  items: semesters
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedSemester = value;
                      selectedSubject = subjectsBySemester[value]!.first;
                    });
                    loadData();
                  },
                  decoration: const InputDecoration(labelText: 'Semester'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedSubject,
                  items: subjectsBySemester[selectedSemester]!
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => selectedSubject = value);
                    loadData();
                  },
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: loadData, child: const Text('Refresh')),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _findGrade(String assignmentTitle) {
    for (final item in assignmentGrades) {
      final row = item as Map<String, dynamic>;
      if (row['assignment']?.toString() == assignmentTitle) {
        return row;
      }
    }
    return null;
  }

  Widget _assignmentCard(Map<String, dynamic> a, Map<String, dynamic>? grade) {
    final bool isGraded = grade != null;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  a['subject']?.toString() ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Chip(
                  label: Text(isGraded ? 'Graded' : 'Pending'),
                  backgroundColor:
                      isGraded ? Colors.green.shade100 : Colors.orange.shade100,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              a['assignment_title']?.toString() ?? 'Assignment',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(a['description']?.toString() ?? ''),
            const SizedBox(height: 10),
            Text('Due: ${a['due_date']?.toString().split('T').first ?? '-'}'),
            if (isGraded) ...[
              const SizedBox(height: 10),
              Text(
                'Marks: ${grade['marks']}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              if ((grade['feedback'] ?? '').toString().isNotEmpty)
                Text('Feedback: ${grade['feedback']}'),
            ],
          ],
        ),
      ),
    );
  }
}
