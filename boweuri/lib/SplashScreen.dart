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
            Image.asset(
              'asset/images/보으링로고.png', // 이미지 경로
              width: 276,
              height: 122, // 이미지 높이
              ),
            SizedBox(height: 20),
            Image.asset(
              'asset/images/보으링아이콘.png', // 이미지 경로
              width: 219,
              height: 205, // 이미지 높이
              ),
          ],
          
        ),
      ),
    );
  }
}