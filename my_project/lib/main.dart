import 'package:flutter/material.dart';
import 'package:my_project/screens/LoginPage.dart';
void main() {
  runApp(
    MyApp());}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoginPage(),
    );
  }
}

