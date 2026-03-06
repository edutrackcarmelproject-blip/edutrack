import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dark_mode_switch.dart';

class ParentAnnouncements extends StatefulWidget {
  const ParentAnnouncements({super.key});

  @override
  State<ParentAnnouncements> createState() => _ParentAnnouncementsState();
}

class _ParentAnnouncementsState extends State<ParentAnnouncements> {
  static const Color primaryColor = Color(0xFF1F3C88);

  List announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse("http://YOUR_IP_ADDRESS:5000/api/announcements"),
      );

      if (response.statusCode == 200) {
        setState(() {
          announcements = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColorPrimary = Theme.of(context).textTheme.bodyLarge?.color;
    final textColorSecondary = Theme.of(context).textTheme.bodyMedium?.color;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: const Text("Announcements"),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: DarkModeSwitch(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : announcements.isEmpty
          ? const Center(child: Text("No Announcements Available"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final item = announcements[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            child: Card(
              color: cardColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.campaign,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["announcement_title"] ?? "",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColorPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item["message"] ?? "",
                            style: TextStyle(
                              fontSize: 13,
                              color: textColorSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              item["created_at"] ?? "",
                              style: TextStyle(
                                fontSize: 11,
                                color: textColorSecondary
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}