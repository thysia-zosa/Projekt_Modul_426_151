import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'projekt_modul_426_151_backend.dart';
import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';

class BackendApplication {
  String ip;
  int port;
  Db db;
  HttpServer server;
  StreamSubscription subscription;

  BackendApplication() {
    ip = 'localhost';
    port = 8081;
    db = Db('mongodb://localhost:27017/test');
  }

  void start() async {
    await db.open();
    server = await HttpServer.bind(ip, port);
    subscription = server
        .transform(HttpBodyHandler())
        .listen((requestBody) => ondata(requestBody));
    await initialize();
    print('Backend started');
  }

  void stop() async {
    await subscription.cancel();
    await server.close();
    print('Backend stopped');
  }

  void ondata(HttpRequestBody requestBody) async {
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
        case '/categories':
          CategoryController(requestBody, db);
          break;
        case '/users':
          UserController(requestBody, db);
          break;
        default:
          requestBody.request.response
            ..statusCode = HttpStatus.notFound
            ..write('Ressource not found');
          await requestBody.request.response.close();
      }
    }
  }

  void initialize() async {
    var _collections = await db.getCollectionNames();
    if (_collections.contains('entries')) {
      await db.collection('entries').drop();
    }
    if (_collections.contains('users')) {
      await db.collection('users').drop();
    }
    if (_collections.contains('categories')) {
      await db.collection('categories').drop();
    }
    var _rand = Random.secure();
    var _saltBytes = List<int>.generate(32, (_) => _rand.nextInt(256));
    var _salt = base64.encode(_saltBytes);
    var _key = utf8.encode('Password1');
    var _bytes = utf8.encode(_salt);
    var _hmacSha256 = Hmac(sha256, _key);
    var _digest = _hmacSha256.convert(_bytes);
    var _hashedPassword = _digest.toString();
    var _user = {
      'username': 'admin',
      'email': 'admin@test.com',
      'hashedPassword': _hashedPassword,
      'salt': _salt,
    };
    var _userResult = await db.collection('users').save(_user);
    var _categoriesResult =
        await db.collection('categories').save({'name': 'Arbeit'});
    await db.collection('categories').save({'name': 'Schule'});
    var _entry = {
      'checkIn': '2020-03-04T08:00:00',
      'checkOut': '2020-03-04T16:00:00',
      'category': {
        '_id': _categoriesResult['insertedId'],
        'name': 'Arbeit',
      },
      'applicationUser': {
        '_id': _userResult['insertedId'],
      }
    };
    await db.collection('entries').save(_entry);
  }
}
