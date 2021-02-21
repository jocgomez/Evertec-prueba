import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/model/WebService/auth.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/payment.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';

class WebService {
  static void processTransactionPost(
      Payment paymentInformation, BuildContext context) async {
    String url = "https://dev.placetopay.com/rest";
    await http
        .post('$url/gateway/process',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: getProcessTransactionBody(paymentInformation))
        .then((response) {
      if (response.body.isNotEmpty) {
        dynamic bodyDecode = json.decode(response.body);
        String state = bodyDecode["status"]["status"] == "REJECTED"
            ? Globals.strRejectedState
            : bodyDecode["status"]["status"] == "PENDING"
                ? Globals.strPendingState
                : bodyDecode["status"]["status"] == "APPROVED"
                    ? Globals.strSuccesState
                    : "";
        print(bodyDecode);
        print(state);
        DBControll.updateStatePaymentInformation(paymentInformation.pid, state);
        Navigator.pushNamed(context, "resume");
      }
    });
  }

  static dynamic getProcessTransactionBody(Payment paymentInformation) {
    // Información de autenticación
    String nonce = AuthWS.generateNonce();
    DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
    String seed = dateFormat.format(DateTime.now()) + "-" + "05" + ":" + "00";

    AuthWS authWS = new AuthWS(
        Globals.login,
        AuthWS.generateTranKey(nonce, seed),
        base64.encode(utf8.encode(nonce)),
        seed);

    // Información personal
    PersonalInformation personalInformation = new PersonalInformation(
        paymentInformation.personalInformation.name,
        paymentInformation.personalInformation.email,
        paymentInformation.personalInformation.phone);

    // Información de la tarjeta de credito
    CreditCard creditCardInformation = new CreditCard(
        paymentInformation.creditCard.cardNumber,
        paymentInformation.creditCard.cardExpMonth,
        paymentInformation.creditCard.cardExpYear,
        paymentInformation.creditCard.cardCVV);

    dynamic body = jsonEncode(<String, dynamic>{
      'auth': <String, dynamic>{
        'login': '${authWS.login}',
        'tranKey': '${authWS.tranKey}',
        'nonce': '${authWS.nonce}',
        'seed': '${authWS.seed}'
      },
      'locale': 'es_CO',
      "payment": {
        "reference": "TEST_20171108_144400",
        /* "description":
            "Ipsam quia sunt dolore minus atque blanditiis corrupti.", */
        "amount": {
          /* "taxes": [
            {"kind": "ice", "amount": 4.8, "base": 40},
            {"kind": "valueAddedTax", "amount": 7.6, "base": 40}
          ],
          "details": [
            {"kind": "shipping", "amount": 2},
            {"kind": "tip", "amount": 2},
            {"kind": "subtotal", "amount": 40}
          ], */
          "currency": "COP",
          "total": 50000
        }
      },
      /* "ipAddress": "127.0.0.1", */
      /* "userAgent": "Mozilla/5.0 USER_AGENT HERE", */
      /* "additional": {
        "SOME_ADDITIONAL": "http://example.com/yourcheckout",
      }, */
      'instrument': <String, dynamic>{
        'card': {
          'number': '${creditCardInformation.cardNumber.toString()}',
          'expirationMonth': '${creditCardInformation.cardExpMonth.toString()}',
          'expirationYear': '${creditCardInformation.cardExpYear.toString()}',
          'cvv': '${creditCardInformation.cardCVV.toString()}'
        },
        /* "credit": {
          "code": "1",
          "type": "02",
          "groupCode": "P",
          "installment": "24"
        }, */
        /* "otp": "a8ecc59c2510a8ae27e1724ebf4647b5" */
      },
      'payer': <String, dynamic>{
        /* "document": "8467451900",
        "documentType": "CC", */
        'name': '${personalInformation.name}',
        /* "surname": "Wisozk", */
        'email': '${personalInformation.email}',
        'mobile': '${personalInformation.phone}'
      },
      /* "buyer": {
        "document": "8467451900",
        "documentType": "CC",
        "name": "Miss Delia Schamberger Sr.",
        "surname": "Wisozk",
        "email": "tesst@gmail.com",
        "mobile": "3006108300"
      } */
    });
    //print(body);
    return body;
  }
}
