import 'package:flutter/material.dart';
import 'theme_controller.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String role = 'Student';
  bool otpSent = false;
  bool otpVerified = false;
  bool loading = false;

  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  // Student
  final deptCtrl = TextEditingController();
  final semesterCtrl = TextEditingController();
  final regNoCtrl = TextEditingController();

  // Parent
  final studentRegNoCtrl = TextEditingController();

  // Mock OTP
  String generatedOtp = '';

  void sendOtp() {
    if (emailCtrl.text.isEmpty || !emailCtrl.text.contains('@')) return;

    setState(() => loading = true);

    // Generate a 4-digit OTP (mock)
    generatedOtp = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
        otpSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to ${emailCtrl.text} (mock: $generatedOtp)')),
      );
    });
  }

  void verifyOtp() {
    if (otpCtrl.text == generatedOtp) {
      setState(() => otpVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified ✔')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // 🔹 Name
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
              ),

              const SizedBox(height: 16),

              // 🔹 Email
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                enabled: !otpVerified,
                onChanged: (_) {
                  setState(() {}); // <-- This triggers rebuild so Send OTP button updates
                },
              ),

// 🔹 SEND OTP BUTTON
              if (!otpSent)
                ElevatedButton(
                  onPressed: loading || emailCtrl.text.isEmpty || !emailCtrl.text.contains('@')
                      ? null
                      : sendOtp,
                  child: loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Send OTP'),
                ),

              // 🔹 OTP Field
              if (otpSent && !otpVerified) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: otpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: verifyOtp,
                  child: const Text('Verify OTP'),
                ),
              ],

              // 🔹 OTP Verified Message
              if (otpVerified)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Email verified ✔',
                    style: TextStyle(color: Colors.green),
                  ),
                ),

              const SizedBox(height: 24),

              // 🔹 Role Selection
              const Text('Select Role', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Student', 'Parent', 'Teacher'].map((r) {
                  return ChoiceChip(
                    label: Text(r),
                    selected: role == r,
                    onSelected: otpVerified ? (_) => setState(() => role = r) : null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // 🔹 Student Fields
              if (role == 'Student' && otpVerified) ...[
                TextFormField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (v) => v == null || v.isEmpty ? 'Department required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: semesterCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Semester'),
                  validator: (v) => v == null || v.isEmpty ? 'Semester required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: regNoCtrl,
                  decoration: const InputDecoration(labelText: 'Register Number'),
                  validator: (v) => v == null || v.isEmpty ? 'Register number required' : null,
                ),
              ],

              // 🔹 Parent Fields
              if (role == 'Parent' && otpVerified) ...[
                TextFormField(
                  controller: studentRegNoCtrl,
                  decoration: const InputDecoration(labelText: 'Student Register Number'),
                  validator: (v) => v == null || v.isEmpty ? 'Register number required' : null,
                ),
              ],

              // 🔹 Teacher Fields
              if (role == 'Teacher' && otpVerified) ...[
                TextFormField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (v) => v == null || v.isEmpty ? 'Department required' : null,
                ),
              ],

              const SizedBox(height: 32),

              // 🔹 Register Button
              ElevatedButton(
                onPressed: otpVerified
                    ? () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration successful')),
                    );
                    Navigator.pop(context);
                  }
                }
                    : null,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
