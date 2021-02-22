import 'package:prueba_placeto_pay/model/payment.dart';

// Objeto que se obtiene a partir de la respuesta del servicio web, se llena con toda la información de la respuesta
// y la información del pago, que incluye la información personal y la información de la tarjeta
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

  addPointValue(String val) {
    var priceLong = val;

    if (priceLong.length == 4) {
      priceLong = priceLong.substring(0, 1) +
          "." +
          priceLong.substring(1, priceLong.length);
    } else if (priceLong.length == 5) {
      priceLong = priceLong.substring(0, 2) +
          "." +
          priceLong.substring(2, priceLong.length);
    } else if (priceLong.length == 6) {
      priceLong = priceLong.substring(0, 3) +
          "." +
          priceLong.substring(3, priceLong.length);
    } else if (priceLong.length == 7) {
      priceLong = priceLong.substring(0, 1) +
          "." +
          priceLong.substring(1, 4) +
          "." +
          priceLong.substring(4, priceLong.length);
    }

    return priceLong;
  }
}
