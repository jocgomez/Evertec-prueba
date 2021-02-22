import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';

// Objeto para la creación de la autenticación
class AuthWS {
  String login;
  String tranKey;
  String nonce;
  String seed;

  AuthWS(this.login, this.tranKey, this.nonce, this.seed);

  // Se crea un valor aleatorio para el nonce
  static String generateNonce() {
    math.Random rnd = new math.Random();
    List<int> values = new List<int>.generate(32, (i) => rnd.nextInt(256));
    return values.toString();
  }

  // Se genera el tranKey a partir de un sha256 y luego un base64
  static String generateTranKey(String nonce, String seed) {
    // Base64(SHA-256(nonce + seed + tranKey))
    String value = nonce + seed + Globals.tranKey;
    var bytes = utf8.encode(value);
    var valueSha256 = sha256.convert(bytes);
    var bytesDigest = valueSha256.bytes;

    return base64.encode(bytesDigest);
  }
}
