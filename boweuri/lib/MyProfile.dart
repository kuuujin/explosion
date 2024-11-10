import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileService {
  final String baseUrl = 'http://34.64.176.207:5000'; // Flask 서버 주소

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // 오류 처리
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}


class MyProfile extends StatefulWidget {
  final String user_id; // user_id를 String형으로 지정

  MyProfile({required this.user_id});
  
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool _isNotificationsEnabled = true; // 알림 수신 상태
  String _userName = ''; // 사용자 이름
  String _userEmail = ''; // 사용자 이메일
  String _profileImage = ''; // 사용자 프로필 이미지 URL

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(widget.user_id);
  }

  Future<void> _fetchUserProfile(String userId) async {
    UserProfileService userProfileService = UserProfileService();
    Map<String, dynamic>? userProfile = await userProfileService.getUserProfile(userId);

    if (userProfile != null) {
      setState(() {
        _userName = userProfile['name']; // API 응답에서 이름 가져오기
        _userEmail = userProfile['email']; // API 응답에서 이메일 가져오기
        _profileImage = userProfile['profile_image']; // API 응답에서 프로필 이미지 URL 가져오기
      });
    }
  }

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
                    backgroundImage: NetworkImage(_profileImage.isNotEmpty ? _profileImage : 'default_image_url'), // 프로필 이미지
                  ),
                  SizedBox(height: 8),
                  Text(
                    _userName, // 동적으로 변경된 이름
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _userEmail, // 동적으로 변경된 이메일
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
