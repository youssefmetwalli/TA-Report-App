import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student/course_input.dart';
// import 'package:ta_report_app/screens/student/report_form.dart';
import 'package:ta_report_app/screens/student/shift_addition.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

class CoursesData {
  static List<dynamic> reportsList = [];

  static void setReportsList(dynamic list) {
    reportsList = list;
    saveReportsListToLocalStorage();
  }

  static void saveReportsListToLocalStorage() {
    String reportsListJson = jsonEncode(reportsList);
    window.localStorage['reportsList'] = reportsListJson;
  }

  static void loadReportsListFromLocalStorage() {
    String? reportsListJson = window.localStorage['reportsList'];
    if (reportsListJson != null) {
      reportsList = jsonDecode(reportsListJson);
    }
  }
}

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  // Use a ChangeNotifier to manage the state
  late StudentScreenStateNotifier stateNotifier;
  String userId = UserData.userId;
  List<dynamic> itemList = [];
  // late List<MapEntry<int, String>> reportKeys;

  @override
  void initState() {
    super.initState();
    stateNotifier = StudentScreenStateNotifier();
    fetchCourses();
  }

  //get courses
  Future<void> fetchCourses() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/courses/getall'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: jsonEncode(<String, dynamic>{'id': userId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        itemList = List<dynamic>.from(data['result']);

        for (var item in itemList) {
          await fetchReports(item);
          print(item);
        }
        // Set courses in the non-static method
        CoursesData.setReportsList(itemList);
        // After fetching all reports, trigger a rebuild of the UI
        stateNotifier.generateDisplayList();
        // Notify listeners to rebuild widgets using this data
        stateNotifier.notifyListeners();
        // reportKeys = stateNotifier.displayList.entries.toList();
        setState(() {});
      } else {
        print(data['message']);
      }
    } else {
      //TODO  Handle other HTTP response codes
      print('Request failed with status: ${response.statusCode}');
    }
  }

  //get reports
  Future<void> fetchReports(item) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/reports/getall'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: jsonEncode(<String, dynamic>{'assigned_course_id': item['ID']}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        item['reports'] = data['result'];
      } else {
        print(data['message']);
      }
    } else {
      // Handle other HTTP response codes
      print('Request failed with status: ${response.statusCode}');
    }
  }

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
      itemList.add(
          '$courseId $courseName $academicYear $month'); // Adjust this line as needed
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
    return ChangeNotifierProvider(
        create: (context) => stateNotifier,
        child: Scaffold(
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
                child: Consumer<StudentScreenStateNotifier>(
                    builder: (context, notifier, child) {
                  return ListView.separated(
                    itemCount: notifier.displayList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8.0);
                    },
                    itemBuilder: (context, index) {
                      int key = notifier.reportKeys[index];
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
                          title: Text(notifier.displayList[key]!),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                //TODO Shifts handling
                                builder: (context) =>
                                    ShiftAddition(reportId: key),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }),
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
              label: const Text('Add Course'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat));
  }
}

//a ChangeNotifier to hold the state
class StudentScreenStateNotifier extends ChangeNotifier {
  Map<int, String> displayList = {};
  List<int> reportKeys = [];

  void generateDisplayList() {
    for (var item in CoursesData.reportsList) {
      String courseInfo = '${item['course_id']} ${item['course_name']}';

      for (var report in item['reports']) {
        String reportInfo = '${report['Year']}/${report['Month']} ';
        String displayString = '$courseInfo $reportInfo';

        // Assigning the displayString to the report_id as the key in the map
        displayList[report['report_id']] = displayString;
        reportKeys.add(report['report_id']);
      }
    }

    // Notify listeners after updating displayList
    notifyListeners();
  }
}
