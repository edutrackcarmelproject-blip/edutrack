import 'package:flutter/material.dart';
import 'theme_controller.dart';


class ParentTimetable extends StatelessWidget {
  const ParentTimetable({super.key});

  static const Color primaryColor = Color(0xFF1F3C88);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        appBar: AppBar(
          title: const Text("Timetable"),
          backgroundColor: primaryColor,
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Mon"),
              Tab(text: "Tue"),
              Tab(text: "Wed"),
              Tab(text: "Thu"),
              Tab(text: "Fri"),
            ],
          ),
        ),
        body: Column(
          children: [
            // 🔹 Semester selector placeholder
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.school, color: primaryColor),
                  SizedBox(width: 10),
                  Text(
                    "Semester 3",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ),

            // 📋 Tab Views for each day
            Expanded(
              child: TabBarView(
                children: [
                  _daySchedule("Monday"),
                  _daySchedule("Tuesday"),
                  _daySchedule("Wednesday"),
                  _daySchedule("Thursday"),
                  _daySchedule("Friday"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _daySchedule(String day) {
    // Sample timetable data
    final List<Map<String, String>> classes = [
      {
        "time": "9:00 - 10:00",
        "subject": "Mathematics",
        "class": "3A",
      },
      {
        "time": "10:15 - 11:15",
        "subject": "Physics",
        "class": "3B",
      },
      {
        "time": "11:30 - 12:30",
        "subject": "Computer Science",
        "class": "3A",
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final item = classes[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // ⏰ Time block
                  Container(
                    width: 70,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item["time"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // 📚 Class info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item["subject"]!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Class: ${item["class"]!}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 📍 Icon
                  const Icon(
                    Icons.school,
                    color: primaryColor,
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
