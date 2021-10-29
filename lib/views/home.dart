import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messager_clone/helperfunctions/sharedpref_helper.dart';
import 'package:messager_clone/services/auth.dart';
import 'package:messager_clone/services/database.dart';
import 'package:messager_clone/sleep/sleep_home.dart';
import 'package:messager_clone/views/breathing_exe.dart';
import 'package:messager_clone/views/chatscreen.dart';

import 'package:messager_clone/views/home_doctor.dart';
import 'package:messager_clone/views/profile.dart';
import 'package:messager_clone/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messager_clone/views/yoga/yoga_main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot> userStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  Stream<QuerySnapshot> chatRoomsStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  bool inSearching = false;
  String? myName, myProfilePic, myUserName, myEmail;

  TextEditingController searchUsernameEditingController =
      TextEditingController();

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

  onSearchBtnClick() async {
    inSearching = true;
    setState(() {});
    userStream = await databaseMethods()
        .getUserByUserName(searchUsernameEditingController.text);
    setState(() {});
  }

  Widget chatRoomsList(BuildContext context) {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return ChatRoomListTile(
                        ds["lastMessage"], ds.id, myUserName);
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  Widget searchListUserTile(
      {required String profileUrl, name, username, email}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: GestureDetector(
        onTap: () {
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
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    profileUrl,
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.pink,
                      ),
                    ),
                    Text(email),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget searchUsersList(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return searchListUserTile(
                      profileUrl: ds["imgUrl"],
                      name: ds["name"],
                      email: ds["email"],
                      username: ds["username"]);
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await databaseMethods().getChatRooms();
    setState(() {});
  }

  onScreenLoaded() async {
    await getMyInfoFromSharedPreference();
    getChatRooms();
  }

  @override
  void initState() {
    onScreenLoaded();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        elevation: 0,
        title: Text("bliss"),
        actions: [
          InkWell(
            onTap: () {
              AuthMethod().signOut();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: FlatButton(
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Text(
                  "Hi, ${myName!}",
                  style: TextStyle(
                    color: Color(0xff363636),
                    fontSize: 25,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, left: 20),
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.pinkAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      child: Text(
                        'Exercises for you',
                        style: TextStyle(
                          color: Color(0xff363636),
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: MediaQuery.of(context).size.width / 1.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image:
                                        AssetImage("assets/SleepBanner.png"))),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Sleep_Home()));
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                            child: Container(
                          width: MediaQuery.of(context).size.width / 1.8,
                          height: MediaQuery.of(context).size.width / 1.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/Breathing Exercises banner.png"))),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Breathing_Exe()));
                            },
                          ),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                            child: Container(
                          width: MediaQuery.of(context).size.width / 1.8,
                          height: MediaQuery.of(context).size.width / 1.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage("assets/yogaBanner.png"))),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => YogaHome()));
                            },
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    Container(
                      child: Text(
                        'No More Stress',
                        style: TextStyle(
                          color: Color(0xff363636),
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      inSearching
                          ? GestureDetector(
                              onTap: () {
                                inSearching = false;
                                searchUsernameEditingController.text = "";
                                setState(() {});
                              },
                              child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_back)),
                            )
                          : Container(),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 3.0,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: SingleChildScrollView(
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: searchUsernameEditingController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "username"),
                                )),
                                GestureDetector(
                                    onTap: () {
                                      if (searchUsernameEditingController
                                              .text !=
                                          "") {
                                        onSearchBtnClick();
                                      }
                                    },
                                    child: Icon(Icons.search)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              inSearching ? searchUsersList(context) : searchUsersList(context)
            ],
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 20.0,
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("${myUserName}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  )),
              accountEmail: Text(myEmail!,
                  style: TextStyle(
                    color: Colors.amber[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  )),
              decoration: BoxDecoration(
                color: Colors.pink[300],
                shape: BoxShape.rectangle,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(myProfilePic!),
                backgroundColor: Colors.transparent,
              ),
            ),
            ListTile(
              title: Text('Chats'),
              leading: Icon(Icons.chat),
              onTap: () {
                AuthMethod().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Home_doctor()));
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              title: Text('Appointment History'),
              leading: Icon(Icons.history),
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              title: Text('Log out '),
              onTap: () {
                AuthMethod().signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
              leading: Icon(Icons.logout),
            ),
            Divider(
              height: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String? lastmessage, chatRoomId, myUsername;
  ChatRoomListTile(this.lastmessage, this.chatRoomId, this.myUsername);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "";

  getThisUserInfo() async {
    username = widget.chatRoomId!
        .replaceAll(widget.myUsername!, "")
        .replaceAll("_", "");
    QuerySnapshot querySnapshot = await databaseMethods().getUserInfo(username);
    print("Something ${querySnapshot.docs[0].id}");
    name = "${querySnapshot.docs[0]["name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(
          profilePicUrl,
          height: 30,
          width: 30,
        ),
        Column(
          children: [Text(name), Text(widget.lastmessage!)],
        )
      ],
    );
  }
}
