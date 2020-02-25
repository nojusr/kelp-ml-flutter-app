import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../components/kelpVideoPlayer.dart';
import '../components/kelpLoadingIndicator.dart';
import '../components/kelpAudioPlayer.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import './fileTypePicker.dart';


// MODELS FOR DATA REPRESENTATION
class FileItem {
  final String filename;
  final String filetype;
  final String id;

  const FileItem({this.id, this.filename, this.filetype});

  factory FileItem.fromJson(Map<String, dynamic> json) {
    return FileItem(
      filename: json["org_filename"],
      filetype: json["filetype"],
      id: json["filename"],
    );
  }
}

class PasteItem {
  final String pastename;
  final String id;

  const PasteItem({this.id, this.pastename});

  factory PasteItem.fromJson(Map<String, dynamic> json) {
    return PasteItem(
      pastename: json["paste_name"],
      id: json["id"],
    );
  }
}

// class of static Futures, used to generate content taken from the web
class kelpApi {

  static String rootRoute = "https://kelp.ml";

  static Future fetchFileList() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api_key = prefs.getString("api_key");

    var map = new Map<String, dynamic>();

    map["api_key"] = api_key;

    final response = await http.post(rootRoute+"/api/fetch/files", body: map);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch files (status code: ${response.statusCode})");
    }

    final jsonResponse = json.decode(response.body);

    if (jsonResponse["success"] == 'false') {
      throw Exception("Failed to get successful response");
    }
    //developer.log("made json response");
    //developer.log(jsonResponse.toString());

    var items = new List();

    items = jsonResponse["files"].map((json) => FileItem.fromJson(json)).toList();

    return items;

  }

  // generates a widget to display from file,
  // returns the icon of the file if preview isn't possible
  static Future fetchFileWidget(BuildContext context, FileItem item) async {
    String route = rootRoute+"/u/"+item.id+"."+item.filetype;

    String check = fileTypePicker.checkIfPreviewPossible(item.filetype);

    if (check == "null") { // if file preview isn't possible

      return fileTypePicker.generateIcon(item.filetype, Theme.of(context).textTheme.body1.color);

    } else if (check == "image") { // if the filetype is an image

      return ClipRRect(
        child: PhotoView(
            imageProvider: NetworkImage(route),
            backgroundDecoration: BoxDecoration(color:Theme.of(context).cardColor, ),
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.5,
            loadingBuilder: (context, progress) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  kelpLoadingIndicator(),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: 11,
                    width: 80,
                    child: LinearProgressIndicator(
                      backgroundColor: Theme.of(context).canvasColor.withOpacity(0.7),
                      value: progress == null
                          ? 0
                          : progress.cumulativeBytesLoaded / progress.expectedTotalBytes,
                    ),
                  ),
                ],
              ),
            ),
        ),
      );

    } else if (check == "text") { // if the filetype is text

      final response = await http.get(route);
      return SingleChildScrollView(
        child: Container(
          child: Text(response.body),
          padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
        ),
      );

    } else if (check == "video"){
      return KelpVideoPlayer(route: route,);
    } else if (check == "audio") {
      return KelpAudioPlayer(route: route,);
    } else {// only used if implementation for file type isn't there
      return Center (
        child: fileTypePicker.generateIcon(item.filetype, Theme.of(context).textTheme.body1.color),
      );
    }
  }

  static Future fetchPasteList() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String api_key = prefs.getString("api_key");

    var map = new Map<String, dynamic>();

    map["api_key"] = api_key;

    final response = await http.post(rootRoute+"/api/fetch/pastes", body: map);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch paste (status code: ${response.statusCode})");
    }

    final jsonResponse = json.decode(response.body);

    if (jsonResponse["success"] == 'false') {
      throw Exception("Failed to get successful response");
    }

    var items = new List();

    items = jsonResponse["pastes"].map((json) => PasteItem.fromJson(json)).toList();

    return items;
  }

  static Future fetchPasteWidget(BuildContext context, PasteItem item) async {
    String route = rootRoute+"/p/raw/"+item.id;

    final response = await http.get(route);

    return SingleChildScrollView(

      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Linkify(
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              throw 'Could not launch $link';
            }
          },
          text: response.body,
          style: Theme.of(context).textTheme.body1,
          linkStyle: TextStyle(
            color: Theme.of(context).textTheme.body1.color,
            decorationStyle: TextDecorationStyle.solid,
            decorationColor: Theme.of(context).accentColor.withOpacity(0.7),
          ),
        ),

        padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
      ),
    );

  }

  static Future checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("api_key")) {
      return true;
    } else {
      return false;
    }

  }


  static Future sendLogin(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var map = new Map<String, dynamic>();

    map["username"] = username;
    map["password"] = password;

    final response = await http.post(rootRoute+"/api/login", body: map);

    if (response.statusCode != 200) {
      throw "Failed to send login request (status code: ${response.statusCode})";
    }

    final jsonResponse = json.decode(response.body);

    if (jsonResponse["success"] == 'false') {
      throw "Login error: ${jsonResponse["reason"]}";
    }

    await prefs.setString("api_key", jsonResponse["api_key"]);

    return;
  }

}