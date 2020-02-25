import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './util/kelpApi.dart';
import './util/fileTypePicker.dart';
import './components/kelpLoadingIndicator.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

class fileViewPage extends StatefulWidget {

  const fileViewPage({
    Key key,
    this.item,
    this.fg = const Color(0xFFFFFFFF),
  }):super(key:key);

  final FileItem item;
  final Color fg;

  @override
  fileViewPageState createState() => fileViewPageState();
}



class fileViewPageState extends State<fileViewPage> {

  bool hasBeenInitialized = false;
  bool shouldShow = false;
  bool isClosing = false;

  @override
  Widget build(BuildContext context) {

    Widget mainScreen;

    if (fileTypePicker.checkIfPreviewPossible(widget.item.filetype) == "null") {
      mainScreen = Expanded(
          child: Center(
            child: Hero(
              tag: widget.item.id+"_icon",
              child: fileTypePicker.generateIcon(widget.item.filetype, widget.fg),
            ),
          )
      );
    } else if (isClosing == false){
      mainScreen = Expanded(
        child: FutureBuilder(
          future: kelpApi.fetchFileWidget(context, widget.item),
          builder: (context, snapshot) {
            Widget output;

            shouldShow = false;

            if (snapshot.hasData) {
              output = snapshot.data;
              if (isClosing){
                shouldShow = false;
              } else {
                shouldShow = true;
              }

            } else if (snapshot.hasError) {
              output = Center(
                child:Text(
                  "Failed to load file preview: ${snapshot.error}",
                ),
              );
            } else {
              output = Center(
                child: kelpLoadingIndicator(),
              );
              shouldShow = false;
            }

            return AnimatedCrossFade(
              crossFadeState: shouldShow ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: output,
              secondChild: Container(height: 0,),

              duration: Duration(milliseconds: 250),
            );
          },
        ),
      );
    } else {
      mainScreen = Container(
        height: 0,
      );
    }


    if (hasBeenInitialized == false) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Theme
            .of(context)
            .canvasColor
            .computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
        statusBarColor: Theme
            .of(context)
            .canvasColor,
        systemNavigationBarColor: Theme
            .of(context)
            .canvasColor,
      ));
      setState(() {
        hasBeenInitialized = true;
      });
    }

    developer.log(mainScreen.toString());

    return
      WillPopScope(
        onWillPop: () async {
          developer.log("POPPIN");
          setState(() {
            isClosing = true;
            //shouldShow = false;
          });


          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarIconBrightness: Theme
                .of(context)
                .canvasColor
                .withOpacity(0.5)
                .computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
            statusBarColor: Theme
                .of(context)
                .canvasColor.withOpacity(0.5),
            systemNavigationBarColor: Theme
                .of(context)
                .primaryColor,
          ));
          return true;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Theme.of(context).canvasColor,
                  padding: EdgeInsets.only(left: 10, right: 10, top:20, bottom: 20),
                  alignment: Alignment.topCenter,
                  child: Row (
                    children: <Widget>[

                      Hero(
                        tag: widget.item.id+"_filename",
                        child: Text(
                          widget.item.filename,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Hero(
                            tag: widget.item.id+"_link",
                            child: Text(
                              widget.item.id+"."+widget.item.filetype,
                              style: Theme.of(context).textTheme.body1,
                            ),
                          ),
                        ),
                      ),
                    ],

                  ),

                ),

                mainScreen,

              ],
            ),
          ),
        ),
      );



  }
}