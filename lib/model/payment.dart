import 'package:prueba_placeto_pay/model/cardInformation.dart';
import 'package:prueba_placeto_pay/model/personalInformation.dart';

class Payment {
  String pid;
  PersonalInformation personalInformation;
  CreditCard creditCard;

  Payment(this.pid, this.personalInformation, this.creditCard);
}
