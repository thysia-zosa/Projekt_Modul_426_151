import 'dart:convert';

import 'package:crypto/crypto.dart';

class Jwt {
  static const String _alg = 'HS256';
  static const String _typ = 'JWT';
  static const String _sub = 'time.fair-rates.ch';
  String _name;
  int _iat;
  String _jwt;
  bool _verified;
  bool get verified => _verified;

  Jwt.fromUsername(this._name)
      : _iat = (DateTime.now().millisecondsSinceEpoch / 1000).floor() {
    _jwt = generateString();
    _verified = true;
  }

  Jwt.fromString(this._jwt) {
    var _payloadEncoded = _jwt.split('.')[1];
    var _payloadDecoded = decode(base64.decode(_payloadEncoded));
    _name = _payloadDecoded['name'];
    _iat = _payloadDecoded['iat'];
    _verified = _verify();
  }

  @override
  String toString() {
    return _jwt;
  }

  String generateString() {
    var _head = base64.encode(encode({'alg': _alg, 'typ': _typ}));
    var _payload =
        base64.encode(encode({'sub': _sub, 'name': _name, 'iat': _iat}));
    // TODO: Der HMACSHA256-Algorithmus ist noch nicht korrekt.
    var _key = utf8.encode('$_head.$_payload');
    var _bytes = utf8.encode('fair-rates-time');
    var _hmacSha256 = Hmac(sha256, _key);
    var _digest = _hmacSha256.convert(_bytes);
    return '$_head.$_payload.${_digest.toString()}';
  }

  List<int> encode(Map<String, dynamic> jsonToEncode) {
    return utf8.encode(json.encode(jsonToEncode));
  }

  Map<String, dynamic> decode(List<int> intListToDecode) {
    return json.decode(utf8.decode(intListToDecode));
  }

  bool _verify() {
    var jwtParts = _jwt.split('.');
    var _head = decode(base64.decode(jwtParts[0]));
    var _payLoad = decode(base64.decode(jwtParts[1]));
    if (_head['alg'] == _alg &&
        _head['typ'] == _typ &&
        _payLoad['sub'] == _sub) {
      return true;
    }
    return false;
  }
}

String getUsername(String jwt) {
  var _payloadEncoded = jwt.split('.')[1];
  var _payloadDecoded = Map<String, dynamic>.from(
      json.decode(utf8.decode(base64.decode(_payloadEncoded))));
  var _username = _payloadDecoded['name'];
  return _username;
}
