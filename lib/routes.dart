import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/pages/login.dart';

Map<String, WidgetBuilder> getApplicationRoutes() => <String, WidgetBuilder>{
      '/': (BuildContext context) => LoginPage(),
/*       'alert': (BuildContext context) => AlertPage(),
      'avatar': (BuildContext context) => AvatarPage(),
      'card': (BuildContext context) => CardPage(),
      'animatedContainer': (BuildContext context) => AnimatedContainerPage(),
      'inputs': (BuildContext context) => InputPage(),
      'slider': (BuildContext context) => SliderPage(),
      'list': (BuildContext context) => ListaPage(), */
    };
