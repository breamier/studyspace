import 'package:flutter/material.dart';
import './screens/study_overview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySpace',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StudyOverview(),
    );
  }
}
