import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_project/screens/signin_screen.dart';
//import 'package:my_flutter_project/screens/fetchsign.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  syncData(); // Start listening for Realtime Database changes
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}

void syncData() {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child('Sensors');
databaseReference.onValue.listen((DatabaseEvent event) {
  var data = event.snapshot.value as Map<dynamic, dynamic>?; // Explicitly cast to Map<dynamic, dynamic> or null
  if (data != null) {
    updateFirestore(data); // Update Firestore with the data from Realtime Database
  } else {
    print('Data is null or not in the expected format');
  }
});


}

void updateFirestore(Map<dynamic, dynamic> data) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference collectionReference = firestore.collection('sensors');

  data.forEach((key, value) {
    // Assuming each key corresponds to a document in Firestore
    collectionReference.doc(key).set(value); // Set the document with the corresponding data
  });
}
