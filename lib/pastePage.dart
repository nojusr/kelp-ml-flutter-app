import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/fileCard.dart';
import './components/kelpLoadingIndicator.dart';
import './util/kelpApi.dart';
import './util/layoutGenerator.dart';
import './util/selectionManager.dart';

import 'dart:developer' as developer;

class pastePage extends StatefulWidget {

  @override
  pastePageState createState() => pastePageState();
}



class pastePageState extends State<pastePage> {
  Future list;

  Future layout;

  SelectionManager manager;
  bool isSelecting = false;
  bool pasteActionIsLoading = false;

  @override
  void initState() {
    super.initState();

    manager = SelectionManager();

    manager.addListener(() {
      setState(() {
        isSelecting = manager.selectionActive;
        list = kelpApi.fetchPasteList();
      });
    });

    list = kelpApi.fetchPasteList();

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
          Future<Widget> layout = layoutGenerator.generatePasteLayout(context, manager, snapshot.data);

          List ListData = snapshot.data;

          output = FutureBuilder(
            future: layout,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (isSelecting) {
                  return Stack(
                    children: <Widget>[
                      snapshot.data,
                      SafeArea(
                        child: AnimatedContainer(
                          height: 50,
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          duration: Duration(milliseconds: 150),
                          color: Theme
                              .of(context)
                              .canvasColor
                              .withOpacity(0.7),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "selected: " +
                                          manager.getSelectedAmount().toString(),
                                    ),
                                  ),

                                  pasteActionIsLoading == true
                                      ? Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),


                                  )
                                      : Container(height: 0, width: 0,),

                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        //List<Future> calls;
                                        setState(() {
                                          pasteActionIsLoading = true;
                                        });
                                        for (var id in manager.selectedItemKeys) {
                                          developer.log("deleting paste..");
                                          await kelpApi.deletePaste(id);
                                          //calls.add(tmp);
                                        }
                                        //await Future.wait(calls);
                                        setState(() {
                                          pasteActionIsLoading = false;
                                        });
                                        manager.clearSelection();
                                      },
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      icon: Icon(
                                        Icons.delete_forever,
                                      ),
                                    ),
                                  ),


                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () async {
                                        //List<Future> calls;
                                        setState(() {
                                          pasteActionIsLoading = true;
                                        });
                                        for (var id in manager.selectedItemKeys) {
                                          var item = ListData[ListData.indexWhere((item) => item.id == id)];
                                          developer.log("downloading pastes...");

                                          await kelpApi.downloadPaste(item);
                                          //calls.add(tmp);
                                        }
                                        //await Future.wait(calls);
                                        setState(() {
                                          pasteActionIsLoading = false;
                                        });
                                        manager.clearSelection();
                                      },
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      icon: Icon(
                                        Icons.file_download,
                                      ),
                                    ),
                                  ),


                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        manager.clearSelection();
                                      },
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      icon: Icon(
                                        Icons.close,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: <Widget>[
                      snapshot.data,
                      SafeArea(
                        child: AnimatedContainer(
                          height: 10,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 150),
                          color: Colors.transparent,
                        ),
                      ),
                    ],
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