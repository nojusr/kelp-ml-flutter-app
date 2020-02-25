import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import "package:vector_math/vector_math.dart" as v;
import "package:bezier/bezier.dart";
import 'dart:developer' as developer;

class kelpTabBar extends StatefulWidget {

  const kelpTabBar({
    Key key,
    this.controller,
    this.textLeft,
    this.textRight,
    this.centerFab,
    this.backgroundColor,
    this.indicatorColor,
    this.textColor,

  }):super(key:key);

  final TabController controller;
  final String textLeft;
  final String textRight;
  final FloatingActionButton centerFab;
  final Color backgroundColor;
  final Color indicatorColor;
  final Color textColor;


  @override
  kelpTabBarState createState() => kelpTabBarState();
}

class kelpTabBarState extends State<kelpTabBar> {

  double animVal = 0;

  void tabChangeListener() {
    setState(() {
      animVal = widget.controller.animation.value;

    });
    //developer.log("listener called");
    //animVal = widget.controller.animation.value;
  }

  @override
  void initState() {

    super.initState();

    widget.controller.animation.addListener(tabChangeListener);
  }

  @override
  void dispose() {

    widget.controller.animation.removeListener(tabChangeListener);

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final double indicator_length = MediaQuery.of(context).size.width*0.35;
    final double indicator_margin = MediaQuery.of(context).size.width/6-indicator_length/3;
    final double startpoint =  (MediaQuery.of(context).size.width-indicator_length)+indicator_margin;


    return Stack(
      children: <Widget>[




        Container(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 82,
              minWidth: double.infinity,
            ),
            child: CustomPaint(
              painter: kelpBarPainter(animVal, widget.backgroundColor, widget.indicatorColor),
            ),
          ),
        ),


        Container(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            height: 82,
            width: double.infinity,
            child:
            ClipPath(
              clipper: kelpTabBarClipper(),
              child: Material(
                color: Colors.transparent,

                child: InkWell(
                  splashColor: Theme.of(context).splashColor,
                  highlightColor: Colors.transparent,
                  onTap: () {}, // for some reason onTapDown doesn't work without onTap
                  onTapDown: (details) {
                    if (details.globalPosition.dx > (MediaQuery.of(context).size.width/2)) {
                      widget.controller.animateTo(1, duration: Duration(milliseconds: 500), curve: Curves.easeOutExpo);
                    } else {
                      widget.controller.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOutExpo);
                    }

                  },
                ),
              ),
            ),
          ),
        ),


        Container(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),

          alignment: Alignment.bottomCenter,
            child: widget.centerFab,
        ),


        IgnorePointer(
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(indicator_margin, 0, 0, 15),
            width: ((startpoint+indicator_length)-indicator_margin*2)-startpoint,
              child: Align(
                alignment: Alignment.bottomCenter,
                child:Text(
                  widget.textLeft,
                  style: TextStyle(
                    color: widget.textColor,
                  ),
                ),
              ),
          ),
        ),
        
        IgnorePointer(
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(startpoint, 0, indicator_margin, 15),
            width: ((startpoint+indicator_length)-indicator_margin*2),
            child: Align(
              alignment: Alignment.bottomCenter,
              child:Text(
                widget.textRight,
                style: TextStyle(
                  color: widget.textColor,
                ),
              ),
            ),
          ),
        ),


      ],
    );
  }


}


class kelpBarPainter extends CustomPainter {

  double bottom_height = 0.45;
  double top_padding = 16;
  double padding = 15;
  double smoothness = 25;
  double xpos;
  Color bgColor;
  Color indicatorColor;


  kelpBarPainter(double xpos, Color bgColor, Color indicatorColor) {
    this.xpos = xpos;
    this.bgColor = bgColor;
    this.indicatorColor = indicatorColor;
  }
  // from 0.0 to 1.0
  v.Vector2 getPosByPercentage(double Xcoord, Size size, double theoretical_midpoint) {

    double Ycoord = size.height*bottom_height;

    if (Xcoord < theoretical_midpoint-(size.height/2)-padding-smoothness ) {
      //developer.log("returning a meme");
      return new v.Vector2(Xcoord, Ycoord);
    } else if (Xcoord < size.width/2) {

      final leftcurve = new CubicBezier([



        new v.Vector2(theoretical_midpoint, top_padding),

        new v.Vector2(theoretical_midpoint-smoothness,top_padding),
        new v.Vector2(theoretical_midpoint-smoothness,size.height*bottom_height),
        new v.Vector2(theoretical_midpoint-(size.height/2)-padding-smoothness, size.height*bottom_height),
      ]);


      double t = leftcurve.nearestTValue(v.Vector2(Xcoord, 0));

      final point = leftcurve.pointAt(t);
      //developer.log("point x:"+point.x.toString()+" point y:"+point.y.toString());
      return point;

    } else if (Xcoord > theoretical_midpoint+(size.height/2)+padding+smoothness) {
      return new v.Vector2(Xcoord, Ycoord);
    } else if (Xcoord > theoretical_midpoint) {



      final rightcurve = new CubicBezier([
        new v.Vector2(theoretical_midpoint, top_padding),
        new v.Vector2(theoretical_midpoint+smoothness,top_padding),
        new v.Vector2(theoretical_midpoint+smoothness,size.height*bottom_height),

        new v.Vector2(theoretical_midpoint+(size.height/2)+padding+smoothness, size.height*bottom_height)
      ]);

      double t = rightcurve.nearestTValue(v.Vector2(Xcoord, 0));
      final point = rightcurve.pointAt(t);
      //developer.log("point x:"+point.x.toString()+" point y:"+point.y.toString());
      return point;
    }


  }

  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = bgColor;
    paint.style = PaintingStyle.fill;
    var path = Path();

    var floatfactor = 4;

    //var theoretical_midpoint = ((size.width/2)*xpos/floatfactor)+( (size.width/2) - (size.width/2)/(floatfactor*2)) ;
    var theoretical_midpoint = size.width/2;

    // left curve to *midpoint*
    path.moveTo(0, size.height*bottom_height);
    path.lineTo( theoretical_midpoint-(size.height/2)-padding-smoothness, size.height*bottom_height);
    path.cubicTo( theoretical_midpoint-smoothness,size.height*bottom_height,theoretical_midpoint-smoothness,top_padding,theoretical_midpoint, top_padding);

    // right curve from *midpoint*
    path.cubicTo(theoretical_midpoint+smoothness,top_padding,theoretical_midpoint+smoothness,size.height*bottom_height, theoretical_midpoint+(size.height/2)+padding+smoothness, size.height*bottom_height);
    path.lineTo(size.width, size.height*bottom_height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);

    paint.color = indicatorColor;
    paint.strokeWidth=2;
    paint.style=PaintingStyle.stroke;

    var linepath = Path();


    double indicator_length = size.width*0.35;
    double indicator_margin = size.width/6-indicator_length/3;

    final double startpoint =  xpos*(size.width-indicator_length)+indicator_margin;

    final point2 = getPosByPercentage(startpoint, size, theoretical_midpoint);

    linepath.moveTo(point2.x, point2.y);

    for (double i=startpoint; i < (startpoint+indicator_length)-indicator_margin*2; i+= 1 ) {
      final point = getPosByPercentage(i, size, size.width/2);
      linepath.lineTo(point.x, point.y);
    }

    linepath.moveTo(point2.x, point2.y);
    linepath.close();
    canvas.drawPath(linepath, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class kelpTabBarClipper extends CustomClipper<Path> {

  double bottom_height = 0.45;
  double top_padding = 16;
  double padding = 15;
  double smoothness = 25;


  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height*bottom_height);
    path.lineTo( (size.width/2)-(size.height/2)-padding-smoothness, size.height*bottom_height);
    path.cubicTo( (size.width/2)-smoothness,size.height*bottom_height,(size.width/2)-smoothness,top_padding,size.width/2, top_padding);

    //path.lineTo( (size.width/2)+(size.height/2)+padding, top_padding);
    path.cubicTo((size.width/2)+smoothness,top_padding,(size.width/2)+smoothness,size.height*bottom_height, (size.width/2)+(size.height/2)+padding+smoothness, size.height*bottom_height);
    path.lineTo(size.width, size.height*bottom_height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;

  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}