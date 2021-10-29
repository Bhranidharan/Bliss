import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messager_clone/helperfunctions/sharedpref_helper.dart';
import 'package:messager_clone/services/auth.dart';
import 'package:messager_clone/services/database.dart';
import 'package:messager_clone/views/chatscreen.dart';
import 'package:messager_clone/views/home.dart';
import 'package:messager_clone/views/profile.dart';
import 'package:messager_clone/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';

class Home_doctor extends StatefulWidget {
  const Home_doctor({Key? key}) : super(key: key);

  @override
  _Home_doctorState createState() => _Home_doctorState();
}

class _Home_doctorState extends State<Home_doctor> {
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
    return StreamBuilder<QuerySnapshot>(
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
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
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Row(
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
                                  if (searchUsernameEditingController.text !=
                                      "") {
                                    onSearchBtnClick();
                                  }
                                },
                                child: Icon(Icons.search)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              inSearching ? searchUsersList(context) : searchUsersList(context)
            ],
          ),
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
  String? profilePicUrl = "", name = "", username = "";
  getThisUserInfo() async {
    username = widget.chatRoomId!
        .replaceAll(widget.myUsername!, "")
        .replaceAll("_", "");
    QuerySnapshot querySnapshot =
        await databaseMethods().getUserInfo(username!);
    print("Something ${querySnapshot.docs[0].id}");
    name = "${querySnapshot.docs[0]["name"]}";
    //profilePicUrl = "${querySnapshot.docs[0]["imgUrl"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(username!, name!)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  profilePicUrl!,
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 3),
                  Text(widget.lastmessage!)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
