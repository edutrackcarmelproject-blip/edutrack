
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherTimetable extends StatefulWidget {
const TeacherTimetable({super.key});

@override
State<TeacherTimetable> createState() => _TeacherTimetableState();
}

class _TeacherTimetableState extends State<TeacherTimetable> {

String selectedSemester = "Sem 1";

final List<String> semesters = [
"Sem 1",
"Sem 2",
"Sem 3",
"Sem 4",
"Sem 5",
"Sem 6"
];

final TextEditingController subjectController = TextEditingController();
final TextEditingController dayController = TextEditingController();
final TextEditingController timeController = TextEditingController();

List<Map<String, String>> timetableList = [];

Future<void> addTimetable() async {

if (subjectController.text.isEmpty ||
dayController.text.isEmpty ||
timeController.text.isEmpty) {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Please fill all fields")),
);
return;
}

try {

final response = await http.post(
  Uri.parse("http://10.0.2.2:5000/api/timetable/add"),
  headers: {"Content-Type": "application/json"},
  body: jsonEncode({
    "semester": selectedSemester,
    "subject": subjectController.text,
    "day": dayController.text,
    "time": timeController.text,
  }),
);

if (response.statusCode == 200) {

setState(() {
timetableList.add({
"semester": selectedSemester,
"subject": subjectController.text,
"day": dayController.text,
"time": timeController.text,
});

subjectController.clear();
dayController.clear();
timeController.clear();
});

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Timetable Added Successfully")),
);

} else {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("Failed to save timetable")),
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
appBar: AppBar(
title: const Text("Upload Timetable"),
backgroundColor: const Color(0xFF1F3C88),
),

body: Padding(
padding: const EdgeInsets.all(16),

child: Column(
children: [

DropdownButtonFormField(
value: selectedSemester,
decoration: const InputDecoration(
labelText: "Select Semester",
border: OutlineInputBorder(),
),
items: semesters.map((sem) {
return DropdownMenuItem(
value: sem,
child: Text(sem),
);
}).toList(),
onChanged: (value) {
setState(() {
selectedSemester = value!;
});
},
),

const SizedBox(height: 15),

TextField(
controller: subjectController,
decoration: const InputDecoration(
labelText: "Subject",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 15),

TextField(
controller: dayController,
decoration: const InputDecoration(
labelText: "Day (Example: Monday)",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 15),

TextField(
controller: timeController,
decoration: const InputDecoration(
labelText: "Time (Example: 10:00 - 11:00)",
border: OutlineInputBorder(),
),
),

const SizedBox(height: 15),

SizedBox(
width: double.infinity,
child: ElevatedButton(
onPressed: addTimetable,
style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF1F3C88),
padding: const EdgeInsets.all(14),
),
child: const Text("Add Timetable"),
),
),

const SizedBox(height: 20),

Expanded(
child: ListView.builder(
itemCount: timetableList.length,
itemBuilder: (context, index) {

final item = timetableList[index];

return Card(
child: ListTile(
title: Text(
"${item["subject"]} (${item["semester"]})",
style: const TextStyle(fontWeight: FontWeight.bold),
),
subtitle: Text(
"${item["day"]} | ${item["time"]}",
),
),
);

},
),
)

],
),
),
);
}
}