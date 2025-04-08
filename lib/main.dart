import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() => runApp(StudySpaceApp());

class StudySpaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
