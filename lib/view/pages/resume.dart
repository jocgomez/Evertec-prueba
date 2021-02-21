import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/components/appbarComponent.dart';

class ResumePage extends StatefulWidget {
  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppbarComponent(titulo: "Resumen"),
      ),
    );
  }
}
