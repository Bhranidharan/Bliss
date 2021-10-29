
import 'package:flutter/material.dart';
import 'package:messager_clone/sleep/sound1.dart';


var yogalist = [
  
];

class Sleep_Home extends StatefulWidget {
  //const Sleep_Home({Key key}) : super(key: key);

  @override
  _Sleep_HomeState createState() => _Sleep_HomeState();
}

class _Sleep_HomeState extends State<Sleep_Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.pink,
        home: Scaffold(
            
            appBar: AppBar(
              backgroundColor: Colors.pink,title: Text("~ SLEEP THERAPY ~"),centerTitle: true,
              elevation: 0,
            ),
            body:Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                          child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/Sleep Music.png"))),
                                    child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Sound1(),
                                ),
                              );
                            },
                          ),
                      )),
                    ),
                       Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                          child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/Sleep 2.png"))),
                                    child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Sound1(),
                                ),
                              );
                            },
                          ),
                      )),
                    ),
                    
                  ]),
              ))));}
}
