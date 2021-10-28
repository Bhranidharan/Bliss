import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messager_clone/front_screen.dart';
import 'package:messager_clone/helperfunctions/sharedpref_helper.dart';
import 'package:messager_clone/services/database.dart';
import 'package:messager_clone/views/home.dart';
import 'package:messager_clone/views/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  final FirebaseAuth auth = FirebaseAuth.instance;

  gerCurrentUser() async {
    return await auth.currentUser;
  }

  SignInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSingnIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSingnIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;
    if (result != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails!.email!);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email!.replaceAll("@gmail.com", ""));
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName!);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL!);

      Map<String, dynamic> UserInfoMap = {
        "email": userDetails.email,
        "username": userDetails.email!.replaceAll("@gmail.com", ""),
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL
      };

      databaseMethods()
          .addUserInfoToDB(userDetails.uid, UserInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => FrontScreen()));
      });
    }
  }

  signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    await auth.signOut();
  }
}
