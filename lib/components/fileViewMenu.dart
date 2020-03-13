import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';

import '../util/kelpApi.dart';

// a menu used inside fileViewPage for the actions that can be applied to
// a file (download, share, delet)
class fileViewMenu extends StatefulWidget {

  final FileItem item;

  const fileViewMenu({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  _fileViewMenuState createState() => _fileViewMenuState();
}

class _fileViewMenuState extends State<fileViewMenu> {

  bool isLoading = false;


  @override
  Widget build (context) {

    Widget LoadingIcon;

    if (isLoading) {
      LoadingIcon = Container(
        margin: EdgeInsets.only(right: 10),
        child: SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );

    } else {
      LoadingIcon = Container();
    }

    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          LoadingIcon,

          Container(
            margin: EdgeInsets.only(right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).dialogBackgroundColor,
                child: InkWell(
                  splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                    child: Text("download"),
                  ),
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await kelpApi.downloadFile(widget.item);

                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
          ),



          Container(
            margin: EdgeInsets.only(right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).dialogBackgroundColor,
                child: InkWell(
                  splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                    child: Text("share"),
                  ),
                  onTap: () {
                    Share.share(kelpApi.rootRoute+"/u/"+widget.item.id+"."+widget.item.filetype);
                  },
                ),
              ),
            ),
          ),



          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).dialogBackgroundColor,
              child: InkWell(
                splashColor: Theme.of(context).accentColor.withOpacity(0.5),
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  child: Text("delete"),
                ),
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });

                  await kelpApi.deleteFile(widget.item.id);

                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}