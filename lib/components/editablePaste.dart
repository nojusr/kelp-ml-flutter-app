import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/pasteViewMenu.dart';
import '../util/kelpApi.dart';

// a menu used inside fileViewPage for the actions that can be applied to
// a file (download, share, delet)
class editablePaste extends StatefulWidget {

  final PasteItem item;
  final String rawText;

  const editablePaste({
    Key key,
    @required this.item,
    @required this.rawText,
  }) : super(key: key);

  @override
  _editablePasteState createState() => _editablePasteState();
}

class _editablePasteState extends State<editablePaste> {

  bool isEditing = false;

  TextEditingController mainEditController;
  ScrollController mainScrollcontroller;
  FocusNode mainFocusNode = FocusNode();


  String textToDisplay;

  @override
  void initState() {
    super.initState();

    textToDisplay = widget.rawText;

    mainScrollcontroller = ScrollController();
    mainEditController = TextEditingController();
  }

  @override
  void dispose() {
    mainEditController.dispose();
    //mainScrollcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {

    developer.log(MediaQuery.of(context).viewInsets.bottom.toString());

    Widget pasteEditCloseButton = Container(
      margin: EdgeInsets.only(right: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).dialogBackgroundColor,
          child: InkWell(
            splashColor: Theme.of(context).accentColor.withOpacity(0.5),
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              child: Text("finish"),
            ),
            onTap: () {



              if (textToDisplay == mainEditController.text) {
                setState(() {
                  isEditing = false;
                });
                return;

              }
              kelpApi.updatePaste(widget.item, mainEditController.text);
              setState(() {
                textToDisplay = mainEditController.text;
                isEditing = false;
              });
            },
          ),
        ),
      ),
    );



        Widget mainText;

    if (isEditing) {

      mainText = SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50, top: 10, left: 5, right: 5),
        controller: mainScrollcontroller,
        child: EditableText(
          controller: mainEditController,
          focusNode: mainFocusNode,

          style: Theme.of(context).textTheme.body1,
          cursorColor: Theme.of(context).accentColor,
          backgroundCursorColor: Theme.of(context).accentColor,

          scrollPhysics: NeverScrollableScrollPhysics(),
          expands: true,
          maxLines: null,
          minLines: null,
        ),
      );


    } else {
      mainText = SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50, top: 10, left: 5, right: 5),
        controller: mainScrollcontroller,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Linkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            text: textToDisplay,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.body1,
            linkStyle: TextStyle(
              color: Theme.of(context).textTheme.body1.color,
              decorationStyle: TextDecorationStyle.solid,
              decorationColor: Theme.of(context).accentColor.withOpacity(0.7),
            ),
          ),
        ),
      );
    }


    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[

          mainText,

          AnimatedPositioned(
            curve: Curves.easeOut,
            duration: Duration(milliseconds: 180),
            bottom: MediaQuery.of(context).viewInsets.bottom,
            right: 0,
            child:
              isEditing
                ? pasteEditCloseButton
                : pasteViewMenu(
                    item: widget.item,
                    onPasteEditTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String textBuf = textToDisplay;
                      mainEditController.text = textBuf;
                      setState(() {
                        isEditing = true;
                      });
                    },
                  ),
          ),


        ],
      ),
    );
  }
}