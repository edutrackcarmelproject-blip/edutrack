import 'package:flutter/material.dart';

class StudentChatbotScreen extends StatefulWidget {
  const StudentChatbotScreen({super.key});

  @override
  State<StudentChatbotScreen> createState() => _StudentChatbotScreenState();
}

class _StudentChatbotScreenState extends State<StudentChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> messages = [
    {
      "role": "bot",
      "text": "Hi 👋 I'm your AI Tutor. Ask me anything about your subjects!"
    }
  ];

  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": _controller.text});
      messages.add({
        "role": "bot",
        "text": "Good question! I’ll explain this once backend is connected."
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Tutor"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).primaryColor
                          : (isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // INPUT AREA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.05),
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Ask your doubt...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
