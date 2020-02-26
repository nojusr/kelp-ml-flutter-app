import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import './components/kelpLoadingIndicator.dart';
import './util/kelpApi.dart';
import './util/layoutGenerator.dart';
import './util/selectionManager.dart';

class filePage extends StatefulWidget {

  @override
  filePageState createState() => filePageState();
}


class filePageState extends State<filePage> {
  Future list;

  Future layout;

  SelectionManager manager = new SelectionManager();
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    manager.addListener(() {
      setState(() {
        isSelecting = manager.selectionActive;
        list = kelpApi.fetchFileList();
      });
    });
    list = kelpApi.fetchFileList();
  }

  @override
  void dispose() {
    //manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    developer.log("rebuildin");

    return FutureBuilder(
      future: list,
      builder: (context, snapshot) {
        Widget output;

        bool shouldShow = false;

        if (snapshot.hasData) {
          shouldShow = true;
          Future<Widget> layout = layoutGenerator.generateFileLayout(
              context, manager, snapshot.data);


          output = FutureBuilder(
            future: layout,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (isSelecting) {
                  return SafeArea(
                    child: Stack(
                      children: <Widget>[

                        snapshot.data,
                        AnimatedContainer(
                          height: 60,
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(10),
                          duration: Duration(milliseconds: 150),
                          color: Theme
                              .of(context)
                              .canvasColor
                              .withOpacity(0.7),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "selected: " +
                                      manager.getSelectedAmount().toString(),
                                ),
                              ),


                              Align(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                  onPressed: () async {
                                    //List<Future> calls;
                                    for (var id in manager.selectedItemKeys) {
                                      await kelpApi.deleteFile(id);
                                      //calls.add(tmp);
                                    }
                                    //await Future.wait(calls);
                                    manager.clearSelection();
                                  },
                                  color: Theme
                                      .of(context)
                                      .cardColor,
                                  child:
                                  Icon(
                                    Icons.delete_forever,
                                  ),
                                ),
                              ),


                              Align(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                  color: Theme
                                      .of(context)
                                      .cardColor,
                                  child: Icon(
                                    Icons.file_download,
                                  ),
                                ),
                              ),


                              Align(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                  onPressed: () {
                                    manager.clearSelection();
                                  },
                                  color: Theme
                                      .of(context)
                                      .cardColor,
                                  child: Icon(
                                    Icons.close,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SafeArea(
                    child: Stack(
                      children: <Widget>[

                        snapshot.data,
                        AnimatedContainer(
                          height: 10,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 150),
                          color: Colors.transparent,
                        ),

                      ],
                    ),
                  );
                }
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