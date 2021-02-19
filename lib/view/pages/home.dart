import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba_placeto_pay/view/components/appbarComponent.dart';
import 'package:prueba_placeto_pay/view/components/bottomNavigationComponent.dart';
import 'package:prueba_placeto_pay/view/components/buttonComponent.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentStep = 0;
  String name = "",
      email = "",
      phone = "",
      emailErrorMessage = "Escriba un email.";
  bool isNameIncomplete = false,
      isEmailIncomplete = false,
      isPhoneIncomplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
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
                  validatePersonalInformation();
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
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text("Hola mundo")],
      ),
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
              "Nombre y apellido",
              true,
              Globals.strNameIcon,
              isNameIncomplete,
              "Escriba nombre y apellido.",
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
            BlacklistingTextInputFormatter("."),
            BlacklistingTextInputFormatter("-"),
            BlacklistingTextInputFormatter(","),
            BlacklistingTextInputFormatter(" "),
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
    if (!EmailValidator.validate(email)) {
      emailErrorMessage = "Escriba un email válido.";
    }
  }

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
}
