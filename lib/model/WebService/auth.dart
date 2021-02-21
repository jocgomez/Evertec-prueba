import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:prueba_placeto_pay/view/utils/globals.dart';

class AuthWS {
  String login;
  String tranKey;
  String nonce;
  String seed;

  AuthWS(this.login, this.tranKey, this.nonce, this.seed);

  static String generateNonce() {
    math.Random rnd = new math.Random();
    List<int> values = new List<int>.generate(32, (i) => rnd.nextInt(256));
    return values.toString();
    /* return base64UrlEncode(utf8.encode('12345678')); */
  }

  static String generateTranKey(String nonce, String seed) {
    // Base64(SHA-256(nonce + seed + tranKey))
    String value = nonce + seed + Globals.tranKey;
    /* String value = '12345678' + '2018-01-29T17:02:49-05:00' + 'ABCD1234'; */
    var bytes = utf8.encode(value);
    var valueSha256 = sha256.convert(bytes);
    var bytesDigest = valueSha256.bytes;

    return base64.encode(bytesDigest);
  }
}
