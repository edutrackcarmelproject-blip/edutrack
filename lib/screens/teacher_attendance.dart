import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherAttendance extends StatefulWidget {
  const TeacherAttendance({super.key});

  @override
  State<TeacherAttendance> createState() => _TeacherAttendanceState();
}

class _TeacherAttendanceState extends State<TeacherAttendance> {

  String semester = "1";
  String subject = "";

  Map<String, List<String>> semesterSubjects = {
    "1": ["Mathematics", "Physics"],
    "2": ["C Programming", "Digital Electronics"],
    "3": ["Data Structures", "OOP"],
    "4": ["Operating System", "DBMS"],
    "5": ["Computer Networks", "Software Engineering"],
    "6": ["Machine Learning", "Cloud Computing"]
  };

  List<String> subjects = [];

  final List<Map<String, dynamic>> students = [
    {"name": "Student 1", "present": false},
    {"name": "Student 2", "present": false},
    {"name": "Student 3", "present": false},
    {"name": "Student 4", "present": false},
    {"name": "Student 5", "present": false},
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
      if (student["present"]) {
        presentStudents.add(student["name"]);
      } else {
        absentStudents.add(student["name"]);
      }
    }

    final response = await http.post(
      Uri.parse("http://10.0.2.2:5000/api/attendance"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "attendance_date": DateTime.now().toString().split(' ')[0],
        "semester": semester,
        "subject": subject,
        "present_students": presentStudents,
        "absent_students": absentStudents
      }),
    );

    print(response.statusCode);
    print(response.body);

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Attendance Submitted"))
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error submitting attendance"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Attendance"),
        backgroundColor: const Color(0xFF1F3C88),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            DropdownButtonFormField<String>(
              value: semester,
              decoration: const InputDecoration(labelText: "Semester"),
              items: const [
                DropdownMenuItem(value: "1", child: Text("Sem 1")),
                DropdownMenuItem(value: "2", child: Text("Sem 2")),
                DropdownMenuItem(value: "3", child: Text("Sem 3")),
                DropdownMenuItem(value: "4", child: Text("Sem 4")),
                DropdownMenuItem(value: "5", child: Text("Sem 5")),
                DropdownMenuItem(value: "6", child: Text("Sem 6")),
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
              decoration: const InputDecoration(labelText: "Subject"),
              items: subjects.map((sub){
                return DropdownMenuItem(
                  value: sub,
                  child: Text(sub),
                );
              }).toList(),
              onChanged: (value){
                setState(() {
                  subject = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Mark Attendance",
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context,index){
                  return Card(
                    child: CheckboxListTile(
                      title: Text(students[index]["name"]),
                      value: students[index]["present"],
                      onChanged: (value){
                        setState(() {
                          students[index]["present"] = value;
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
                child: const Text("Submit Attendance"),
              ),
            )

          ],
        ),
      ),
    );
  }
}