import 'package:flutter/material.dart';

class CourseInputDialog extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CourseInputDialogState createState() => _CourseInputDialogState();
}

class _CourseInputDialogState extends State<CourseInputDialog> {
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController instructorNameController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                      child: buildTextField(
                        'Student Name',
                        studentNameController,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: buildTextField('Student ID', studentIDController),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField(
                        'Course Name',
                        courseNameController,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: buildTextField(
                        'Instructor Name',
                        instructorNameController,
                        enabled: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle registration logic
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
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
                    'Add Course',
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
}
