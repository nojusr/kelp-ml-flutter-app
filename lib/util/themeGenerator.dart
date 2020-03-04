import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:developer' as developer;

// a class that reads user prefs from SharedPreferences
// and generates a theme depending on them
class themeGenerator {


  //TODO: add these colors: tab/dialog foreground, cardItem foreground

  Future <ThemeData> generateThemeData (BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.containsKey("app_theme") ? prefs.getString("app_theme") : "black";

    ThemeData generatedTheme;



    if (theme != "custom") { // if user is not using a custom theme

      if (theme == "black") { // user is using black theme

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Color(0xFF000000).withOpacity(0.7),
          systemNavigationBarColor: Color(0xFF111111),
        ));


        generatedTheme = ThemeData(
          fontFamily: 'D_DIN',
          accentColor: Color(0xFFFFFFFF),
          indicatorColor: Color(0xFFFFFFFF),
          canvasColor: Color(0xFF000000),
          dialogBackgroundColor: Color(0xFF111111),
          backgroundColor: Color(0xFF000000),
          cursorColor: Color(0xFFFFFFFF),
          cardColor: Color(0xFF0C0C0C),
          primaryColor: Color(0xFF111111),
          textSelectionColor: Color(0xFFFFFFFF).withOpacity(0.4),
          textSelectionHandleColor: Color(0xFFFFFFFF),
          brightness: Brightness.dark,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
        return generatedTheme;
      } else { // user is using white theme


        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Color(0xFFFFFFFF).withOpacity(0.7),
          systemNavigationBarColor: Color(0xFFDDDDDD),
        ));

        generatedTheme = ThemeData(
          fontFamily: 'D_DIN',
          accentColor: Color(0xFF000000),
          indicatorColor: Color(0xFF000000),
          canvasColor: Color(0xFFFFFFFF),
          dialogBackgroundColor: Color(0xFFDDDDDD),
          backgroundColor: Color(0xFFFFFFFF),
          cursorColor: Color(0xFF000000),
          cardColor: Color(0xFFEEEEEE),
          primaryColor: Color(0xFFDDDDDD),
          textSelectionColor: Color(0xFF000000).withOpacity(0.4),
          textSelectionHandleColor: Color(0xFF000000),
          brightness: Brightness.light,
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );
        return generatedTheme;
      }
    } else { // user is using custom theme

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Color(prefs.containsKey("main_bg")? prefs.getInt("main_bg") : 0xFFFFFFFF).withOpacity(0.7).computeLuminance() > 0.5 ? Brightness.dark : Brightness.light,
        statusBarColor: Color(prefs.containsKey("main_bg")? prefs.getInt("main_bg") : 0xFFFFFFFF).withOpacity(0.7),
        systemNavigationBarColor: Color(prefs.containsKey("tab_bg")? prefs.getInt("tab_bg") : 0xFF111111),
      ));

      developer.log("USING CUSTOM THEME");
      generatedTheme = ThemeData(
        fontFamily: 'D_DIN',
        accentColor: Color(prefs.containsKey("accent_color")? prefs.getInt("accent_color") : 0xFFFFFFFF),
        indicatorColor: Color(prefs.containsKey("accent_color")? prefs.getInt("accent_color") : 0xFFFFFFFF),
        canvasColor: Color(prefs.containsKey("main_bg")? prefs.getInt("main_bg") : 0xFF000000),
        dialogBackgroundColor: Color(prefs.containsKey("tab_bg")? prefs.getInt("tab_bg") : 0xFF111111),
        backgroundColor: Color(prefs.containsKey("main_bg")? prefs.getInt("main_bg") : 0xFF000000),
        cursorColor: Color(prefs.containsKey("accent_color")? prefs.getInt("accent_color") : 0xFFFFFFFF),
        cardColor: Color(prefs.containsKey("item_bg")? prefs.getInt("item_bg") : 0xFF222222),
        primaryColor: Color(prefs.containsKey("tab_bg")? prefs.getInt("tab_bg") : 0xFF111111),
        textSelectionColor: Color(prefs.containsKey("accent_color")? prefs.getInt("accent_color") : 0xFFFFFFFF).withOpacity(0.4),
        textSelectionHandleColor: Color(prefs.containsKey("accent_color")? prefs.getInt("accent_color") : 0xFFFFFFFF),
        brightness: Color(prefs.containsKey("main_bg")? prefs.getInt("main_bg") : 0xFFFFFFFF).computeLuminance() > 0.5 ? Brightness.light : Brightness.dark,
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
      return generatedTheme;
    }
  }
}