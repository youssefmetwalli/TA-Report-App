import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/admin/admin.dart';
import 'package:ta_report_app/screens/faculty/faculty.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student/report_list.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      initialRoute: '/', // Set your initial route as needed
      routes: {
        '/': (context) => const StudentScreen(),
        '/student_screen': (context) => const StudentScreen(),
        '/faculty_screen': (context) => const FacultyScreen(),
        '/admin_screen': (context) => const AdminScreen(),
        // Add other routes as needed
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
