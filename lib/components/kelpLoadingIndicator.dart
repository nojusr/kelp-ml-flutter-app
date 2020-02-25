import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as developer;
import 'dart:async';


class kelpLoadingIndicator extends StatefulWidget {

  @override
  kelpLoadingIndicatorState createState() => kelpLoadingIndicatorState();
}

class kelpLoadingIndicatorState extends State<kelpLoadingIndicator> {


  bool isFlashing = false;

  Timer timer;

  @override
  void initState() {

    timer = new Timer.periodic(new Duration(milliseconds: 250), (Timer timer){
      setState(() {
        isFlashing = !isFlashing;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    TextStyle fstyle = TextStyle(
      color: Theme.of(context).textTheme.body1.color,
      letterSpacing: 1,
      fontFamily: 'monospace',
      height: 1.5,
      fontSize: 5,
      fontWeight: FontWeight.bold,
    );

    if(isFlashing) {
      fstyle = TextStyle(
        color: Colors.transparent,
        letterSpacing: 1,
        fontFamily: 'monospace',
        height: 1.5,
        fontSize: 5,
        fontWeight: FontWeight.bold,
      );
    }


    return
      Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[

            Text(// sorry for this hot mess but afaik there's no other way to do ascii art in flutter/dart
              '''
     ___     
    /\\__\\
   /:/  /
  /:/__/
 /::\\__\\____
/:/\\:::::\\__\\
\\/_|:|~~|~
\ \ \ |:|  |
\ \ \ |:|  |
\ \ \ |:|  |  
    \\|__|''',
              style: TextStyle(
                color: Theme.of(context).textTheme.body1.color,
                letterSpacing: 1,
                fontFamily: 'monospace',
                height: 1.5,
                fontSize: 5,
              ),
            ),
            Text(
              "█",
              style: fstyle,
            ),
          ]
      );
  }

}



