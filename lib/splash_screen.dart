import 'package:flutter/material.dart';

class splash_screen extends StatefulWidget {
  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.purple),
    child:Image.asset(
    'images/splash_screen.jpg',)
      ),
    );
  }
}
