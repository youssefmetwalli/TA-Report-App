import 'package:flutter/material.dart';

class CourseInputDialog extends StatefulWidget {
  @override
  _CourseInputDialogState createState() => _CourseInputDialogState();
}

class _CourseInputDialogState extends State<CourseInputDialog> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameKanaController = TextEditingController();
  final TextEditingController lastNameKanaController = TextEditingController();
  final TextEditingController phoneNumber1Controller = TextEditingController();
  final TextEditingController phoneNumber2Controller = TextEditingController();
  final TextEditingController phoneNumber3Controller = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ユーザー登録'),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField('姓', lastNameController),
                SizedBox(height: 16.0),
                buildTextField('名', firstNameController),
                SizedBox(height: 16.0),
                buildTextField('姓（フリガナ）', lastNameKanaController),
                SizedBox(height: 16.0),
                buildTextField('名（フリガナ）', firstNameKanaController),
                SizedBox(height: 16.0),
                buildPhoneNumberField(),
                SizedBox(height: 16.0),
                buildTextField('会社', companyController, enabled: false),
                SizedBox(height: 16.0),
                buildTextField('部署', departmentController, enabled: false),
                SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle registration logic
                    if (_formKey.currentState!.validate()) {
                      // Your registration logic here
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 112, 218, 115),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    '登録する',
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
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          validator: validate,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            errorStyle: TextStyle(fontSize: 16),
          ),
          style: TextStyle(fontSize: 20.0),
          enabled: enabled,
        ),
      ],
    );
  }

  Widget buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '電話番号',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Flexible(
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  controller: phoneNumber1Controller,
                  validator: validate,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              '-',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(width: 10),
            Flexible(
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  controller: phoneNumber2Controller,
                  validator: validate,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              '-',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(width: 10),
            Flexible(
              child: SizedBox(
                width: 200,
                child: TextFormField(
                  validator: validate,
                  controller: phoneNumber3Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return '(必須)';
    }
    return null;
  }
}
