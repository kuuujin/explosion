// import 'package:flutter/material.dart';

// class Register extends StatefulWidget {
//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _verificationController = TextEditingController();
//   bool _isButtonEnabled = false;
//   bool _isVerificationFieldVisible = false; // 인증번호 입력 필드 가시성 상태

//   void _checkPhoneNumber(String value) {
//     setState(() {
//       _isButtonEnabled = value.length == 11; // 전화번호 길이 체크
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
//         title: Text('회원가입'),
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
//              Padding(padding: const EdgeInsets.only(top: 150)), // 위젯 간의 간격 조정
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
//             // 인증번호 확인 로직 추가
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

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

  Future<void> _confirmVerification() async {
    final phoneNumber = _phoneController.text;
    final verificationCode = _verificationController.text;

    // 서버에 인증 코드 확인 요청
    try {
      final response = await http.post(
        Uri.parse('http://34.64.176.207:5000/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber, 'code': verificationCode}),  // 전화번호와 인증 코드를 JSON 형식으로 전송
      );

      // 서버 응답 상태 코드 처리
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 인증 성공 시 비밀번호 재설정 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AccountInfoScreen(phoneNumber: _phoneController.text)),
        );
      } else {
        // 인증 실패 시 사용자에게 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 번호가 일치하지 않습니다.')),
        );
      }
    } catch (e) {
      // 예외 처리 (예: 네트워크 오류)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류 발생')),
      );
    }
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
          keyboardType: TextInputType.number, // 숫자 키보드 설정
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

// 계정 정보 및 회원 정보 입력 화면



class AccountInfoScreen extends StatefulWidget {
  final String phoneNumber;

  AccountInfoScreen({required this.phoneNumber});

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  DateTime? _selectedDate;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); // 생년월일 컨트롤러 추가

  @override
  void initState() {
    super.initState();
    // 전화번호 초기화
    _phoneController.text = widget.phoneNumber;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // 선택된 날짜 저장
        _dobController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"; // 생년월일 필드 업데이트
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: SingleChildScrollView( // SingleChildScrollView 추가
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '계정 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '아이디',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이메일 주소',
              ),
            ),
            SizedBox(height: 20),
            Text(
              '회원 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이름',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController, // 전화번호를 컨트롤러로 표시
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '전화번호',
              ),
              enabled: false, // 전화번호 필드 비활성화
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context), // 날짜 선택 시 달력 열기
              child: AbsorbPointer(
                child: TextField(
                  controller: _dobController, // 생년월일 컨트롤러
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '생년월일',
                    hintText: '생년월일 선택', // 기본 힌트 텍스트
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 다음 단계로 진행하는 로직 추가
              },
              child: Text('다음'),
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