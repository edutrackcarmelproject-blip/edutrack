import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'subjects_screen.dart';
import 'schedule_screen.dart';
import 'attendance_screen.dart';
import 'performance_screen.dart';
import 'student_assignments_screen.dart';
import 'student_announcements.dart';
import 'student_profile.dart';
import 'student_chatbot_screen.dart';
import 'student_speech_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  static const Color primaryColor = Color(0xFF1F3C88);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("EduTrack – Student"),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StudentProfile()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.8,
          children: [
            _dashboardTile(
              icon: Icons.book,
              title: "Subjects",
              subtitle: "View subjects",
              page: const SubjectsScreen(),
            ),
            _dashboardTile(
              icon: Icons.schedule,
              title: "Timetable",
              subtitle: "Class schedule",
              page: const ScheduleScreen(),
            ),
            _dashboardTile(
              icon: Icons.fact_check,
              title: "Attendance",
              subtitle: "Stats & summary",
              page: AttendanceScreen(),
            ),
            _dashboardTile(
              icon: Icons.show_chart,
              title: "Performance",
              subtitle: "Marks & grades",
              page: const PerformanceScreen(),
            ),
            _dashboardTile(
              icon: Icons.assignment,
              title: "Assignments",
              subtitle: "View & submit",
              page: const StudentAssignmentsScreen(),
            ),
            _dashboardTile(
              icon: Icons.campaign,
              title: "Announcements",
              subtitle: "Latest updates",
              page: const StudentAnnouncements(),
            ),
            _dashboardTile(
              icon: Icons.smart_toy,
              title: "AI Tutor",
              subtitle: "Ask & learn",
              page: const StudentChatbotScreen(),
            ),
            _dashboardTile(
              icon: Icons.mic,
              title: "Speech Input",
              subtitle: "Talk instead of typing",
              page: const StudentSpeechScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget page,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
