import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/view/components/buttonComponent.dart';
import 'package:prueba_placeto_pay/view/components/toastComponent.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = "", password = "";
  bool isRegisterClicked = false,
      isUsernameIncomplete = false,
      isPasswordIncomplete = false,
      isPasswordInvisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  width: 130,
                  height: 130,
                  child: Image.asset('assets/ic_evertec.jpg'),
                  margin: EdgeInsets.all(50),
                ),
              ),
              Expanded(
                flex: 3,
                child: ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: Container(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      color: StylesElements.colorPrimary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          ButtonComponent(
                            text: isRegisterClicked
                                ? "Registrarte"
                                : "Iniciar sesión",
                            color: Colors.white,
                            borderColor: Colors.white,
                            function: () {
                              FocusScope.of(context).unfocus();

                              setState(() {
                                // Si el usuario y contraseña no estan vacíos se registra o ingresa segun el caso
                                if (username.isNotEmpty &&
                                    password.isNotEmpty) {
                                  // En caso de estar en la parte de registro
                                  if (isRegisterClicked) {
                                    // Se valida que el usuario no exista de la BD y se crea
                                    DBControll.createUserDB(username, password)
                                        .then((value) {
                                      if (value) {
                                        ToastComponent.toastMessage(
                                            "¡Bienvenido! $username", false);
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, "home", (route) => false);
                                      } else {
                                        // En caso de que exista se da un mensaje de retroalimentación
                                        ToastComponent.toastMessage(
                                            "Ya existe una cuenta con este nombre de usuario",
                                            false);
                                      }
                                    });
                                  } else {
                                    // Para ingresar, se lee el usuario de la BD
                                    DBControll.readUserDB(username, password)
                                        .then((value) {
                                      // Si no existe, se da un mensaje de retroalimentación
                                      if (value["username"] == false ||
                                          value["password"] == false) {
                                        ToastComponent.toastMessage(
                                            "No se encontró la cuenta, verifique el usuario o la contraseña",
                                            true);
                                        // Si existe se pasa a la siguiente página
                                      } else if (!value.containsValue(false)) {
                                        ToastComponent.toastMessage(
                                            "¡Bienvenido! $username", false);
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, "home", (route) => false);
                                      }
                                    });
                                  }
                                }
                                validateTextfield();
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Se validan los campos de texto para mostrar o no el mensaje de error
  void validateTextfield() {
    if (username.isEmpty) {
      isUsernameIncomplete = true;
    } else {
      isUsernameIncomplete = false;
    }
    if (password.isEmpty) {
      isPasswordIncomplete = true;
    } else {
      isPasswordIncomplete = false;
    }
  }
}
