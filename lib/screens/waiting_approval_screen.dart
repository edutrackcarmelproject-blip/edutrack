import 'package:flutter/material.dart';

class WaitingApprovalScreen extends StatelessWidget {
  const WaitingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ICON
              const Icon(
                Icons.hourglass_top,
                size: 90,
                color: Color(0xFF1F3C88),
              ),
              const SizedBox(height: 20),

              // TITLE
              const Text(
                "Waiting for Approval",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F3C88),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // MESSAGE
              const Text(
                "Your account is under verification.\n"
                    "You will be able to access the dashboard\n"
                    "after teacher approval.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // LOADING
              const CircularProgressIndicator(
                color: Color(0xFF1F3C88),
              ),
              const SizedBox(height: 30),

              // LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back to Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
