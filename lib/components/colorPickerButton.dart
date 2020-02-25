import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';



// a basic color picker button that displays the given color in
// hex and a square with the actual color next to it
class colorPickerButton extends StatelessWidget {

  const colorPickerButton({
    Key key,
    @required this.currentColor,
    @required this.onColorChanged,
  }) : super(key: key);

  final Color currentColor;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build (context) {

    TextStyle main = TextStyle(
      color: Theme.of(context).textTheme.body1.color,
      fontFamily: 'monospace',
    );
    
    return Container(
      width: 121,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).accentColor, width: 1),
        ),
      ),
      child: Row(
        children: <Widget>[

          FlatButton(
            child: Text(
              "#" + currentColor.toString().substring(10, 16).toUpperCase(),
              style: main,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        content: SingleChildScrollView(
                          child: ColorPicker(

                            pickerColor: currentColor,
                            onColorChanged: onColorChanged,
                            colorPickerWidth: 300.0,
                            pickerAreaHeightPercent: 0.7,
                            enableAlpha: false,
                            displayThumbColor: true,
                            enableLabel: true,
                            paletteType: PaletteType.hsv,
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),

          Container(
            height: 30,
            width: 30,
            color: currentColor,
          ),
        ],
      ),
    );
  }
}