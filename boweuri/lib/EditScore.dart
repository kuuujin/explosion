import 'package:flutter/material.dart';

class EditScore extends StatelessWidget {
  final String user_id;

  EditScore({required this.user_id});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '점수기록 탭 내용',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
