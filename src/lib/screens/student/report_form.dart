import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student/course_input.dart';
import 'package:ta_report_app/screens/student/report_list.dart';
import 'package:ta_report_app/screens/student/shift_addition.dart';
import 'package:http/http.dart' as http;

//edit reports or assigned course's submit status
Future<bool> updateReport(newData, id) async {
  try {
    print(CoursesData.assignedCourseId);
    print(newData);
    final response = await http.put(
      Uri.parse('http://localhost:3000/courses/update'),
      body: {'submit_status': newData, 'id': id.toString()},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (responseData['success'] == true) {
        print("report status updated");
        //screen message
        return true;
      } else {
        print('Failed to update course. ${responseData['message']}');
        return false;
      }
    } else {
      // ignore: avoid_print
      print(
          'Failed to update course. ${responseData['message']} \n Status code: ${response.statusCode}');
      return false;
    }
  } catch (error) {
    // ignore: avoid_print
    print('Erroryyyy: $error');
    return false;
  }
}

class ReportForm extends StatefulWidget {
  final List? reportData; //assigned course data
  ReportForm({Key? key, required this.reportData}) : super(key: key);
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  // final List? reportData; // State variable to store reportData

  @override
  void initState() {
    super.initState();
    // reportData = widget.reportData; // Initialize reportData in initState
  }

  bool buttonDisabled = false; // State variable for button state
  final ScreenshotController _screenshotController = ScreenshotController();

  // get id => null;

  // Future<void> launchPDFExport() async {
  //   final Uint8List? screenshot = await _screenshotController.capture();

  //   if (screenshot != null) {
  //     final pdf = pdfWidgets.Document();

  //     // Add content to the PDF document
  //     pdf.addPage(
  //       pdfWidgets.Page(
  //         build: (context) {
  //           return pdfWidgets.Center(
  //             child: pdfWidgets.Image(
  //               pdfWidgets.MemoryImage(screenshot),
  //               fit: pdfWidgets.BoxFit.contain,
  //             ),
  //           );
  //         },
  //       ),
  //     );

  //     // Get the directory for storing the PDF file
  //     final directory = await path_provider.getApplicationDocumentsDirectory();
  //     final path = '${directory.path}/ta_report.pdf';

  //     // Save the PDF to a file
  //     final file = File(path);
  //     await file.writeAsBytes(await pdf.save());

  //     print('PDF Exported: $path');
  //   } else {
  //     print('Error: Unable to capture screenshot');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    sortShiftsByDate();
    List<String> select =
        shifts.map((shift) => shift.categoryController.text).toList();
    List<String> companyName =
        shifts.map((shift) => formatDate(shift.dateController.text)).toList();
    List<String> phoneNumber =
        shifts.map((shift) => shift.startTimeController.text).toList();
    List<String> fax =
        shifts.map((shift) => shift.breakTimeController.text).toList();
    List<String> address =
        shifts.map((shift) => shift.endTimeController.text).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reportData?[0],
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 228, 228, 228)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 0, 128, 0),
                Color.fromARGB(255, 0, 64, 0),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: widget.reportData?[3] == "Submitted"
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Submission'),
                          content: Text('Are you sure you want to submit?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                updateReport(
                                    "Submitted", widget.reportData?[4]);
                                // Disable the button
                                setState(() {
                                  buttonDisabled = true;
                                });
                                // Navigate to StudentScreen after submitting
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const StudentScreen(),
                                  ),
                                );
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled) ||
                    buttonDisabled ||
                    widget.reportData?[3] == "Submitted") {
                  return Colors.grey; // Change color when disabled
                }
                return Color.fromARGB(255, 45, 159, 229); // Default color
              }),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white, // Text color
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Color.fromARGB(255, 145, 244, 191),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ignore: prefer_interpolation_to_compose_strings
                Text("Name: " + UserData.userDetails['username']),

                Text("ID: ${UserData.userId}"),

                Text(CurrentReport.taStatus),

                Text("Residency: ${UserData.userDetails['status']}"),

                Text(
                    "Instructor Name: ${CurrentReport.reportTitle[1]}"), //=> prof_id
              ],
            ),
          ),
          Screenshot(
            controller: _screenshotController,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: Text('Work Category',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: Text('Date',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: Text('Start Time',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: Text('Break Time',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(8),
                          child: const Center(
                            child: Text('End Time',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < shifts.length; i++)
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 50),
                            color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(select[i])),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 50),
                            color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(companyName[i])),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 50),
                            color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(phoneNumber[i])),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 50),
                            color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(fax[i])),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 50),
                            color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                            padding: const EdgeInsets.all(8),
                            child: Center(child: Text(address[i])),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // launchPDFExport();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.picture_as_pdf),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return '${dateTime.year}/${dateTime.month}/${dateTime.day}';
  }

  void sortShiftsByDate() {
    shifts.sort((a, b) => DateTime.parse(b.dateController.text)
        .compareTo(DateTime.parse(a.dateController.text)));
  }
}
