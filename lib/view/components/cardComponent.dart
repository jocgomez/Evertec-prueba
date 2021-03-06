import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/payment.dart';
import 'package:prueba_placeto_pay/view/components/alertDialogComponent.dart';
import 'package:prueba_placeto_pay/view/pages/resume.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class CardComponent extends StatelessWidget {
  CardComponent({Key key, @required this.paymentInformation}) : super(key: key);

  final Payment paymentInformation;

  @override
  Widget build(BuildContext context) {
    // Se inicializa la información recibida para crear la card
    String state = this.paymentInformation.state;
    String cardNumber = this.paymentInformation.creditCard.cardNumber;
    String cardExpMonth = this.paymentInformation.creditCard.cardExpMonth;
    String cardExpYear = this.paymentInformation.creditCard.cardExpYear;
    String cardCVV = this.paymentInformation.creditCard.cardCVV;
    String name = this.paymentInformation.personalInformation.name;
    String email = this.paymentInformation.personalInformation.email;
    String phone = this.paymentInformation.personalInformation.phone;

    // Componente que posee la estructura gráfica de la card, se pone la información enviada desde solicitudes
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 7.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: () {
          Navigator.pushNamed(context, "splash");
          DBControll.readPaymentWithTransactionResponse(
                  this.paymentInformation.pid)
              .then((processTransactionResponse) {
            if (processTransactionResponse != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResumePage(
                      processTransactionResponse: processTransactionResponse,
                    ),
                  ));
            }
          });
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
                  // Icono del estado, en caso de tardar el proceso de transacción pone un circular progress
                  Padding(
                    padding: EdgeInsets.only(right: 11),
                    child: IconTheme(
                      data: new IconThemeData(
                        size: 20,
                        color: state == Globals.strSuccesState
                            ? StylesElements.colorSucces
                            : state == Globals.strPendingState
                                ? StylesElements.colorPending
                                : state == Globals.strRejectedState
                                    ? StylesElements.colorFail
                                    : StylesElements.colorPrimary,
                      ),
                      child: state == Globals.strSuccesState
                          ? StylesElements.getIcon(Globals.strApprovedIcon)
                          : state == Globals.strPendingState
                              ? StylesElements.getIcon(Globals.strPendingIcon)
                              : state == Globals.strRejectedState
                                  ? StylesElements.getIcon(
                                      Globals.strRejectedIcon)
                                  : Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                StylesElements.colorPrimary),
                                      ),
                                    ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: <Widget>[
                    Text("N° Tarjeta:",
                        textAlign: TextAlign.right,
                        style: StylesElements.tsBoldBlack),
                    SizedBox(width: 15),
                    Text(
                      CreditCard.cardNumberFormat(cardNumber),
                      style: StylesElements.tsNormalBlack,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Fecha exp:",
                            textAlign: TextAlign.right,
                            style: StylesElements.tsBoldBlack),
                        SizedBox(width: 15),
                        Text(
                          "$cardExpMonth/$cardExpYear",
                          style: StylesElements.tsNormalBlack,
                        ),
                      ],
                    ),
                    SizedBox(width: 27),
                    Row(
                      children: <Widget>[
                        Text("CVV:",
                            textAlign: TextAlign.right,
                            style: StylesElements.tsBoldBlack),
                        SizedBox(width: 15),
                        Text(
                          cardCVV,
                          style: StylesElements.tsNormalBlack,
                        ),
                      ],
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 30, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Nombre:",
                                  textAlign: TextAlign.right,
                                  style: StylesElements.tsBoldBlack),
                              SizedBox(width: 15),
                              Text(name, style: StylesElements.tsNormalBlack),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: <Widget>[
                              Text("Email:",
                                  textAlign: TextAlign.right,
                                  style: StylesElements.tsBoldBlack),
                              SizedBox(width: 15),
                              Text(email, style: StylesElements.tsNormalBlack),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              Text("N° celular:",
                                  textAlign: TextAlign.right,
                                  style: StylesElements.tsBoldBlack),
                              SizedBox(width: 15),
                              Text(phone, style: StylesElements.tsNormalBlack),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      alignment: Alignment.bottomCenter,
                      icon: StylesElements.getIcon(Globals.strRemoveIcon),
                      color: StylesElements.colorFail,
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
