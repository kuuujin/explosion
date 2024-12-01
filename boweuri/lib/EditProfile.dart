import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  final String user_id;

  EditProfile({required this.user_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 수정'),
      ),
      body: Center(
        child: Text(
          '프로필 수정 화면',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
  
}

