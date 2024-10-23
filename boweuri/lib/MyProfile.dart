import 'package:flutter/material.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool _isNotificationsEnabled = true; // 알림 수신 상태

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('프로필'),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 252, 36, 90), // 상단 바 색상
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 프로필 이미지 및 이름
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40, // 프로필 이미지 크기
                    backgroundImage: AssetImage('asset/images/보으링아이콘.png'), // 프로필 이미지
                  ),
                  SizedBox(height: 8),
                  Text(
                    '이순신',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'General.Lee@gmail.com',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 알림 수신 스위치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('알림 수신', style: TextStyle(fontSize: 18)),
                Switch(
                  value: _isNotificationsEnabled, // 현재 스위치 상태
                  activeColor: Color.fromARGB(255, 252, 36, 90), // 스위치가 켜졌을 때 색상
                  activeTrackColor: Colors.grey[100],
                  inactiveThumbColor: Colors.grey, // 스위치가 꺼졌을 때 Thumb 색상
                  inactiveTrackColor: Colors.grey[300], // 스위치가 꺼졌을 때 Track 색상
                  onChanged: (value) {
                    setState(() {
                      _isNotificationsEnabled = value; // 스위치 상태 변경
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // 리스트 항목
            Expanded(
              child: ListView(
                children: [
                  _buildListItem('프로필 편집', context),
                  _buildListItem('공지사항', context),
                  _buildListItem('고객센터', context),
                  _buildListItem('탈퇴하기', context),
                  _buildListItem('로그아웃', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // 항목 클릭 시 행동 처리
        // 예를 들어 다른 화면으로 전환할 수 있습니다.
      },
    );
  }
}
