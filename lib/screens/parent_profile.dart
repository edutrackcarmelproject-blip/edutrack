import 'package:flutter/material.dart';
import 'theme_controller.dart';


class ParentProfile extends StatelessWidget {
  const ParentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Center(
              child: CircleAvatar(
                radius: 45,
                child: Icon(Icons.person, size: 55),
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Parent Name"),
              subtitle: Text("Parent Name"),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text("parent@email.com"),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text("Child"),
              subtitle: Text("Student Name – Class 10 A"),
            ),
          ],
        ),
      ),
    );
  }
}
