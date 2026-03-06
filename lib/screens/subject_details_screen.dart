import 'package:flutter/material.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Map<String, String> subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  int selectedTab = 0;

  final List<Map<String, dynamic>> testMarks = [
    {"name": "Internal Test 1", "mark": 18, "total": 20},
    {"name": "Internal Test 2", "mark": 15, "total": 20},
    {"name": "Model Exam", "mark": 40, "total": 50},
  ];

  final List<Map<String, String>> assignments = [
    {"title": "ER Diagram", "status": "Submitted", "mark": "9/10"},
    {"title": "Normalization", "status": "Pending", "mark": "-"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(widget.subject["name"]!),
        backgroundColor: const Color(0xFF1F3C88),
      ),
      body: Column(
        children: [
          _subjectHeader(),
          _tabBar(),
          Expanded(child: selectedTab == 0 ? _performanceView() : _assignmentView()),
        ],
      ),
    );
  }

  Widget _subjectHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.subject["code"]!,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 6),
            Text(
              widget.subject["teacher"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          Chip(
            label: const Text("Attendance: 82%"),
            backgroundColor: Colors.green.shade50,
            labelStyle: const TextStyle(color: Colors.green),
          )
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _tabButton("Performance", 0),
          const SizedBox(width: 12),
          _tabButton("Assignments", 1),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final bool isActive = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1F3C88) : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 📊 PERFORMANCE VIEW
  Widget _performanceView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: testMarks.length,
      itemBuilder: (context, index) {
        final test = testMarks[index];
        final percent =
        ((test["mark"] / test["total"]) * 100).round();

        return Card(
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
                  test["name"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("${test["mark"]} / ${test["total"]}"),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: percent / 100,
                  minHeight: 8,
                  color: percent >= 75 ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 6),
                Text("$percent%"),
              ],
            ),
          ),
        );
      },
    );
  }

  // 📝 ASSIGNMENT VIEW
  Widget _assignmentView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final a = assignments[index];
        final bool submitted = a["status"] == "Submitted";

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            title: Text(a["title"]!),
            subtitle: Text("Mark: ${a["mark"]}"),
            trailing: Chip(
              label: Text(a["status"]!),
              backgroundColor:
              submitted ? Colors.green.shade50 : Colors.orange.shade50,
              labelStyle: TextStyle(
                color: submitted ? Colors.green : Colors.orange,
              ),
            ),
          ),
        );
      },
    );
  }
}
