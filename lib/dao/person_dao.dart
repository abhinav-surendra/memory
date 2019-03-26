import 'dart:async';

import 'package:memory/app_database.dart';
import 'package:memory/dao/person_photograph_dao.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/entity/person_photograph.dart';
import 'package:sqflite/sqflite.dart';

class PersonDao {
  Future<Person> getPerson(String name) async {
    final db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(Person.table,
        columns: Person.allCols,
        where: "${Person.nameCol} = ?",
        whereArgs: [name]);
    if (maps.length > 0) return Person.fromMap(maps.first);
    return null;
  }

  Future<List<Person>> getPersons() async {
    final db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      Person.table,
      columns: Person.allCols,
    );
    return maps.map((m) => Person.fromMap(m)).toList();
  }

  Future<Person> insert(Person person) async {
    final db = await new AppDatabase().getDb();
    await db.insert(Person.table, person.toMap());
    return person;
  }

  Future<Null> update(Person person) async {
    final db = await new AppDatabase().getDb();
    await db.update(Person.table, person.toMap(),
        where: '${Person.idCol} = ?', whereArgs: [person.id]);
  }

  Future<Null> delete(Person person) async {
    final db = await new AppDatabase().getDb();
    final personPhotographs =
        await PersonPhotographDao().getPersonPhotographsByPerson(person.id);
    await Future.forEach(
        personPhotographs,
        (pp) async => await db.delete(PersonPhotograph.table,
            where: '${PersonPhotograph.personIdCol} = ?',
            whereArgs: [person.id]));
    await db.delete(Person.table,
        where: '${Person.idCol} = ?', whereArgs: [person.id]);
  }
}
