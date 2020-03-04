import 'dart:developer' as developer;

import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import './components/kelpLoadingIndicator.dart';
import './components/kelpTabBar.dart';
import './util/kelpApi.dart';
import './util/themeGenerator.dart';
import './util/mainFabAnimController.dart';
import 'settingsPage.dart';
import 'filePage.dart';
import 'loginPage.dart';
import 'pastePage.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(rootApp());
}

class rootApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    themeGenerator themeGen = themeGenerator();

    developer.log("returning FutureBuilder in rootApp");
    return FutureBuilder(
      future: themeGen.generateThemeData(context),
      builder: (context, snapshot) {
        ThemeData mainThemeData = snapshot.data;

        Future loginChk = kelpApi.checkIfLoggedIn();
        return FutureBuilder(
          future: loginChk,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return MaterialApp(
                  title: 'kelp\'s place',
                  theme: mainThemeData,
                  home: kelpHomePage(),
                );
              } else {
                return MaterialApp(
                  title: 'kelp\'s place',
                  theme: mainThemeData,
                  home: loginPage(),
                );
              }
            } else {
              return MaterialApp(
                title: 'kelp\'s place',
                theme: mainThemeData,
                home: Scaffold(
                  body: Center(child: kelpLoadingIndicator(),),
                ),
              );
            }
          },
        );
      },
    );
  }
}

class kelpHomePage extends StatefulWidget {
  kelpHomePage({Key key}) : super(key: key);

  @override
  kelpHomePageState createState() => kelpHomePageState();
}

class kelpHomePageState extends State<kelpHomePage> with TickerProviderStateMixin {

  //bool isMenuOpen = false;
  Widget menuChildWidget;

  TabController tabController;

  //AnimationController animController;
  mainFabAnimController _fabAnimController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
    //animController = AnimationController(duration: Duration(milliseconds: 225),vsync: this);
    _fabAnimController = mainFabAnimController(tabCtrl: tabController);

    tabController.animation.addListener((){
      _fabAnimController.setAnimVal(tabController.animation.value);
    });

  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    developer.log("tbctrlval: "+tabController.animation.value.toString());
    TextStyle main = Theme.of(context).textTheme.body1;
    developer.log(_fabAnimController.animVal.toString());

    Widget centerFab = GestureDetector(
      onLongPress: () {
        developer.log("longTap");
        SystemChannels.platform.invokeMethod<void>('HapticFeedback.vibrate');
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => settingsPage()),
        );
      },
      child: FloatingActionButton(
        child: Container(
          padding: EdgeInsets.all(14),
          child: FlareActor(
            "assets/flare/upload-to-paste.flr",
            fit: BoxFit.contain,
            color: Theme.of(context).accentColor,
            controller: _fabAnimController,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        onPressed: () {
          developer.log("pressed");
        },
      ),
    );

    return Scaffold(
      body: Stack(
        children: [

          TabBarView(
            children: <Widget>[
              filePage(),
              pastePage(),
            ],
            controller: tabController,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: kelpTabBar(
              controller: tabController,
              textRight: "pastes",
              textLeft: "files",
              backgroundColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).indicatorColor,
              textColor: main.color,
              centerFab: centerFab,
            ),
          ),
        ],
      ),
    );
  }
}
