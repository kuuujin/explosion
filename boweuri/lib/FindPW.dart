// import 'package:flutter/material.dart';

// class FindPW extends StatefulWidget {
//   @override
//   _FindPWState createState() => _FindPWState();
// }

// class _FindPWState extends State<FindPW> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _verificationController = TextEditingController();
//   bool _isButtonEnabled = false;
//   bool _isVerificationFieldVisible = false; // 두 번째 필드의 가시성 상태

//   void _checkPhoneNumber(String value) {
//     setState(() {
//       _isButtonEnabled = value.length == 11;
//     });
//   }

//   void _requestVerification() {
//     setState(() {
//       _isVerificationFieldVisible = true; // 인증번호 입력 필드 표시
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('비밀번호 재설정'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // 뒤로 가기
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_isVerificationFieldVisible) ...[
//               VerificationInputGroup(
//                 controller: _verificationController,
//               ),
//               Padding(padding: const EdgeInsets.only(top: 20)), // 위젯 간격
//             ],
//             PhoneInputGroup(
//               controller: _phoneController,
//               onChanged: _checkPhoneNumber,
//               onRequest: _requestVerification,
//               isButtonEnabled: _isButtonEnabled,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PhoneInputGroup extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onRequest;
//   final bool isButtonEnabled;

//   PhoneInputGroup({
//     required this.controller,
//     required this.onChanged,
//     required this.onRequest,
//     required this.isButtonEnabled,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '가입에 사용한\n휴대폰 번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           keyboardType: TextInputType.phone,
//           maxLength: 11,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: '휴대폰 번호 입력',
//             counterText: '', // 카운터 텍스트 숨기기
//           ),
//           onChanged: onChanged, // 전화번호 입력 시 변경 사항을 전달
//         ),
//         SizedBox(height: 20), // 위젯 내부의 간격
//         ElevatedButton(
//           onPressed: isButtonEnabled ? onRequest : null,
//           child: Text('인증 번호 요청'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink,
//             foregroundColor: Colors.white,
//             minimumSize: Size(double.infinity, 50),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class VerificationInputGroup extends StatelessWidget {
//   final TextEditingController controller;

//   VerificationInputGroup({required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '발송된 인증번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: '인증번호 입력',
//           ),
//         ),
//         SizedBox(height: 20), // 위젯 내부의 간격
//         ElevatedButton(
//           onPressed: () {
//             // 인증번호 확인 로직
//           },
//           child: Text('인증 번호 확인'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink,
//             foregroundColor: Colors.white,
//             minimumSize: Size(double.infinity, 50),
//           ),
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';


// class FindPW extends StatefulWidget {
//   @override
//   _FindPWState createState() => _FindPWState();
// }

// class _FindPWState extends State<FindPW> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _verificationController = TextEditingController();
//   bool _isButtonEnabled = false;
//   bool _isVerificationFieldVisible = false;

//   void _checkPhoneNumber(String value) {
//     setState(() {
//       _isButtonEnabled = value.length == 11;
//     });
//   }

//   Future<void> _requestVerification() async {
//     final phoneNumber = _phoneController.text;

    

//     setState(() {
//       _isVerificationFieldVisible = true;
//     });
//   }

//   void _confirmVerification() {
//     // 인증번호 확인 후 비밀번호 재설정 화면으로 전환
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => PasswordReset()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('비밀번호 찾기'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_isVerificationFieldVisible) ...[
//               VerificationInputGroup(
//                 controller: _verificationController,
//                 onConfirm: _confirmVerification,
//               ),
//               Padding(padding: const EdgeInsets.only(top: 20)),
//             ],
//             PhoneInputGroup(
//               controller: _phoneController,
//               onChanged: _checkPhoneNumber,
//               onRequest: _requestVerification,
//               isButtonEnabled: _isButtonEnabled,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PhoneInputGroup extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onRequest;
//   final bool isButtonEnabled;

//   PhoneInputGroup({
//     required this.controller,
//     required this.onChanged,
//     required this.onRequest,
//     required this.isButtonEnabled,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '가입에 사용한\n휴대폰 번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           keyboardType: TextInputType.phone,
//           maxLength: 11,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: '휴대폰 번호 입력',
//             counterText: '',
//           ),
//           onChanged: onChanged,
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: isButtonEnabled ? onRequest : null,
//           child: Text('인증 번호 요청'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink,
//             foregroundColor: Colors.white,
//             minimumSize: Size(double.infinity, 50),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class VerificationInputGroup extends StatelessWidget {
//   final TextEditingController controller;
//   final VoidCallback onConfirm;

//   VerificationInputGroup({required this.controller, required this.onConfirm});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           '발송된 인증번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: '인증번호 입력',
//           ),
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: onConfirm,
//           child: Text('인증 번호 확인'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink,
//             foregroundColor: Colors.white,
//             minimumSize: Size(double.infinity, 50),
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FindPW extends StatefulWidget {
  @override
  _FindPWState createState() => _FindPWState();
}

class _FindPWState extends State<FindPW> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isVerificationFieldVisible = false; // 두 번째 필드의 가시성 상태

  void _checkPhoneNumber(String value) {
    setState(() {
      _isButtonEnabled = value.length == 11;
    });
  }

  Future<void> _requestVerification() async {
  final phoneNumber = _phoneController.text;

  // API 요청
  try {
    final response = await http.post(
      Uri.parse('http://34.64.176.207:5000/sendsms'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber}),  // 전화번호를 JSON 형식으로 전송
    );

    // 서버 응답 상태 코드에 관계없이 두 번째 필드 보이기
    setState(() {
      _isVerificationFieldVisible = true; // 인증번호 입력 필드 표시
    });

    // 서버 응답 처리 (선택 사항)
    if (response.statusCode == 200) {
      // 추가 로직 (예: 성공 메시지 등) 구현 가능
    } else {
      // 에러 처리 (예: 사용자에게 알림)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증 번호 요청 실패')),
      );
    }
  } catch (e) {
    // 예외 처리 (예: 네트워크 오류)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('네트워크 오류 발생')),
    );
  }
}

  void _confirmVerification() {
    // 인증번호 확인 후 새로운 화면으로 전환
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetSuccess()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isVerificationFieldVisible) ...[
              VerificationInputGroup(
                controller: _verificationController,
                onConfirm: _confirmVerification, // 확인 콜백 추가
              ),
              Padding(padding: const EdgeInsets.only(top: 150)), // 위젯 간격
            ],
            PhoneInputGroup(
              controller: _phoneController,
              onChanged: _checkPhoneNumber,
              onRequest: _requestVerification, // 요청 메서드 변경
              isButtonEnabled: _isButtonEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneInputGroup extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onRequest;
  final bool isButtonEnabled;

  PhoneInputGroup({
    required this.controller,
    required this.onChanged,
    required this.onRequest,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '가입에 사용한\n휴대폰 번호를 입력해 주세요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '휴대폰 번호 입력',
            counterText: '', // 카운터 텍스트 숨기기
          ),
          onChanged: onChanged, // 전화번호 입력 시 변경 사항을 전달
        ),
        SizedBox(height: 20), // 위젯 내부의 간격
        ElevatedButton(
          onPressed: isButtonEnabled ? onRequest : null,
          child: Text('인증 번호 요청'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}

class VerificationInputGroup extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onConfirm; // 확인 버튼 콜백

  VerificationInputGroup({required this.controller, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '발송된 인증번호를 입력해 주세요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '인증번호 입력',
          ),
        ),
        SizedBox(height: 20), // 위젯 내부의 간격
        ElevatedButton(
          onPressed: onConfirm, // 인증번호 확인 시 콜백 호출
          child: Text('인증 번호 확인'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isButtonEnabled = false;

  void _checkPasswords() {
    setState(() {
      _isButtonEnabled = _newPasswordController.text.isNotEmpty &&
                        _confirmPasswordController.text.isNotEmpty &&
                        _newPasswordController.text == _confirmPasswordController.text;
    });
  }

  void _resetPassword() {
    // 비밀번호 재설정 로직
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordResetSuccess()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 재설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '새 비밀번호를 입력하세요',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '새 비밀번호 입력',
              ),
              onChanged: (_) => _checkPasswords(),
            ),
            SizedBox(height: 20),
            Text(
              '비밀번호 확인',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '비밀번호 확인 입력',
              ),
              onChanged: (_) => _checkPasswords(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _resetPassword : null,
              child: Text('변경'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordResetSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 재설정 성공'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '비밀번호가 성공적으로 재설정되었습니다!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
