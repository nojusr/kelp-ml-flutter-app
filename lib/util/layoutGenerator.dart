import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/pasteCard.dart';
import '../components/fileCard.dart';
import 'dart:async';
import 'dart:developer' as developer;


// a class that reads user prefs from SharedPreferences
// and generates an item layout for filePage and pastePage
class layoutGenerator {
  
  static Future <Widget> generateFileLayout (BuildContext context, List items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String filePageLayout = prefs.containsKey("file_page_layout")? prefs.getString("file_page_layout") : "1 column";
    
    if (filePageLayout == "1 column") {
      return ListView.builder(
        itemBuilder: (context, position) {
          return fileCard(
            bg: Theme.of(context).cardColor,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );
    } else if (filePageLayout == "2 columns") {

      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/2)-10;

      return Container(

        margin: EdgeInsets.only(left: 5, right: 5),

        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (widgetWidth/widgetHeight),
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,


          ),
          semanticChildCount: items.length,
          itemBuilder: (context, position) {
            return fileCard(
              bg: Theme.of(context).cardColor,
              fg: Theme.of(context).textTheme.body1.color,
              item: items[position],
            );
          },
          itemCount: items.length,
        ),
      );

    } else if (filePageLayout == "3 columns") {

      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/3)-10;

      return Container(

        margin: EdgeInsets.only(left: 5, right: 5),

        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (widgetWidth/widgetHeight),
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, position) {
              return fileCard(
                bg: Theme.of(context).cardColor,
                fg: Theme.of(context).textTheme.body1.color,
                item: items[position],
              );
            },
            itemCount: items.length,
        ),
      );
    } else { // fallback
      return ListView.builder(
        itemBuilder: (context, position) {
          return fileCard(
            bg: Theme.of(context).cardColor,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );
    }
  }

  static Future <Widget> generatePasteLayout (BuildContext context, List items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String filePageLayout = prefs.containsKey("paste_page_layout")? prefs.getString("paste_page_layout") : "1 column";

    if (filePageLayout == "1 column") {
      return ListView.builder(
        itemBuilder: (context, position) {
          return pasteCard(
            bg: Theme.of(context).cardColor,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );
    } else if (filePageLayout == "2 columns") {

      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/2)-10;

      return Container(

        margin: EdgeInsets.only(left: 5, right: 5),

        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (widgetWidth/widgetHeight),
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,


          ),
          semanticChildCount: items.length,
          itemBuilder: (context, position) {
            return pasteCard(
              bg: Theme.of(context).cardColor,
              fg: Theme.of(context).textTheme.body1.color,
              item: items[position],
            );
          },
          itemCount: items.length,
        ),
      );

    } else if (filePageLayout == "3 columns") {

      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/3)-10;

      return Container(

        margin: EdgeInsets.only(left: 5, right: 5),

        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: (widgetWidth/widgetHeight),
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemBuilder: (context, position) {
            return pasteCard(
              bg: Theme.of(context).cardColor,
              fg: Theme.of(context).textTheme.body1.color,
              item: items[position],
            );
          },
          itemCount: items.length,
        ),
      );
    } else { // fallback
      return ListView.builder(
        itemBuilder: (context, position) {
          return pasteCard(
            bg: Theme.of(context).cardColor,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );
    }
  }

}