import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_project/screens/fetch_data.dart';
import 'package:my_flutter_project/screens/insert_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              width: 300,
              height: 300,
              image: NetworkImage(
                  'https://cdn.pixabay.com/photo/2017/01/07/19/03/icon-1961299_1280.png'),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Smart Home Monitor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InsertData()));
              },
              child: const Text('Create Account'),    //insert data
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 40),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FetchData()));
              },
              child: const Text('sign-in'),    //fetch data
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(300, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
