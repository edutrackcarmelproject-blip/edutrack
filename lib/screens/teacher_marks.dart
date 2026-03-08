import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TeacherMarks extends StatefulWidget {
  const TeacherMarks({super.key});

  static const Color primaryColor = Color(0xFF0D1A3C);

  @override
  State<TeacherMarks> createState() => _TeacherMarksState();
}

class _TeacherMarksState extends State<TeacherMarks> {
  String selectedSemester = "S3";
  String selectedSubject = "Data Structures";

  final List<String> semesters = ["S1", "S2", "S3", "S4", "S5", "S6"];

  final Map<String, List<String>> subjectsBySemester = {
    "S1": ["Maths I", "Physics"],
    "S2": ["Maths II", "Electronics"],
    "S3": ["Data Structures", "OOPS"],
    "S4": ["DBMS", "Operating Systems"],
    "S5": ["Computer Networks", "AI"],
    "S6": ["Web Programming", "ML"],
  };

  final List<Map<String, dynamic>> students = [
    {"name": "Student 1", "marks": ""},
    {"name": "Student 2", "marks": ""},
    {"name": "Student 3", "marks": ""},
    {"name": "Student 4", "marks": ""},
    {"name": "Student 5", "marks": ""},
  ];

  // 🔹 Send marks to backend
  Future<void> saveMarks() async {

    List<Map<String, dynamic>> marksList = students.map((student) {
      return {
        "name": student["name"],
        "marks": int.tryParse(student["marks"].toString()) ?? 0
      };
    }).toList();

    final ok = await ApiService.saveMarks(
      semester: selectedSemester,
      subject: selectedSubject,
      marksList: marksList,
    );

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Marks saved successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving marks")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Enter Marks"),
        backgroundColor: TeacherMarks.primaryColor,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _selectors(),
          _subjectHeader(),
          Expanded(child: _marksList()),
          _saveButton(context),
        ],
      ),
    );
  }

  // 🎓 Semester + Subject Dropdowns
  Widget _selectors() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedSemester,
              items: semesters
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value!;
                  selectedSubject = subjectsBySemester[value]!.first;
                });
              },
              decoration: const InputDecoration(labelText: "Semester"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedSubject,
              items: subjectsBySemester[selectedSemester]!
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Subject"),
            ),
          ),
        ],
      ),
    );
  }

  // 📘 Subject Header
  Widget _subjectHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TeacherMarks.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.book, color: TeacherMarks.primaryColor),
          const SizedBox(width: 10),
          Text(
            "$selectedSemester  •  $selectedSubject",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: TeacherMarks.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // 📋 Student list
  Widget _marksList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                  TeacherMarks.primaryColor.withOpacity(0.12),
                  child: Text(
                    students[index]["name"]
                        .substring(0, 2)
                        .toUpperCase(),
                    style: const TextStyle(
                        color: TeacherMarks.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    students[index]["name"],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    initialValue: students[index]["marks"],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      students[index]["marks"] = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Marks",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 💾 Save Button
  Widget _saveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: TeacherMarks.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: saveMarks,
          child: const Text(
            "Save Marks",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}