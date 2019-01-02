import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memory/dao/person_dao.dart';
import 'package:memory/dao/person_photograph_dao.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/entity/person_photograph.dart';
import 'package:memory/entity/photograph.dart';
import 'package:aws_ai/src/RekognitionHandler.dart';
import 'package:memory/person_mark.dart';

class PhotoDetail extends StatefulWidget {
  final Photograph photograph;

  const PhotoDetail({Key key, this.photograph}) : super(key: key);

  @override
  _PhotoDetailState createState() => _PhotoDetailState();
}

class _PhotoDetailState extends State<PhotoDetail> {
  List<PersonPhotograph> personPhotographs = [];
  Map<Person, dynamic> boxMap = {};
  double x;
  double y;
  double height;
  double width;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    personPhotographs = await PersonPhotographDao()
        .getPersonPhotographsByPhotograph(widget.photograph.id);
    if (personPhotographs.length == 0) {
      final persons = await PersonDao().getPersons();

      await Future.forEach(persons, (p) async {
        File sourceImagefile = File(p.imageFile);
        File targetImagefile = File(widget.photograph.file);

        RekognitionHandler rekognition =
            new RekognitionHandler(accessKey, secretKey, region);
        final labelsArray =
            await rekognition.compareFaces(sourceImagefile, targetImagefile);
        final labelsJson = json.decode(labelsArray);
        print(labelsJson);

        if (labelsJson['FaceMatches'].length > 0) {
          final similarPerson = labelsJson['FaceMatches']
              .reduce((v, f) => v['Similarity'] > f['Similarity'] ? v : f);
          if (similarPerson['Similarity'] > 95.0) {
            final box = similarPerson['Face']['BoundingBox'];
            final personPhotograph = PersonPhotograph(
                personId: p.id,
                photographId: widget.photograph.id,
                x: box['Left'],
                y: box['Top'],
                width: box['Width'],
                height: box['Height']);
            await PersonPhotographDao().insert(personPhotograph);
            personPhotographs.add(personPhotograph);
          }
        }
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(personPhotographs);
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo'),
      ),
      body: Center(
        child: PersonMark(
          photograph: widget.photograph,
          personPhotographs: personPhotographs,
        ),
      ),
    );
  }
}
