import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserData {
  static String userId = '';
  static Map<String, dynamic> userDetails = {};

  static void setUserId(String id) {
    userId = id;
  }

  static void setUserDetails(Map<String, dynamic> studentData) {
    if (studentData['status'] == 0) {
      studentData['status'] = "International";
    } else {
      studentData['status'] = "Japanese";
    }
    userDetails = studentData;
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String username = '';
  String password = '';
  String userType = 'student'; // Default user type
  final _formKey = GlobalKey<FormState>();

  String? validateUsername(String? value) {
    // if (value == null || !value.contains('@')) {
    //   return 'Please Enter a Valid Email Address';
    // }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || !RegExp(r'(?=.*[0-9])(?=.*[A-Z])').hasMatch(value)) {
      return 'One numerical value and one upper case letter are required';
    }
    return null;
  }

  String? loginError;

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*'
        },
        body:
            jsonEncode(<String, dynamic>{'id': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          UserData.setUserId(username);
          UserData.setUserDetails(data['result'][0]);

          // Navigate based on user type
          if (userType == 'student' &&
              UserData.userDetails['role'] == 'student') {
            Navigator.pushReplacementNamed(context, '/student_screen');
          } else if (userType == 'faculty' &&
              UserData.userDetails['role'] == 'faculty') {
            Navigator.pushReplacementNamed(context, '/faculty_screen');
          } else if (userType == 'admin' &&
              UserData.userDetails['role'] == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin_screen');
          } else {
            setState(() {
              loginError =
                  "ERROR: You must select student, faculty, or admin according to your status!";
            });
          }
        } else {
          // ignore: avoid_print
          setState(() {
            loginError = data['message'];
          });

          print('Incorrect email or password');
        }
      } else {
        setState(() {
          loginError = "Invalid credentials";
        });
        print('Request failed with status: ${response.statusCode}');
      }
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
            child: Form(
              key: _formKey,
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      userTypeRadioButton('student', 'Student'),
                      userTypeRadioButton('faculty', 'Faculty'),
                      userTypeRadioButton('admin', 'Admin'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    validator: validateUsername,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: true,
                    validator: validatePassword,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[500],
                    ),
                    child: const Text('Login'),
                  ),
                  if (loginError != null)
                    Text(
                      loginError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
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
