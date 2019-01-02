import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory/entity/person_photograph.dart';
import 'package:memory/entity/photograph.dart';

class PersonMark extends StatefulWidget {
  final Photograph photograph;
  final List<PersonPhotograph> personPhotographs;

  const PersonMark({Key key, this.photograph, this.personPhotographs})
      : super(key: key);

  @override
  PersonMarkState createState() {
    return new PersonMarkState();
  }
}

class PersonMarkState extends State<PersonMark> {
  GlobalKey _myWidgetKey = GlobalKey();
  Size _size = Size.zero;
  static const scale = 1;

  @override
  void didUpdateWidget(PersonMark oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.personPhotographs != widget.personPhotographs)
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    print('person_mark:build:${widget.personPhotographs}');
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterBuild());
    final children = <Widget>[
      Hero(
        tag: widget.photograph.id,
        child: Image.file(
          File(widget.photograph.file),
          key: _myWidgetKey,
          fit: BoxFit.contain,
        ),
      )
    ];
    if (_size != Size.zero) {
      children.addAll(widget.personPhotographs.map((p) {
        return Positioned(
          top: _size.height * p.y * scale,
          left: _size.width * p.x * scale,
          child: InkWell(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
              ),
              height: _size.height * p.height / scale,
              width: _size.width * p.width / scale,
            ),
            onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => BottomSheet(
                        elevation: 8.0,
                        onClosing: () => null,
                        builder: (context) => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: media.size.height / 8,
                                    backgroundImage:
                                        FileImage(File(p.person.imageFile)),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    p.person.name,
                                    style: TextStyle(fontSize: 24.0),
                                  ),
                                ),
                              ],
                            ),
                      ),
                ),
          ),
        );
      }));
    }
    return Stack(children: children);
  }

  void _afterBuild() {
    print('_afterBuild: $_size');
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (_myWidgetKey.currentContext != null) {
          final RenderBox box =
              _myWidgetKey.currentContext.findRenderObject() as RenderBox;
          if (_size != box.size) {
            setState(() {
              _size = box.size;
            });
          }
        }
      },
    );
  }
}
