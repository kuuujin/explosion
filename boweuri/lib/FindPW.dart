import 'package:flutter/material.dart';

class FindPw extends StatelessWidget {
  const FindPw({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 재설정')),
      body: const Center(child: Text('비밀번호 재설정 화면')),
    );
  }
}