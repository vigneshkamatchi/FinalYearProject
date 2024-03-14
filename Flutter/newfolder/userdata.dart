import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  final Map<String, dynamic> userData; // Assuming you have data to display for users

  const UserData({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome User!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Display user data here
            Text('Name: ${userData['name']}'),
            Text('Email: ${userData['email']}'),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}
