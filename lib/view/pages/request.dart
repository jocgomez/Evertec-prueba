import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prueba_placeto_pay/controller/database.dart';
import 'package:prueba_placeto_pay/view/components/appbarComponent.dart';
import 'package:prueba_placeto_pay/view/components/bottomNavigationComponent.dart';
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
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 16),
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
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      elevation: 7.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                      child: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("data"),
                        ),
                      ),
                    );
                  });
            }));
  }
}
