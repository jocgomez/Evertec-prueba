import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/model/user.dart';
import 'package:prueba_placeto_pay/view/components/buttonComponent.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRegisterClicked = false;
  String username = "";
  bool isUsernameIncomplete = false;
  String password = "";
  bool isPasswordIncomplete = false;
  bool isPasswordInvisible = true;

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
                width: 130,
                height: 130,
                child: Image.asset('assets/ic_evertec.jpg'),
                margin: EdgeInsets.all(50),
              ),
              ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 50.0, bottom: 20.0),
                    color: StylesElements.colorPrimary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 10),
                        TextField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          decoration: StylesElements.textFieldDecoration(
                              "Nombre de usuario",
                              true,
                              Globals.strUserIcon,
                              isUsernameIncomplete,
                              "Escriba un nombre de usuario",
                              () {}),
                          onChanged: (value) {
                            setState(() {
                              username = value;
                              isUsernameIncomplete = false;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isPasswordInvisible,
                          decoration: StylesElements.textFieldDecoration(
                              "Contraseña",
                              true,
                              isPasswordInvisible
                                  ? Globals.strPasswordIconInvisible
                                  : Globals.strPasswordIconVisible,
                              isPasswordIncomplete,
                              "Escriba una contraseña", () {
                            setState(() {
                              isPasswordInvisible = !isPasswordInvisible;
                            });
                          }),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                              isPasswordIncomplete = false;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        BotonComponent(
                          text: isRegisterClicked
                              ? "Registrate"
                              : "Iniciar sesión",
                          color: Colors.white,
                          borderColor: Colors.white,
                          function: () {
                            FocusScope.of(context).unfocus();

                            setState(() {
                              if (username.isNotEmpty) {
                                isUsernameIncomplete = false;
                                if (password.isNotEmpty) {
                                  isPasswordIncomplete = false;
                                  if (isRegisterClicked) {
                                    DBControll.createUserDB(username, password)
                                        .then((value) {
                                      if (value) {
                                        Fluttertoast.showToast(
                                          msg: "Bienvenido $username",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        Navigator.pushNamed(context, "splash");
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Ya existe una cuenta con este nombre de usuario",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      }
                                    });
                                  } else {
                                    DBControll.readUserDB(username, password)
                                        .then((value) {
                                      if (value["username"] == false ||
                                          value["password"] == false) {
                                        Fluttertoast.showToast(
                                          msg:
                                              "No se encontró la cuenta, verifique el usuario ó la contraseña",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                      } else if (!value.containsValue(false)) {
                                        Fluttertoast.showToast(
                                          msg: "Bienvenido $username",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                        );
                                        Navigator.pushNamed(context, "splash");
                                      }
                                    });
                                  }
                                }
                              }
                              if (username.isEmpty) {
                                isUsernameIncomplete = true;
                              }
                              if (password.isEmpty) {
                                isPasswordIncomplete = true;
                              }
                            });
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
