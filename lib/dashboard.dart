import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Study Space'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'Welcome to Study Space!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}