import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student/report_list.dart';

class CourseInputDialog extends StatefulWidget {
  final Function(String, String, String, String) onCourseAdded;

  const CourseInputDialog({Key? key, required this.onCourseAdded})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseInputDialogState createState() => _CourseInputDialogState();
}

class AddedReportData {
  static int reportId = 13;
  static dynamic status = "TA";
  static dynamic assignedId = "";
}

class _CourseInputDialogState extends State<CourseInputDialog> {
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseIDController = TextEditingController();
  final TextEditingController instructorNameController =
      TextEditingController();
  final TextEditingController maximumHoursController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool suggestionsVisible = false;
  Map<String, int> status = {"SA": 0, "TA": 1};

  Future<bool> addCourse() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/courses/add'),
        body: {
          'student_id': UserData.userId,
          'prof_id': instructorNameController.text.toString(),
          'course_id': courseIDController.text.toString(),
          'status': status[statusController.text].toString(),
          'max_hours': maximumHoursController.text,
          'course_name': courseNameController.text.toString(),
          'month': monthController.text.toString(),
          'year': academicYearController.text.toString(),
        },
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['success'] == true && responseData['result'] != null) {
          final int? insertId = responseData['result']['insertId'];

          AddedReportData.reportId = insertId!;
          return true;
        } else {
          print('Failed to add course. ${responseData['message']}');
          _showErrorDialog(
              'ERROR: Failed to add the course. Make sure all the fields are answered correctly and the professor email is correct }');
          return false;
        }
      } else {
        // ignore: avoid_print
        print(
            'Failed to add course. ${responseData['message']} \n Status code: ${response.statusCode}');
        _showErrorDialog(
            'ERROR: Failed to add course. \n Status code: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error: $error');
      _showErrorDialog(
          'ERROR: Failed to add the course. Make sure all the fields are answered correctly and the professor email is correct');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white, // Added to make the close button visible
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Input Course Information',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        'Academic Year',
                        academicYearController,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: buildTextField('Month', monthController),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: buildAutocompleteTextField(
                        'Status',
                        statusController,
                        ['SA', 'TA'],
                      ),
                    ),
                    // const SizedBox(width: 16.0),
                    // Expanded(
                    //   child: buildTextField('Student ID', studentIDController),
                    // ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        'Course Name',
                        courseNameController,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: buildTextField(
                        'Course ID',
                        courseIDController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        'Instructor Email',
                        instructorNameController,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: buildTextField(
                        'Maximum Hours',
                        maximumHoursController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () async {
                    // Handle registration logic
                    if (_formKey.currentState!.validate()) {
                      if (await addCourse()) {
                        widget.onCourseAdded(
                          academicYearController.text,
                          monthController.text,
                          courseNameController.text,
                          courseIDController.text,
                        );

                        setState(() {
                          const StudentScreen();
                        });

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Add Report',
                    style: TextStyle(
                      fontSize: 28.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAutocompleteTextField(String labelText,
      TextEditingController controller, List<String> suggestions) {
    return Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: suggestions[0],
              items: suggestions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  controller.text = newValue!;
                });
              },
            ),
          ],
        ));
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          validator: validate,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            errorStyle: TextStyle(fontSize: 16),
          ),
          style: const TextStyle(fontSize: 20.0),
          enabled: enabled,
        ),
      ],
    );
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required Input';
    }
    return null;
  }

  Widget buildSuggestionTextField(String labelText,
      TextEditingController controller, List<String> suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(height: 8.0),
        Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              // Clear suggestions when focus is lost
              setState(() {
                suggestionsVisible = false;
              });
            }
          },
          child: TextFormField(
            controller: controller,
            validator: validate,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              errorStyle: TextStyle(fontSize: 16),
            ),
            style: const TextStyle(fontSize: 20.0),
            onChanged: (value) {
              // Show/hide suggestions based on user input
              setState(() {
                suggestionsVisible = value.isNotEmpty;
              });
            },
          ),
        ),
        // Suggestions Dropdown
        if (suggestionsVisible)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: suggestions
                  .where((suggestion) => suggestion
                      .toLowerCase()
                      .contains(controller.text.toLowerCase()))
                  .map((suggestion) => ListTile(
                        title: Text(suggestion),
                        onTap: () {
                          // Handle suggestion selection
                          setState(() {
                            controller.text = suggestion;
                            suggestionsVisible =
                                false; // Hide suggestions after selection
                          });
                        },
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
