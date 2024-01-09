import 'package:flutter/material.dart';

class AdminForm extends StatelessWidget {
  const AdminForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ダミーのデータ
    List<String> select =
        List<String>.generate(10, (index) => 'Assistance in lectures');
    List<String> companyName =
        List<String>.generate(10, (index) => '2024-01-08');
    List<String> phoneNumber = List<String>.generate(10, (index) => '9:00');
    List<String> fax = List<String>.generate(10, (index) => '1:00');
    List<String> address = List<String>.generate(10, (index) => '14:00');
    ;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SE01 BIG DATA    OCTOBER'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 150, 171, 248),
                Color.fromARGB(255, 254, 187, 255)
              ],
            ),
          ),
        ),
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
}
