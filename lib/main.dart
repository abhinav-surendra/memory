import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memory/dao/person_dao.dart';
import 'package:memory/dao/photograph_dao.dart';
import 'package:memory/entity/person.dart';
import 'package:memory/entity/photograph.dart';
import 'package:memory/person_list.dart';
import 'package:memory/photo_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory/quiz_navigator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Memory',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Widget getChild() {
    switch (_selectedIndex) {
      case 0:
        return PhotoList();
        break;
      case 1:
        return PersonList();
        break;
      case 2:
        return RaisedButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Start',
              style: TextStyle(fontSize: 48.0),
            ),
          ),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => QuizNavigator(),
              )),
        );
        break;
    }
    return Container();
  }

  AppBar getAppBar() {
    switch (_selectedIndex) {
      case 0:
        return AppBar(
          title: Text('Pictures'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: getPhotographImage,
            )
          ],
        );
        break;
      case 1:
        return AppBar(
          title: Text('People'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: getPersonImage,
            )
          ],
        );
        break;
      case 2:
        return AppBar(title: Text('Quiz'));
        break;
    }
    return AppBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Center(
        child: getChild(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_library), title: Text('Pictures')),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: Text('People')),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), title: Text('Quiz')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future getPhotographImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    final filename = file.path.split("/").last;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final finalFilename = '$appDocPath/$filename';
    await file.copy(finalFilename);
    final codec = await instantiateImageCodec(file.readAsBytesSync());
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final photograph = Photograph(
        id: Uuid().v4(),
        file: finalFilename,
        createdAt: DateTime.now(),
        width: image.width,
        height: image.height);
    await PhotographDao().insert(photograph);
    setState(() {});
  }

  Future getPersonImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    final filename = file.path.split("/").last;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final finalFilename = '$appDocPath/$filename';
    await file.copy(finalFilename);
    final person = Person(
      id: Uuid().v4(),
      imageFile: finalFilename,
    );
    await PersonDao().insert(person);
    setState(() {});
  }
}
