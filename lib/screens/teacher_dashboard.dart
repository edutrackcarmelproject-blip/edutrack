import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'teacher_upload_assignment.dart';
import 'teacher_submissions.dart';
import 'teacher_attendance.dart';
import 'teacher_marks.dart';
import 'teacher_timetable.dart';
import 'teacher_announcements.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  static const Color primaryColor = Color(0xFF1F3C88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("EduTrack – Teacher"),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.25,
          children: const [
            _DashboardTile(
              icon: Icons.upload_file,
              title: "Upload Assignment",
              subtitle: "Add questions",
              page: TeacherUploadAssignment(),
            ),
            _DashboardTile(
              icon: Icons.assignment_turned_in,
              title: "Submissions",
              subtitle: "View & grade",
              page: TeacherSubmissions(),
            ),
            _DashboardTile(
              icon: Icons.fact_check,
              title: "Attendance",
              subtitle: "Mark attendance",
              page: TeacherAttendance(),
            ),
            _DashboardTile(
              icon: Icons.grade,
              title: "Marks",
              subtitle: "Enter marks",
              page: TeacherMarks(),
            ),
            _DashboardTile(
              icon: Icons.schedule,
              title: "Timetable",
              subtitle: "Class schedule",
              page: TeacherTimetable(),
            ),
            _DashboardTile(
              icon: Icons.campaign,
              title: "Announcements",
              subtitle: "Post notices",
              page: TeacherAnnouncements(),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget page;

  const _DashboardTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashColor: TeacherDashboard.primaryColor.withOpacity(0.1),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: TeacherDashboard.primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
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
