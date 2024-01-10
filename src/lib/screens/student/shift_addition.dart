import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_report_app/screens/login.dart';
import 'package:ta_report_app/screens/student/report_form.dart';
import 'package:http/http.dart' as http;
import 'components/break_time.dart';

class CurrentReport {
  static String reportId = '';

  static void setReportId(String id) {
    reportId = id;
  }
}

class ShiftAddition extends StatefulWidget {
  final int reportId;
  const ShiftAddition({Key? key, required this.reportId}) : super(key: key);

  @override
  State<ShiftAddition> createState() => _ShiftAdditionState();
}

class _ShiftAdditionState extends State<ShiftAddition> {
  List<ShiftData> shifts = [
    ShiftData(
      breakTimeController: TextEditingController(text: "00:00"),
      categoryController: TextEditingController(text: ""),
      dateController: TextEditingController(text: ""),
      endTimeController: TextEditingController(text: ""),
      startTimeController: TextEditingController(text: ""),
    )
  ];
  int? selectedRowIndex;

  @override
  void initState() {
    super.initState();
    CurrentReport.setReportId(widget.reportId.toString());
    fetchShifts();
  }

  Future<void> fetchShifts() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/shifts/getall'),
        body: {'report_id': CurrentReport.reportId},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          final List<dynamic> shiftDataList = data['result'];
          setState(() {
            shifts = shiftDataList
                .map((shiftData) => ShiftData.fromJson(shiftData))
                .toList();
          });
          print('Shifts fetched successfully');
        } else {
          print('Failed to fetch shifts. Message: ${data['message']}');
        }
      } else {
        print('Failed to fetch shifts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    }
  }

  Future<void> addShift() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/shifts/add'),
        body: {
          'date': shifts[0].dateController.text,
          'start_time': shifts[0].startTimeController.text,
          'end_time': shifts[0].endTimeController.text,
          'break_time': shifts[0].breakTimeController.text,
          'work_category': shifts[0].categoryController.text,
          'report_id': CurrentReport.reportId,
          'student_status': 0
        },
      );

      if (response.statusCode == 200) {
        // Course added successfully
        print('Shift added successfully');
      } else {
        // Handle errors
        print('Failed to shift. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print('Error: $error');
    }
  }

  void addShiftFromRow() {
    addShift();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shifts'),
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
                Color.fromARGB(255, 0, 64, 0),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 211, 247, 211),
              Color.fromARGB(255, 201, 231, 201),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (int index = 0; index < shifts.length; index++)
                  Column(
                    children: [
                      ShiftRow(
                        shiftData: shifts[index],
                        onAddEditShift: () {
                          setState(() {
                            if (!shifts[index].isEditMode) {
                              shifts.insert(
                                  index,
                                  ShiftData(
                                    breakTimeController:
                                        TextEditingController(text: "00:00"),
                                    categoryController: TextEditingController(
                                        text: 'Assistance in lectures'),
                                    dateController:
                                        TextEditingController(text: ""),
                                    endTimeController:
                                        TextEditingController(text: ""),
                                    startTimeController:
                                        TextEditingController(text: ""),
                                  ));
                            }
                            shifts[index].isEditMode =
                                !shifts[index].isEditMode;
                            selectedRowIndex = index;
                          });
                        },
                        isSelected: selectedRowIndex == index,
                        addShiftCallback: addShift,
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ReportForm(),
            ),
          );
        },
        label: const Text('Create Report'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class ShiftRow extends StatefulWidget {
  final ShiftData shiftData;
  final VoidCallback onAddEditShift;
  final bool isSelected;
  final VoidCallback? addShiftCallback;

  const ShiftRow({
    Key? key,
    required this.shiftData,
    required this.onAddEditShift,
    required this.isSelected,
    this.addShiftCallback,
  }) : super(key: key);

  @override
  _ShiftRowState createState() => _ShiftRowState();
}

class _ShiftRowState extends State<ShiftRow> {
  DateTime? selectedDate;

  List<String> workCategories = [
    'Assistance in lectures',
    'Assistance in exam proctoring',
    'Assistance in making teaching materials',
    'Assistance in grading',
    'Other',
  ];

  bool validateTime() {
    bool isValid = true;

    List<TextEditingController> timeControllers = [
      widget.shiftData.startTimeController,
      widget.shiftData.endTimeController,
    ];

    for (TextEditingController controller in timeControllers) {
      String timeText = controller.text;
      TimeOfDay selectedTime = TimeOfDay(
        hour: int.parse(timeText.split(':')[0]),
        minute: int.parse(timeText.split(':')[1]),
      );

      // Check if the selected time is between 00:00 and 07:00 AM
      if (selectedTime.hour < 7) {
        isValid = false;
        break;
      }
    }

    return isValid;
  }

  void _showWorkCategoryDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: workCategories.map((String category) {
            return ListTile(
              title: Text(category),
              onTap: () {
                setState(() {
                  widget.shiftData.categoryController.text = category;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              _showWorkCategoryDropdown(context);
            },
            child: const InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Work Category',
              ),

              // child: DropdownButtonHideUnderline(
              //   child: DropdownButton<String>(
              //     value: widget.shiftData.categoryController.text,
              //     isDense: true,
              //     isExpanded: true,
              //     style: const TextStyle(fontSize: 10),
              //     onChanged: (newValue) {
              //       setState(() {
              //         widget.shiftData.categoryController.text = newValue!;
              //       });
              //     },
              //     items: [
              //       'Assistance in lectures',
              //       'Assistance in exam proctoring',
              //       'Assistance in making teaching materials',
              //       'Assistance in grading',
              //       'Other',
              //     ].map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //     }).toList(),
              //   ),
              // ),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Date',
            ),
            controller: widget.shiftData.dateController,
            readOnly: true,
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                  widget.shiftData.dateController.text =
                      "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
                });
              }
            },
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Start Time',
            ),
            controller: widget.shiftData.startTimeController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                widget.shiftData.startTimeController.text =
                    '${pickedTime.hour}:${pickedTime.minute}';
              }
            },
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: BreakTimePicker(
            controller: widget.shiftData.breakTimeController,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'End Time',
            ),
            controller: widget.shiftData.endTimeController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());

              if (pickedTime != null) {
                widget.shiftData.endTimeController.text =
                    '${pickedTime.hour}:${pickedTime.minute}';
              }
            },
          ),
        ),
        const SizedBox(width: 8.0),
        ElevatedButton(
          onPressed: () {
            if (validateTime()) {
              widget.onAddEditShift();
              if (widget.addShiftCallback != null) {
                widget
                    .addShiftCallback!(); // Call the callback function if not null
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text(
                      'Selected time must be between 07:00 AM and 11:59 PM.',
                    ),
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
          },
          child: Text(widget.isSelected ? 'Add Shift' : 'Edit Shift'),
        ),
        const SizedBox(width: 8.0),
        // Delete Shift Button
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Deletion'),
                  content:
                      const Text('Are you sure you want to delete this shift?'),
                  actions: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete Shift'),
        ),
      ],
    );
  }
}

class ShiftData {
  late final int? id;
  late final TextEditingController categoryController;
  late final TextEditingController dateController;
  late final TextEditingController breakTimeController;
  late final TextEditingController startTimeController;
  late final TextEditingController endTimeController;
  bool isEditMode = false;
  late final double? workingHours;
  late final int? reportId;

  ShiftData({
    this.id,
    required this.categoryController,
    required this.dateController,
    required this.breakTimeController,
    required this.startTimeController,
    required this.endTimeController,
    this.workingHours,
    this.reportId,
    this.isEditMode = false,
  });

  ShiftData.fromJson(Map<String, dynamic> json)
      : id = json['ID'],
        categoryController = TextEditingController(
          text: json['work_category'] != null
              ? json['work_category'].toString()
              : 'Assistance in lectures',
        ),
        dateController = TextEditingController(text: json['date'] ?? ''),
        breakTimeController =
            TextEditingController(text: json['break_time'] ?? ''),
        startTimeController =
            TextEditingController(text: json['start_time'] ?? ''),
        endTimeController = TextEditingController(text: json['end_time'] ?? ''),
        workingHours = json['working_hours']?.toDouble(),
        reportId = json['report_id'];

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'work_category':
          categoryController.text.isNotEmpty ? categoryController.text : null,
      'date': dateController.text,
      'break_time': breakTimeController.text,
      'start_time': startTimeController.text,
      'end_time': endTimeController.text,
      'working_hours': workingHours,
      'report_id': reportId,
    };
  }
}
