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

  void handle() {}
}
