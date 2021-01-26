import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/jwt.dart';

class AuthController {
  /// Felder
  final HttpRequestBody _requestBody;
  final HttpRequest _request;
  final DbCollection _authCollection;
  final DbCollection _sessionCollection;

  /// Constructor
  AuthController(
    this._requestBody,
    Db db,
  )   : _request = _requestBody.request,
        _authCollection = db.collection('users'),
        _sessionCollection = db.collection('sessions') {
    handle();
  }

  void handle() async {
    switch (_request.uri.path) {
      case '/login':
        await handleLogin();
        break;
      case '/users/sign-up':
        await handleSignUp();
        break;
      default:
        _request.response.statusCode = HttpStatus.forbidden;
    }
    await _request.response.close();
  }

  Future<void> handleLogin() async {
    try {
      final _body = Map<String, dynamic>.from(_requestBody.body);
      final String _username = _body['username'];
      final String _password = _body['password'];
      final _validUser =
          await _authCollection.findOne(where.eq('username', _username));
      if (_validUser == null) {
        throw Exception('username not found');
      }
      final _salt = _validUser['salt'];
      final _hashedPassword = _hashPassword(_password, _salt);
      if (_hashedPassword != _validUser['hashedPassword']) {
        throw Exception('wrong password');
      }
      var _jwt = Jwt.fromUsername(_username).toString();
      var _newSession = <String, dynamic>{
        '_id': null,
        'username': _username,
        'JWT': _jwt,
      };
      var _session =
          await _sessionCollection.findOne(where.eq('username', _username));
      if (_session != null) {
        _newSession['_id'] = _session['_id'];
        await _sessionCollection.update(
            where.eq('_id', _session['_id']), _newSession);
      } else {
        _newSession['_id'] = ObjectId();
        await _sessionCollection.save(_newSession);
      }
    } catch (e) {
      print(e);
      _request.response.statusCode = HttpStatus.forbidden;
      _request.response.write(e.toString());
    }
  }

  Future<void> handleSignUp() async {
    try {
      var _body = Map<String, dynamic>.from(_requestBody.body);
      final String _username = _body['username'];
      final String _email = _body['email'];
      final String _password = _body['password'];
      var _savedUser =
          await _authCollection.findOne(where.eq('username', _username));
      if (_savedUser != null) {
        throw Exception('username already used');
      }
      var _rand = Random.secure();
      var _saltBytes = List<int>.generate(32, (_) => _rand.nextInt(256));
      var _salt = base64.encode(_saltBytes);
      var _hashedPassword = _hashPassword(_password, _salt);
      var _newUserDocument = {
        'username': _username,
        'email': _email,
        'hashedPassword': _hashedPassword,
        'salt': _salt,
      };
      await _authCollection.save(_newUserDocument);
      _request.response.statusCode = HttpStatus.accepted;
      _request.response.write(_username);
    } catch (e) {
      print(e.toString());
      _request.response.statusCode = HttpStatus.unprocessableEntity;
      _request.response.write(e.toString());
    }
  }

  String _hashPassword(String password, String salt) {
    var _key = utf8.encode(password);
    var _bytes = utf8.encode(salt);
    var _hmacSha256 = Hmac(sha256, _key);
    var digest = _hmacSha256.convert(_bytes);
    return digest.toString();
  }
}
