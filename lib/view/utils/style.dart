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
  static TextStyle tsButtonOrange =
      new TextStyle(color: colorPrimary, fontWeight: FontWeight.bold);
  static TextStyle tsButtonWhite =
      new TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  // --- Iconos
  static final _icons = <String, IconData>{
    'email': Icons.mail_outline,
    'passwordVisible': Icons.lock_outline,
    'passwordInvisible': Icons.lock_open,
    'user': Icons.person_outline
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
