import 'package:flutter/material.dart';
import 'LoginScreen.dart'; // 로그인 화면 임포트

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 스플래시 화면을 위한 위젯
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '보으링',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}