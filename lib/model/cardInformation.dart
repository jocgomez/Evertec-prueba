class CreditCard {
  // Objeto con la información de la tarjeta de credito, se llena en el formulario
  String cardNumber;
  String cardExpMonth;
  String cardExpYear;
  String cardCVV;

  CreditCard(
      this.cardNumber, this.cardExpMonth, this.cardExpYear, this.cardCVV);

  // Se establece el formato del numero de la tarjeta, espacio cada 4 digitos
  static String cardNumberFormat(String text) {
    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return string;
  }
}
