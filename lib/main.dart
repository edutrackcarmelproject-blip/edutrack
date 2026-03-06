import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const EduTrackApp());
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduTrack',
      home: const SplashScreen(), // 👈 START HERE
    );
  }
}
