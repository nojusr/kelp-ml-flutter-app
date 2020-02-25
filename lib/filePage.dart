import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/fileCard.dart';
import './components/kelpLoadingIndicator.dart';
import './util/kelpApi.dart';
import './util/layoutGenerator.dart';

class filePage extends StatefulWidget {

  @override
  filePageState createState() => filePageState();
}



class filePageState extends State<filePage> {
  Future list;

  Future layout;

  @override
  void initState() {
    super.initState();
    list = kelpApi.fetchFileList();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: list,
      builder: (context, snapshot) {
        Widget output;

        bool shouldShow = false;

        if (snapshot.hasData) {

          shouldShow = true;
          Future<Widget> layout = layoutGenerator.generateFileLayout(context, snapshot.data);

          output = FutureBuilder(
            future: layout,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data;
              } else {
                return Container(height: 0, width: 0,);
              }
            },
          );
        } else if (snapshot.hasError) {
          output = Center(child:Text("Failed to load files: ${snapshot.error}", style: TextStyle(color: Colors.white, fontSize: 8,)));
        } else {
          output = Center(child:kelpLoadingIndicator(),);
          shouldShow = false;
        }

        return AnimatedCrossFade(
          crossFadeState: shouldShow ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: output,
          secondChild: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(child:kelpLoadingIndicator(),),
          ),

          duration: Duration(milliseconds: 250),
        );

      },
    );
  }
}