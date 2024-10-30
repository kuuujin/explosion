import 'package:flutter/material.dart';

class MyScore extends StatelessWidget {
  final String user_id;

  MyScore({required this.user_id});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '내기록 탭 내용',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
