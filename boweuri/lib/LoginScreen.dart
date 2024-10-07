import 'package:flutter/material.dart';
import 'FindID.dart'; // FindID.dart 파일 import
import 'FindPW.dart'; // FindPw.dart 파일 import
import 'Register.dart'; // Register.dart 파일 import

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300, // 원하는 너비 설정
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 제목 및 이미지
              Column(
                children: [
                  Image.asset(
              'asset/images/보으링로고.png', // 이미지 경로
              width: 276,
              height: 122, // 이미지 높이
              ),
                  SizedBox(height: 10),
                  Image.asset(
                    'asset/images/보으링아이콘.png', // 이미지 경로
                    width: 219,
                    height: 205, // 이미지 높이
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 아이디 입력 필드
              TextField(
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // 비밀번호 입력 필드
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // 로그인 버튼
              OutlinedButton(
                onPressed: () {
                  // 로그인 처리
                },
                child: Text('로그인'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white, // 배경색
                  foregroundColor: Color(0xFFFC245A), // 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 코너 반경
                    side: BorderSide(
                      color: Color(0xFFFC245A), // 테두리 색상
                      width: 2, // 테두리 두께
                    ),
                  ),
                  minimumSize: Size(230, 40), // 버튼 크기 설정
                ),
              ),
              SizedBox(height: 10),
              // 하단 텍스트
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // 아이디 찾기 이벤트 처리
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindID()), // FindID 화면으로 이동
                      );
                    },
                    child: Text(
                      '아이디 찾기',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                  Container(
                    width: 1, // 선의 두께
                    height: 20, // 선의 높이
                    color: Colors.black54, // 선의 색상
                    margin: EdgeInsets.symmetric(horizontal: 10), // 간격
                  ),
                  GestureDetector(
                    onTap: () {
                      // 비밀번호 재설정 이벤트 처리
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindPw()), // FindPw 화면으로 이동
                      );
                    },
                    child: Text(
                      '비밀번호 재설정',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                  Container(
                    width: 1, // 선의 두께
                    height: 20, // 선의 높이
                    color: Colors.black54, // 선의 색상
                    margin: EdgeInsets.symmetric(horizontal: 10), // 간격
                  ),
                  GestureDetector(
                    onTap: () {
                      // 회원가입 이벤트 처리
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()), // Register 화면으로 이동
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 카카오톡 로그인 버튼
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 카카오톡 로그인 처리
                  },
                  child: Text('카카오톡으로 로그인 하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // 버튼 색상
                    foregroundColor: Colors.black, // 텍스트 색상
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
