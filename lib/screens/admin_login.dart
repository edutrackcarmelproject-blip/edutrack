import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
const AdminDashboard({super.key});

static const Color primaryColor = Color(0xFF1F3C88);

@override
Widget build(BuildContext context) {

return Scaffold(
backgroundColor: const Color(0xFFF5F7FB),

appBar: AppBar(
title: const Text("EduTrack - Admin"),
backgroundColor: primaryColor,
centerTitle: true,
),

body: Padding(
padding: const EdgeInsets.all(16),

child: GridView.count(
crossAxisCount: 2,
crossAxisSpacing: 14,
mainAxisSpacing: 14,
childAspectRatio: 1.2,

children: [

_AdminTile(
icon: Icons.person_add,
title: "Add Teacher",
subtitle: "Register teacher",
),

_AdminTile(
icon: Icons.group_add,
title: "Add Student",
subtitle: "Register student",
),

_AdminTile(
icon: Icons.menu_book,
title: "Subjects",
subtitle: "Manage subjects",
),

_AdminTile(
icon: Icons.schedule,
title: "Timetable",
subtitle: "Manage timetable",
),

_AdminTile(
icon: Icons.fact_check,
title: "Attendance",
subtitle: "View attendance",
),

_AdminTile(
icon: Icons.grade,
title: "Marks",
subtitle: "View marks",
),

_AdminTile(
icon: Icons.campaign,
title: "Announcements",
subtitle: "Post notices",
),

_AdminTile(
icon: Icons.settings,
title: "Settings",
subtitle: "System settings",
),

],
),
),
);
}
}

class _AdminTile extends StatelessWidget {

final IconData icon;
final String title;
final String subtitle;

const _AdminTile({
required this.icon,
required this.title,
required this.subtitle,
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

onTap: () {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("$title clicked")),
);
},

child: Padding(
padding: const EdgeInsets.symmetric(
vertical: 18, horizontal: 12),

child: Column(
mainAxisAlignment: MainAxisAlignment.center,

children: [

Icon(
icon,
size: 32,
color: AdminDashboard.primaryColor,
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

