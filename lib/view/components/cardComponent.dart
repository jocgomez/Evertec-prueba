import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/payment.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class CardComponent extends StatelessWidget {
  CardComponent({Key key, @required this.paymentInformation}) : super(key: key);

  final Payment paymentInformation;

  @override
  Widget build(BuildContext context) {
    String state = this.paymentInformation.state;
    int cardNumber = this.paymentInformation.creditCard.cardNumber;
    int cardExpMonth = this.paymentInformation.creditCard.cardExpMonth;
    int cardExpYear = this.paymentInformation.creditCard.cardExpYear;
    int cardCVV = this.paymentInformation.creditCard.cardCVV;
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
                        style: StylesElements.tsNormalOrange,
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
              Text(
                CreditCard.cardNumberFormat(cardNumber.toString()),
                style: StylesElements.tsNormalBlack,
              ),
              SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Text(
                    "${cardExpMonth.toString()}/${cardExpYear.toString()}",
                    style: StylesElements.tsNormalBlack,
                  ),
                  SizedBox(width: 75),
                  Text(
                    cardCVV.toString(),
                    style: StylesElements.tsNormalBlack,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  StylesElements.getIcon(Globals.strUserIcon),
                  SizedBox(width: 4),
                  Text(
                    "Información personal",
                    style: StylesElements.tsNormalOrange,
                  )
                ],
              ),
              SizedBox(height: 5),
              Text(name, style: StylesElements.tsNormalBlack),
              SizedBox(height: 4),
              Row(
                children: <Widget>[
                  Text(email, style: StylesElements.tsNormalBlack),
                  SizedBox(width: 30),
                  Text(phone, style: StylesElements.tsNormalBlack)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
