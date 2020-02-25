import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../fileViewPage.dart';
import '../util/fileTypePicker.dart';
import '../util/kelpApi.dart';
import '../util/circularRevealRoute.dart';

class fileCard extends StatelessWidget {

  const fileCard({
    Key key,
    this.bg = const Color(0xFFFF0000),
    this.fg = const Color(0xFFFFFFFF),
    this.item = const FileItem(id: "null", filename: "null", filetype: "null"),
  }) : super(key: key);

  final FileItem item;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {

    // determine icon for filetype

    Widget fileIcon = fileTypePicker.generateIcon(this.item.filetype, this.fg);

    Widget item;

    String err = " ";

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
                      Container(
                          margin: EdgeInsets.only(right: 5),
                          child: Hero(
                            tag: this.item.id+"_icon",
                            child: fileTypePicker.generateIcon(this.item.filetype, this.fg),
                          ),
                      ),

                      Hero(
                        tag: this.item.id+"_filename",
                        child: Text(
                          this.item.filename,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Hero(
                            tag: this.item.id+"_link",
                            child: Text(
                              this.item.id+"."+this.item.filetype,
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
            color: Colors.transparent,

            child: Container(

              decoration: BoxDecoration(
                    color: this.bg,
                    borderRadius: BorderRadius.all(Radius.circular(10)),),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        Container(
                          constraints: BoxConstraints(maxWidth: 156),
                          margin: EdgeInsets.only(top:10, left: 8),
                          child: Row(
                            children: <Widget>[
                                //fit: FlexFit.loose,
                                Expanded(
                                  child: Hero(
                                    tag: this.item.id+"_filename",
                                    child: Text(
                                      this.item.filename,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.body1,
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
                                tag: this.item.id+"_link",
                                child: Text(
                                  this.item.id+"."+this.item.filetype,
                                  style: Theme.of(context).textTheme.body1,
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
                        child:
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Hero(
                            tag: this.item.id+"_icon",
                            child: fileTypePicker.generateIcon(this.item.filetype, this.fg),
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
          onTapUp: (TapUpDetails details) {
            Navigator.push(
              context,
              RevealRoute(
                transitionDuration: Duration(milliseconds: 300),
                page: fileViewPage(
                  item: this.item,
                  fg: this.fg,
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