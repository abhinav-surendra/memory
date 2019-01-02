import 'dart:async';

import 'package:memory/app_database.dart';
import 'package:memory/entity/person_photograph.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/dao/person_dao.dart';
import 'package:memory/entity/photograph.dart';

class PersonPhotographDao {
  Future<List<PersonPhotograph>> getPersonPhotographsByPerson(
      String personId) async {
    final db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${PersonPhotograph.table}, ${Person.table}, ${Photograph.table}',
        columns: PersonPhotograph.allCols,
        where: '''
${PersonPhotograph.table}.${PersonPhotograph.personIdCol} = ? 
AND ${Person.table}.${Person.idCol} = ${PersonPhotograph.table}.${PersonPhotograph.personIdCol}
AND ${Photograph.table}.${Photograph.idCol} = ${PersonPhotograph.table}.${PersonPhotograph.photographIdCol}
''',
        whereArgs: [personId]);
    return maps.map((m) => PersonPhotograph.fromMap(m)).toList();
  }

  Future<List<PersonPhotograph>> getPersonPhotographsByPhotograph(
      String photographId) async {
    final db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(
        '${PersonPhotograph.table}, ${Person.table}, ${Photograph.table}',
        columns: PersonPhotograph.allCols,
        where: '''
${PersonPhotograph.table}.${PersonPhotograph.photographIdCol} = ? 
AND ${Photograph.table}.${Photograph.idCol} = ${PersonPhotograph.table}.${PersonPhotograph.photographIdCol}
AND ${Person.table}.${Person.idCol} = ${PersonPhotograph.table}.${PersonPhotograph.personIdCol}
''',
        whereArgs: [photographId]);
    return maps.map((m) => PersonPhotograph.fromMap(m)).toList();
  }

  Future<List<PersonPhotograph>> getAllPersonPhotographs() async {
    final db = await new AppDatabase().getDb();
    List<Map> maps = await db.query(
      '${PersonPhotograph.table}, ${Person.table}, ${Photograph.table}',
      columns: PersonPhotograph.allCols,
      where: '''
${Photograph.table}.${Photograph.idCol} = ${PersonPhotograph.table}.${PersonPhotograph.photographIdCol}
AND ${Person.table}.${Person.idCol} = ${PersonPhotograph.table}.${PersonPhotograph.personIdCol}
''',
    );
    return maps.map((m) => PersonPhotograph.fromMap(m)).toList();
  }

  Future<List<PersonPhotograph>> getRandomPersonPhotographs(int count) async {
    final persons = await PersonDao().getPersons()
      ..shuffle();
    List<PersonPhotograph> personPhotographs = [];
    await Future.forEach(persons.take(count), (i) async {
      final nameItemPhotographs =
          await getPersonPhotographsByPerson(i.photographId)
            ..shuffle();
      personPhotographs.add(nameItemPhotographs.first);
    });
    return personPhotographs;
  }

  Future<PersonPhotograph> insert(PersonPhotograph person) async {
    final db = await new AppDatabase().getDb();
    await db.insert(PersonPhotograph.table, person.toMap());
    return person;
  }
}
