import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(StylesElements.colorPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
