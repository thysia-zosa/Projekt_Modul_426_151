import 'dart:io';

import 'package:projekt_modul_426_151_backend/projekt_modul_426_151_backend.dart';
import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main(List<String> args) async {
  var ip = 'localhost';
  var port = 8081;
  var server = await HttpServer.bind(ip, port);
  var db = Db('mongodb://localhost:27017/test');

  server
      .transform(HttpBodyHandler())
      .listen((HttpRequestBody requestBody) async {
    requestBody.request.response.headers.set('Cache-Control', 'no-cache');
    requestBody.request.response.headers
        .set('Access-Control-Allow-Credentials', 'true');
    requestBody.request.response.headers
        .set('Access-Control-Allow-Origin', '*');
    requestBody.request.response.headers
        .set('Access-Control-Allow-Methods', '*');
    requestBody.request.response.headers
        .set('Access-Control-Allow-Headers', '*');
    requestBody.request.response.headers
        .set('Access-Control-Expose-Headers', HttpHeaders.authorizationHeader);

    if (requestBody.request.method == 'OPTIONS') {
      requestBody.request.response..statusCode = HttpStatus.ok;
      await requestBody.request.response.close();
    } else {
      /// Weiterleitung des Requestbodys an den jeweiligen Controller
      switch (requestBody.request.uri.path) {
        case '/users/signup':
        case '/login':
          AuthController(requestBody, db);
          break;
        case '/entries':
          EntryController(requestBody, db);
          break;
        default:
          requestBody.request.response
            ..statusCode = HttpStatus.notFound
            ..write('Ressource not found');
          await requestBody.request.response.close();
      }
    }
  });
}
