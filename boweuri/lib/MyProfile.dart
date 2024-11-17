import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginScreen.dart';
import 'EditProfile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfileService {
  final String baseUrl = 'http://34.64.176.207:5000';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
   Future<bool> logoutUser() async {
    // 로그아웃 로직을 서버에서 처리하는 경우
    // 세션 종료 요청 등
    // ID와 비밀번호 삭제
    await _storage.delete(key: 'login_id');
    await _storage.delete(key: 'password');
    return true;
  }

  Future<bool> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/${userId}'));

    if (response.statusCode == 200) {
      // 사용자 삭제 후 ID와 비밀번호 삭제
      await _storage.delete(key: 'login_id');
      await _storage.delete(key: 'password');
      return true;
    }
    return false;
  }
}


class MyProfile extends StatefulWidget {
  final String user_id;

  MyProfile({required this.user_id});
  
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool _isNotificationsEnabled = true; 
  String _userName = ''; 
  String _userEmail = ''; 
  String _profileImageUrl = ''; 

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
        _userName = userProfile['name'];
        _userEmail = userProfile['email'];
      });

      _fetchProfileImage(userId);
    }
  }

  Future<void> _fetchProfileImage(String userId) async {
    final response = await http.get(Uri.parse('http://34.64.176.207:5000/users/$userId/image'));
    
    if (response.statusCode == 200) {
      setState(() {
        _profileImageUrl = 'http://34.64.176.207:5000/users/$userId/image';
      });
    } else {
      print('Error fetching profile image: ${response.statusCode}');
    }
  }

  void _showConfirmationDialog(String action) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(action == 'logout' ? '로그아웃 확인' : '탈퇴 확인'),
        content: Text(action == 'logout' 
          ? '로그아웃 하시겠습니까?' 
          : '정말 탈퇴하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('확인'),
            onPressed: () async {
              Navigator.of(context).pop();
              if (action == 'logout') {
                bool success = await UserProfileService().logoutUser();
                if (success) {
                  // 로그아웃 후 확인 메시지
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그아웃되었습니다.'))
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              } else {
                bool success = await UserProfileService().deleteUser(widget.user_id);
                if (success) {
                  // 탈퇴 후 확인 메시지
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('계정이 삭제되었습니다.'))
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  // 오류 처리
                  print('탈퇴 실패');
                }
              }
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('프로필'),
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 252, 36, 90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImageUrl.isNotEmpty
                        ? NetworkImage(_profileImageUrl)
                        : null,
                  ),
                  if (_profileImageUrl.isEmpty)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(Icons.account_circle, size: 40, color: Colors.black),
                    ),
                  SizedBox(height: 8),
                  Text(
                    _userName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _userEmail,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('알림 수신', style: TextStyle(fontSize: 18)),
                Switch(
                  value: _isNotificationsEnabled,
                  activeColor: Color.fromARGB(255, 252, 36, 90),
                  activeTrackColor: Colors.grey[100],
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                  onChanged: (value) {
                    setState(() {
                      _isNotificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildListItem('프로필 편집', context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile(user_id: widget.user_id)),
                    );
                  }),
                  _buildListItem('공지사항', context, () {
                    // 공지사항 페이지 이동 로직 추가
                  }),
                  _buildListItem('고객센터', context, () {
                    // 고객센터 페이지 이동 로직 추가
                  }),
                  _buildListItem('탈퇴하기', context, () {
                    _showConfirmationDialog('delete');
                  }),
                  _buildListItem('로그아웃', context, () {
                    _showConfirmationDialog('logout');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(String title, BuildContext context, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}