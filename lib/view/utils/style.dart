import 'package:flutter/material.dart';

class StylesElements {
  // --- Colores
  static Color colorPrimary = new Color(0xFFfd7e14);
  static Color colorSecondary = new Color(0xFF0DD3AD);
  static Color colorBlack = new Color(0xFF333333);

  static Color colorSucces = new Color(0xFF28a745);
  static Color colorPending = new Color(0xFFffc107);
  static Color colorFail = new Color(0xFFdc3545);

  // --- Text styles
  // Texto en botones
  static TextStyle tsButtonOrange =
      new TextStyle(color: colorPrimary, fontWeight: FontWeight.bold);
  static TextStyle tsButtonWhite =
      new TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  // Texto bold
  static TextStyle tsBoldOrange18 = new TextStyle(
      color: colorPrimary, fontWeight: FontWeight.bold, fontSize: 18);
  static TextStyle tsBoldBlack18 = new TextStyle(
      color: colorBlack, fontWeight: FontWeight.bold, fontSize: 18);
  static TextStyle tsBoldOrange =
      new TextStyle(color: colorPrimary, fontWeight: FontWeight.bold);
  static TextStyle tsBoldBlack =
      new TextStyle(color: colorBlack, fontWeight: FontWeight.bold);
  // Texto Normal
  static TextStyle tsNormalOrange = new TextStyle(color: colorPrimary);
  static TextStyle tsNormalWhite = new TextStyle(color: Colors.white);
  static TextStyle tsNormalBlack = new TextStyle(color: colorBlack);

  // --- Iconos
  static final _icons = <String, IconData>{
    'email': Icons.mail_outline,
    'passwordVisible': Icons.lock_outline,
    'passwordInvisible': Icons.lock_open,
    'user': Icons.person_outline,
    'name': Icons.person_outline,
    'phone': Icons.phone_android,
    'card': Icons.credit_card,
    'date': Icons.date_range,
    'cvv': Icons.security
  };
  static Icon getIcon(String nombreIcono) {
    return Icon(
      _icons[nombreIcono],
    );
  }

  // --- Estilo de los TextFields
  static InputDecoration textFieldDecoration(
      String labelText,
      bool withIcon,
      String iconText,
      bool isErrorShow,
      String errorText,
      VoidCallback iconFunction) {
    return InputDecoration(
        fillColor: Colors.white,
        focusColor: Colors.white,
        filled: true,
        labelText: labelText,
        alignLabelWithHint: true,
        isDense: true,
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: withIcon
            ? IconButton(
                icon: getIcon(iconText), onPressed: () => iconFunction())
            : null,
        errorText: isErrorShow ? errorText : null);
  }
}
