import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRegisterClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                child: Image.asset('assets/ic_evertec.jpg'),
                margin: EdgeInsets.all(50),
              ),
              ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
                    color: StylesElements.colorPrimary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 10),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: StylesElements.textFieldDecoration(
                              "Nombre de usuario", true, Globals.strUserIcon),
                          onChanged: (value) {},
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: StylesElements.textFieldDecoration(
                              "Contraseña", true, Globals.strPasswordIcon),
                          onChanged: (value) {},
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                          child: Text(isRegisterClicked
                              ? "Registrate"
                              : "Iniciar sesión"),
                          color: Colors.white,
                          textColor: StylesElements.colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              isRegisterClicked
                                  ? "Si ya tienes una cuenta, "
                                  : "Si aún no tienes cuenta, ",
                              style: TextStyle(color: Colors.white),
                            ),
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    isRegisterClicked = !isRegisterClicked;
                                  });
                                },
                                child: Text(
                                    isRegisterClicked
                                        ? "ingresa aquí"
                                        : "registrate aquí",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)))
                          ],
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
