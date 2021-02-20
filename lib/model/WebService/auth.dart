import 'dart:convert';
import 'dart:math' as math;

class AuthWS {
  String login = "6dd490faf9cb87a9862245da41170ff2";
  String tranKey = "024h1IlD";
  String nonce;
  String seed = DateTime.now().toIso8601String();

  AuthWS(this.login, this.tranKey, this.nonce, this.seed);

  static String generateNonceBase64() {
    math.Random rnd = new math.Random();
    List<int> values = new List<int>.generate(32, (i) => rnd.nextInt(256));
    return base64UrlEncode(values);
  }
}
