import 'package:flutter/material.dart';
import 'desktop.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: Scaffold(
        body: Desktop(), // This will be our main desktop
      ),
    );
  }
}

