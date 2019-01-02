import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _appDatabase = new AppDatabase._internal();

  Database _db;
  bool didInit = false;

  factory AppDatabase() {
    return _appDatabase;
  }

  AppDatabase._internal();

  Future<Database> getDb({String path}) async {
    if (!didInit) await _initDatabase(path: path);
    return _db;
  }

  Future _initDatabase({String path}) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.sqlite");
    var dbFile = new File(path);
    if (!await dbFile.exists()) {
      ByteData data = await rootBundle.load(join("assets", "database.sqlite"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);
    }
    _db = await openDatabase(path, version: 1);
    didInit = true;
  }
}
