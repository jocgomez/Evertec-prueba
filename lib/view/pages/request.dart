import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/model/WebService/auth.dart';
import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/payment.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';
import 'package:prueba_placeto_pay/view/components/appbarComponent.dart';
import 'package:prueba_placeto_pay/view/components/bottomNavigationComponent.dart';
import 'package:prueba_placeto_pay/view/components/cardComponent.dart';
import 'package:prueba_placeto_pay/view/utils/style.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Text("Lista de pagos realizados",
                style: StylesElements.tsBoldOrange18),
          ),
          requestPaymentsCardsWidget()
        ],
      ),
      bottomNavigationBar: BottomNavigationComponent(selectedIndex: 1),
    );
  }

  Widget requestPaymentsCardsWidget() {
    return Expanded(
        child: StreamBuilder(
            stream: DBControll.readAllPaymentDB(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              int length = snapshot.data.documents.length;
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot doc = snapshot.data.documents[index];
                    PersonalInformation personalInformation =
                        new PersonalInformation(doc.data["name"],
                            doc.data["email"], doc.data["phone"]);
                    CreditCard creditCardInformation = new CreditCard(
                        doc.data["cardNumber"],
                        doc.data["cardExpMonth"],
                        doc.data["cardExpYear"],
                        doc.data["cardCVV"]);
                    Payment paymentInformation = new Payment(
                        doc.documentID,
                        personalInformation,
                        creditCardInformation,
                        doc.data["state"]);
                    return CardComponent(
                        paymentInformation: paymentInformation);
                  });
            }));
  }
}
