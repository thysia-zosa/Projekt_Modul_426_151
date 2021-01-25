import 'dart:convert';
import 'dart:io';

import 'package:projekt_modul_426_151_backend/backend_application.dart';

void main(List<String> args) async {
  var _backendApplication = BackendApplication();
  _backendApplication.start();

  readLine().listen((String line) async {
    if (line == 'exit') {
      await _backendApplication.stop();
      exit(0);
    }
  });
}

Stream<String> readLine() =>
    stdin.transform(utf8.decoder).transform(const LineSplitter());
