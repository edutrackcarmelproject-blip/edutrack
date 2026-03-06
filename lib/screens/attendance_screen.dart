import 'package:flutter/material.dart';
import 'theme_controller.dart';
class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String selectedMonth = 'September';

  final List<String> months = [
    'July',
    'August',
    'September',
    'October',
  ];

  // Subject-wise attendance
  final List<Map<String, dynamic>> subjects = [
    {"name": "Software Testing", "present": 20, "total": 25},
    {"name": "Indian Constitution", "present": 18, "total": 22},
    {"name": "CNE", "present": 20, "total": 24},
    {"name": "ST Lab", "present": 26, "total": 28},
  ];

  // Monthly calendar (P/A)
  final Map<String, List<String>> monthlyAttendance = {
    'September': [
      'P','P','A','P','P','P','A',
      'P','P','P','P','A','P','P',
      'P','A','P','P','P','P','A',
    ]
  };

  @override
  Widget build(BuildContext context) {
    int totalPresent = 0;
    int totalClasses = 0;

    for (var s in subjects) {
      totalPresent += s['present'] as int;
      totalClasses += s['total'] as int;
    }

    int overallPercentage =
    ((totalPresent / totalClasses) * 100).round();

    int requiredClasses = 0;
    if (overallPercentage < 75) {
      requiredClasses =
          ((0.75 * totalClasses) - totalPresent).ceil();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Summary"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// OVERALL SUMMARY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Overall Attendance",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$overallPercentage%",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: overallPercentage >= 75
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PREDICTION
            if (overallPercentage < 75)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Attend $requiredClasses more classes to reach 75%",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            /// SUBJECT-WISE ATTENDANCE
            const Text(
              "Subject-wise Attendance",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...subjects.map((s) {
              int percent =
              ((s['present'] / s['total']) * 100).round();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['name'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text("${s['present']} / ${s['total']} classes"),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percent / 100,
                      minHeight: 8,
                      color: percent >= 75 ? Colors.green : Colors.red,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            /// MONTH SELECT
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Monthly Attendance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedMonth,
                  items: months
                      .map(
                        (m) =>
                        DropdownMenuItem(value: m, child: Text(m)),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// CALENDAR VIEW
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: monthlyAttendance[selectedMonth]!.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                final status =
                monthlyAttendance[selectedMonth]![index];

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: status == 'P'
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${index + 1}\n$status",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            /// ABSENT DAYS
            const Text(
              "Absent Days",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: monthlyAttendance[selectedMonth]!
                  .asMap()
                  .entries
                  .where((e) => e.value == 'A')
                  .map(
                    (e) => Chip(
                  label: Text("Day ${e.key + 1}"),
                  backgroundColor: Colors.red.shade100,
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
