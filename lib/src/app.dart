import 'package:flutter/material.dart';
import 'screens/login_screens.dart';

class App extends StatelessWidget{
  Widget build(context) {
    return MaterialApp(
      title: ('Hello my app!'),
      home: Scaffold(
        body: LoginScreen(),

      ),
    );
  }
}