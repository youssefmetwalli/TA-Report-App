import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/student/course_input.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  // Sample list for the body
  List<String> itemList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  // Sample list of notifications
  List<String> notifications = [
    'Notification 1',
    'Notification 2',
    'Notification 3',
  ];

  // Controllers for text form fields in the dialog
  List<TextEditingController> _textFieldControllers = List.generate(6, (index) => TextEditingController());

  // Function to show the create report dialog
  void _showCreateReportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CourseInputDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle logout button press
              // Add your logout logic here
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Show the create report dialog
              _showCreateReportDialog();
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
        decoration: BoxDecoration(
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
              return SizedBox(height: 8.0);
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: ListTile(
                  title: Text(itemList[index]),
                  onTap: () {
                    print('Tapped on: ${itemList[index]}');
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
            DrawerHeader(
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
    );
  }
}
