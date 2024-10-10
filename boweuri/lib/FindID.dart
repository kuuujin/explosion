// import 'package:flutter/material.dart';

// class FindID extends StatefulWidget {
//   @override
//   _FindIDState createState() => _FindIDState();
// }

// class _FindIDState extends State<FindID> {
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
//         title: Text('아이디 찾기'),
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
//               // 위젯 간의 간격을 조정
//               Padding(padding: const EdgeInsets.only(top: 150)),
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


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginScreen.dart'; // LoginScreen import 추가

class FindID extends StatefulWidget {
  @override
  _FindIDState createState() => _FindIDState();
}

class _FindIDState extends State<FindID> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isVerificationFieldVisible = false; // 인증 번호 입력 필드 가시성 상태

  void _checkPhoneNumber(String value) {
    setState(() {
      _isButtonEnabled = value.length == 11; // 전화번호가 11자리인지 확인
    });
  }

  Future<void> _requestVerification() async {
    final phoneNumber = _phoneController.text;

    // API 요청
    try {
      final response = await http.post(
        Uri.parse('http://34.64.176.207:5000/sendsms'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber}), // 전화번호를 JSON 형식으로 전송
      );

      // 인증 번호 입력 필드 표시
      setState(() {
        _isVerificationFieldVisible = true; 
      });

      // 서버 응답 상태 코드 처리
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 번호 요청 완료')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 번호 요청 실패')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류 발생')),
      );
    }
  }

  Future<void> _confirmVerification() async {
    final phoneNumber = _phoneController.text;
    final verificationCode = _verificationController.text;

    // 서버에 인증 코드 확인 요청
    try {
      final response = await http.post(
        Uri.parse('http://34.64.176.207:5000/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber, 'code': verificationCode}), 
      );

      // 서버 응답 상태 코드 처리
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 인증 성공 시 팝업창 출력
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('인증 완료'),
              content: Text('인증완료 확인 테스트'),
              actions: [
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 팝업 닫기
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()), // LoginScreen으로 이동
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 번호가 일치하지 않습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류 발생')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('아이디 찾기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: SingleChildScrollView( // 변경된 부분
        child: Padding(
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
          keyboardType: TextInputType.phone, // 숫자 키보드 설정
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
