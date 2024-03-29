import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UpdateRecord extends StatefulWidget {
  const UpdateRecord({Key? key, required this.SensorsKey}) : super(key: key);

  final String SensorsKey;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final currentController = TextEditingController();
  final totalLitersController = TextEditingController();
  final voltageController = TextEditingController();

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('Sensors').child(widget.SensorsKey);
    getSensorsData();
  }

  void getSensorsData() async {
    DataSnapshot snapshot = (await dbRef.once()) as DataSnapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic> sensors = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        currentController.text = (sensors['Current'] ?? '').toString();
        totalLitersController.text = (sensors['Total Liters'] ?? '').toString();
        voltageController.text = (sensors['Voltage'] ?? '').toString();
      });
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
              controller: currentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Usage of current:'),
            ),
            TextField(
              controller: totalLitersController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Liters of water Usage:'),
            ),
            TextField(
              controller: voltageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Voltage Usage:'),
            ),
            ElevatedButton(
              onPressed: () {
                dbRef.update({
                  'Current': int.tryParse(currentController.text) ?? 0,
                  'Total Liters': int.tryParse(totalLitersController.text) ?? 0,
                  'Voltage': int.tryParse(voltageController.text) ?? 0,
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
