import 'dart:convert';
import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../models/jwt.dart';

class UserController {
  /// Felder
  final HttpRequestBody _requestBody;
  final HttpRequest _request;
  final DbCollection _userCollection;

  /// Constructor
  UserController(
    this._requestBody,
    Db db,
  )   : _request = _requestBody.request,
        _userCollection = db.collection('users') {
    handle();
  }

  void handle() async {
    var _allowed = checkJwt();
    if (_allowed) {
      _request.response.statusCode = HttpStatus.forbidden;
    } else {
      switch (_request.method) {
        case 'GET':
          await handleGet();
          break;
        case 'POST':
          await handlePost();
          break;
        case 'PUT':
          await handlePut();
          break;
        case 'PATCH':
          await handlePatch();
          break;
        case 'DELETE':
          await handleDelete();
          break;
        default:
          _request.response.statusCode = HttpStatus.methodNotAllowed;
      }
    }
    await _request.response.close();
  }

  Future<void> handleGet() async {
    var _result = await _userCollection.find().toList();
    _request.response.write(json.encode(_result));
  }

  Future<void> handlePost() async {
    var _result = await _userCollection
        .save(Map<String, dynamic>.from(_requestBody.body));
    _request.response.write(json.encode(_result));
  }

  Future<void> handlePut() async {
    var _result = await _userCollection
        .save(Map<String, dynamic>.from(_requestBody.body));
    _request.response.write(json.encode(_result));
  }

  Future<void> handlePatch() async {
    var _result = await _userCollection
        .save(Map<String, dynamic>.from(_requestBody.body));
    _request.response.write(json.encode(_result));
  }

  Future<void> handleDelete() async {
    var _id = _request.uri.queryParameters['id'];
    var _result = await _userCollection.remove(where.eq('_id', _id));
    _request.response.write(json.encode(_result));
  }

  bool checkJwt() {
    var _authHeader =
        _requestBody.request.headers.value(HttpHeaders.authorizationHeader);
    var _jwt = _authHeader.split(' ')[1];
    return Jwt.fromString(_jwt).verified;
  }
}
