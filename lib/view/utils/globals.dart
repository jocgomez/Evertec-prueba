import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba_placeto_pay/model/user.dart';

class Globals {
  // Strings para los iconos
  static String strEmailIcon = "email";
  static String strUserIcon = "user";
  static String strPasswordIconInvisible = "passwordVisible";
  static String strPasswordIconVisible = "passwordInvisible";

  static User userInstance;

  static void toastMessage(String message, bool isLong) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
