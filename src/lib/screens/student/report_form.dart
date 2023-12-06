import 'package:flutter/material.dart';

import '../login.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({Key? key}) : super(key: key);

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shifts'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginForm(),
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
      body: Column(
        children: [
          // Add the title above the DataTable
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'SE01 BIG DATA ANALYSIS REPORT      OCTOBER',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          // Your other widgets can be added above the Expanded widget
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Column 1')),
                  DataColumn(label: Text('Column 2')),
                  DataColumn(label: Text('Column 3')),
                  DataColumn(label: Text('Column 4')),
                  // Add more DataColumn widgets for additional columns
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Data 1')),
                    DataCell(Text('Data 2')),
                    DataCell(Text('Data 3')),
                    DataCell(Text('Data 4')),
                    // Add more DataCell widgets for additional cells in the row
                  ]),
                  // Add more DataRow widgets for additional rows
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Handle the 'Export Report' action here
          // Add the desired functionality when the button is pressed
          // For example, export the data to Excel
        },
        label: Text('Export Report'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
