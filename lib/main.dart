import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/admin.dart';
import 'package:ta_report_app/screens/faculty.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      initialRoute: '/', // Set your initial route as needed
      routes: {
        '/': (context) => LoginForm(),
        '/student_screen': (context) => StudentScreen(),
        '/faculty_screen': (context) => FacultyScreen(),
        '/admin_screen': (context) => AdminScreen(),
        // Add other routes as needed
      },
    );
  }
}
