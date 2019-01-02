import 'dart:async';

import 'package:memory/app_database.dart';
import 'package:memory/entity/photograph.dart';
import 'package:sqflite/sqflite.dart';

class PhotographDao {
  Future<Photograph> getPhotograph(String id) async {
    final db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(Photograph.table,
        columns: Photograph.allCols,
        where: "${Photograph.idCol} = ?",
        whereArgs: [id]);
    if (maps.length > 0) return Photograph.fromMap(maps.first);
    return null;
  }

  Future<List<Photograph>> getPhotographs() async {
    final db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(Photograph.table,
        columns: Photograph.allCols,
        orderBy: '${Photograph.createdAtCol} DESC');
    return maps.map((m) => Photograph.fromMap(m)).toList();
  }

  Future<Photograph> insert(Photograph photograph) async {
    final db = await new AppDatabase().getDb();
    final existingItem = await getPhotograph(photograph.id);
    if (existingItem == null) {
      await db.insert(Photograph.table, photograph.toMap());
    }
    return photograph;
  }

  Future<Null> update(Photograph photograph) async {
    final db = await new AppDatabase().getDb();
    await db.update(Photograph.table, photograph.toMap(),
        where: '${Photograph.idCol} = ?', whereArgs: [photograph.id]);
  }
}
