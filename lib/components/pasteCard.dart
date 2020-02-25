import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pasteViewPage.dart';
import '../util/kelpApi.dart';
import '../util/circularRevealRoute.dart';

class pasteCard extends StatelessWidget {

  const pasteCard({
    Key key,
    this.bg = const Color(0xFFFF0000),
    this.fg = const Color(0xFFFFFFFF),
    this.item = const PasteItem(id: "null", pastename: "null"),
  }) : super(key: key);

  final PasteItem item;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {

    Widget item;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > MediaQuery.of(context).size.width/2){
          item = Container(

            margin: EdgeInsets.all(3),

            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: this.bg,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.only(left: 10, right: 10, top:20, bottom: 20),

              child: Center(
                child: Row(
                  children: <Widget>[

                    Hero(
                      tag: this.item.id+"_pastename",
                      child: Text(
                        this.item.pastename,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Hero(
                          tag: this.item.id+"_id",
                          child: Text(
                            this.item.id,
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
            child: Container(
              decoration: BoxDecoration(
                color: this.bg,
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
                          tag: this.item.id+"_pastename",
                          child: Text(
                            this.item.pastename,
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
                          tag: this.item.id+"_id",
                          child: Text(
                            this.item.id,
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
          onTapUp: (TapUpDetails details) {
            Navigator.push(
              context,
              RevealRoute(
                transitionDuration: Duration(milliseconds: 300),
                page: pasteViewPage(
                  item: this.item,
                ),
                maxRadius: 1200,
                centerOffset: details.globalPosition,
              ),
            );
          },
          child: item,
        );

      },
    );

  }
}