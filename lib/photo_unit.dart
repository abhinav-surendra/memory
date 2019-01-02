import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory/entity/photograph.dart';
import 'package:memory/photo_detail.dart';

class PhotoUnit extends StatelessWidget {
  final Photograph photograph;

  const PhotoUnit({Key key, this.photograph}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Hero(
        tag: photograph.id,
        child: Image.file(
          File(photograph.file),
          fit: BoxFit.cover,
        ),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => PhotoDetail(
                  photograph: photograph,
                ),
          )),
    );
  }
}
