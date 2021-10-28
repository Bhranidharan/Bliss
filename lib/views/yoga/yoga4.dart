import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class Yoga4 extends StatelessWidget {
   
  static String videoID = 'q4cD11J8MkQ';
 
  
 
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoID,
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,startAt: 6,controlsVisibleAtStart: true,
    ),
  );
 
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: Colors.red,
      
        appBar: AppBar(centerTitle: true,backgroundColor: Colors.pink,elevation: 0,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Supported bridge Pose',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,)),
          ),
        ),
        body: 
            Material(
              child: Container(
                
                height: MediaQuery.of(context).size.height,
                
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Demo Video", style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: YoutubePlayer(
                      key: ObjectKey(_controller),
                      controller: _controller,
                      actionsPadding: const EdgeInsets.only(left: 16.0),
                      bottomActions: [
                          CurrentPosition(),
                          const SizedBox(width: 10.0),
                          ProgressBar(isExpanded: true),
                          const SizedBox(width: 10.0),
                          RemainingDuration(),
                          FullScreenButton(),
                      ],
                           
                          
                     
                      ),
                       ),
                       SizedBox(height: 10,),
                       Text("Benefitsof Pristhasana", style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20),),
                       SizedBox(height: 10,),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Card(shadowColor: Colors.pink,child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("Aute do excepteur Lorem adipisicing nulla ut sit. Sit esse commodo magna esse consequat ipsum incididunt cupidatat fugiat. Ut anim incididunt Lorem enim qui adipisicing nostrud elit nulla.Labore esse nulla pariatur cillum incididunt ad ea aliquip. Officia aliquip cillum nisi excepteur duis. Et velit mollit nulla nisi excepteur laborum minim exercitation eiusmod ex.",style: TextStyle(fontSize: 20,letterSpacing: 0.2),),
                         )),
                       ), 
                    ],
                  ),
                ),
              ),
            ),
            
          
        );
  }
}