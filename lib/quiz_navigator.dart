import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory/dao/person_dao.dart';
import 'package:memory/dao/person_photograph_dao.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/entity/person_photograph.dart';
import 'package:memory/person_mark.dart';
import 'package:memory/photo_detail.dart';
import 'package:memory/quiz.dart';

class QuizNavigator extends StatefulWidget {
  @override
  QuizState createState() {
    return new QuizState();
  }
}

class QuizState extends State<QuizNavigator> {
  List<PersonPhotograph> _itemImages;
  List<Person> _persons;
  bool _isLoading = true;
  bool _isInstruction = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _itemImages = await PersonPhotographDao().getAllPersonPhotographs()
      ..shuffle();
    _persons = await PersonDao().getPersons();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Navigator(
                onGenerateRoute: (RouteSettings settings) => PageRouteBuilder(
                    opaque: true,
                    transitionDuration: const Duration(milliseconds: 350),
                    pageBuilder: (BuildContext context, _, __) {
                      return _buildContent(context);
                    },
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return new SlideTransition(
                        child: child,
                        position: new Tween<Offset>(
                          begin: Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                      );
                    })));
  }

  Widget _buildContent(BuildContext context) {
    final media = MediaQuery.of(context);
    PersonPhotograph question;
    List<Person> choices;

    if (!_isInstruction && _itemImages.length > 0) {
      question = _itemImages.first;
      choices =
          _persons.where((i) => question.personId != i.id).take(3).toList()
            ..add(question.person)
            ..shuffle();
    }
    return (_isInstruction || choices?.length == 4)
        ? Column(
            children: <Widget>[
              Flexible(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                    Flexible(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: PersonMark(
                            photograph: _itemImages.first.photograph,
                            personPhotographs: [_itemImages.first],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: _isInstruction
                          ? _buildInstruction(context)
                          : _buildQuiz(question, choices),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    )
                  ])),
              _isInstruction
                  ? Container(
                      padding: const EdgeInsets.all(8.0),
                      width: media.size.width,
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Next'),
                        onPressed: () {
                          _itemImages.removeAt(0);
                          _isInstruction = false;
                          Navigator.of(context).pushReplacementNamed('/quiz');
                        },
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        : Container(
            color: Colors.white,
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Text('Done'),
            ),
          );
  }

  Widget _buildInstruction(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 32.0,
          backgroundImage: FileImage(File(_itemImages.first.person.imageFile)),
        ),
        Text(_itemImages.first.person.name ?? 'Name'),
      ],
    );
  }

  Widget _buildQuiz(PersonPhotograph question, List<Person> choices) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Quiz(
        question: question,
        choices: choices,
        onChoice: _onChoice,
      ),
    );
  }

  void _onChoice(BuildContext context, bool isCorrect) {
    if (isCorrect) {
      _itemImages.removeAt(0);
      _isInstruction = false;
    } else {
      _isInstruction = true;
    }
    Navigator.of(context).pushReplacementNamed('/quiz');
  }
}
