import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthController {
  /// Felder
  final HttpRequestBody _requestBody;
  final HttpRequest _request;
  final DbCollection _authCollection;
  final DbCollection _sessionCollection;
  final DbCollection _recordCollection;

  /// Constructor
  AuthController(
    this._requestBody,
    Db db,
  )   : _request = _requestBody.request,
        _authCollection = db.collection('users'),
        _sessionCollection = db.collection('sessions'),
        _recordCollection = db.collection('records') {
    handle();
  }

  void handle() {}
}
