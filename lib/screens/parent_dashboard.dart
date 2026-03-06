import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'parent_timetable.dart';
import 'parent_announcements.dart';
import 'parent_profile.dart';
import 'parent_performance.dart'; // <-- New Performance Page

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  static const Color primaryColor = Color(0xFF1F3C88);

  @override
  Widget build(BuildContext context) {
    final dashboardItems = [
      _DashboardItem(Icons.schedule, "Timetable", "Class routine", const ParentTimetable()),
      _DashboardItem(Icons.campaign, "Announcements", "School updates", const ParentAnnouncements()),
      _DashboardItem(Icons.star, "Performance", "View subject-wise performance", const ParentPerformance()), // <-- New
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("EduTrack – Parent"),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentProfile())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: dashboardItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final item = dashboardItems[index];
            return _DashboardTile(item: item);
          },
        ),
      ),
    );
  }
}

class _DashboardItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget page;

  _DashboardItem(this.icon, this.title, this.subtitle, this.page);
}

class _DashboardTile extends StatelessWidget {
  final _DashboardItem item;

  const _DashboardTile({required this.item});

  static const Color primaryColor = Color(0xFF1F3C88);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.page)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: primaryColor, size: 26),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
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
