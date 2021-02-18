import 'package:fluttertoast/fluttertoast.dart';

class ToastComponent {
  static void toastMessage(String message, bool isLong) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
