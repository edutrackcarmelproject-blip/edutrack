import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  String selectedSemester = "Semester 1";
  int selectedDayIndex = 0;

  final List<String> semesters = [
    "Semester 1",
    "Semester 2",
    "Semester 3",
    "Semester 4",
  ];

  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];

  final Map<String, List<Map<String, String>>> timetable = {
    "Mon": [
      {
        "subject": "DBMS",
        "time": "9:00 - 10:00",
        "teacher": "Mr. Arun",
        "room": "Lab 2"
      },
      {
        "subject": "OS",
        "time": "10:15 - 11:15",
        "teacher": "Ms. Priya",
        "room": "Room 304"
      },
    ],
    "Tue": [
      {
        "subject": "DS",
        "time": "9:00 - 10:00",
        "teacher": "Dr. Kumar",
        "room": "Room 210"
      },
    ],
    "Wed": [],
    "Thu": [
      {
        "subject": "DBMS",
        "time": "11:30 - 12:30",
        "teacher": "Mr. Arun",
        "room": "Lab 1"
      },
    ],
    "Fri": [
      {
        "subject": "OS",
        "time": "9:00 - 10:00",
        "teacher": "Ms. Priya",
        "room": "Room 304"
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Timetable"),
        backgroundColor: const Color(0xFF1F3C88),
      ),
      body: Column(
        children: [
          _semesterSelector(),
          _dayTabs(),
          Expanded(child: _classList()),
        ],
      ),
    );
  }

  // 🔹 Semester Dropdown
  Widget _semesterSelector() {
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
            .map((sem) =>
            DropdownMenuItem(value: sem, child: Text(sem)))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedSemester = value!;
          });
        },
      ),
    );
  }

  // 🔹 Day Tabs
  Widget _dayTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(days.length, (index) {
          final bool isSelected = index == selectedDayIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDayIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1F3C88)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                days[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // 🔹 Classes List
  Widget _classList() {
    final day = days[selectedDayIndex];
    final classes = timetable[day]!;

    if (classes.isEmpty) {
      return const Center(
        child: Text(
          "No classes scheduled",
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        return _classCard(classes[index], index);
      },
    );
  }

  // 🔹 Class Card
  Widget _classCard(Map<String, String> cls, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 100),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cls["subject"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14),
                  const SizedBox(width: 6),
                  Text(cls["time"]!),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.person, size: 14),
                  const SizedBox(width: 6),
                  Text(cls["teacher"]!),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14),
                  const SizedBox(width: 6),
                  Text(cls["room"]!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
