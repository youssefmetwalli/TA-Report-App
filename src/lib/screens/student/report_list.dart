import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student/course_input.dart';
import 'package:ta_report_app/screens/student/report_form.dart';
import 'package:ta_report_app/screens/student/shift_addition.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  // Sample list for the body
  List<String> itemList = [
    'SE01 Big Data Analytics    October 2023',
    'SE01 Big Data Analytics    November 2023',
    'IE04 Integrated Exercise for Software    October 2023',
    'IE04 Integrated Exercise for Software    October 2023',
  ];

  // Sample list of notifications
  List<String> notifications = [
    'Notification 1',
    'Notification 2',
    'Notification 3',
  ];

  // Controllers for text form fields in the dialog
  final List<TextEditingController> _textFieldControllers =
      List.generate(6, (index) => TextEditingController());

  void _addCourseToItemList(
      String academicYear, String month, String courseName, String courseId) {
    setState(() {
      itemList.add('$courseName $academicYear'); // Adjust this line as needed
    });
  }

  // Function to show the create report dialog
  void _showCreateReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CourseInputDialog(
          onCourseAdded: _addCourseToItemList,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Current Reports'),
          actions: [
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginForm(),
                  ),
                );
              },
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 0, 128, 0),
                  Color.fromARGB(255, 0, 64, 0)
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 192, 255, 192),
                Color.fromARGB(255, 201, 231, 201),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: ListView.separated(
              itemCount: itemList.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8.0);
              },
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  child: ListTile(
                    title: Text(itemList[index]),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ShiftAddition(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 0, 128, 0),
                      Color.fromARGB(255, 0, 255, 0),
                    ],
                  ),
                ),
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              for (var notification in notifications)
                ListTile(
                  title: Text(notification),
                  onTap: () {
                    print('Tapped on: $notification');
                  },
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showCreateReportDialog();
          },
          label: const Text('Create New Report'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
