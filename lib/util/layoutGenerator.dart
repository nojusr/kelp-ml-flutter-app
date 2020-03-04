import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/fileCard.dart';
import '../components/pasteCard.dart';
import 'selectionManager.dart';


// a class that reads user prefs from SharedPreferences
// and generates an item layout for filePage and pastePage
class layoutGenerator {

  static Future <Widget> generateFileLayout(BuildContext context,
      SelectionManager manager, List items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String filePageLayout = prefs.containsKey("file_page_layout")? prefs.getString("file_page_layout") : "1 column";


    double paddingTop = MediaQuery.of(context).padding.top;

    if (filePageLayout == "1 column") {

      return ListView.builder(
        padding: EdgeInsets.only(top: paddingTop, bottom: 50),
        itemBuilder: (context, position) {
          return fileCard(
            bg: Theme.of(context).cardColor,
            selectedBg: Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
            selectionManager: manager,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );

    } else if (filePageLayout == "2 columns") {
      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/2)-10;

      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: paddingTop, bottom: 50),
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
            selectedBg: Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
            selectionManager: manager,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );


    } else if (filePageLayout == "3 columns") {
      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/3)-10;

      return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: paddingTop, bottom: 50, left: 3, right: 3),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (widgetWidth/widgetHeight),
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        semanticChildCount: items.length,
        itemBuilder: (context, position) {
          return fileCard(
            bg: Theme.of(context).cardColor,
            selectedBg: Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
            selectionManager: manager,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );

    } else { // fallback
      throw Exception("No setting set for FilePage");
    }
  }

  static Future <Widget> generatePasteLayout (BuildContext context, SelectionManager manager, List items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pastePageLayout = prefs.containsKey("paste_page_layout")? prefs.getString("paste_page_layout") : "1 column";

    double paddingTop = MediaQuery.of(context).padding.top;

    if (pastePageLayout == "1 column") {

      /*
      return ListView.builder(
        itemBuilder: (context, position) {
          return pasteCard(
            bg: Theme.of(context).cardColor,
            selectedBg: Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
            selectionManager: manager,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );*/

      return ListView.builder(
        padding: EdgeInsets.only(top: paddingTop, bottom: 50),
        itemBuilder: (context, position) {
          return pasteCard(
            bg: Theme.of(context).cardColor,
            selectedBg: Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
            selectionManager: manager,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );



    } else if (pastePageLayout == "2 columns") {
      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/2)-10;

      return GridView.builder(

        padding: EdgeInsets.only(top: paddingTop, bottom: 50, left: 3, right: 3),
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
            selectedBg: Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
            selectionManager: manager,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );


    } else if (pastePageLayout == "3 columns") {
      var widgetHeight = MediaQuery.of(context).size.height/12;
      var widgetWidth = (MediaQuery.of(context).size.width/3)-10;

      return GridView.builder(
        padding: EdgeInsets.only(top: paddingTop, bottom: 50, left: 3, right: 3),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: (widgetWidth/widgetHeight),
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        semanticChildCount: items.length,
        itemBuilder: (context, position) {
          return pasteCard(
            bg: Theme.of(context).cardColor,
            selectedBg: Theme
                .of(context)
                .accentColor
                .withOpacity(0.2),
            selectionManager: manager,
            fg: Theme.of(context).textTheme.body1.color,
            item: items[position],
          );
        },
        itemCount: items.length,
      );
    } else { // fallback
      throw Exception("Layout setting not found for paste page!");
    }
  }

}