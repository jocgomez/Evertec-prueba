import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/controller/webService.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';
import 'package:prueba_placeto_pay/view/components/alertDialogComponent.dart';
import 'package:prueba_placeto_pay/view/components/appbarComponent.dart';
import 'package:prueba_placeto_pay/view/components/bottomNavigationComponent.dart';
import 'package:prueba_placeto_pay/view/components/buttonComponent.dart';
import 'package:prueba_placeto_pay/view/components/toastComponent.dart';
import 'package:prueba_placeto_pay/view/utils/cardMonthInputFormatter.dart';
import 'package:prueba_placeto_pay/view/utils/cardNumberInputFormatter.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentStep = 0;

  // Variables para la información personal
  String name = "",
      email = "",
      phone = "",
      emailErrorMessage = "Escriba un email.";
  bool isNameIncomplete = false,
      isEmailIncomplete = false,
      isPhoneIncomplete = false;

  // Variables para el medio de pago
  String cardCVVErrorMessage = "Escriba el CVV de la terjeta.";
  String cardExpDateErrorMessage = "Escriba la fecha de expiración";
  String cardNumber = "", cardExpMonth = "", cardExpYear = "", cardCvv = "";
  bool isCardNumberIncomplete = false,
      iscardMonthIncomplete = false,
      isCardYearIncomplete = false,
      isCardExpDateIncomplete = false,
      isCardCvvIncomplete = false;

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
      appBar: AppbarComponent(titulo: "Formulario"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Theme(
              data: ThemeData(
                primaryColor: StylesElements.colorPrimary,
              ),
              child: Stepper(
                controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                  return Container();
                },
                physics: ClampingScrollPhysics(),
                steps: mySteps(),
                currentStep: this.currentStep,
                onStepTapped: (step) {
                  setState(() {
                    this.currentStep = step;
                  });
                },
              ),
            ),
            ButtonComponent(
                color: StylesElements.colorPrimary,
                text: "Realizar pago",
                borderColor: StylesElements.colorPrimary,
                function: () {
                  FocusScope.of(context).unfocus();
                  validatePersonalInformation();
                  validatePaymentInformation();

                  if (validateAllInformation()) {
                    PersonalInformation personalInformation =
                        new PersonalInformation(name, email, phone);
                    CreditCard creditCard = new CreditCard(
                        cardNumber, cardExpMonth, cardExpYear, cardCvv);
                    DBControll.createPaymentDB(personalInformation, creditCard)
                        .then((paymentInformation) {
                      if (paymentInformation != null) {
                        Navigator.pushNamed(context, "splash");
                        WebService.processTransactionPost(
                            paymentInformation, context);
                        ToastComponent.toastMessage(
                            "Se ha generado el pago correctamente.", false);
                      } else {
                        ToastComponent.toastMessage(
                            "No se ha podido generar el pago.", false);
                      }
                    });
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogComponent(
                              titulo: "Información incompleta",
                              contenido: Text(
                                "No es posible continuar debido a que hace falta información.\n\nPor favor revise el numeral 1 o 2 para validar que todos los campos esten completos.",
                                style: StylesElements.tsNormalBlack,
                              ),
                              dosBotones: false,
                              textoBotonPositivo: "Aceptar",
                              textoBotonNegativo: "",
                              funcionPositiva: () => Navigator.pop(context),
                              funcionNegativa: () {});
                        });
                  }
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationComponent(selectedIndex: 0),
    );
  }

  List<Step> mySteps() {
    List<Step> steps = [];

    steps.add(Step(
      title: Text('Información personal', style: StylesElements.tsBoldOrange18),
      content: personalInformationWidget(),
      isActive: currentStep == 0,
    ));
    steps.add(Step(
      title: Text('Medio de pago', style: StylesElements.tsBoldOrange18),
      content: paymentInformationWidget(),
      isActive: currentStep == 1,
    ));

    return steps;
  }

  Widget personalInformationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: StylesElements.textFieldDecoration(
              "Nombre",
              true,
              Globals.strNameIcon,
              isNameIncomplete,
              "Escriba un nombre.",
              () {}),
          onChanged: (value) {
            name = value;
            isNameIncomplete = validateFieldInformation(name, isNameIncomplete);
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: StylesElements.textFieldDecoration(
              "Dirección de email",
              true,
              Globals.strEmailIcon,
              isEmailIncomplete,
              emailErrorMessage,
              () {}),
          onChanged: (value) {
            email = value;
            isEmailIncomplete =
                validateFieldInformation(email, isEmailIncomplete);
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          decoration: StylesElements.textFieldDecoration(
              "Número de celular",
              true,
              Globals.strPhoneIcon,
              isPhoneIncomplete,
              "Escriba un número de celular.",
              () {}),
          onChanged: (value) {
            phone = value;
            isPhoneIncomplete =
                validateFieldInformation(phone, isPhoneIncomplete);
          },
        ),
      ],
    );
  }

  void validatePersonalInformation() {
    isNameIncomplete = validateFieldInformation(name, isNameIncomplete);
    isEmailIncomplete = validateFieldInformation(email, isEmailIncomplete);
    isPhoneIncomplete = validateFieldInformation(phone, isPhoneIncomplete);
    // Se valida el formato del email para mostrar un mensaje de error dependiendo
    if (!EmailValidator.validate(email) && isEmailIncomplete == false) {
      setState(() {
        emailErrorMessage = "Escriba un email válido.";
        isEmailIncomplete = true;
      });
    }
    if (email.isEmpty) {
      emailErrorMessage = "Escriba un email.";
    }
  }

  Widget paymentInformationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(19),
            new CardNumberInputFormatter()
          ],
          textCapitalization: TextCapitalization.words,
          decoration: StylesElements.textFieldDecoration(
              "Numero de tarjeta",
              true,
              Globals.strCardIcon,
              isCardNumberIncomplete,
              "Escriba el número de la tarjeta.",
              () {}),
          onChanged: (value) {
            isCardNumberIncomplete =
                validateFieldInformation(value, isCardNumberIncomplete);
            if (value.isNotEmpty) {
              String valueClean = value.replaceAll(" ", "");
              cardNumber = valueClean;
            } else {
              cardNumber = null;
            }
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(4),
            new CardMonthInputFormatter()
          ],
          decoration: StylesElements.textFieldDecoration(
              "Fecha de expiración",
              true,
              Globals.strDateIcon,
              isCardExpDateIncomplete,
              cardExpDateErrorMessage,
              () {}),
          onChanged: (value) {
            if (value.length < 1) {
              cardExpDateErrorMessage = "Escriba la fecha de expiración";
              cardExpMonth = null;
              cardExpYear = null;
            } else if (value.length < 3) {
              cardExpYear = null;
            }

            try {
              // Se separa el / y se obtiene mes y año de expiración
              List<String> splitDate = value.split(new RegExp(r'(\/)'));
              cardExpMonth = splitDate[0];
              cardExpYear = splitDate[1];
            } catch (e) {}

            // Se valida la información para mostrar o no mensaje de error
            // Fecha y año deben estar completos para no mostrarlo
            iscardMonthIncomplete =
                validateFieldInformation(cardExpMonth, iscardMonthIncomplete);
            isCardYearIncomplete =
                validateFieldInformation(cardExpYear, isCardYearIncomplete);

            // Se valida que las fechas de expiración esten bien
            if (int.parse(cardExpMonth) > 12) {
              iscardMonthIncomplete = true;
              cardExpDateErrorMessage = "Fecha de expiración inválida";
            } else {
              iscardMonthIncomplete = false;
            }
            DateTime today = new DateTime.now();
            if (int.parse("20" + cardExpYear) < today.year) {
              isCardYearIncomplete = true;
              cardExpDateErrorMessage = "Fecha de expiración inválida";
            } else {
              isCardYearIncomplete = false;
            }

            // Si fecha o año esta incompleto, se muestra error
            if (isCardYearIncomplete == false &&
                iscardMonthIncomplete == false) {
              isCardExpDateIncomplete = false;
            } else {
              isCardExpDateIncomplete = true;
            }
            setState(() {});
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly,
            new LengthLimitingTextInputFormatter(4),
          ],
          decoration: StylesElements.textFieldDecoration(
              "CVV de la terjeta",
              true,
              Globals.strCvvIcon,
              isCardCvvIncomplete,
              cardCVVErrorMessage,
              () {}),
          onChanged: (value) {
            isCardCvvIncomplete =
                validateFieldInformation(value, isCardCvvIncomplete);
            if (value.isNotEmpty) {
              cardCvv = value;
            } else {
              cardCvv = null;
            }
            if (cardCvv.toString().length < 3 ||
                cardCvv.toString().length > 4) {
              cardCVVErrorMessage = "El CVV es inválido.";
              isCardCvvIncomplete = true;
            } else {
              cardCVVErrorMessage = "Escriba el CVV de la terjeta.";
            }
          },
        ),
      ],
    );
  }

  // Se valida la información de medio de pago, que no se encuentre vacia
  void validatePaymentInformation() {
    isCardNumberIncomplete =
        validateFieldInformation(cardNumber, isCardNumberIncomplete);
    iscardMonthIncomplete =
        validateFieldInformation(cardExpMonth, iscardMonthIncomplete);
    isCardYearIncomplete =
        validateFieldInformation(cardExpYear, iscardMonthIncomplete);
    isCardCvvIncomplete =
        validateFieldInformation(cardCvv, isCardCvvIncomplete);

    // Se valida que las fechas de expiración esten bien
    if (int.parse(cardExpMonth) > 12) {
      iscardMonthIncomplete = true;
      cardExpDateErrorMessage = "Fecha de expiración inválida";
    } else {
      iscardMonthIncomplete = false;
    }
    DateTime today = new DateTime.now();
    if (int.parse("20" + cardExpYear) < today.year) {
      isCardYearIncomplete = true;
      cardExpDateErrorMessage = "Fecha de expiración inválida";
    } else {
      isCardYearIncomplete = false;
    }

    // Se valida que el mes y año de expiración esten completos
    if (iscardMonthIncomplete || isCardYearIncomplete) {
      isCardExpDateIncomplete = true;
    } else {
      isCardExpDateIncomplete = false;
    }

    // Se valida que el cvv tenga 3 o 4 digitos para mostrar un mensaje de error dependiendo
    if (cardCvv.toString().length < 3 || cardCvv.toString().length > 4) {
      cardCVVErrorMessage = "El CVV es inválido.";
      isCardCvvIncomplete = true;
    }
    if (isCardCvvIncomplete) {
      cardCVVErrorMessage = "Escriba el CVV de la terjeta.";
    }
  }

  // Validación para los campos de texto String, si este esta vacio
  bool validateFieldInformation(String fieldValue, bool isEmpty) {
    setState(() {
      if (fieldValue.isEmpty) {
        isEmpty = true;
      } else {
        isEmpty = false;
      }
    });
    return isEmpty;
  }

  // Validación para los campos de texto Int, si este es null
  bool validateIntInformation(int fieldValue, bool isEmpty) {
    setState(() {
      if (fieldValue == null) {
        isEmpty = true;
      } else {
        isEmpty = false;
      }
    });
    return isEmpty;
  }

  // Se valida toda la información, de los strings y los int
  bool validateAllInformation() {
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        cardNumber != null &&
        cardExpMonth != null &&
        cardExpYear != null &&
        cardCvv != null) {
      if (isNameIncomplete == false &&
          isEmailIncomplete == false &&
          isPhoneIncomplete == false &&
          isCardNumberIncomplete == false &&
          isCardExpDateIncomplete == false &&
          isCardCvvIncomplete == false) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
