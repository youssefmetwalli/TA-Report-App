import 'dart:convert';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student/course_input.dart';
import 'package:ta_report_app/screens/student/report_form.dart';
// import 'package:ta_report_app/screens/student/report_form.dart';
import 'package:ta_report_app/screens/student/shift_addition.dart';
import 'package:http/http.dart' as http;
import 'dart:html';

class CoursesData {
  static List<dynamic> reportsList = [];
  static String submitStatus = "";
  static int assignedCourseId = 0;

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
  Map<int, String> status = {0: "SA", 1: "TA"};

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
          // print(item);
        }
        // Set courses in the non-static method
        CoursesData.setReportsList(itemList);
        // After fetching all reports, trigger a rebuild of the UI
        stateNotifier.generateDisplayList();
        // Notify listeners to rebuild widgets using this data
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
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

  // Sample list of notifications
  List<String> notifications = [
    'Notification 1',
    'Notification 2',
    'Notification 3',
  ];

  // Controllers for text form fields in the dialog

  void _addCourseToItemList(
      String academicYear, String month, String courseName, String courseId) {
    setState(() {
      stateNotifier.displayList[AddedReportData.reportId]?[0] = [
        '$courseId $courseName $month/$academicYear ',
        AddedReportData.status,
        "Editing",
        AddedReportData.assignedId
      ];
      stateNotifier.setReportKeys(AddedReportData.reportId);
    });
  }

  // Function to show the create report dialog
  //TODO this is where the error is
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
              title: const Text(
                'Current Reports',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 228, 228, 228)),
              ),
              actions: [
                IconButton(
                  color: Color.fromARGB(255, 225, 217, 217),
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(notifier.displayList[key]
                                  ?[0]), //report description
                              Text(
                                notifier.displayList[key]?[3], // submit_status
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 46, 223,
                                      123), // Customize the color if needed
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            try {
                              if (notifier.displayList[key]?[3] ==
                                      "Submitted" ||
                                  notifier.displayList[key]?[3] ==
                                      "Faculty Approved" ||
                                  notifier.displayList[key]?[3] ==
                                      "Admin Approved" ||
                                  notifier.displayList[key]?[3] == "Locked" ||
                                  false) {
                                // If the submit_status is "submitted", navigate to ReportForm page
                                // and fetch shifts using a function in ReportForm
                                print(key);
                                print(notifier.displayList[key]);
                                await fetchShiftsAndNavigateToReportForm(
                                    context, key, notifier.displayList[key]!);
                              } else {
                                // If submit_status is not "submitted", navigate to ShiftAddition page
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ShiftAddition(
                                      reportId: key,
                                      reportTitle: notifier.displayList[key]!,
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              print("Error: $e");
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginForm(),
                                ),
                              );
                            }
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

Future<void> fetchShiftsAndNavigateToReportForm(
    BuildContext context, int reportId, List reportData) async {
  try {
    // Make HTTP POST request to fetch shifts
    final shiftsResponse = await http.post(
      Uri.parse('http://localhost:3000/shifts/getall'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      body: jsonEncode(<String, dynamic>{'report_id': reportId}),
    );

    if (shiftsResponse.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData =
          json.decode(shiftsResponse.body);
      final List<dynamic> shiftDataList = responseData['result'];

      shifts = shiftDataList
          .map((shiftData) => ShiftData.fromJson(shiftData))
          .toList();
      print(shifts);
      // Now navigate to the ReportForm page
      fetchShifts(reportId);
      print(shifts);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReportForm(
            reportData: reportData,
          ),
        ),
      );
    } else {
      // Handle HTTP error response
      print('Failed to fetch shifts. Status code: ${shiftsResponse}');
      // Optionally, show a snackbar or dialog to inform the user
    }
  } catch (e) {
    // Handle exceptions
    print('Error fetching shifts: $e');
    // Optionally, show a snackbar or dialog to inform the user
  }
}

//a ChangeNotifier to hold the state
class StudentScreenStateNotifier extends ChangeNotifier {
  Map<int, List> displayList = {};
  List<int> reportKeys = [];
  void setReportKeys(reportId) {
    reportKeys.add(reportId);
  }

  // Map<dynamic, dynamic> reportData = {};
// TODO improve data structure
  void generateDisplayList() {
    for (var item in CoursesData.reportsList) {
      String courseInfo = '${item['course_id']} ${item['course_name']}';
      CoursesData.submitStatus = item['submit_status'];
      CoursesData.assignedCourseId = item['ID'];

      for (var report in item['reports']) {
        String reportInfo = '${report['Year']}/${report['Month']} ';
        List display = [
          '$courseInfo $reportInfo',
          item['prof_id'],
          item['status'],
          item['submit_status'],
          item['ID']
        ];

        // Assigning the displayString to the report_id as the key in the map
        displayList[report['report_id']] = display;
        setReportKeys(report['report_id']);
      }
    }

    // Notify listeners after updating displayList
    notifyListeners();
  }
}
