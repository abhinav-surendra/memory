class Person {
  static const table = 'person';
  static const idCol = 'id';
  static const nameCol = 'name';
  static const imageFileCol = 'image_file';
  static const audioFileCol = 'audio_file';

  static const idSel = '${table}_$idCol';
  static const nameSel = '${table}_$nameCol';
  static const imageFileSel = '${table}_$imageFileCol';
  static const audioFileSel = '${table}_$audioFileCol';

  static const List<String> allCols = [
    '$idCol AS $idSel',
    '$nameCol AS $nameSel',
    '$imageFileCol AS $imageFileSel',
    '$audioFileCol AS $audioFileSel',
  ];

  String id;
  String name;
  String imageFile;
  String audioFile;

  Person({this.id, this.name, this.imageFile, this.audioFile});

  Map<String, dynamic> toMap() {
    return {
      idCol: id,
      nameCol: name,
      imageFileCol: imageFile,
      audioFileCol: audioFile
    };
  }

  Person.fromMap(Map<String, dynamic> map)
      : this(
            id: map[idSel],
            name: map[nameSel],
            imageFile: map[imageFileSel],
            audioFile: map[audioFileSel]);

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ imageFile.hashCode ^ audioFile.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          imageFile == other.imageFile &&
          audioFile == other.audioFile;

  @override
  String toString() {
    return 'Person{id: $id, name: $name, imageFile: $imageFile, audioFile: $audioFile}';
  }
}
