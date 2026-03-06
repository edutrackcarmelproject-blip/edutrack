import 'package:flutter/material.dart';
import 'teacher_grade_assignment.dart';

class TeacherSubmissions extends StatefulWidget {
  const TeacherSubmissions({super.key});

  @override
  State<TeacherSubmissions> createState() => _TeacherSubmissionsState();
}

class _TeacherSubmissionsState extends State<TeacherSubmissions>
    with SingleTickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF1F3C88);

  late TabController _tabController;
  String searchText = "";

  String selectedSemester = "Sem 3";
  String selectedSubject = "Data Structures";

  final List<String> semesters = ["Sem 1", "Sem 3", "Sem 5"];

  final Map<String, List<String>> subjectsBySemester = {
    "Sem 1": ["Maths", "Physics"],
    "Sem 3": ["Data Structures", "Operating Systems"],
    "Sem 5": ["DBMS", "Computer Networks"],
  };

  final List<Map<String, dynamic>> submissions = [
    {
      "name": "Student 1",
      "status": "Submitted",
      "date": "10 Feb 2026",
      "semester": "Sem 3",
      "subject": "Data Structures"
    },
    {
      "name": "Student 2",
      "status": "Pending",
      "date": null,
      "semester": "Sem 3",
      "subject": "Data Structures"
    },
    {
      "name": "Student 3",
      "status": "Submitted",
      "date": "11 Feb 2026",
      "semester": "Sem 5",
      "subject": "DBMS"
    },
    {
      "name": "Student 4",
      "status": "Submitted",
      "date": "11 Feb 2026",
      "semester": "Sem 3",
      "subject": "Operating Systems"
    },
    {
      "name": "Student 5",
      "status": "Pending",
      "date": null,
      "semester": "Sem 1",
      "subject": "Maths"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Student Submissions"),
        backgroundColor: primaryColor,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Submitted"),
            Tab(text: "Pending"),
          ],
        ),
      ),
      body: Column(
        children: [
          _selectors(),

          // 🔍 Search
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              onChanged: (value) =>
                  setState(() => searchText = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Search student",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList("Submitted"),
                _buildList("Pending"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🎓 Semester + Subject selector
  Widget _selectors() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField(
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
              decoration: const InputDecoration(labelText: "Semester"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField(
              value: selectedSubject,
              items: subjectsBySemester[selectedSemester]!
                  .map((s) =>
                  DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => selectedSubject = value!),
              decoration: const InputDecoration(labelText: "Subject"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(String status) {
    final filtered = submissions.where((item) {
      return item["status"] == status &&
          item["semester"] == selectedSemester &&
          item["subject"] == selectedSubject &&
          item["name"].toLowerCase().contains(searchText);
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text("No records found",
            style: TextStyle(color: Colors.black54)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final student = filtered[index];

        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: student["status"] == "Submitted"
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const TeacherGradeAssignment(),
                ),
              );
            }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                    primaryColor.withOpacity(0.12),
                    child: Text(
                      student["name"].substring(0, 2),
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(student["name"],
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        student["date"] != null
                            ? Text(student["date"],
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54))
                            : const Text("Not submitted yet",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: student["status"] == "Submitted"
                          ? Colors.green.withOpacity(0.12)
                          : Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      student["status"],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: student["status"] == "Submitted"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
