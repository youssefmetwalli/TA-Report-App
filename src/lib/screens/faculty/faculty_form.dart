import 'package:flutter/material.dart';
import 'package:ta_report_app/screens/student/shift_addition.dart';

class FacultyForm extends StatefulWidget {
  final List? reportData;
  FacultyForm(
      {Key? key,
      required this.reportData,
      required this.onApprovalStatusChanged,
      required this.reportId})
      : super(key: key);

  final Function(bool) onApprovalStatusChanged;
  final int reportId;

  @override
  // ignore: library_private_types_in_public_api
  _FacultyFormState createState() => _FacultyFormState();
}

class _FacultyFormState extends State<FacultyForm> {
  bool isApproved = false;

  List<ShiftData> shifts = [
    ShiftData(
      breakTimeController: TextEditingController(text: "00:00"),
      categoryController: TextEditingController(text: ""),
      dateController: TextEditingController(text: ""),
      endTimeController: TextEditingController(text: ""),
      startTimeController: TextEditingController(text: ""),
    )
  ];

  @override
  Widget build(BuildContext context) {
    fetchShifts(widget.reportId);
    sortShiftsByDate();
    List<String> select =
        shifts.map((shift) => shift.categoryController.text).toList();
    List<String> companyName =
        shifts.map((shift) => (shift.dateController.text)).toList();
    List<String> phoneNumber =
        shifts.map((shift) => shift.startTimeController.text).toList();
    List<String> fax =
        shifts.map((shift) => shift.breakTimeController.text).toList();
    List<String> address =
        shifts.map((shift) => shift.endTimeController.text).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reportData?[0]),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 150, 171, 248),
                Color.fromARGB(255, 114, 201, 245)
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  isApproved = true;
                });
                widget.onApprovalStatusChanged(isApproved);
                Navigator.of(context).pop();
              },
              child: const Text('Approve')),
          const SizedBox(
            width: 10,
          ),
          ElevatedButton(onPressed: () {}, child: const Text('Lock'))
        ],
      ),
      body: // テーブルを配置
          Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // ヘッダー部分
          TableRow(
            children: [
              TableCell(
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                      child: Text('Work Category',
                          style: TextStyle(color: Colors.white))),
                ),
              ),
              TableCell(
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                      child:
                          Text('Date', style: TextStyle(color: Colors.white))),
                ),
              ),
              TableCell(
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                      child: Text('Start Time',
                          style: TextStyle(color: Colors.white))),
                ),
              ),
              TableCell(
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                      child: Text('Break Time',
                          style: TextStyle(color: Colors.white))),
                ),
              ),
              TableCell(
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                      child: Text('End Time',
                          style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
          // データ部分
          for (int i = 0; i < 10; i++)
            TableRow(
              children: [
                TableCell(
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 50), // ここで最小の高さを設定します。
                    color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text(select[i])),
                  ),
                ),
                TableCell(
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 50), // ここで最小の高さを設定します。
                    color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text(companyName[i])),
                  ),
                ),
                TableCell(
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 50), // ここで最小の高さを設定します。
                    color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text(phoneNumber[i])),
                  ),
                ),
                TableCell(
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 50), // ここで最小の高さを設定します。
                    color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text(fax[i])),
                  ),
                ),
                TableCell(
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 50), // ここで最小の高さを設定します。
                    color: i % 2 == 0 ? Colors.white : Colors.grey[200],
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text(address[i])),
                  ),
                ),
              ],
            ),
        ],
      ),
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
