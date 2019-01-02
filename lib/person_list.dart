import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory/dao/person_dao.dart';
import 'package:memory/dao/photograph_dao.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/entity/photograph.dart';
import 'package:memory/person_detail.dart';
import 'package:memory/photo_detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PersonList extends StatefulWidget {
  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  bool _isLoading = true;
  List<Person> _persons;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _persons = await PersonDao().getPersons();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    if (_isLoading) {
      return SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(),
      );
    }
    return GridView.count(
      crossAxisCount:
          (media.size.width * media.devicePixelRatio / 400.0).floor(),
      children: _persons
          .map((p) => Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Hero(
                            tag: p.id,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: CircleAvatar(
                                backgroundImage: FileImage(
                                  File(p.imageFile),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(p.name ?? 'Name'),
                        )
                      ],
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PersonDetail(
                                person: p,
                              ),
                        )),
                  ),
                ),
              ))
          .toList(growable: false),
    );
  }
}
