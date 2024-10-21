
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'LoginScreen.dart';

// class Register extends StatefulWidget {
//   @override
//   _RegisterState createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController verificationCodeController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController loginIdController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController birthdateController = TextEditingController();

//   bool _isButtonEnabled = false;
//   bool _isVerificationFieldVisible = false;

//   void _checkPhoneNumber(String value) {
//     setState(() {
//       _isButtonEnabled = value.length == 11;
//     });
//   }

//   Future<void> _requestVerification() async {
//     final phoneNumber = phoneController.text;

//     // 전화번호 중복 확인
//     final checkResponse = await http.post(
//       Uri.parse('http://34.64.176.207:5000/check_phone'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'phone_num': phoneNumber}),
//     );

//     if (checkResponse.statusCode == 200) {
//       final exists = json.decode(checkResponse.body)['exists'];
//       if (exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('해당 전화번호로 이미 계정이 존재합니다.')),
//         );
//         return; // 중복된 번호가 있으면 함수 종료
//       }
//     }

//     try {
//       final response = await http.post(
//         Uri.parse('http://34.64.176.207:5000/sendsms'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'phone': phoneNumber}),
//       );

//       setState(() {
//         _isVerificationFieldVisible = true;
//       });

//       if (response.statusCode != 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('인증 번호 요청 실패')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('네트워크 오류 발생')),
//       );
//     }
//   }

//   Future<void> _confirmVerification() async {
//   final phoneNumber = phoneController.text;
//   final verificationCode = verificationCodeController.text;

//   try {
//     final response = await http.post(
//       Uri.parse('http://34.64.176.207:5000/verify'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'phone': phoneNumber, 'code': verificationCode}),
//     );

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AccountInfoScreen(
//             phoneNumber: phoneController.text,
//             nameController: nameController,
//             loginIdController: loginIdController,
//             passwordController: passwordController,
//             emailController: emailController,
//             birthdateController: birthdateController,
//             phoneController: phoneController, // 전화번호 컨트롤러 전달
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('인증 번호가 일치하지 않습니다.')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('네트워크 오류 발생')),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('회원가입'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Align(alignment: Alignment.centerLeft,
//               child :
//               Image.asset(
//               'asset/images/1단계.png', // 이미지 경로
//               width: 150,
//               height: 100, // 이미지 높이
//             ),
//           ),
//             const SizedBox(height: 10),
//               if (_isVerificationFieldVisible) ...[
//                 VerificationInputGroup(
//                   controller: verificationCodeController,
//                   onConfirm: _confirmVerification,
//                 ),
//                 Padding(padding: const EdgeInsets.only(top: 100)),
//               ],
//               PhoneInputGroup(
//                 controller: phoneController,
//                 onChanged: _checkPhoneNumber,
//                 onRequest: _requestVerification,
//                 isButtonEnabled: _isButtonEnabled,
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
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
//           '가입에 사용할\n휴대폰 번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           keyboardType: TextInputType.phone,
//           maxLength: 11,
//           decoration: InputDecoration(
//             border: UnderlineInputBorder(),
//             hintText: '휴대폰 번호 입력',
//             counterText: '',
//           ),
//           onChanged: onChanged,
//         ),
//         SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: isButtonEnabled
//       ? () {
//           FocusScope.of(context).unfocus(); // 키보드 닫기
//           onRequest(); // 인증 번호 요청
//         }
//       : null,
//   child: Text('인증 번호 요청'),
//   style: ElevatedButton.styleFrom(
//     backgroundColor: Colors.pink,
//     foregroundColor: Colors.white,
//     minimumSize: Size(double.infinity, 50),
//   ),
// ),
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
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             border: UnderlineInputBorder(),
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

// class AccountInfoScreen extends StatefulWidget {
//   final String phoneNumber;
//   final TextEditingController nameController;
//   final TextEditingController loginIdController;
//   final TextEditingController passwordController;
//   final TextEditingController emailController;
//   final TextEditingController birthdateController;
//   final TextEditingController phoneController; // 전화번호 컨트롤러 추가

//   AccountInfoScreen({
//     required this.phoneNumber,
//     required this.nameController,
//     required this.loginIdController,
//     required this.passwordController,
//     required this.emailController,
//     required this.birthdateController,
//     required this.phoneController, // 전화번호 컨트롤러 초기화
//   });

//   @override
//   _AccountInfoScreenState createState() => _AccountInfoScreenState();
// }

// class _AccountInfoScreenState extends State<AccountInfoScreen> {
//   DateTime? _selectedDate;
//   final TextEditingController _dobController = TextEditingController();
  
//   @override
//   void initState() {
//     super.initState();
//     _dobController.text = "";
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//         _dobController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
//         widget.birthdateController.text = _dobController.text; // 생년월일 컨트롤러에 값 저장
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text('회원가입 정보'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//               Align(alignment: Alignment.centerLeft,
//               child :
//               Image.asset(
//               'asset/images/2단계.png', // 이미지 경로
//               width: 150,
//               height: 100, // 이미지 높이
//             ),
//           ),
//             Text(
//               '계정 정보',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: widget.loginIdController,
//               decoration: InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: '아이디',
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               obscureText: true,
//               controller: widget.passwordController,
//               decoration: InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: '비밀번호',
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: widget.emailController,
//               decoration: InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: '이메일 주소',
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               '회원 정보',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: widget.nameController,
//               decoration: InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: '이름',
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: TextEditingController(text: widget.phoneNumber),
//               decoration: InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: '전화번호',
//               ),
//               enabled: false,
//             ),
//             SizedBox(height: 10),
//             GestureDetector(
//               onTap: () => _selectDate(context),
//               child: AbsorbPointer(
//                 child: TextField(
//                   controller: _dobController,
//                   decoration: InputDecoration(
//                     border: UnderlineInputBorder(),
//                     labelText: '생년월일',
//                     hintText: '생년월일 선택',
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProfileSettingScreen(
//                       phoneController: widget.phoneController,
//                       nameController: widget.nameController,
//                       loginIdController: widget.loginIdController,
//                       passwordController: widget.passwordController,
//                       emailController: widget.emailController,
//                       birthdateController: widget.birthdateController,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('다음'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.pink,
//                 foregroundColor: Colors.white,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class ProfileSettingScreen extends StatelessWidget {
//   final TextEditingController nicknameController = TextEditingController();
//   final TextEditingController phoneController;
//   final TextEditingController nameController;
//   final TextEditingController loginIdController;
//   final TextEditingController passwordController;
//   final TextEditingController emailController;
//   final TextEditingController birthdateController;

//   ProfileSettingScreen({
//     required this.phoneController,
//     required this.nameController,
//     required this.loginIdController,
//     required this.passwordController,
//     required this.emailController,
//     required this.birthdateController,
//   });

//   Future<void> _registerUser(BuildContext context) async {
//   final phoneNumber = phoneController.text;

//   final response = await http.post(
//     Uri.parse('http://34.64.176.207:5000/users'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'name': nameController.text,
//       'phone_num': phoneNumber,
//       'login_id': loginIdController.text,
//       'pw': passwordController.text,
//       'email': emailController.text,
//       'birthdate': birthdateController.text,
//       'nickname': nicknameController.text, // 닉네임 추가
//     }),
//   );

//   if (response.statusCode == 201) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('회원가입 성공'),
//           content: Text('회원가입이 완료되었습니다.'),
//           actions: [
//             TextButton(
//               child: Text('확인'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // 다이얼로그 닫기
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen()), // LoginScreen으로 이동
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('사용자 등록 실패: ${json.decode(response.body)['error']}')),
//     );
//   }
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Colors.white,
//     appBar: AppBar(
//       backgroundColor: Colors.white,
//       title: Text('프로필 설정'),
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//     ),
//     body: SingleChildScrollView(  // SingleChildScrollView 추가
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Align(alignment: Alignment.centerLeft,
//               child :
//               Image.asset(
//               'asset/images/3단계.png', // 이미지 경로
//               width: 150,
//               height: 100, // 이미지 높이
//             ),
//           ),
//             Center(
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundColor: Colors.grey[300],
//                 child: Icon(Icons.person, size: 50, color: Colors.grey),
//               ),
//             ),
            
//             SizedBox(height: 20),
//             TextField(
//               controller: nicknameController,
//               decoration: InputDecoration(
//                 border: UnderlineInputBorder(),
//                 labelText: '닉네임',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _registerUser(context),
//               child: Text('회원가입 하기'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.pink,
//                 foregroundColor: Colors.white,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController loginIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isVerificationFieldVisible = false;

  void _checkPhoneNumber(String value) {
    setState(() {
      _isButtonEnabled = value.length == 11;
    });
  }

  Future<void> _requestVerification() async {
    final phoneNumber = phoneController.text;

    // 전화번호 중복 확인
    final checkResponse = await http.post(
      Uri.parse('http://34.64.176.207:5000/check_phone'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_num': phoneNumber}),
    );

    if (checkResponse.statusCode == 200) {
      final exists = json.decode(checkResponse.body)['exists'];
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('해당 전화번호로 이미 계정이 존재합니다.')),
        );
        return; // 중복된 번호가 있으면 함수 종료
      }
    }

    try {
      final response = await http.post(
        Uri.parse('http://34.64.176.207:5000/sendsms'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber}),
      );

      setState(() {
        _isVerificationFieldVisible = true;
      });

      if (response.statusCode != 200) {
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
    final phoneNumber = phoneController.text;
    final verificationCode = verificationCodeController.text;

    try {
      final response = await http.post(
        Uri.parse('http://34.64.176.207:5000/verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber, 'code': verificationCode}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountInfoScreen(
              phoneNumber: phoneController.text,
              nameController: nameController,
              loginIdController: loginIdController,
              passwordController: passwordController,
              emailController: emailController,
              birthdateController: birthdateController,
              phoneController: phoneController, // 전화번호 컨트롤러 전달
            ),
          ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('회원가입'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'asset/images/1단계.png', // 이미지 경로
                  width: 150,
                  height: 100, // 이미지 높이
                ),
              ),
              const SizedBox(height: 10),
              if (_isVerificationFieldVisible) ...[
                VerificationInputGroup(
                  controller: verificationCodeController,
                  onConfirm: _confirmVerification,
                ),
                Padding(padding: const EdgeInsets.only(top: 100)),
              ],
              PhoneInputGroup(
                controller: phoneController,
                onChanged: _checkPhoneNumber,
                onRequest: _requestVerification,
                isButtonEnabled: _isButtonEnabled,
              ),
              SizedBox(height: 20),
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
          '가입에 사용할\n휴대폰 번호를 입력해 주세요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: '휴대폰 번호 입력',
            counterText: '',
          ),
          onChanged: onChanged,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isButtonEnabled
              ? () {
                  FocusScope.of(context).unfocus(); // 키보드 닫기
                  onRequest(); // 인증 번호 요청
                }
              : null,
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
  final VoidCallback onConfirm;

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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: '인증번호 입력',
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: onConfirm,
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

class AccountInfoScreen extends StatefulWidget {
  final String phoneNumber;
  final TextEditingController nameController;
  final TextEditingController loginIdController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController birthdateController;
  final TextEditingController phoneController; // 전화번호 컨트롤러 추가

  AccountInfoScreen({
    required this.phoneNumber,
    required this.nameController,
    required this.loginIdController,
    required this.passwordController,
    required this.emailController,
    required this.birthdateController,
    required this.phoneController, // 전화번호 컨트롤러 초기화
  });

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  DateTime? _selectedDate;
  final TextEditingController _dobController = TextEditingController();
  
  @override
  void initState() {
     super.initState();
     _dobController.text = "";
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
        _selectedDate = picked;
        _dobController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
        widget.birthdateController.text = _dobController.text; // 생년월일 컨트롤러에 값 저장
      });
    }
  }

  Future<void> _checkLoginId() async {
    final loginId = widget.loginIdController.text;

    try {
      final response = await http.post(
        Uri.parse('http://34.64.176.207:5000/check_login_id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login_id': loginId}),
      );

      if (response.statusCode == 200) {
        final exists = json.decode(response.body)['exists'];
        if (exists) {
          _showDialog('중복된 아이디입니다. 다른 아이디를 사용해주세요.');
        } else {
          _showDialog('사용 가능한 아이디입니다.');
        }
      } else {
        _showDialog('아이디 중복 확인 실패');
      }
    } catch (e) {
      _showDialog('네트워크 오류 발생');
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('중복임'),
              onPressed: () {
                Navigator.of(context).pop();
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
        backgroundColor: Colors.white,
        title: Text('회원가입 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'asset/images/2단계.png', // 이미지 경로
                width: 150,
                height: 100, // 이미지 높이
              ),
            ),
            Text(
              '계정 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.loginIdController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: '아이디',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _checkLoginId,
                  child: Text('중복 확인'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: widget.passwordController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget.emailController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
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
              controller: widget.nameController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '이름',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: TextEditingController(text: widget.phoneNumber),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '전화번호',
              ),
              enabled: false,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: '생년월일',
                    hintText: '생년월일 선택',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingScreen(
                      phoneController: widget.phoneController,
                      nameController: widget.nameController,
                      loginIdController: widget.loginIdController,
                      passwordController: widget.passwordController,
                      emailController: widget.emailController,
                      birthdateController: widget.birthdateController,
                    ),
                  ),
                );
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

class ProfileSettingScreen extends StatefulWidget {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController;
  final TextEditingController nameController;
  final TextEditingController loginIdController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController birthdateController;

  ProfileSettingScreen({
    required this.phoneController,
    required this.nameController,
    required this.loginIdController,
    required this.passwordController,
    required this.emailController,
    required this.birthdateController,
  });

  @override
  _ProfileSettingScreenState createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  File? _image; // 선택한 이미지를 저장할 변수

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 선택한 이미지 파일 경로
      });
    }
  }

  Future<void> _registerUser(BuildContext context) async {
    final phoneNumber = widget.phoneController.text;

    // 이미지가 선택된 경우 Base64로 인코딩
    String? base64Image;
    if (_image != null) {
      Uint8List imageBytes = await _image!.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    final response = await http.post(
      Uri.parse('http://34.64.176.207:5000/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': widget.nameController.text,
        'phone_num': phoneNumber,
        'login_id': widget.loginIdController.text,
        'pw': widget.passwordController.text,
        'email': widget.emailController.text,
        'birthdate': widget.birthdateController.text,
        'nickname': widget.nicknameController.text, // 닉네임 추가
        'profile_image': base64Image, // Base64 인코딩된 이미지 추가
      }),
    );

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원가입 성공'),
            content: Text('회원가입이 완료되었습니다.'),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
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
        SnackBar(content: Text('사용자 등록 실패: ${json.decode(response.body)['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('프로필 설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(  // SingleChildScrollView 추가
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'asset/images/3단계.png', // 이미지 경로
                  width: 150,
                  height: 100, // 이미지 높이
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // 이미지 선택 기능 추가
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _image != null ? FileImage(_image!) : null, // 선택한 이미지 표시
                    child: _image == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: widget.nicknameController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '닉네임',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _registerUser(context),
                child: Text('회원가입 하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}