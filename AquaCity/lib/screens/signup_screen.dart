import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_flutter_project/reusable_widget/reusable_widget.dart';
import 'package:my_flutter_project/screens/signin_screen.dart';
import 'package:my_flutter_project/utils/color_utils.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  String _selectedHouse = "House 1"; // Default selection
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('Users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                  "Your name",
                ),
                SizedBox(height: 20),
                reusableTextField(
                  "Enter Email Id",
                  Icons.email_outlined,
                  false,
                  _emailTextController,
                  "mail-id",
                ),
                SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                  "password",
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedHouse,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedHouse = newValue!;
                    });
                  },
                  items: <String>['House 1', 'House 2', 'House 3','Admin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                firebaseUIButton(context, "Sign Up", () {
                  if (_userNameTextController.text.isNotEmpty &&
                      _emailTextController.text.isNotEmpty &&
                      _passwordTextController.text.isNotEmpty) {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    )
                        .then((value) {
                      // Inserting data into Firebase Realtime Database
                      Map<String, dynamic> userData = {
                        'username': _userNameTextController.text,
                        'email': _emailTextController.text,
                        'house': _selectedHouse,
                      };

                      dbRef.push().set(userData).then((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Created New Account"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        _userNameTextController.clear();
                        _emailTextController.clear();
                        _passwordTextController.clear();
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to insert data: $error'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    }).catchError((error) {
                      print("Error ${error.toString()}");
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all the fields'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:my_flutter_project/reusable_widget/reusable_widget.dart';
// import 'package:my_flutter_project/screens/signin_screen.dart';
// import 'package:my_flutter_project/utils/color_utils.dart';
// import 'package:flutter/material.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key}) : super(key: key);

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   TextEditingController _passwordTextController = TextEditingController();
//   TextEditingController _emailTextController = TextEditingController();
//   TextEditingController _userNameTextController = TextEditingController();
//   String _selectedHouse = "House 1"; // Default selection
//   late DatabaseReference dbRef;

//   @override
//   void initState() {
//     super.initState();
//     dbRef = FirebaseDatabase.instance.reference().child('Users');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text(
//           "Sign Up",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               hexStringToColor("CB2B93"),
//               hexStringToColor("9546C4"),
//               hexStringToColor("5E61F4"),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
//             child: Column(
//               children: <Widget>[
//                 SizedBox(height: 20),
//                 reusableTextField(
//                   "Enter UserName",
//                   Icons.person_outline,
//                   false,
//                   _userNameTextController,
//                   "Your name",
//                 ),
//                 SizedBox(height: 20),
//                 reusableTextField(
//                   "Enter Email Id",
//                   Icons.email_outlined,
//                   false,
//                   _emailTextController,
//                   "mail-id",
//                 ),
//                 SizedBox(height: 20),
//                 reusableTextField(
//                   "Enter Password",
//                   Icons.lock_outlined,
//                   true,
//                   _passwordTextController,
//                   "password",
//                 ),
//                 SizedBox(height: 20),
//                 DropdownButton<String>(
//                   value: _selectedHouse,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedHouse = newValue!;
//                     });
//                   },
//                   items: <String>['House 1', 'House 2', 'House 3']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//                 SizedBox(height: 20),
//                 firebaseUIButton(context, "Sign Up", () {
//                   if (_userNameTextController.text.isNotEmpty &&
//                       _emailTextController.text.isNotEmpty &&
//                       _passwordTextController.text.isNotEmpty) {
//                     FirebaseAuth.instance
//                         .createUserWithEmailAndPassword(
//                       email: _emailTextController.text,
//                       password: _passwordTextController.text,
//                     )
//                         .then((value) {
//                       // Inserting data into Firebase Realtime Database
//                       Map<String, dynamic> userData = {
//                         'username': _userNameTextController.text,
//                         'email': _emailTextController.text,
//                         'house': _selectedHouse,
//                       };

//                       dbRef.push().set(userData).then((_) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SignInScreen()),
//                         );
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text("Created New Account"),
//                             duration: Duration(seconds: 3),
//                           ),
//                         );
//                         _userNameTextController.clear();
//                         _emailTextController.clear();
//                         _passwordTextController.clear();
//                       }).catchError((error) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Failed to insert data: $error'),
//                             duration: Duration(seconds: 2),
//                           ),
//                         );
//                       });
//                     }).catchError((error) {
//                       print("Error ${error.toString()}");
//                     });
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Please fill all the fields'),
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//                   }
//                 }),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
