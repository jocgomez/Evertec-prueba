import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class BottomNavigationComponent extends StatefulWidget {
  BottomNavigationComponent({this.selectedIndex});
  int selectedIndex;

  @override
  _BottomNavigationElementState createState() =>
      _BottomNavigationElementState();
}

class _BottomNavigationElementState extends State<BottomNavigationComponent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 60.0,
        child: BottomNavigationBar(
          selectedLabelStyle: StylesElements.tsNormalOrange,
          unselectedLabelStyle: StylesElements.tsNormalBlack,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              title: Text('Formulario'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              title: Text('Solicitudes'),
            ),
          ],
          currentIndex: widget.selectedIndex,
          selectedItemColor: StylesElements.colorPrimary,
          selectedIconTheme: IconThemeData(color: StylesElements.colorPrimary),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      switch (widget.selectedIndex) {
        case 0:
          Navigator.pushReplacementNamed(context, 'home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, 'request');
          break;
        default:
      }
    });
  }
}
