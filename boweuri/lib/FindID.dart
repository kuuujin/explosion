import 'package:flutter/material.dart';

class FindID extends StatelessWidget {
  const FindID({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('아이디 찾기')),
      body: const Center(child: Text('아이디 찾기 화면')),
    );
  }
}