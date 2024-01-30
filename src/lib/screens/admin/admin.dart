import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_report_app/screens/admin/admin_form.dart';
import 'package:ta_report_app/screens/faculty/faculty_form.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:ta_report_app/screens/student/report_list.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Sample list for the body
  late StudentScreenStateNotifier stateNotifier;
  List<dynamic> itemList = [];

  @override
  void initState() {
    super.initState();
    stateNotifier = StudentScreenStateNotifier();
    // Call the function to fetch reports data when the widget is initialized
    fetchCoursesData("Submitted");
    fetchCoursesData("Faculty Approved");
    fetchCoursesData("Admin Disapproved");
    fetchCoursesData("Faculty Disapproved");
  }

  Future<void> fetchCoursesData(submitStatus) async {
    final url = Uri.parse('http://localhost:3000/courses/submitted/getall');
    final response = await http.post(
      url,
      body: json.encode({'submit_status': submitStatus}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        print(data);
        List<dynamic> newData = List<dynamic>.from(data['result']);

        setState(() {
          itemList.addAll(newData); // Add new data to existing itemList
        });

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
        print("error");
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

  List<bool> approvalStatus = List.generate(4, (index) => false);

  // Controllers for text form fields in the dialog

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => stateNotifier,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Submitted Reports'),
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
                  Color.fromARGB(255, 151, 167, 239),
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
                        if (
                            // notifier.displayList[key]?[3] == "Submitted" ||
                            // notifier.displayList[key]?[3] ==
                            //         "Faculty Approved" ||
                            notifier.displayList[key]?[3] == "Admin Approved" ||
                                notifier.displayList[key]?[3] == "Locked") {
                          // If the submit_status is "submitted", navigate to ReportForm page
                          // and fetch shifts using a function in ReportForm
                          print(key);
                          print(notifier.displayList[key]);
                          await fetchShiftsAndNavigateToReportForm(
                              context, key, notifier.displayList[key]!);
                        } else {
                          print("hereeeeeeeee 333333");
                          print(index);

                          try {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdminForm(
                                  item: notifier.displayList[key]?[0],
                                  onApprovalStatusChanged: (status) {},
                                  // reportData: notifier.displayList[key],
                                  // onApprovalStatusChanged: (status) {
                                  //   _updateApprovalStatus(index, status);
                                  // },
                                  // reportId: key,
                                ),
                              ),
                            );
                          } catch (e) {
                            throw Exception(
                                "Error navigating to FacultyForm: $e");
                          }
                          // If submit_status is not "submitted", navigate to ShiftAddition page
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
      ),
    );
  }

  bool isItemApproved(int index) {
    return approvalStatus[index];
  }

  void _updateApprovalStatus(int index, bool status) {
    setState(() {
      approvalStatus[index] = status;
    });
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
