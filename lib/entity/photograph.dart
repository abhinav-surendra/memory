class Photograph {
  static const table = 'photograph';
  static const idCol = 'id';
  static const fileCol = 'file';
  static const createdAtCol = 'created_at';
  static const widthCol = 'width';
  static const heightCol = 'height';

  static const idSel = '${table}_$idCol';
  static const fileSel = '${table}_$fileCol';
  static const createdAtSel = '${table}_$createdAtCol';
  static const widthSel = '${table}_$widthCol';
  static const heightSel = '${table}_$heightCol';

  static const List<String> allCols = [
    '$idCol AS $idSel',
    '$fileCol AS $fileSel',
    '$createdAtCol AS $createdAtSel',
    '$widthCol AS $widthSel',
    '$heightCol AS $heightSel'
  ];

  String id;
  String file;
  DateTime createdAt;
  int width;
  int height;

  Photograph({this.id, this.file, this.createdAt, this.width, this.height});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      fileCol: file,
      createdAtCol: createdAt.millisecondsSinceEpoch,
      widthCol: width,
      heightCol: height
    };
  }

  Photograph.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idSel],
            file: map[fileSel],
            createdAt: DateTime.fromMicrosecondsSinceEpoch(map[createdAtSel]),
            width: map[widthSel],
            height: map[heightSel]);

  @override
  int get hashCode =>
      id.hashCode ^
      file.hashCode ^
      createdAt.hashCode ^
      width.hashCode ^
      height.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photograph &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          file == other.file &&
          createdAt == other.createdAt &&
          width == other.width &&
          height == other.height;

  @override
  String toString() {
    return 'Photograph{id: $id, file: $file, createdAt: $createdAt, width: $width, height: $height}';
  }
}
