import 'package:fluttertoast/fluttertoast.dart';

class defaultToast {

  static void send(String input) {
    Fluttertoast.showToast(
      msg: input,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      fontSize: 16.0,
    );
  }
}