import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/pages/home.dart';
import 'package:prueba_placeto_pay/view/pages/login.dart';
import 'package:prueba_placeto_pay/view/pages/request.dart';

Map<String, WidgetBuilder> getApplicationRoutes() => <String, WidgetBuilder>{
      '/': (BuildContext context) => LoginPage(),
      'home': (BuildContext context) => HomePage(),
      'request': (BuildContext context) => RequestPage(),
    };
