import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class Breathing_Exe extends StatefulWidget {

  
   Breathing_Exe({Key? key}) : super(key: key);

  @override
  _Breathing_ExeState createState() => _Breathing_ExeState();
}

class _Breathing_ExeState extends State<Breathing_Exe> {

  static String videoID = 'N2wR1OWhD4s';
 
  
 
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: videoID,
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,startAt: 6,controlsVisibleAtStart: true,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: Colors.pink,
        home: Scaffold(
            backgroundColor: Colors.pink,
            appBar: AppBar(title: Text("Breathing Exercises",style: TextStyle(fontFamily: 'Roboto'),),
              backgroundColor: Colors.pink,
              elevation: 0,
            ),
            body: Material(
              child: Container(
                
                height: MediaQuery.of(context).size.height,
                
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Pranayama", style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20),),
                      ),Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text("Pranayama is the practice of breath regulation. It’s a main component of yoga, an exercise for physical and mental wellness.\n\nIn Sanskrit, “prana” means life energy and “yama” means control.\n\nThe practice of pranayama involves breathing exercises and patterns.\n\nYou purposely inhale, exhale, and hold your breath in a specific sequence.In yoga, pranayama is used with other practices like physical postures (asanas) and meditation (dhyana).\n\nTogether, these practices are responsible for the many benefits of yoga.",style: TextStyle(fontSize: 20,letterSpacing: 0.2),),
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
                       Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Text("Importance of Pranayama", style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: 20),),
                       ),
                       SizedBox(height: 10,),
                       Card(shadowColor: Colors.pink,child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text("1. Decreases stress\n\n2. Improves sleep quality\n\n3. Increases mindfulness\n\n4. Enhances cognitive performance\n\nPranayama, or breath control, is a main component of yoga. It’s frequently practiced with yoga postures and meditation.The goal of pranayama is to strengthen the connection between your body and mind.According to research, pranayama can promote relaxation and mindfulness. It’s also proven to support multiple aspects of physical health, including lung function, blood pressure, and brain function.",style: TextStyle(fontSize: 20,letterSpacing: 0.2),),
                       )), 
                    ],
                  ),
                ),
              ),
            ),
                    ),
                  );
           
  }
}
