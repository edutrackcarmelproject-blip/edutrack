import 'package:flutter/material.dart';

class StudentSpeechScreen extends StatefulWidget {
  const StudentSpeechScreen({super.key});

  @override
  State<StudentSpeechScreen> createState() => _StudentSpeechScreenState();
}

class _StudentSpeechScreenState extends State<StudentSpeechScreen> {
  bool isListening = false;
  String spokenText = "Press the mic and start speaking";

  void toggleListening() {
    setState(() {
      isListening = !isListening;
      spokenText = isListening
          ? "Listening... (speech feature will be connected later)"
          : "Speech stopped. Your text will appear here.";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // STATUS CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      size: 60,
                      color: isListening ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isListening ? "Listening..." : "Tap mic to speak",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // TEXT OUTPUT
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  spokenText,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // MIC BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: toggleListening,
              icon: Icon(isListening ? Icons.stop : Icons.mic),
              label: Text(isListening ? "Stop Listening" : "Start Speaking"),
            ),
          ],
        ),
      ),
    );
  }
}
