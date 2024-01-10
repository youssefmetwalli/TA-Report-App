import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/login.dart';

import 'admin_form.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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

  // Function to show the create report dialog
  // void _showCreateReportDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const CourseInputDialog();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Screen'),
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
                Color.fromARGB(255, 93, 179, 255),
                Color.fromARGB(255, 151, 167, 239)
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
              Color.fromARGB(255, 195, 255, 241),
              Color.fromARGB(255, 222, 255, 222),
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
                        builder: (context) => const AdminForm(),
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
                    Color.fromARGB(255, 114, 225, 223),
                    Color.fromARGB(255, 158, 194, 253),
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
    // floatingActionButton: FloatingActionButton.extended(
    //   onPressed: () {
    //     _showCreateReportDialog();
    //   },
    //   label: const Text('Create New Report'),
    // ),
    // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
