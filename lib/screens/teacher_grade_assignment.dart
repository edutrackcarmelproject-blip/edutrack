
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherGradeAssignment extends StatefulWidget {
const TeacherGradeAssignment({super.key});

static const Color primaryColor = Color(0xFF1F3C88);

@override
State<TeacherGradeAssignment> createState() =>
_TeacherGradeAssignmentState();
}

class _TeacherGradeAssignmentState extends State<TeacherGradeAssignment> {

String selectedSemester = "Sem 3";
String selectedSubject = "Data Structures";
String selectedAssignment = "Assignment 1";

final List<String> semesters = ["Sem 1", "Sem 3", "Sem 5"];

final Map<String, List<String>> subjectsBySemester = {
"Sem 1": ["Maths", "Physics"],
"Sem 3": ["Data Structures", "Operating Systems"],
"Sem 5": ["DBMS", "Computer Networks"],
};

final Map<String, List<String>> assignmentsBySubject = {
"Data Structures": ["Assignment 1", "Assignment 2"],
"Operating Systems": ["Assignment 1"],
"DBMS": ["Assignment 1", "Assignment 2"],
"Maths": ["Assignment 1"],
"Physics": ["Assignment 1"],
};

final TextEditingController marksController = TextEditingController();
final TextEditingController feedbackController = TextEditingController();

/// Send grade to backend
Future<void> submitGrade() async {

if (marksController.text.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Please enter marks")),
);
return;
}

try {

final response = await http.post(
Uri.parse("http://10.0.2.2:5000/api/assignment-marks/add"),
headers: {"Content-Type": "application/json"},
body: jsonEncode({
"semester": selectedSemester,
"subject": selectedSubject,
"assignment": selectedAssignment,
"student": "Student 1",
"marks": marksController.text,
"feedback": feedbackController.text,
}),
);

if (response.statusCode == 200) {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Grade submitted successfully")),
);

marksController.clear();
feedbackController.clear();

} else {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Failed to submit grade")),
);

}

} catch (e) {

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Error: $e")),
);

}

}

@override
Widget build(BuildContext context) {

return Scaffold(
backgroundColor: const Color(0xFFF5F7FB),

appBar: AppBar(
title: const Text("Grade Assignment"),
backgroundColor: TeacherGradeAssignment.primaryColor,
centerTitle: true,
),

body: SingleChildScrollView(
padding: const EdgeInsets.all(16),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

/// Semester + Subject + Assignment
_selectors(),

/// Student card
_studentCard(),

const SizedBox(height: 20),

/// Answer preview
_answerPreview(),

const SizedBox(height: 24),

/// Marks
_marksInput(),

const SizedBox(height: 24),

/// Feedback
_feedbackInput(),

const SizedBox(height: 30),

/// Submit
_submitButton(),

],
),
),
);
}

/// Dropdown selectors
Widget _selectors() {

return Column(
children: [

Row(
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
selectedAssignment =
assignmentsBySubject[selectedSubject]!.first;
});

},
decoration:
const InputDecoration(labelText: "Semester"),
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
onChanged: (value) {

setState(() {
selectedSubject = value!;
selectedAssignment =
assignmentsBySubject[value]!.first;
});

},
decoration:
const InputDecoration(labelText: "Subject"),
),
),

],
),

const SizedBox(height: 12),

DropdownButtonFormField(
value: selectedAssignment,
items: assignmentsBySubject[selectedSubject]!
    .map((a) =>
DropdownMenuItem(value: a, child: Text(a)))
    .toList(),
onChanged: (value) =>
setState(() => selectedAssignment = value!),
decoration:
const InputDecoration(labelText: "Assignment"),
),

],
);

}

/// Student info
Widget _studentCard() {

return Card(
elevation: 3,
margin: const EdgeInsets.only(top: 16),

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),

child: Padding(
padding: const EdgeInsets.all(16),

child: Row(
children: [

CircleAvatar(
radius: 22,
backgroundColor:
TeacherGradeAssignment.primaryColor.withOpacity(0.12),
child: const Text(
"S1",
style: TextStyle(
color: TeacherGradeAssignment.primaryColor,
fontWeight: FontWeight.bold),
),
),

const SizedBox(width: 14),

Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

const Text(
"Student 1",
style: TextStyle(fontWeight: FontWeight.w600),
),

Text(
selectedAssignment,
style: const TextStyle(
fontSize: 12, color: Colors.black54),
),

],
),

],
),
),
);

}

/// Preview answer
Widget _answerPreview() {

return Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [

const Text("Student Answer",
style: TextStyle(fontWeight: FontWeight.bold)),

const SizedBox(height: 10),

Card(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),

child: const Padding(
padding: EdgeInsets.all(16),
child: Text(
"Preview of uploaded assignment.\nPDF viewer or download later.",
),
),
),

],
);

}

/// Marks field
Widget _marksInput() {

return Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [

const Text("Enter Marks",
style: TextStyle(fontWeight: FontWeight.bold)),

const SizedBox(height: 8),

TextField(
controller: marksController,
keyboardType: TextInputType.number,

decoration: InputDecoration(
hintText: "Marks (out of 100)",
filled: true,
fillColor: Colors.white,

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
),
),
),

],
);

}

/// Feedback field
Widget _feedbackInput() {

return Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [

const Text("Feedback (optional)",
style: TextStyle(fontWeight: FontWeight.bold)),

const SizedBox(height: 8),

TextField(
controller: feedbackController,
maxLines: 3,

decoration: InputDecoration(
hintText: "Write feedback",
filled: true,
fillColor: Colors.white,

border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
),
),
),

],
);

}

/// Submit button
Widget _submitButton() {

return SizedBox(
width: double.infinity,
height: 50,

child: ElevatedButton(

style: ElevatedButton.styleFrom(
backgroundColor: TeacherGradeAssignment.primaryColor,

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
),

onPressed: submitGrade,

child: const Text(
"Submit Grade",
style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),

),
);

}

}

