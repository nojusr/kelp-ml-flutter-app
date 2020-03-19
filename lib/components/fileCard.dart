import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../fileViewPage.dart';
import '../util/circularRevealRoute.dart';
import '../util/fileTypePicker.dart';
import '../util/kelpApi.dart';
import '../util/selectionManager.dart';
import '../main.dart';

class fileCard extends StatefulWidget {

  const fileCard({
    Key key,
    this.bg = const Color(0xFFFF0000),
    this.selectedBg = const Color(0xFFFF5555),
    this.fg = const Color(0xFFFFFFFF),
    this.selectionManager,
    this.item = const FileItem(id: "null", filename: "null", filetype: "null"),
  }) : super(key: key);

  final SelectionManager selectionManager;
  final FileItem item;
  final Color bg;
  final Color selectedBg;
  final Color fg;

  @override
  _fileCardState createState() => _fileCardState();
}

class _fileCardState extends State<fileCard> {
  @override
  Widget build(BuildContext context) {
    // determine icon for filetype

    //Widget fileIcon = fileTypePicker.generateIcon(this.item.filetype, this.fg);

    Widget item;

    bool isSelected = widget.selectionManager.checkIfSelected(this.widget.item.id);

    final pp = Provider.of<pageProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > MediaQuery.of(context).size.width/2){
          item = Container(

            margin: EdgeInsets.all(3),

            color: Colors.transparent,
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isSelected ? this.widget.selectedBg : this.widget.bg,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.only(left: 10, right: 10, top:20, bottom: 20),

              child: Center(
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Hero(
                        tag: this.widget.item.id + "_icon",
                        child: fileTypePicker.generateIcon(this.widget.item
                            .filetype, Theme.of(context).accentColor),
                      ),
                    ),

                    Hero(
                      tag: this.widget.item.id + "_filename",
                      child: Text(
                        this.widget.item.filename,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Hero(
                          tag: this.widget.item.id + "_link",
                          child: Text(
                            this.widget.item.id + "." +
                                this.widget.item.filetype,
                            style: Theme
                                .of(context)
                                .textTheme
                                .body1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          item = Container(
            color: Colors.transparent,

            child: Container(

              decoration: BoxDecoration(
                color: isSelected ? this.widget.selectedBg : this.widget.bg,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        constraints: BoxConstraints(maxWidth: 156),
                        margin: EdgeInsets.only(top: 10, left: 8),
                        child: Row(
                          children: <Widget>[
                            //fit: FlexFit.loose,
                            Expanded(
                              child: Hero(
                                tag: this.widget.item.id + "_filename",
                                child: Text(
                                  this.widget.item.filename,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .body1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 8, bottom: 10),
                            child: Hero(
                              tag: this.widget.item.id + "_link",
                              child: Text(
                                this.widget.item.id + "." +
                                    this.widget.item.filetype,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1,
                              ),
                            ),
                          ),

                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Hero(
                          tag: this.widget.item.id + "_icon",
                          child: fileTypePicker.generateIcon(
                              this.widget.item.filetype, Theme.of(context).accentColor),
                        ),
                      ),

                    ),
                  )

                ],
              ),


            ),
          );
        }

        return GestureDetector(

          onLongPress: () {
            if (this.widget.selectionManager.checkIfSelected(this.widget.item.id) == false) {
              SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
              this.widget.selectionManager.addToSelection(this.widget.item.id);
            } else {
              this.widget.selectionManager.removeFromSelection(
                  this.widget.item.id);
            }
            setState(() {});
          },

          onTapUp: (TapUpDetails details) {
            if (this.widget.selectionManager.selectionActive) {
              if (this.widget.selectionManager.checkIfSelected(
                  this.widget.item.id) == false) {
                this.widget.selectionManager.addToSelection(
                    this.widget.item.id);
              } else {
                this.widget.selectionManager.removeFromSelection(
                    this.widget.item.id);
              }
              setState(() {});
            } else {
              Navigator.push(
                context,
                RevealRoute(
                  transitionDuration: Duration(milliseconds: 300),
                  page: ChangeNotifierProvider.value(
                      value: pp,
                      child: fileViewPage(
                        item: this.widget.item,
                      ),
                  ),



                  maxRadius: 1200,
                  centerOffset: details.globalPosition,
                ),
              );
            }
          },
          child: item,
        );
      },
    );
  }
}