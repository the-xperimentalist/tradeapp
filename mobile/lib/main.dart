
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile/screens/HomePage.dart';
import 'package:mobile/screens/LoginPage.dart';
import 'package:mobile/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double screenWidth = window.physicalSize.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trade Journal',
      theme: ThemeData(
        primaryColor: COLOR_WHITE,
        accentColor: COLOR_DARK_BLUE,
        textTheme: screenWidth < 500 ? TEXT_THEME_SMALL : TEXT_THEME_DEFAULT,
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
