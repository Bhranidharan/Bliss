import 'package:flutter/material.dart';
import 'package:messager_clone/views/yoga/yoga1.dart';
import 'package:messager_clone/views/yoga//yoga2.dart';
import 'package:messager_clone/views/yoga/yoga3.dart';
import 'package:messager_clone/views/yoga/yoga4.dart';
import 'package:messager_clone/views/yoga/yoga5.dart';

var yogalist = [
  "Wide-Legged Forward Bend Pose (Prasarita Padottanasana)",
  "Lizard Pose (Utthan Pristhasana)",
  "Sphinx Pose (Salamba Bhujangasana)",
  "Supported Bridge Pose (Setu Bandhasana Sarvangasana)",
  "Forward Fold Pose (Uttanasana)",
  "Reclining Bound Angle Pose (Supta Baddha Konasana)"
];



class YogaHome extends StatefulWidget {
  const YogaHome({Key? key}) : super(key: key);

  @override
  _YogaHomeState createState() => _YogaHomeState();
}

class _YogaHomeState extends State<YogaHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.pink,
        home: Scaffold(
            backgroundColor: Colors.pink,
            appBar: AppBar(
              backgroundColor: Colors.pink,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Material(
                  color: Colors.pink,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.list),
                                  title: Text(yogalist[0]),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Yoga1()));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.list),
                                  title: Text(yogalist[1]),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Yoga2()));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.list),
                                  title: Text(yogalist[2]),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Yoga3()));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.list),
                                  title: Text(yogalist[3]),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Yoga4()));
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.list),
                                  title: Text(yogalist[4]),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Yoga5()));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            )));
  }
}
