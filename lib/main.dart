import 'package:flutter/material.dart';
import 'package:wallpaperque/views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WallpaperQue',
      theme: ThemeData(
        brightness: Brightness.dark
        //primaryColor: Colors.white,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

