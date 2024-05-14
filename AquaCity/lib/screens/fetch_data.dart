import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/screens/signin_screen.dart';
import 'package:my_flutter_project/utils/color_utils.dart';

class FetchData extends StatefulWidget {
  final String selectedHouse;
  final String email;
  const FetchData({Key? key, required this.selectedHouse, required this.email}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  late DatabaseReference reference;

  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.reference().child('Sensors');
    print(widget.selectedHouse);
  }

  Widget listItem(Map<dynamic, dynamic> Sensors) {
    return Dismissible(
      key: Key(Sensors['key']),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Edit action
        } else if (direction == DismissDirection.endToStart) {
          reference.child(Sensors['key']).remove();
        }
      },
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20.0),
        child: Icon(Icons.edit, color: const Color.fromRGBO(149, 70, 196, 1)),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: const Color.fromRGBO(149, 70, 196, 1)),
      ),
      child: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        height: 150,
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '             ${Sensors['Location']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                selectionColor: Color.fromARGB(0, 0, 0, 1),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Units Consumed: ${Sensors['Energy']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Total Liters of water Usage: ${Sensors['Total Liters']}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetching data'),
        backgroundColor: Color.fromRGBO(203, 43, 147, 1),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
  child: FirebaseAnimatedList(
    query: reference,
    itemBuilder: (BuildContext context, DataSnapshot snapshot,
        Animation<double> animation, int index) {
      if (snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> Sensors = snapshot.value as Map<dynamic, dynamic>;
        Sensors['key'] = snapshot.key;
        // print(Sensors['Location']);
        if(widget.email == "admin@gmail.com" && widget.selectedHouse=='Admin'){
          return listItem(Sensors);
        }
        else if(Sensors['Location']==widget.selectedHouse.replaceAll(' ', '')){
          return listItem(Sensors);
        }
        
        else{
          return SizedBox(height: 20);
        }
        
      } else {
        return Container();  // Return an empty widget when snapshot.value is not a Map
      }
    },
  ),
),

            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Signed out'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignInScreen()));
                  }).catchError((error) {
                    print("Error signing out: $error");
                  });
                },
                child: Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
