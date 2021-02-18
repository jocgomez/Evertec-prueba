import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/view/components/alertDialogComponent.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class AppbarComponent extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Evertec - test", style: StylesElements.tsNormalWhite),
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
