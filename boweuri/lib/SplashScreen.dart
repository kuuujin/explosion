import 'package:flutter/material.dart';
import 'LoginScreen.dart'; // 로그인 화면 임포트

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // 아래에서 위로 올라오는 애니메이션
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ));
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/images/보으링로고.png', // 이미지 경로
              width: 276,
              height: 122, // 이미지 높이
            ),
            const SizedBox(height: 20),
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