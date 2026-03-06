/*
import 'package:flutter/material.dart';
import '../services/api_service.dart';

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

  // Common
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  // Student
  final deptCtrl = TextEditingController();
  final semesterCtrl = TextEditingController();
  final regNoCtrl = TextEditingController();

  // Parent
  final studentRegNoCtrl = TextEditingController();

  get ApiService => null;tp() async {
    setState(() => loading = true);

    bool sent = await ApiService.sendOtp(phoneCtrl.text);

    setState(() {
      loading = false;
      otpSent = sent;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(sent ? 'OTP sent' : 'Failed to send OTP'),
      ),
    );
  }

  Future<void> verifyOtp() async {
    final result = await ApiService.verifyOtp(
      phoneCtrl.text,
      otpCtrl.text,
      role,
    );

    if (result != null) {
      setState(() => otpVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified')),
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

              // 🔹 NAME
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                v == null || v.isEmpty ? 'Name required' : null,
              ),

              const SizedBox(height: 16),

              // 🔹 EMAIL
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) =>
                v == null || !v.contains('@') ? 'Enter valid email' : null,
              ),

              const SizedBox(height: 16),

              // 🔹 PHONE
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+91 ',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) =>
                v == null || v.length != 10 ? 'Enter valid phone number' : null,
                enabled: !otpVerified,
              ),

              const SizedBox(height: 8),

              // 🔹 SEND OTP BUTTON
              if (!otpSent)
                ElevatedButton(
                  onPressed: loading ? null : () {
                    if (phoneCtrl.text.length == 10) {
                      sendOtp();
                    }
                  },
                  child: const Text('Send OTP'),
                ),

              // 🔹 OTP FIELD
              if (otpSent && !otpVerified) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: otpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: verifyOtp,
                  child: const Text('Verify OTP'),
                ),
              ],

              // 🔹 OTP VERIFIED MESSAGE
              if (otpVerified)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Phone number verified ✔',
                    style: TextStyle(color: Colors.green),
                  ),
                ),

              const SizedBox(height: 24),

              // 🔹 ROLE SELECTION
              const Text('Select Role', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['Student', 'Parent', 'Teacher'].map((r) {
                  return ChoiceChip(
                    label: Text(r),
                    selected: role == r,
                    onSelected: otpVerified
                        ? (_) => setState(() => role = r)
                        : null,
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // 🔹 STUDENT FIELDS
              if (role == 'Student' && otpVerified) ...[
                TextFormField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Department required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: semesterCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Semester'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Semester required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: regNoCtrl,
                  decoration: const InputDecoration(labelText: 'Register Number'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Register number required' : null,
                ),
              ],

              // 🔹 PARENT FIELDS
              if (role == 'Parent' && otpVerified) ...[
                TextFormField(
                  controller: studentRegNoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Student Register Number',
                  ),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Register number required' : null,
                ),
              ],

              // 🔹 TEACHER FIELDS
              if (role == 'Teacher' && otpVerified) ...[
                TextFormField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(labelText: 'Department'),
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Department required' : null,
                ),
              ],

              const SizedBox(height: 32),

              // 🔹 REGISTER BUTTON
              ElevatedButton(
                onPressed: otpVerified
                    ? () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration successful'),
                      ),
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
}*/
