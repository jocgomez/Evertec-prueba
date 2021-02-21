import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/controller/webService.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/payment.dart';
import 'package:prueba_placeto_pay/view/components/alertDialogComponent.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class CardComponent extends StatelessWidget {
  CardComponent({Key key, @required this.paymentInformation}) : super(key: key);

  final Payment paymentInformation;

  @override
  Widget build(BuildContext context) {
    String state = this.paymentInformation.state;
    String cardNumber = this.paymentInformation.creditCard.cardNumber;
    String cardExpMonth = this.paymentInformation.creditCard.cardExpMonth;
    String cardExpYear = this.paymentInformation.creditCard.cardExpYear;
    String cardCVV = this.paymentInformation.creditCard.cardCVV;
    String name = this.paymentInformation.personalInformation.name;
    String email = this.paymentInformation.personalInformation.email;
    String phone = this.paymentInformation.personalInformation.phone;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 7.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pushNamed(context, "splash");
          WebService.processTransactionPost(this.paymentInformation, context);
          //Navigator.pushNamed(context, "resume");
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      StylesElements.getIcon(Globals.strCardIcon),
                      SizedBox(width: 5),
                      Text(
                        "Información de la tarjeta",
                        style: StylesElements.tsBoldOrange,
                      ),
                    ],
                  ),
                  Text(state,
                      style: state == Globals.strSuccesState
                          ? StylesElements.tsBoldGreenSucces
                          : state == Globals.strPendingState
                              ? StylesElements.tsBoldOrangePending
                              : state == Globals.strRejectedState
                                  ? StylesElements.tsBoldRedFail
                                  : StylesElements.tsNormalBlack),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  CreditCard.cardNumberFormat(cardNumber),
                  style: StylesElements.tsNormalBlack,
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: <Widget>[
                    Text(
                      "$cardExpMonth/$cardExpYear",
                      style: StylesElements.tsNormalBlack,
                    ),
                    SizedBox(width: 75),
                    Text(
                      cardCVV,
                      style: StylesElements.tsNormalBlack,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  StylesElements.getIcon(Globals.strUserIcon),
                  SizedBox(width: 4),
                  Text(
                    "Información personal",
                    style: StylesElements.tsBoldOrange,
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(name, style: StylesElements.tsNormalBlack),
                          SizedBox(height: 4),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            spacing: 15,
                            children: <Widget>[
                              Text(email, style: StylesElements.tsNormalBlack),
                              Text(phone, style: StylesElements.tsNormalBlack)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: StylesElements.getIcon(Globals.strRemoveIcon),
                      color: Colors.red,
                      visualDensity: VisualDensity.compact,
                      onPressed: () => showDialogDeletePayment(
                          context, this.paymentInformation.pid))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void showDialogDeletePayment(BuildContext context, String pid) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogComponent(
              titulo: "Eliminar pago",
              contenido: Text(
                "¿Está seguro que desea eliminar el pago? Perderá toda la información del mismo y no podrá recuperarla.",
                style: StylesElements.tsNormalBlack,
              ),
              dosBotones: true,
              textoBotonPositivo: "Aceptar",
              textoBotonNegativo: "Cancelar",
              funcionPositiva: () {
                DBControll.deletePaymentInformation(pid);
                Navigator.pop(context);
              },
              funcionNegativa: () => Navigator.pop(context));
        });
  }
}
