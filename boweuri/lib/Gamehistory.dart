import 'package:flutter/material.dart';

class GameHistory extends StatelessWidget {
  final String user_id;

  GameHistory({required this.user_id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게임 기록'),
      ),
      body: Center(
        child: Text('사용자 ID: $user_id'), // 예시: 사용자 ID 표시
      ),
    );
  }
}
