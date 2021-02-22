import 'dart:async';

import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/components/buttonComponent.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer timer;
  int start;

  @override
  void initState() {
    start = 10;
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    didChangeDependencies();
    super.dispose();
  }

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
              Spacer(flex: 2),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(StylesElements.colorPrimary),
              ),
              Spacer(flex: 2),
              start == 0
                  ? () {
                      return Column(children: <Widget>[
                        /* SizedBox(height: 100), */
                        Text(
                            "Si la petición tarda mucho, puedes volver al inicio.\nUna vez se obtenga resultado se actualizará el pago respectivo.",
                            style: StylesElements.tsNormalBlack,
                            textAlign: TextAlign.center),
                        SizedBox(height: 20),
                        ButtonComponent(
                            color: StylesElements.colorPrimary,
                            text: "Volver",
                            borderColor: StylesElements.colorPrimary,
                            function: () => Navigator.pop(context)),
                      ]);
                    }()
                  : SizedBox(),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  // Contador para mostrar mensaje de retroalimentación en caso de tardar mucho el servicio en responder
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }
}
