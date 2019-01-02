import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory/dao/person_dao.dart';
import 'package:memory/dao/person_photograph_dao.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/entity/person_photograph.dart';
import 'package:memory/entity/photograph.dart';
import 'package:memory/photo_list.dart';
import 'package:memory/photo_unit.dart';

class PersonDetail extends StatefulWidget {
  final Person person;

  const PersonDetail({Key key, this.person}) : super(key: key);

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  bool _isEditMode = false;
  String _name;
  TextEditingController _controller;
  List<PersonPhotograph> personPhotographs;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _name = widget.person.name ?? 'Name';
    _controller = TextEditingController(text: _name);
    _initData();
  }

  void _initData() async {
    personPhotographs = await PersonPhotographDao()
        .getPersonPhotographsByPerson(widget.person.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        child: Center(
          child: Hero(
            tag: widget.person.id,
            child: CircleAvatar(
              radius: 96.0,
              backgroundImage: FileImage(
                File(widget.person.imageFile),
              ),
            ),
          ),
        ),
      )
    ];
    if (!_isLoading) {
      children.add(Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'My Photos',
            style: Theme.of(context).textTheme.headline,
          ),
        ),
      ));
      children.addAll(personPhotographs.map((pp) => Padding(
            padding: EdgeInsets.all(8.0),
            child: PhotoUnit(
              photograph: pp.photograph,
            ),
          )));
    }
    return Scaffold(
      appBar: AppBar(
        title: _isEditMode
            ? TextField(
                controller: _controller,
                onSubmitted: (String text) => _handleSubmitted(context, text),
              )
            : Text(_name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => setState(() => _isEditMode = true),
          )
        ],
      ),
      body: ListView(
        children: children,
      ),
    );
  }

  Future<Null> _handleSubmitted(BuildContext context, String text) async {
    widget.person.name = text;
    await PersonDao().update(widget.person);
    setState(() {
      _isEditMode = false;
      _name = text;
    });
  }
}
