import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/pages/home.dart';
import 'package:prueba_placeto_pay/view/pages/login.dart';
import 'package:prueba_placeto_pay/view/pages/splash.dart';

Map<String, WidgetBuilder> getApplicationRoutes() => <String, WidgetBuilder>{
      '/': (BuildContext context) => LoginPage(),
      'home': (BuildContext context) => HomePage(),
      'splash': (BuildContext context) => SplashPage(),
      /*'avatar': (BuildContext context) => AvatarPage(),
      'card': (BuildContext context) => CardPage(),
      'animatedContainer': (BuildContext context) => AnimatedContainerPage(),
      'inputs': (BuildContext context) => InputPage(),
      'slider': (BuildContext context) => SliderPage(),
      'list': (BuildContext context) => ListaPage(), */
    };
