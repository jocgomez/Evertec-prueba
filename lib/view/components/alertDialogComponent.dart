import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/components/buttonComponent.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class AlertDialogComponent extends StatelessWidget {
  AlertDialogComponent(
      {Key key,
      @required this.titulo,
      @required this.contenido,
      @required this.dosBotones,
      @required this.textoBotonPositivo,
      @required this.textoBotonNegativo,
      @required this.funcionPositiva,
      @required this.funcionNegativa})
      : super(key: key);

  final String titulo;
  final Widget contenido;
  final bool dosBotones;
  final String textoBotonNegativo;
  final String textoBotonPositivo;
  final VoidCallback funcionPositiva;
  final VoidCallback funcionNegativa;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.titulo, style: StylesElements.tsBoldOrange18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SingleChildScrollView(child: this.contenido),
      actions: <Widget>[
        this.dosBotones
            ? ButtonComponent(
                color: Colors.white,
                text: this.textoBotonNegativo,
                borderColor: StylesElements.colorPrimary,
                function: this.funcionNegativa)
            : SizedBox(),
        ButtonComponent(
            color: StylesElements.colorPrimary,
            text: this.textoBotonPositivo,
            borderColor: StylesElements.colorPrimary,
            function: this.funcionPositiva),
      ],
    );
  }
}
