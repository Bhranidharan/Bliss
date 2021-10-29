import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messager_clone/helperfunctions/sharedpref_helper.dart';
import 'package:messager_clone/services/auth.dart';
import 'package:messager_clone/services/database.dart';
import 'package:messager_clone/views/chatscreen.dart';
import 'package:messager_clone/views/profile.dart';
import 'package:messager_clone/views/signin.dart';
import 'package:firebase_core/firebase_core.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
        /*onTap: () {
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
        },*/
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
        title: Text("User Profile"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        myProfilePic!,
                      ),
                      backgroundColor: Colors.transparent,
                      radius: 50,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 35,
                thickness: 1,
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Column(
                            children: [
                              Text(
                                "${myName!}",
                                style: TextStyle(
                                  color: Colors.pink[300],
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 55, right: 25),
                      child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          "This is not your username or pin . this name will be visible to your chat contact",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 35,
                      thickness: 1,
                      color: Colors.grey,
                      indent: 25,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Icon(
                            Icons.account_circle_sharp,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            "${myUserName!}",
                            style: TextStyle(
                              color: Colors.pink[300],
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 55, right: 25),
                      child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          "This is your username . Using this you can communicate with other users",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 35,
                      thickness: 1,
                      color: Colors.grey,
                      indent: 25,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Icon(
                              Icons.mail_rounded,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "${myEmail!}",
                              style: TextStyle(
                                color: Colors.pink[300],
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
