import 'package:flutter/material.dart';
import 'package:messager_clone/front_screen.dart';
import 'package:messager_clone/services/auth.dart';
import 'package:messager_clone/views/home.dart';
import 'package:messager_clone/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bliss',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: FutureBuilder(
        future: AuthMethod().gerCurrentUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return FrontScreen();
          } else {
            return SignIn();
          }
        },
      ),
    );
  }
}
