import 'package:prueba_placeto_pay/model/payment.dart';

class ProcessTransactionResponse {
  String transactionDate;
  String reference;
  String paymentMethod;
  String franchiseName;
  String issuerName;
  int total;
  String currency;
  String receipt;
  bool refunded;
  String provider;
  String authorization;
  Payment paymentInformation;
  String message;

  ProcessTransactionResponse(
      this.transactionDate,
      this.reference,
      this.paymentMethod,
      this.franchiseName,
      this.issuerName,
      this.total,
      this.currency,
      this.receipt,
      this.refunded,
      this.provider,
      this.authorization,
      this.paymentInformation,
      this.message);
}
