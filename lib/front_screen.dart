import 'package:flutter/material.dart';
import 'package:messager_clone/views/home.dart';
import 'package:messager_clone/views/home_doctor.dart';
import 'package:messager_clone/views/signin.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({Key? key}) : super(key: key);

  @override
  _FrontScreenState createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[100],
        body: Center(
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              height: 460,
              width: 330,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      "assets/bliss bold.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home_doctor()));
                        },
                        color: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Text("Doctor",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        color: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0)),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Text("Patient",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  /*Text(
                "Have an accont? ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),*/
                  /* GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Logi));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),*/
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
