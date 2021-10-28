import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messager_clone/helperfunctions/sharedpref_helper.dart';
import 'package:messager_clone/services/database.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, name;
  ChatScreen(this.chatWithUsername, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId = "", messageId = "";
  Stream<QuerySnapshot> messageStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  String? myName, myProfilePic, myUserName, myEmail;
  TextEditingController messageTextEditingController = TextEditingController();

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUsername();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    var myUser = myUserName;
    if (myUser != null) {
      chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUser);
    }
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked) {
    if (messageTextEditingController != "") {
      String message = messageTextEditingController.text;
      var lastMessageTs = DateTime.now();
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };
      // messageid
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }
      databaseMethods()
          .addMessage(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendts": lastMessageTs,
          "lastMessageSendBy": myUserName,
        };

        databaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          messageTextEditingController.text = "";
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: sendByMe ? Radius.circular(25) : Radius.circular(0),
            ),
            color: sendByMe ? Colors.pink[500] : Colors.blueGrey[500],
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return chatMessageTile(
                      ds["message"], myUserName == ds["sendBy"]);
                },
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await databaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: FlatButton(
                child: Icon(
                  Icons.video_call,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
        title: Text(widget.name),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey.withOpacity(0.9),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextEditingController,
                      onChanged: (value) {
                        addMessage(false);
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a Mesage",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white)),
                    )),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
