
import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';
import 'parent_dashboard.dart';
import 'theme_controller.dart';
import 'admin_login.dart'; // ✅ Import admin login page

class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

@override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
with TickerProviderStateMixin {

final TextEditingController emailController = TextEditingController();
final TextEditingController otpController = TextEditingController();

bool otpSent = false;
String role = 'Student';

late AnimationController logoController;
late Animation<double> logoAnimation;

@override
void initState() {
super.initState();

logoController =
AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

logoAnimation =
CurvedAnimation(parent: logoController, curve: Curves.easeOutBack);

logoController.forward();
}

@override
void dispose() {
logoController.dispose();
emailController.dispose();
otpController.dispose();
super.dispose();
}

bool isValidEmail(String email) {
final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
return emailRegex.hasMatch(email);
}

@override
Widget build(BuildContext context) {

return ValueListenableBuilder<bool>(
valueListenable: ThemeController.isDarkMode,

builder: (_, isDark, __) {

final theme =
isDark ? ThemeController.darkTheme : ThemeController.lightTheme;

return MaterialApp(

debugShowCheckedModeBanner: false,
theme: ThemeController.lightTheme,
darkTheme: ThemeController.darkTheme,
themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

home: Scaffold(

backgroundColor: theme.scaffoldBackgroundColor,

/// ✅ Admin button in top-right
appBar: AppBar(
backgroundColor: Colors.transparent,
elevation: 0,
actions: [

TextButton.icon(

icon: const Icon(Icons.admin_panel_settings,
color: Color(0xFF1F3C88)),

label: const Text(
"Admin",
style: TextStyle(
color: Color(0xFF1F3C88),
fontWeight: FontWeight.bold,
),
),

onPressed: () {

Navigator.push(
context,
MaterialPageRoute(
builder: (context) => const AdminDashboard(),
),
);

},
)

],
),

body: SingleChildScrollView(

padding: const EdgeInsets.all(24),

child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,

children: [

const SizedBox(height: 20),

/// Logo
ScaleTransition(
scale: logoAnimation,
child: Center(
child: Column(
children: const [

Icon(Icons.school,
size: 90, color: Color(0xFF1F3C88)),

SizedBox(height: 12),

Text(
"EduTrack",
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
color: Color(0xFF1F3C88),
),
),

SizedBox(height: 4),

Text(
"Login to continue",
style: TextStyle(
fontSize: 16, color: Colors.grey),
),
],
),
),
),

const SizedBox(height: 40),

/// Role Selection
Wrap(
spacing: 10,
runSpacing: 10,
alignment: WrapAlignment.center,

children: ['Student', 'Parent', 'Teacher'].map((r) {

final selected = role == r;

return ChoiceChip(
label: Text(
r,
style: TextStyle(
color: selected
? Colors.white
    : theme.textTheme.bodyLarge?.color),
),

selected: selected,
selectedColor: const Color(0xFF1F3C88),
backgroundColor: theme.cardColor,
elevation: 3,

onSelected: (_) => setState(() => role = r),
);

}).toList(),
),

const SizedBox(height: 24),

/// Email
Card(
color: theme.cardColor,
elevation: 4,

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16)),

child: TextField(

controller: emailController,
keyboardType: TextInputType.emailAddress,

decoration: const InputDecoration(
labelText: "Email ID",
prefixIcon: Icon(Icons.email),
border: InputBorder.none,
contentPadding:
EdgeInsets.symmetric(horizontal: 16, vertical: 20),
),
),
),

const SizedBox(height: 20),

/// OTP
AnimatedSwitcher(
duration: const Duration(milliseconds: 400),

child: otpSent
? Card(
color: theme.cardColor,
elevation: 4,

shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16)),

child: TextField(
controller: otpController,
keyboardType: TextInputType.number,

decoration: const InputDecoration(
labelText: "Enter OTP",
prefixIcon: Icon(Icons.lock),
border: InputBorder.none,
contentPadding: EdgeInsets.symmetric(
horizontal: 16, vertical: 20),
),
),
)
    : const SizedBox.shrink(),
),

const SizedBox(height: 32),

/// Login Button
SizedBox(
height: 50,

child: ElevatedButton(

style: ElevatedButton.styleFrom(
backgroundColor: const Color(0xFF1F3C88),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
),
),

onPressed: () {

final email = emailController.text.trim();

if (email.isEmpty) {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Email cannot be empty")),
);

return;
}

if (!isValidEmail(email)) {

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Enter a valid email address")),
);

return;
}

if (!otpSent) {

setState(() => otpSent = true);

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text("OTP sent (mock)")),
);

return;
}

Widget page;

switch (role) {

case 'Teacher':
page = const TeacherDashboard();
break;

case 'Parent':
page = const ParentDashboard();
break;

default:
page = const StudentDashboard();
}

Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (_) => page),
);

},

child: Text(
otpSent ? 'Verify OTP' : 'Send OTP',
style: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.white),
),
),
),

const SizedBox(height: 20),

/// Register
Center(
child: TextButton(

onPressed: () {

Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const RegisterScreen()),
);

},

child: const Text("New user? Create account"),
),
),

const SizedBox(height: 20),

/// Dark Mode Toggle
Center(
child: IconButton(
icon: Icon(
isDark ? Icons.dark_mode : Icons.light_mode,
color: const Color(0xFF1F3C88),
size: 32,
),
onPressed: ThemeController.toggleTheme,
),
),

],
),
),
),
);
},
);
}
}
