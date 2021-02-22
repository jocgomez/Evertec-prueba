import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';

class Payment {
  // Objeto del pago, se llena cuando se llena la información en la BD
  // Contiene la información personal del usuario y la información de la tarjeta
  String pid;
  PersonalInformation personalInformation;
  CreditCard creditCard;
  String state;

  Payment(this.pid, this.personalInformation, this.creditCard, this.state);
}
