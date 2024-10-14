// import 'package:flutter/material.dart';
// import 'FindID.dart'; // FindID.dart 파일 import
// import 'FindPW.dart'; // FindPw.dart 파일 import
// import 'Register.dart'; // Register.dart 파일 import

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: 300, // 원하는 너비 설정
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // 제목 및 이미지
//               Column(
//                 children: [
//                   Image.asset(
//               'asset/images/보으링로고.png', // 이미지 경로
//               width: 276,
//               height: 122, // 이미지 높이
//               ),
//                   const SizedBox(height: 10),
//                   Image.asset(
//                     'asset/images/보으링아이콘.png', // 이미지 경로
//                     width: 219,
//                     height: 205, // 이미지 높이
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // 아이디 입력 필드
//               const TextField(
//                 decoration: InputDecoration(
//                   labelText: '아이디',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // 비밀번호 입력 필드
//               const TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: '비밀번호',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // 로그인 버튼
//               OutlinedButton(
//                 onPressed: () {
//                   // 로그인 처리
//                 },
//                 style: OutlinedButton.styleFrom(
//                   backgroundColor: Colors.white, // 배경색
//                   foregroundColor: const Color(0xFFFC245A), // 텍스트 색상
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10), // 코너 반경
//                     side: const BorderSide(
//                       color: Color(0xFFFC245A), // 테두리 색상
//                       width: 2, // 테두리 두께
//                     ),
//                   ),
//                   minimumSize: const Size(230, 40), // 버튼 크기 설정
//                 ),
//                 child: Text('로그인'),
//               ),
//               const SizedBox(height: 10),
//               // 하단 텍스트
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       // 아이디 찾기 이벤트 처리
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => FindID()), // FindID 화면으로 이동
//                       );
//                     },
//                     child: const Text(
//                       '아이디 찾기',
//                       style: TextStyle(fontSize: 11, color: Colors.black54),
//                     ),
//                   ),
//                   Container(
//                     width: 1, // 선의 두께
//                     height: 20, // 선의 높이
//                     color: Colors.black54, // 선의 색상
//                     margin: const EdgeInsets.symmetric(horizontal: 10), // 간격
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // 비밀번호 재설정 이벤트 처리
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => FindPW()), // FindPw 화면으로 이동
//                       );
//                     },
//                     child: const Text(
//                       '비밀번호 재설정',
//                       style: TextStyle(fontSize: 11, color: Colors.black54),
//                     ),
//                   ),
//                   Container(
//                     width: 1, // 선의 두께
//                     height: 20, // 선의 높이
//                     color: Colors.black54, // 선의 색상
//                     margin: const EdgeInsets.symmetric(horizontal: 10), // 간격
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       // 회원가입 이벤트 처리
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => Register()), // Register 화면으로 이동
//                       );
//                     },
//                     child: const Text(
//                       '회원가입',
//                       style: TextStyle(fontSize: 11, color: Colors.black54),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // 카카오톡 로그인 버튼
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // 카카오톡 로그인 처리
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.yellow, // 버튼 색상
//                     foregroundColor: Colors.black, // 텍스트 색상
//                   ),
//                   child: Text('카카오톡으로 로그인 하기'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'FindID.dart'; // FindID.dart 파일 import
import 'FindPW.dart'; // FindPw.dart 파일 import
import 'Register.dart'; // Register.dart 파일 import

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

   Future<void> _login(String id, String password, BuildContext context) async {
    final url = Uri.parse('http://34.64.176.207:5000/users/login'); // 로그인 엔드포인트 URL

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'login_id': id, 'password': password}),
    );

    if (response.statusCode == 200) {
      // 로그인 성공 처리
      showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('로그인 성공'),
        content: Text('로그인에 성공했습니다.'),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
              // 다음 화면으로 이동하는 코드를 여기에 추가할 수 있습니다.
            },
          ),
        ],
      );
    },
  );
} else { 
  // 로그인 실패 처리
  final errorData = json.decode(response.body);
  
  // 로그인 실패 팝업창 띄우기
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('로그인 실패'),
        content: Text('로그인 실패: ${errorData['error']}'),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
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
      body: SingleChildScrollView( // 추가된 부분
        child: Center(
          child: Container(
            width: 300, // 원하는 너비 설정
            padding: const EdgeInsets.all(16.0),
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
                    const SizedBox(height: 10),
                    Image.asset(
                      'asset/images/보으링아이콘.png', // 이미지 경로
                      width: 219,
                      height: 205, // 이미지 높이
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 아이디 입력 필드
                TextField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    labelText: '아이디',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // 비밀번호 입력 필드
                TextField(
                  controller: _pwController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                // 로그인 버튼
                OutlinedButton(
                  onPressed: () {
                    _login(_idController.text, _pwController.text, context);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white, // 배경색
                    foregroundColor: const Color(0xFFFC245A), // 텍스트 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // 코너 반경
                      side: const BorderSide(
                        color: Color(0xFFFC245A), // 테두리 색상
                        width: 2, // 테두리 두께
                      ),
                    ),
                    minimumSize: const Size(230, 40), // 버튼 크기 설정
                  ),
                  child: Text('로그인'),
                ),
                const SizedBox(height: 10),
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
                      child: const Text(
                        '아이디 찾기',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                    Container(
                      width: 1, // 선의 두께
                      height: 20, // 선의 높이
                      color: Colors.black54, // 선의 색상
                      margin: const EdgeInsets.symmetric(horizontal: 10), // 간격
                    ),
                    GestureDetector(
                      onTap: () {
                        // 비밀번호 재설정 이벤트 처리
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FindPW()), // FindPw 화면으로 이동
                        );
                      },
                      child: const Text(
                        '비밀번호 재설정',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                    Container(
                      width: 1, // 선의 두께
                      height: 20, // 선의 높이
                      color: Colors.black54, // 선의 색상
                      margin: const EdgeInsets.symmetric(horizontal: 10), // 간격
                    ),
                    GestureDetector(
                      onTap: () {
                        // 회원가입 이벤트 처리
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()), // Register 화면으로 이동
                        );
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // 카카오톡 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 카카오톡 로그인 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // 버튼 색상
                      foregroundColor: Colors.black, // 텍스트 색상
                    ),
                    child: Text('카카오톡으로 로그인 하기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
