import 'package:flutter/cupertino.dart';
import 'package:meme_machine/components/kelpLoadingIndicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer' as developer;
import 'package:async/async.dart';

class KelpVideoPlayer extends StatefulWidget {
  @override
  KelpVideoPlayerState createState() => KelpVideoPlayerState();

  const KelpVideoPlayer({
    Key key,
    this.route,

  }):super(key:key);

  final String route;

}

class KelpVideoPlayerState extends State<KelpVideoPlayer> with SingleTickerProviderStateMixin {
  VideoPlayerController controller; // main video controller
  bool isMenuOpen = true;
  Widget menuChildWidget; // the video control widget
  RestartableTimer menuTimer; // a timer for making the video control widget dissapear after inactivity
  AnimationController playPauseController; // used in the play/pause anim


  int minutes;
  int seconds;

  String vid_len; // text representation of video duration

  @override
  void initState() {
    super.initState();

    playPauseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );

    menuTimer = RestartableTimer(Duration(seconds: 3), () {
      setState(() {
        isMenuOpen = false;
      });
    });

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
    menuTimer.cancel();
    playPauseController.dispose();
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {



    if (isMenuOpen == true && controller.value.initialized) {

      String current_time;

      if (seconds < 10) {
        current_time = minutes.toString() + ":0" + seconds.toString();
      } else {
        current_time = minutes.toString() + ":" + seconds.toString();
      }




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
                        menuTimer.reset();

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
                        menuTimer.reset();
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
                        menuTimer.reset();

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
    }

    return Stack(
      children: <Widget>[

        GestureDetector(

          onTap: () {
            setState(() {
              isMenuOpen = true;
            });
            menuTimer.reset();
          },

          child: Center(
            child: controller.value.initialized
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  )
                : kelpLoadingIndicator(),
          ),
        ),



        AnimatedOpacity(
          onEnd: () {
            if (isMenuOpen == false) {
              setState(() {
                menuChildWidget = Container(height: 0,);
              });
            }
          },
          opacity: isMenuOpen ? 1.0 : 0.0,
          duration: Duration(milliseconds: 225),
          child: menuChildWidget,
        ),

      ],
    );
  }
}