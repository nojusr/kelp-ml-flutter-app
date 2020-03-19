import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme_machine/main.dart';
import 'package:provider/provider.dart';
import '../pasteViewPage.dart';
import '../util/kelpApi.dart';
import '../util/circularRevealRoute.dart';
import '../util/selectionManager.dart';
import '../main.dart';

class pasteCard extends StatefulWidget {

  const pasteCard({
    Key key,
    this.bg = const Color(0xFFFF0000),
    this.selectedBg = const Color(0xFFFF5555),
    this.fg = const Color(0xFFFFFFFF),
    this.selectionManager,
    this.item = const PasteItem(id: "null", pastename: "null"),
  }) : super(key: key);

  final SelectionManager selectionManager;
  final PasteItem item;
  final Color bg;
  final Color selectedBg;
  final Color fg;

  @override
  _pasteCardState createState() => _pasteCardState();
}

class _pasteCardState extends State<pasteCard> {
  @override
  Widget build(BuildContext context) {

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

                    Hero(
                      tag: this.widget.item.id+"_pastename",
                      child: Text(
                        this.widget.item.pastename,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Hero(
                          tag: this.widget.item.id+"_id",
                          child: Text(
                            this.widget.item.id,
                            style: Theme.of(context).textTheme.body1,
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

            //margin: EdgeInsets.all(3),

            color: Colors.transparent,
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 150),
              decoration: BoxDecoration(
                color: isSelected ? this.widget.selectedBg : this.widget.bg,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.only(left: 10, right: 10, top:10, bottom: 10),

              child: Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child:
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Hero(
                          tag: this.widget.item.id+"_pastename",
                          child: Text(
                            this.widget.item.pastename,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                      ),

                    ),
                   Align(
                        alignment: Alignment.centerRight,
                        child: Hero(
                          tag: this.widget.item.id+"_id",
                          child: Text(
                            this.widget.item.id,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ),
                   ),
                  ],
                ),
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
                      child: pasteViewPage(
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