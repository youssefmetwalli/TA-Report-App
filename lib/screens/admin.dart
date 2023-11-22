import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Sample list for the body
  List<String> itemList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  // Sample list of notifications
  List<String> notifications = [
    'Notification 1',
    'Notification 2',
    'Notification 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle logout button press
              // Add your logout logic here
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0), // Add padding on all sides
        child: ListView.separated(
          itemCount: itemList.length,
          separatorBuilder: (context, index) {
            return SizedBox(height: 8.0); // Adjust the height of the separator
          },
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0), // Border radius
                ),
              ),
              child: ListTile(
                title: Text(itemList[index]),
                onTap: () {
                  // Handle the tap on an item
                  print('Tapped on: ${itemList[index]}');
                  // Add your item handling logic here
                },
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            for (var notification in notifications)
              ListTile(
                title: Text(notification),
                onTap: () {
                  // Handle the tap on a notification
                  print('Tapped on: $notification');
                  // Add your notification handling logic here
                },
              ),
          ],
        ),
      ),
    );
  }
}
