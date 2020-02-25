import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meme_machine/components/kelpLoadingIndicator.dart';
import './util/themeGenerator.dart';
import './util/kelpApi.dart';
import './components/kelpTabBar.dart';
import './components/mainMenu.dart';
import 'filePage.dart';
import 'pastePage.dart';
import 'loginPage.dart';
import 'dart:developer' as developer;

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
              return Center(child: kelpLoadingIndicator(),);
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

  bool isMenuOpen = false;
  Widget menuChildWidget;

  TabController tabController;

  AnimationController animController;
  Animation fabAnimation;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
    animController = AnimationController(duration: Duration(milliseconds: 225),vsync: this);

  }

  @override
  void dispose() {
    tabController.dispose();
    animController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    TextStyle main = Theme.of(context).textTheme.body1;

    // TODO: longtap for menu, press for upload (make this a setting??)
    Widget centerFab = FloatingActionButton(
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: animController,
        color: Theme.of(context).textTheme.title.color,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      onPressed: () {
        setState(() {
          isMenuOpen = !isMenuOpen;
          if (isMenuOpen == true) {
            menuChildWidget = mainMenu(bg: Theme.of(context).primaryColor, fg: main.color,);
          }
        });
      },

    );

    if (isMenuOpen) {
      animController.forward();
    } else {
      animController.reverse();

    }



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
            child: Container(
              margin: EdgeInsets.only(bottom: 70),

              decoration: BoxDecoration(

              ),

              child: AnimatedOpacity(
                onEnd: () {
                  if (isMenuOpen == false) {
                    setState(() {
                      menuChildWidget = Container(height: 0,);
                    });

                  }
                },
                opacity: isMenuOpen ? 1.0 : 0.0,
                duration: Duration(milliseconds: 225),
                child: menuChildWidget,
              ),
            ),
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
