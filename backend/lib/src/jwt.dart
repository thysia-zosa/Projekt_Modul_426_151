import 'dart:convert';

import 'package:crypto/crypto.dart';

class Jwt {
  static const String _alg = 'HS256';
  static const String _typ = 'JWT';
  static const String _sub = 'time.fair-rates.ch';
  final String _name;
  final int _iat;

  Jwt(this._name)
      : _iat = (DateTime.now().millisecondsSinceEpoch / 1000).floor();

  @override
  String toString() {
    var _head = encode({'alg': _alg, 'typ': _typ});
    var _payload = encode({'sub': _sub, 'name': _name, 'iat': _iat});
    // TODO: Der HMACSHA256-Algorithmus ist noch nicht korrekt.
    var _key = utf8.encode('$_head.$_payload');
    var _bytes = utf8.encode('fair-rates-time');
    var _hmacSha256 = Hmac(sha256, _key);
    var _digest = _hmacSha256.convert(_bytes);
    return '$_head.$_payload.${_digest.toString()}';
  }

  String encode(Map<String, dynamic> jsonToEncode) {
    return base64.encode(utf8.encode(json.encode(jsonToEncode)));
  }
}

String getUsername(String jwt) {
  var _payloadEncoded = jwt.split('.')[1];
  var _payloadDecoded = Map<String, dynamic>.from(
      json.decode(utf8.decode(base64.decode(_payloadEncoded))));
  var _username = _payloadDecoded['name'];
  return _username;
}
