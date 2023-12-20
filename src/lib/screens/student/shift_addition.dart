import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ta_report_app/screens/login.dart';

import 'components/break_time.dart';

class ShiftAddition extends StatefulWidget {
  const ShiftAddition({Key? key}) : super(key: key);

  @override
  State<ShiftAddition> createState() => _ShiftAdditionState();
}

class _ShiftAdditionState extends State<ShiftAddition> {
  List<ShiftData> shifts = [ShiftData()];
  int? selectedRowIndex;

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
                              shifts.insert(index, ShiftData());
                            }
                            shifts[index].isEditMode =
                                !shifts[index].isEditMode;
                            selectedRowIndex = index;
                          });
                        },
                        isSelected: selectedRowIndex == index,
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
          // Handle the 'Create Report' action here
          // Add the desired functionality when the button is pressed
          // For example, navigate to a new screen for creating a report
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

  const ShiftRow({
    Key? key,
    required this.shiftData,
    required this.onAddEditShift,
    required this.isSelected,
  }) : super(key: key);

  @override
  _ShiftRowState createState() => _ShiftRowState();
}

class _ShiftRowState extends State<ShiftRow> {
  DateTime? selectedDate;

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
      ],
    );
  }
}

class ShiftData {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController breakTimeController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  bool isEditMode = false;
}
