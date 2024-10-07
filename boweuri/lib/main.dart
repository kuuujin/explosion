import 'package:flutter/material.dart';
import 'SplashScreen.dart'; // 스플래시 화면 임포트

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}