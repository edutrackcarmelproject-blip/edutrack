import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 60),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Name"),
              subtitle: Text("Student Name"),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text("student@email.com"),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text("Class"),
              subtitle: Text("Class 10 - A"),
            ),
            ListTile(
              leading: Icon(Icons.badge),
              title: Text("Role"),
              subtitle: Text("Student"),
            ),
          ],
        ),
      ),
    );
  }
}
