import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/components/alertDialogComponent.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class AppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  AppbarComponent({Key key, @required this.titulo}) : super(key: key);
  final String titulo;

  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text("Evertec - $titulo", style: StylesElements.tsNormalWhite),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogComponent(
                      titulo: "Cerrar sesión",
                      contenido: Text(
                        "¿Estás seguro que desea salir de la app?",
                        style: StylesElements.tsNormalBlack,
                      ),
                      dosBotones: true,
                      textoBotonPositivo: "Aceptar",
                      textoBotonNegativo: "Cancelar",
                      funcionPositiva: () => Navigator.pushNamedAndRemoveUntil(
                          context, "/", (route) => false),
                      funcionNegativa: () => Navigator.pop(context));
                });
          },
        )
      ],
    );
  }
}
