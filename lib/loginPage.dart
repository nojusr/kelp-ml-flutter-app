import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meme_machine/main.dart';
import 'package:flare_flutter/flare_actor.dart';
import './util/kelpApi.dart';

class loginPage extends StatefulWidget {

  @override
  loginPageState createState() => loginPageState();
}

class loginPageState extends State<loginPage> {

  final usernameInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  @override
  void dispose() {
    usernameInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          constraints: BoxConstraints(
            maxWidth: 400
          ),
          child:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // look, there's no other nice looking way to do ascii art here, understand?
                // nothing i can do about it apart from refactoring it to a seperate widget so that it's hidden away
                // (see kelpLoadingIndicator)
                Container(
                  height: MediaQuery.of(context).size.height/5,
                  width: MediaQuery.of(context).size.width,
                  child: FlareActor(
                    "assets/flare/main_logo.flr",
                    fit: BoxFit.contain,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),






                Column(
                  children: <Widget>[
                    TextFormField(
                      controller: usernameInputController,
                      decoration: InputDecoration(
                        labelText: "username",
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: passwordInputController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "password",
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                            width: 1,
                          ),
                        ),
                      ),

                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10, top: 20),
                        height: 35,
                        width: 75,

                        decoration: BoxDecoration(
                          border: Border (
                            bottom: BorderSide(
                                color: Theme.of(context).accentColor,
                                width: 1.0
                            ),
                          ),
                        ),
                        child: Material(
                          child: InkWell(
                            onTap: () async {
                              String username = usernameInputController.text;
                              String password = passwordInputController.text;

                              try {
                                await kelpApi.sendLogin(username, password);
                              } on String catch (err) {
                                return;
                              }

                              MaterialPageRoute route = MaterialPageRoute(builder: (context) => kelpHomePage());

                              Navigator.push(
                                context,
                                route,
                              );

                              Navigator.removeRouteBelow(context, route);

                            },
                            child: Center( child: Text("login")),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        )

      ),
    );

  }
}