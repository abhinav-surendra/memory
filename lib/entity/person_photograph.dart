import 'package:memory/entity/person.dart';
import 'package:memory/entity/photograph.dart';

class PersonPhotograph {
  static const table = 'person_photograph';
  static const personIdCol = 'person_id';
  static const photographIdCol = 'photograph_id';
  static const xCol = 'x';
  static const yCol = 'y';
  static const widthCol = 'width';
  static const heightCol = 'height';

  static const personIdSel = '${table}_$personIdCol';
  static const photographIdSel = '${table}_$photographIdCol';
  static const xSel = '${table}_$xCol';
  static const ySel = '${table}_$yCol';
  static const widthSel = '${table}_$widthCol';
  static const heightSel = '${table}_$heightCol';

  static const List<String> allCols = [
    '$table.$personIdCol AS $personIdSel',
    '$table.$photographIdCol AS $photographIdSel',
    '$table.$xCol AS $xSel',
    '$table.$yCol AS $ySel',
    '$table.$widthCol AS $widthSel',
    '$table.$heightCol AS $heightSel',
    '${Person.table}.${Person.idCol} AS ${Person.idSel}',
    '${Person.table}.${Person.nameCol} AS ${Person.nameSel}',
    '${Person.table}.${Person.imageFileCol} AS ${Person.imageFileSel}',
    '${Person.table}.${Person.audioFileCol} AS ${Person.audioFileSel}',
    '${Photograph.table}.${Photograph.idCol} AS ${Photograph.idSel}',
    '${Photograph.table}.${Photograph.fileCol} AS ${Photograph.fileSel}',
    '${Photograph.table}.${Photograph.createdAtCol} AS ${Photograph.createdAtSel}',
    '${Photograph.table}.${Photograph.widthCol} AS ${Photograph.widthSel}',
    '${Photograph.table}.${Photograph.heightCol} AS ${Photograph.heightSel}',
  ];

  String personId;
  String photographId;
  double x;
  double y;
  double width;
  double height;
  Person person;
  Photograph photograph;

  PersonPhotograph(
      {this.personId,
      this.photographId,
      this.x,
      this.y,
      this.width,
      this.height,
      this.person,
      this.photograph});

  Map<String, dynamic> toMap() {
    return {
      personIdCol: personId,
      photographIdCol: photographId,
      xCol: x,
      yCol: y,
      widthCol: width,
      heightCol: height
    };
  }

  PersonPhotograph.fromMap(Map<String, dynamic> map)
      : this(
            personId: map[personIdSel],
            photographId: map[photographIdSel],
            x: map[xSel],
            y: map[ySel],
            width: map[widthSel],
            height: map[heightSel],
            person: Person.fromMap(map),
            photograph: Photograph.fromMap(map));

  @override
  int get hashCode =>
      personId.hashCode ^
      photographId.hashCode ^
      x.hashCode ^
      y.hashCode ^
      width.hashCode ^
      height.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonPhotograph &&
          runtimeType == other.runtimeType &&
          personId == other.personId &&
          photographId == other.photographId &&
          x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height;

  @override
  String toString() {
    return 'PersonPhotograph{personId: $personId, photographId: $photographId, x: $x, y: $y, width: $width, height: $height}';
  }
}
