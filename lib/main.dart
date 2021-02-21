import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/routes.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evertec test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(color: StylesElements.colorPrimary),
        primaryColor: StylesElements.colorPrimary,
        cursorColor: StylesElements.colorPrimary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: getApplicationRoutes(),
    );
  }
}
