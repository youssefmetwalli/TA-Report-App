import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String username = '';
  String password = '';
  String userType = 'student'; // Default user type

  void handleLogin() {
    // Add authentication logic here
    // You can replace this with your authentication logic

    // Navigate based on user type
    if (userType == 'student') {
      // Navigate to /report for students
      Navigator.pushReplacementNamed(context, '/student_screen');
    } else if (userType == 'faculty') {
      // Navigate to /faculty_screen for faculty
      Navigator.pushReplacementNamed(context, '/faculty_screen');
    } else if (userType == 'admin') {
      // Navigate to /admin_screen for admin
      Navigator.pushReplacementNamed(context, '/admin_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/Aizu-Univ1-3-scaled.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    userTypeRadioButton('student', 'Student'),
                    userTypeRadioButton('faculty', 'Faculty'),
                    userTypeRadioButton('admin', 'Admin'),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[500],
                    onPrimary: Colors.white,
                  ),
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userTypeRadioButton(String value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: userType,
          onChanged: (val) {
            setState(() {
              userType = val.toString();
            });
          },
        ),
        Text(label),
      ],
    );
  }
}
