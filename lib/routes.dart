import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/pages/home.dart';
import 'package:prueba_placeto_pay/view/pages/login.dart';
import 'package:prueba_placeto_pay/view/pages/request.dart';
import 'package:prueba_placeto_pay/view/pages/resume.dart';
import 'package:prueba_placeto_pay/view/pages/splash.dart';

Map<String, WidgetBuilder> getApplicationRoutes() => <String, WidgetBuilder>{
      '/': (BuildContext context) => LoginPage(),
      'splash': (BuildContext context) => SplashPage(),
      'home': (BuildContext context) => HomePage(),
      'request': (BuildContext context) => RequestPage(),
      'resume': (BuildContext context) => ResumePage(),
    };
