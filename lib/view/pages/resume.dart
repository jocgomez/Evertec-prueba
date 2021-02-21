import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prueba_placeto_pay/model/WebService/processTransaction.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';
import 'package:prueba_placeto_pay/view/components/appbarComponent.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class ResumePage extends StatefulWidget {
  // Se recibe el parametro al entrar a la página
  final ProcessTransactionResponse processTransactionResponse;
  ResumePage({Key key, @required this.processTransactionResponse})
      : super(key: key);

  @override
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  PersonalInformation personalInformation;
  CreditCard creditCardInformation;
  String transactionDate;

  @override
  void initState() {
    // Inicialización de los objetos de información personal y medio de pago
    personalInformation = widget
        .processTransactionResponse.paymentInformation.personalInformation;
    creditCardInformation =
        widget.processTransactionResponse.paymentInformation.creditCard;

    String transactionDateIso =
        widget.processTransactionResponse.transactionDate;
    transactionDate = DateFormat("dd-MM-yyyy HH:mm:ss")
        .format(DateTime.parse(transactionDateIso));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Se captura la salida de la pestaña para saltar la pagina de splash
        Navigator.pop(context);
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppbarComponent(titulo: "Resumen"),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: <Widget>[
                personalInformationWidget(),
                paymentInformationWidget(),
                transactionProcessInformationWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget personalInformationWidget() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            StylesElements.getIcon(Globals.strUserIcon),
            SizedBox(width: 4),
            Text(
              "Información personal",
              style: StylesElements.tsBoldOrange,
            ),
          ],
        ),
        SizedBox(height: 8),
        informationStructureWidget(
            title: "Nombre", content: personalInformation.name),
        informationStructureWidget(
            title: "Email", content: personalInformation.email),
        informationStructureWidget(
            title: "N° Celular", content: personalInformation.phone),
      ],
    );
  }

  Widget paymentInformationWidget() {
    return Column(
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
        SizedBox(height: 8),
        informationStructureWidget(
            title: "Franquicia",
            content: widget.processTransactionResponse.franchiseName),
        informationStructureWidget(
            title: "Banco",
            content: widget.processTransactionResponse.issuerName),
        informationStructureWidget(
            title: "N° Tarjeta", content: creditCardInformation.cardNumber),
        informationStructureWidget(
            title: "Fecha de exp.",
            content:
                '${creditCardInformation.cardExpMonth}/${creditCardInformation.cardExpYear}'),
        informationStructureWidget(
            title: "CVV", content: creditCardInformation.cardCVV),
      ],
    );
  }

  Widget transactionProcessInformationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            StylesElements.getIcon(Globals.strReceiptIcon),
            SizedBox(width: 5),
            Text(
              "Información del pago",
              style: StylesElements.tsBoldOrange,
            ),
          ],
        ),
        SizedBox(height: 8),
        informationStructureWidget(
            title: "Estado",
            content:
                widget.processTransactionResponse.paymentInformation.state),
        widget.processTransactionResponse.paymentInformation.state !=
                Globals.strSuccesState
            ? informationStructureWidget(
                title: "Descripción",
                content: widget.processTransactionResponse.message)
            : SizedBox(),
        informationStructureWidget(
            title: "Recibo",
            content: widget.processTransactionResponse.receipt),
        informationStructureWidget(
            title: "Fecha del pago", content: transactionDate),
        informationStructureWidget(
            title: "Referencia",
            content: widget.processTransactionResponse.reference),
        informationStructureWidget(
            title: "Proveedor",
            content: widget.processTransactionResponse.provider),
        informationStructureWidget(
            title: "Total",
            content: widget.processTransactionResponse.addPointValue(
                widget.processTransactionResponse.total.toString())),
        informationStructureWidget(
            title: "Divisa",
            content: widget.processTransactionResponse.currency),
        informationStructureWidget(
            title: "Reembolsable",
            content: widget.processTransactionResponse.refunded ? "Si" : "No"),
        informationStructureWidget(
            title: "Autorización",
            content: widget.processTransactionResponse.authorization),
      ],
    );
  }

  Widget informationStructureWidget({String title, String content}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Text(title,
                  textAlign: TextAlign.right,
                  style: StylesElements.tsBoldBlack)),
          SizedBox(width: 20),
          Expanded(
              flex: 3,
              child: Text(
                content,
                textAlign: TextAlign.left,
                style: title == "Estado"
                    ? styleForState()
                    : StylesElements.tsNormalBlack,
              )),
        ],
      ),
    );
  }

  TextStyle styleForState() {
    String state = widget.processTransactionResponse.paymentInformation.state;
    if (state == Globals.strSuccesState) {
      return StylesElements.tsBoldGreenSucces;
    } else if (state == Globals.strPendingState) {
      return StylesElements.tsBoldOrangePending;
    } else if (state == Globals.strRejectedState) {
      return StylesElements.tsBoldRedFail;
    } else {
      return StylesElements.tsNormalBlack;
    }
  }
}
