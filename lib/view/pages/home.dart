import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/components/appbarComponent.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppbarComponent());
  }
}
