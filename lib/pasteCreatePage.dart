import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:meme_machine/main.dart';
import './util/kelpApi.dart';

import 'dart:developer' as developer;

class pasteCreatePage extends StatefulWidget {

  @override
  pasteCreatePageState createState() => pasteCreatePageState();
}

class pasteCreatePageState extends State<pasteCreatePage> {

  final pasteTitleController = TextEditingController();
  final pasteContentController = TextEditingController();

  bool shouldShowHint = true;

  @override
  void dispose() {
    pasteTitleController.dispose();
    pasteContentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    TextStyle segment = new TextStyle(
      color: Theme.of(context).textTheme.body1.color,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );

    TextStyle hint = Theme.of(context).textTheme.body1.copyWith(
        color: Theme.of(context).textTheme.body1.color.withOpacity(0.5),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("create new paste", style: segment,)
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: "paste title"
                ),
                controller: pasteTitleController,
              ),
            ),



            Expanded(
              child: Stack(
                children: <Widget>[




                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 70, left: 10, right: 10),
                      child: shouldShowHint
                          ? GestureDetector(
                              onTap: (){
                                setState(() {
                                  shouldShowHint = false;
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Enter paste here...",
                                  textAlign: TextAlign.start,
                                  style: hint,
                                ),
                              ),


                            )
                          : EditableText(
                              controller: pasteContentController,

                              style: Theme.of(context).textTheme.body1,
                              cursorColor: Theme.of(context).accentColor,
                              backgroundCursorColor: Theme.of(context).accentColor,
                              focusNode: FocusNode(),
                              scrollPhysics: NeverScrollableScrollPhysics(),

                              selectionColor: Theme.of(context).accentColor.withOpacity(0.3),
                              expands: true,
                              maxLines: null,
                              minLines: null,
                            ),
                    ),
                  ),



                  Positioned(
                    bottom: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).dialogBackgroundColor,
                              child: InkWell(
                                splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                                child: Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                                  child: Text("paste"),
                                ),
                                onTap: () async {
                                  await kelpApi.createPaste(pasteTitleController.text, pasteContentController.text);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 5,
                            color: Colors.transparent,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).dialogBackgroundColor,
                              child: InkWell(
                                splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                                child: Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                                  child: Text("quick paste from clipboard"),
                                ),
                                onTap: () async {
                                  ClipboardData data = await Clipboard.getData('text/plain');
                                  if (pasteTitleController.text == ""){
                                    await kelpApi.createPaste("Clipboard paste", data.text);
                                  } else {
                                    await kelpApi.createPaste(pasteTitleController.text, data.text);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}