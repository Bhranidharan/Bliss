import 'package:flutter/material.dart';
import 'package:messager_clone/views/home.dart';
import 'package:messager_clone/views/home_doctor.dart';
import 'package:messager_clone/views/profile.dart';

void main() {
  runApp(const MyApp_doc());
}

class MyApp_doc extends StatelessWidget {
  const MyApp_doc({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyBottomNavigation(),
    );
  }
}

class MyBottomNavigation extends StatefulWidget {
  const MyBottomNavigation({Key? key}) : super(key: key);

  @override
  _MyBottomNavigationState createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _children = [Home(), Home_doctor(), Profile()];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: new Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: new Text("Chats"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: new Text("Profile"),
          ),
        ],
        onTap: onTappedBar,
        currentIndex: _currentIndex,
      ),
    );
  }
}
