import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './components/colorPickerButton.dart';
import 'dart:developer' as developer;
import 'main.dart';


class settingsPage extends StatefulWidget {
  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {

  String pastePageLayout = "1 column";
  String filePageLayout = "1 column";
  String apiKey = "nil"; // has to be loaded upon opening this page

  String theme = 'black';

  Color mainBg = Color(0xFF000000);
  Color tabBg = Color(0xFF111111);
  Color itemBg = Color(0xFF222222);
  Color textColor = Color(0xFFFFFFFF);
  Color accentColor = Color(0xFFFFFFFF);



  void _updatePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("main_bg", mainBg.value);
    prefs.setInt("tab_bg", tabBg.value);
    prefs.setInt("item_bg", itemBg.value);
    prefs.setInt("text_color", textColor.value);
    prefs.setInt("accent_color", accentColor.value);
    prefs.setString("app_theme", theme);
    prefs.setString("file_page_layout", filePageLayout);
    prefs.setString("paste_page_layout", pastePageLayout);
  }

  void _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mainBg = Color(prefs.containsKey("main_bg")? prefs.getInt("main_bg") : 0xFF000000);
      tabBg = Color(prefs.containsKey("tab_bg")? prefs.getInt("tab_bg") : 0xFF111111);
      itemBg = Color(prefs.containsKey("item_bg")? prefs.getInt("item_bg") : 0xFF222222);
      textColor = Color(prefs.containsKey("text_color")? prefs.getInt("text_color") : 0xFFFFFFFF);
      accentColor = Color(prefs.containsKey("accent_color")? prefs.getInt("accent_color") : 0xFFFFFFFF);
      pastePageLayout = prefs.containsKey("paste_page_layout")? prefs.getString("paste_page_layout") : "1 column";
      filePageLayout = prefs.containsKey("file_page_layout")? prefs.getString("file_page_layout") : "1 column";
      theme = prefs.containsKey("app_theme") ? prefs.getString("app_theme") : "black";
      apiKey = prefs.containsKey("api_key") ? prefs.getString("api_key") : "nil";

    });

  }

  bool hasBeenInitialized = false;

  @override
  Widget build(context) {
    _loadPrefs();


    TextStyle main = Theme.of(context).textTheme.body1;
    TextStyle segment = new TextStyle(
      color: Theme.of(context).textTheme.body1.color,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );



    if (hasBeenInitialized == false) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Theme
            .of(context)
            .canvasColor
            .computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
        statusBarColor: Theme
            .of(context)
            .canvasColor,
        systemNavigationBarColor: Theme
            .of(context)
            .canvasColor,
      ));
      setState(() {
        hasBeenInitialized = true;
      });
    }

    return WillPopScope(
      onWillPop: () async {

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness: Theme
              .of(context)
              .canvasColor
              .withOpacity(0.5)
              .computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
          statusBarColor: Theme
              .of(context)
              .canvasColor.withOpacity(0.5),
          systemNavigationBarColor: Theme
              .of(context)
              .primaryColor,
        ));

        WidgetsFlutterBinding.ensureInitialized();
        runApp(rootApp());
        return true;
      },

      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(
          children: <Widget>[

            ListTile(
              title: Text(
                "theme",
                style: segment,
              ),
            ),

            Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.only(top:10, bottom: 10),
                margin: EdgeInsets.only(left: 3, right: 3),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "app style:",
                        style: main,
                      ),
                      trailing: DropdownButton<String>(
                        onChanged: (String newValue) {
                          setState(() {
                            theme = newValue;
                          });
                          _updatePrefs();
                        },
                        underline: Container(
                          height: 1,
                          color: Theme.of(context).accentColor,
                        ),

                        value: theme,
                        //style: main,
                        items: <String>['black', 'white', 'custom']
                            .map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: new Text("   "+val, style: main),
                          );
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "background color:",
                        style: main,
                      ),
                      trailing: colorPickerButton(
                        onColorChanged: (Color color) {
                          setState(() => mainBg = color);
                          _updatePrefs();
                        },
                        currentColor: mainBg,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "tab bar and dialog color:",
                        style: main,
                      ),
                      trailing: colorPickerButton(
                        onColorChanged: (Color color) {
                          setState(() => tabBg = color);
                          _updatePrefs();
                        },
                        currentColor: tabBg,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "list item color:",
                        style: main,
                      ),
                      trailing: colorPickerButton(
                        onColorChanged: (Color color) {
                          setState(() => itemBg = color);
                          _updatePrefs();
                        },
                        currentColor: itemBg,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "text color:",
                        style: main,
                      ),
                      trailing: colorPickerButton(
                        onColorChanged: (Color color) {
                          setState(() => textColor = color);
                          _updatePrefs();
                        },
                        currentColor: textColor,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "accent color:",
                        style: main,
                      ),
                      trailing: colorPickerButton(
                        onColorChanged: (Color color) {
                          setState(() => accentColor = color);
                          _updatePrefs();
                        },
                        currentColor: accentColor,
                      ),
                    ),
                  ],
                ),
            ),

            ListTile(
              title: Text(
                "layout",
                style: segment,
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.only(top:10, bottom: 10),
              margin: EdgeInsets.only(left: 3, right: 3),
              child: Column (
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "file page layout style:",
                      style: main,
                    ),
                    trailing: DropdownButton<String>(
                      onChanged: (String newValue) {
                        setState(() {
                          filePageLayout = newValue;
                        });
                        _updatePrefs();
                      },
                      underline: Container(
                        height: 1,
                        color: Theme.of(context).accentColor,
                      ),
                      value: filePageLayout,
                      //style: main,
                      items: <String>['1 column', '2 columns', '3 columns']
                          .map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: new Text("   "+val, style: main),
                        );
                      }).toList(),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "paste page layout style:",
                      style: main,
                    ),
                    trailing: DropdownButton<String>(
                      onChanged: (String newValue) {
                        setState(() {
                          pastePageLayout = newValue;
                        });
                        _updatePrefs();
                      },
                      underline: Container(
                        height: 1,
                        color: Theme.of(context).accentColor,
                      ),
                      value: pastePageLayout,
                      //style: main,
                      items: <String>['1 column', '2 columns', '3 columns']
                          .map((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: new Text("   "+val, style: main),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              title: Text(
                "misc",
                style: segment,
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.only(top:10, bottom: 10),
              margin: EdgeInsets.only(left: 3, right: 3),
              child: Column (
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "your api key:",
                      style: main,
                    ),
                    trailing: Text(
                      this.apiKey,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        height: 35,
                        width: 75,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).accentColor,
                              width: 1
                            ),
                          ),
                        ),
                        child: Material(
                          color: Theme.of(context).cardColor,
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove("api_key");

                              MaterialPageRoute route = MaterialPageRoute(builder: (context) => loginPage());

                              Navigator.pushReplacement(
                                context,
                                route
                              );
                              Navigator.removeRouteBelow(context, route);
                            },
                            child: Center( child: Text("logout")),
                          ),
                        ),
                      ),


                    ],
                  ),

                ],
              ),
            ),


            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: Text(
                  "changes will be applied upon leaving the settings screen",
                  style: TextStyle(
                      fontSize: 12.5,
                      color: Theme.of(context).textTheme.body1.color.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );



  }
}
