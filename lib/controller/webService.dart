import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/model/WebService/auth.dart';
import 'package:prueba_placeto_pay/model/WebService/processTransaction.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/payment.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';
import 'package:prueba_placeto_pay/view/pages/resume.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';

class WebService {
  static void processTransactionPost(
      Payment paymentInformation, BuildContext context) async {
    String url = "https://dev.placetopay.com/rest";
    // Se realiza la solicitud POST
    await http
        .post('$url/gateway/process',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: getProcessTransactionBody(paymentInformation))
        .then((response) {
      // Se obtiene la respuesta y se recibe el estado de la misma
      if (response.body.isNotEmpty) {
        dynamic bodyDecode = json.decode(response.body);
        String state = bodyDecode["status"]["status"] == "REJECTED"
            ? Globals.strRejectedState
            : bodyDecode["status"]["status"] == "PENDING"
                ? Globals.strPendingState
                : bodyDecode["status"]["status"] == "APPROVED"
                    ? Globals.strSuccesState
                    : "";

        // Se crea un objeto con la información obtenida como respuesta
        paymentInformation.state = state;
        ProcessTransactionResponse processTransactionResponse =
            createTransactionResponseObj(bodyDecode, paymentInformation);

        // Se actualiza el estado y la información adicional del pago en la BD
        DBControll.updateStatePaymentInformation(paymentInformation.pid, state);
        DBControll.updatePaymentWithTransactionResponse(
            paymentInformation.pid, processTransactionResponse);
        try {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResumePage(
                  processTransactionResponse: processTransactionResponse,
                ),
              ));
        } catch (e) {}
      }
    });
  }

  static dynamic getProcessTransactionBody(Payment paymentInformation) {
    // Información de autenticación
    String nonce = AuthWS.generateNonce();
    DateFormat dateFormat = new DateFormat("yyyy-MM-ddTHH:mm:ss");
    String seed = dateFormat.format(DateTime.now()) + "-" + "05" + ":" + "00";

    // Se crea el bojeto de la autenticación
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

    // Valor aleatorio para el precio entre 50000 y 100000
    var random = new Random();
    int randomPrice = random.nextInt(100000) + 50000;
    // Se crea el cuerpo del objeto JSON que recibe el servicio
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
        "amount": {"currency": "COP", "total": randomPrice}
      },
      'instrument': <String, dynamic>{
        'card': {
          'number': '${creditCardInformation.cardNumber.toString()}',
          'expirationMonth': '${creditCardInformation.cardExpMonth.toString()}',
          'expirationYear': '${creditCardInformation.cardExpYear.toString()}',
          'cvv': '${creditCardInformation.cardCVV.toString()}'
        },
      },
      'payer': <String, dynamic>{
        'name': '${personalInformation.name}',
        'email': '${personalInformation.email}',
        'mobile': '${personalInformation.phone}'
      },
    });
    //print(body);
    return body;
  }

  static ProcessTransactionResponse createTransactionResponseObj(
      dynamic bodyDecode, Payment paymentInformation) {
    // A partir de la información retornada por el servicio se crea un objeto de tipo
    // Process transaction
    String transactionDate = bodyDecode["transactionDate"];
    String reference = bodyDecode["reference"];
    String paymentMethod = bodyDecode["paymentMethod"];
    String franchiseName = bodyDecode["franchiseName"];
    String issuerName = bodyDecode["issuerName"].toString();
    int total = bodyDecode["amount"]["total"] == null
        ? 0
        : bodyDecode["amount"]["total"];
    String currency = bodyDecode["amount"]["currency"];
    String receipt = bodyDecode["receipt"].toString();
    bool refunded =
        bodyDecode["refunded"] == null ? false : bodyDecode["refunded"];
    String provider = bodyDecode["provider"];
    String authorization = bodyDecode["authorization"];
    String message = bodyDecode["status"]["message"];

    ProcessTransactionResponse processTransactionResponse =
        new ProcessTransactionResponse(
            transactionDate,
            reference,
            paymentMethod,
            franchiseName,
            issuerName,
            total,
            currency,
            receipt,
            refunded,
            provider,
            authorization,
            paymentInformation,
            message);

    return processTransactionResponse;
  }
}
