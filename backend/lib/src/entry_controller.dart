import 'dart:convert';
import 'dart:io';

import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';

class EntryController {
  /// Felder
  final HttpRequestBody _requestBody;
  final HttpRequest _request;
  final DbCollection _recordCollection;

  /// The sessionCollection is needed to get the username in the handleRerecord method
  final DbCollection _sessionCollection;

  /// Constructor
  EntryController(
    this._requestBody,
    Db db,
  )   : _request = _requestBody.request,
        _sessionCollection = db.collection('sessions'),
        _recordCollection = db.collection('records') {
    handle();
  }

  void handle() async {
    await checkJwt();
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
    await _request.response.close();
  }

  Future<void> handleGet() async {
    var _result = await _recordCollection.find();
    _request.response.write(_result.toList());
  }

  Future<void> handlePost() async {
    var _result = await _recordCollection.save(
        Map<String, dynamic>.from(json.decode(utf8.decode(_requestBody.body))));
    _request.response.write(_result);
  }

  Future<void> handlePut() async {
    var _id = _request.uri.queryParameters['id'];
    var _itemToReplace = await _recordCollection.findOne(where.eq('_id', _id));
    var _result;
    if (_itemToReplace == null) {
      _result = await _recordCollection.save(Map<String, dynamic>.from(
          json.decode(utf8.decode(_requestBody.body))));
    }
  }

  Future<void> handlePatch() async {}

  Future<void> handleDelete() async {}
}
