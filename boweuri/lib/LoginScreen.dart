import 'package:flutter_application_1/MainScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'FindID.dart';
import 'FindPW.dart';
import 'Register.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    String? id = await _storage.read(key: 'login_id');
    String? password = await _storage.read(key: 'password');

    if (id != null && password != null) {
      _login(id, password, context);
    }
  }

  Future<void> _login(String id, String password, BuildContext context) async {
    final url = Uri.parse('http://34.64.176.207:5000/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'login_id': id, 'password': password}),
    );

    if (response.statusCode == 200) {
      // 로그인 성공 처리
      final responseData = json.decode(response.body);
      int user_id = responseData['user_id']; // user_id를 정수형으로 가져옴
      String userid = user_id.toString(); // 문자열로 변환
      // 로그인 정보 저장
      await _storage.write(key: 'login_id', value: id);
      await _storage.write(key: 'password', value: password);
      await _storage.write(key: 'user_id', value: userid);

      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(user_id: userid)),  
    );
  } else {
      // 로그인 실패 처리
      final errorData = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('로그인 실패', style: TextStyle(fontWeight: FontWeight.w400)),
            content: Text('로그인 실패: ${errorData['error']}'),
            actions: [
              TextButton(
                child: Text('확인', style: TextStyle(fontWeight: FontWeight.w400)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 제목 및 이미지
                Column(
                  children: [
                    Image.asset(
                      'asset/images/보으링로고.png',
                      width: 276,
                      height: 122,
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'asset/images/보으링아이콘.png',
                      width: 219,
                      height: 205,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 아이디 입력 필드
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: '아이디',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // 비밀번호 입력 필드
                TextField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),
                // 로그인 버튼
                OutlinedButton(
                  onPressed: () {
                    _login(_idController.text, _pwController.text, context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFC245A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                        color: Color(0xFFFC245A),
                        width: 2,
                      ),
                    ),
                    minimumSize: const Size(300, 40),
                  ),
                  child: Text('로그인', style: TextStyle(fontWeight: FontWeight.w400)),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 30),
                // 하단 텍스트
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindID()),
                        );
                      },
                      child: const Text(
                        '아이디 찾기',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black54),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.black54,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindPW()),
                        );
                      },
                      child: const Text(
                        '비밀번호 재설정',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.black54),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.black54,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontSize: 11,fontWeight: FontWeight.w400, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
