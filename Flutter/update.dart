import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateRecord extends StatefulWidget {
  const UpdateRecord({Key? key, required this.studentKey}) : super(key: key);

  final String studentKey;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final userNameController = TextEditingController();
  final userPasswordController = TextEditingController(); // Added for password

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('Students').child(widget.studentKey);
    getStudentData();
  }

  void getStudentData() async {
    DataSnapshot snapshot = await dbRef.get();

    if (snapshot.value != null) {
      Map student = snapshot.value as Map;
      userNameController.text = student['name'];
      userPasswordController.text = student['password']; // Set password
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updating record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: userPasswordController, // Use password controller
              decoration: const InputDecoration(labelText: 'Password'), // Change label
            ),
            ElevatedButton(
              onPressed: () {
                dbRef.update({
                  'name': userNameController.text,
                  'password': userPasswordController.text, // Update password
                });
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
