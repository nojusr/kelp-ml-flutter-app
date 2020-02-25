import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_machine/settingsPage.dart';



class mainMenu extends StatelessWidget {

  const mainMenu({
    Key key,
    this.bg = const Color(0xFFFF0000),
    this.fg = const Color(0xFF000000),
  }) : super(key: key);

  final Color bg;
  final Color fg;




  @override
  Widget build(BuildContext context) {

    TextStyle menuTextStyle = TextStyle(color: this.fg, fontSize: 15);


    return Container(
      margin: EdgeInsets.all(3),
      color: Colors.transparent,
      height: 120,
      width: 120,
      child:  Container(
          decoration: BoxDecoration(
            color: this.bg,
            borderRadius: new BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color(0xCC000000),
                blurRadius: 5.0,
              ),
            ],
          ),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                    child: FlatButton(
                      splashColor: Theme.of(context).splashColor,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => settingsPage()),
                        );
                      },
                      child: Text("settings", style: menuTextStyle,),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: FlatButton(
                    splashColor: Theme.of(context).splashColor,
                    onPressed: (){
                      developer.log("item2Pressed");
                    },
                    child: Text("paste", style: menuTextStyle,),
                  ),
                ),

                SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: FlatButton(
                        splashColor: Theme.of(context).splashColor,
                        onPressed: (){
                          developer.log("item3Pressed");
                        },
                        child: Text("upload", style: menuTextStyle,),
                      ),
                    ),
                ),

              ],
            ),
          )
      ),
    );

  }
}