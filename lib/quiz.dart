import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory/dao/person_dao.dart';
import 'package:memory/dao/person_photograph_dao.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/entity/person_photograph.dart';

class Quiz extends StatefulWidget {
  final PersonPhotograph question;
  final List<Person> choices;
  final Function onChoice;

  const Quiz({Key key, this.question, this.choices, this.onChoice})
      : super(key: key);

  @override
  QuizState createState() {
    return new QuizState();
  }
}

class QuizState extends State<Quiz> {
  Person chosen;

  @override
  Widget build(BuildContext context) {
    print('quiz:build');
    return Table(
      children: <TableRow>[
        TableRow(
          children: widget.choices
              .take(2)
              .map((i) => _buildButton(context, i))
              .toList(),
        ),
        TableRow(
          children: widget.choices
              .skip(2)
              .take(2)
              .map((i) => _buildButton(context, i))
              .toList(),
        )
      ],
    );
  }

  Widget _buildButton(BuildContext context, Person itemImage) {
    Color color;
    Color textColor;
    if (chosen?.id == itemImage.id) {
      textColor = Colors.white;
      if (itemImage.id == widget.question.personId) {
        color = Colors.green;
      } else {
        color = Colors.red;
      }
    } else if (chosen != null && itemImage.id == widget.question.personId) {
      color = Colors.green;
      textColor = Colors.white;
    } else {
      color = Colors.white;
      textColor = Colors.blue;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        color: color,
        textColor: textColor,
        padding: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 32.0,
                backgroundImage: FileImage(File(itemImage.imageFile)),
              ),
            ),
            Text(
              itemImage.name ?? 'Name',
              style: TextStyle(fontSize: 24.0, color: Colors.black),
            ),
          ],
        ),
        onPressed: () {
          setState(() {
            chosen = itemImage;
          });
          Future.delayed(const Duration(milliseconds: 1000), () {
            widget.onChoice(context, chosen.id == widget.question.personId);
          });
        },
      ),
    );
  }
}
