import 'dart:developer' as developer;


import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';


import './components/kelpLoadingIndicator.dart';
import './components/kelpTabBar.dart';
import './util/defaultToast.dart';
import './util/kelpApi.dart';
import './util/themeGenerator.dart';
import './util/mainFabAnimController.dart';
import 'settingsPage.dart';
import 'filePage.dart';
import 'loginPage.dart';
import 'pastePage.dart';
import 'pasteCreatePage.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(rootApp());
}

class rootApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    themeGenerator themeGen = themeGenerator();

    return FutureBuilder(
      future: themeGen.generateThemeData(context),
      builder: (context, snapshot) {

        ThemeData mainThemeData = snapshot.data;
        if (snapshot.hasData) {
          Future loginChk = kelpApi.checkIfLoggedIn();
          return FutureBuilder(
            future: loginChk,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true) {
                  return MaterialApp(
                    title: 'kelp\'s place',
                    theme: mainThemeData,
                    home: ChangeNotifierProvider<pageProvider>(
                      create: (_) => pageProvider(),
                      child: kelpHomePage(),
                    ),

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
  }
}

class kelpHomePage extends StatefulWidget {
  kelpHomePage({Key key}) : super(key: key);

  @override
  kelpHomePageState createState() => kelpHomePageState();
}

class pageProvider with ChangeNotifier {
  pageProvider();

  filePage _filepage = filePage();
  pastePage _pastepage = pastePage();

  void reloadFilePage () {
    _filepage.state.reloadList();
    notifyListeners();
  }

  void reloadPastePage () {
    _pastepage.state.reloadList();
    notifyListeners();
  }
}

class kelpHomePageState extends State<kelpHomePage> with TickerProviderStateMixin {

  //bool isMenuOpen = false;
  Widget menuChildWidget;

  TabController tabController;

  //AnimationController animController;
  mainFabAnimController _fabAnimController;

  // shared intent stuff
  StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile> _sharedFiles;
  //String _sharedText;


  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
    //animController = AnimationController(duration: Duration(milliseconds: 225),vsync: this);
    _fabAnimController = mainFabAnimController(tabCtrl: tabController);

    tabController.animation.addListener((){
      _fabAnimController.setAnimVal(tabController.animation.value);
    });

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getMediaStream().listen((List<SharedMediaFile> value) {
          if (value.first.path == null) {
            return;
          }
          defaultToast.send("uploading file...");
          File f = File(value.first.path);
          kelpApi.uploadFile(f);
          defaultToast.send("done");
          return;
        }, onError: (err) {
          defaultToast.send("failed to upload file");
          return;
        });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.first.path == null) {
        return;
      }
      defaultToast.send("uploading file...");
      File f = File(value.first.path);
      kelpApi.uploadFile(f);
      defaultToast.send("done");

    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          if (value == null) {
            return;
          }
          defaultToast.send("uploading paste...");
          kelpApi.createPaste("Shared paste", value);
          defaultToast.send("done");
          return;
        }, onError: (err) {
          defaultToast.send("failed to upload paste");
          return;
        });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String value) {// TEST IF THIS WORKS WHILE LOGGED OUT
      if (value == null) {
        return;
      }
      defaultToast.send("uploading paste...");
      kelpApi.createPaste("Shared paste", value);
      defaultToast.send("done");
      return;
    });


  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    tabController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {

    TextStyle main = Theme.of(context).textTheme.body1;


    final pp = Provider.of<pageProvider>(context);

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
            //TODO: wait until flare-flutter merges antialiasing_flag to master (pr #228) and apply the setting here for better performance
            //link: https://github.com/2d-inc/Flare-Flutter/pull/228
            color: Theme.of(context).accentColor,
            controller: _fabAnimController,
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        onPressed: () async {
          if (tabController.index == 0) {
            //uploadFile
            File fileToUpload = await FilePicker.getFile();
            await kelpApi.uploadFile(fileToUpload);
            pp._filepage.state.reloadList();
          } else if (tabController.index == 1) {
            // uploadPaste
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => pasteCreatePage()),
            );
            pp._pastepage.state.reloadList();
          }
        },
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            TabBarView(
              children: <Widget>[
                pp._filepage,
                pp._pastepage,
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
      ),
    );
  }
}

