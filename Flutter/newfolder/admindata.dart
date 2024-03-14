import 'package:flutter/material.dart';

class AdminData extends StatelessWidget {
  final Map<String, dynamic> adminData; // Assuming you have data to display for admin

  const AdminData({Key? key, required this.adminData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Display admin data here
            Text('Name: ${adminData['name']}'),
            Text('Email: ${adminData['email']}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
