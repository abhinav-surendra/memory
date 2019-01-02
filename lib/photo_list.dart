import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory/dao/photograph_dao.dart';
import 'package:memory/entity/photograph.dart';
import 'package:memory/photo_detail.dart';
import 'package:memory/photo_unit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  bool _isLoading = true;
  List<Photograph> _photographs;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _photographs = await PhotographDao().getPhotographs();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didUpdateWidget(PhotoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _isLoading = true;
    });
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    print('photo_list:build: $_photographs');
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
      children: _photographs
          .map((p) => Padding(
                padding: EdgeInsets.all(8.0),
                child: PhotoUnit(
                  photograph: p,
                ),
              ))
          .toList(growable: false),
    );
  }
}
