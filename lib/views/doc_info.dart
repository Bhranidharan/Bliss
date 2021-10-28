import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:messager_clone/helperfunctions/sharedpref_helper.dart';
import 'package:messager_clone/services/database.dart';
import 'package:messager_clone/views/chatscreen.dart';

class DoctorDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DoctorDetailState();
}

class _DoctorDetailState extends State<DoctorDetailPage> {
  Stream<QuerySnapshot> userStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  String? myName, myProfilePic, myUserName, myEmail;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUsername();
    myEmail = await SharedPreferenceHelper().getUserEmail();
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget searchListUserTile(
      {required String profileUrl, name, username, email}) {
    print("Albert");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: GestureDetector(
        onTap: () {
          print("hello Tesla");
          var myUser = myUserName;
          if (myUser != null) {
            var chatRoomId = getChatRoomIdByUsernames(myUser, username);

            Map<String, dynamic> chatRoomInfoMap = {
              "users": [myUserName, username]
            };

            databaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(username, name)));
        },
      ),
    );
  }

  Widget searchUsersList(BuildContext context) {
    print('hello Nikola');
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return searchListUserTile(
                  profileUrl: ds["imgUrl"],
                  name: ds["name"],
                  email: ds["email"],
                  username: ds["username"]);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.pink,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        /*actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 205,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Container(
                margin: EdgeInsets.only(left: 30, bottom: 30),
                child: Column(
                  children: [
                    Row(
                      children: [
                        /*Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Image.asset(
                            "assets/dr_1.png",
                          ),
                        ),*/
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text(
                                  'Dr. Fred Mask',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Heart surgen',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Rating: 4.5',
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 15,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RaisedButton(
                            onPressed: () {
                              print("Tesla");
                              searchUsersList(context);
                            },
                            color: Colors.pink[300],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Chat",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 30),
              child: Text(
                'April 2020',
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 20, right: 20),
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  demoDates("Mon", "21", true),
                  demoDates("Tue", "22", false),
                  demoDates("Wed", "23", false),
                  demoDates("Thur", "24", false),
                  demoDates("Fri", "25", false),
                  demoDates("Sat", "26", false),
                  demoDates("Sun", "27", false),
                  demoDates("Mon", "28", false),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, top: 30),
              child: Text(
                'Morning',
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 2.7,
                children: [
                  doctorTimingsData("08:30 AM", true),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, top: 30),
              child: Text(
                'Evening',
                style: TextStyle(
                  color: Color(0xff363636),
                  fontSize: 25,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 20),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                physics: NeverScrollableScrollPhysics(),
                childAspectRatio: 2.6,
                children: [
                  doctorTimingsData("08:30 AM", true),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                  doctorTimingsData("08:30 AM", false),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 54,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x17000000),
                    offset: Offset(0, 15),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Text(
                'Make An Appointment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget demoDates(String day, String date, bool isSelected) {
    return isSelected
        ? Container(
            width: 70,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(7),
                  child: Text(
                    date,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        : Container(
            width: 70,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Color(0xffEEEEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(7),
                  child: Text(
                    date,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
  }

  Widget doctorTimingsData(String time, bool isSelected) {
    return isSelected
        ? Container(
            margin: EdgeInsets.only(left: 20, top: 10),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 2),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Text(
                    '08:30 AM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(left: 20, top: 10),
            decoration: BoxDecoration(
              color: Color(0xffEEEEEE),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 2),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Text(
                    '08:30 AM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
