import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

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
        title: const Text('Admin Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Handle logout button press
              // Add your logout logic here
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 78, 177, 204),
                Color.fromARGB(255, 0, 128, 255),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 205, 242, 255),
              Color.fromARGB(255, 219, 241, 255),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0), // Add padding on all sides
          child: ListView.separated(
            itemCount: itemList.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8.0); // Adjust the height of the separator
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black, // Border color
                    width: 1.0, // Border width
                  ),
                  borderRadius: const BorderRadius.all(
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 0, 0, 255),
                    Color.fromARGB(255, 0, 128, 255),
                  ],
                ),
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
