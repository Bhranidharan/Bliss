import 'package:flutter/material.dart';
import 'package:messager_clone/front_screen.dart';
import 'package:messager_clone/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Card(
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 460,
            width: 330,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset(
                    "assets/bliss bold.png",
                    fit: BoxFit.contain,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AuthMethod().SignInWithGoogle(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FrontScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.pink,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Text(
                      "Sign in",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
