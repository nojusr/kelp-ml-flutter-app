import 'package:flutter/cupertino.dart';
import 'package:meme_machine/components/kelpLoadingIndicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:async/async.dart';

// NOTE: this is just a nicer wrapper for a video player, which can play audio
// by default.

class KelpAudioPlayer extends StatefulWidget {
  @override
  KelpAudioPlayerState createState() => KelpAudioPlayerState();

  const KelpAudioPlayer({
    Key key,
    this.route,

  }):super(key:key);

  final String route;

}

class KelpAudioPlayerState extends State<KelpAudioPlayer> with SingleTickerProviderStateMixin {
  VideoPlayerController controller; // main audio controller
  bool isMenuOpen = true;
  Widget menuChildWidget; // the audio control widget
  Widget centerIcon; // just an icon
  AnimationController playPauseController; // used in the play/pause anim


  int minutes;
  int seconds;

  String vid_len; // text representation of audio duration

  @override
  void initState() {
    super.initState();

    playPauseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );

    controller = VideoPlayerController.network(widget.route)
      ..initialize().then((_) {

        int vid_len_minutes = (controller.value.duration.inSeconds/60).floor();
        int vid_len_seconds = (controller.value.duration.inSeconds%60).floor();
        if (vid_len_seconds < 10) {
          vid_len = vid_len_minutes.toString() + ":0" + vid_len_seconds.toString();
        } else {
          vid_len = vid_len_minutes.toString() + ":" + vid_len_seconds.toString();
        }


        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    controller.addListener(() {
      setState(() {
        minutes = (controller.value.position.inSeconds/60).floor();
        seconds = (controller.value.position.inSeconds%60).floor();
      });
    });

    // assume video is initialized at this point



  }


  @override
  void dispose() {
    playPauseController.dispose();
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if (controller.value.initialized) {

      String current_time;

      if (seconds < 10) {
        current_time = minutes.toString() + ":0" + seconds.toString();
      } else {
        current_time = minutes.toString() + ":" + seconds.toString();
      }

      centerIcon = Icon(
        Icons.music_note,
        size: 55,
      );

      menuChildWidget = Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 20, left: 10, right: 10,),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).dialogBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                VideoProgressIndicator(
                  controller,
                  colors: VideoProgressColors(
                    playedColor: Theme.of(context).accentColor,
                    bufferedColor: Theme.of(context).accentColor.withOpacity(0.4),
                    backgroundColor: Theme.of(context).accentColor.withOpacity(0.3),
                  ),
                  allowScrubbing: true,
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                ),

                Container(
                  padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Row(
                    children: <Widget>[
                      Text(current_time),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(vid_len),
                        ),
                      ),
                    ],
                  ),
                ),




                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    IconButton(
                      iconSize: 40,
                      splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                      icon: Icon(
                        Icons.skip_previous,
                      ),
                      onPressed: () {
                        int currentPos = controller.value.position.inSeconds;
                        controller.seekTo(Duration(seconds: currentPos-5));
                      },
                    ),
                    IconButton(
                      iconSize: 50,
                      splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: playPauseController,
                      ),
                      onPressed: () {
                        if (controller.value.isPlaying == true) {
                          playPauseController.reverse();
                          controller.pause();
                        } else {
                          playPauseController.forward();
                          controller.play();
                        }
                      },
                    ),
                    IconButton(
                      iconSize: 40,
                      splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                      icon: Icon(
                        Icons.skip_next,
                      ),
                      onPressed: () {
                        int currentPos = controller.value.position.inSeconds;
                        controller.seekTo(Duration(seconds: currentPos+5));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      centerIcon = kelpLoadingIndicator();
      menuChildWidget = Container(height: 0, width: 0,);
    }
    
    return Stack(
      children: <Widget>[
       Center(
          child: centerIcon,
        ),
        menuChildWidget,
      ],
    );
  }
}