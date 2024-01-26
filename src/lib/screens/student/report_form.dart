import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';

class ReportForm extends StatelessWidget {
  ReportForm({Key? key}) : super(key: key);

  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> launchPDFExport() async {
    final Uint8List? screenshot = await _screenshotController.capture();

    if (screenshot != null) {
      final pdf = pdfWidgets.Document();

      // Add content to the PDF document
      pdf.addPage(
        pdfWidgets.Page(
          build: (context) {
            return pdfWidgets.Center(
              child: pdfWidgets.Image(
                pdfWidgets.MemoryImage(screenshot),
                fit: pdfWidgets.BoxFit.contain,
              ),
            );
          },
        ),
      );

      // Get the directory for storing the PDF file
      final directory = await path_provider.getApplicationDocumentsDirectory();
      final path = '${directory.path}/ta_report.pdf';

      // Save the PDF to a file
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      print('PDF Exported: $path');
    } else {
      print('Error: Unable to capture screenshot');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data
    List<String> select =
        List<String>.generate(10, (index) => 'Assistance in lectures');
    List<String> companyName =
        List<String>.generate(10, (index) => '2024-01-08');
    List<String> phoneNumber = List<String>.generate(10, (index) => '9:00');
    List<String> fax = List<String>.generate(10, (index) => '1:00');
    List<String> address = List<String>.generate(10, (index) => '14:00');

    return Scaffold(
      appBar: AppBar(
        title: const Text('SE01 BIG DATA    OCTOBER'),
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
      body: Screenshot(
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
                        child:
                            Text('Date', style: TextStyle(color: Colors.white)),
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
              for (int i = 0; i < 10; i++)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchPDFExport();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.picture_as_pdf),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
