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
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

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

//   void _confirmVerification() {
//     // 인증번호 확인 후 다음 화면으로 전환
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => AccountInfoScreen(phoneNumber: _phoneController.text)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('회원가입'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
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
//                 onConfirm: _confirmVerification, // 인증 확인 콜백 추가
//               ),
//               const SizedBox(height: 20), // 위젯 간의 간격 조정
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

//   const PhoneInputGroup({super.key, 
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
//         const Text(
//           '가입에 사용한\n휴대폰 번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           keyboardType: TextInputType.phone,
//           maxLength: 11,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: '휴대폰 번호 입력',
//             counterText: '', // 카운터 텍스트 숨기기
//           ),
//           onChanged: onChanged, // 전화번호 입력 시 변경 사항을 전달
//         ),
//         const SizedBox(height: 20), // 위젯 내부의 간격
//         ElevatedButton(
//           onPressed: isButtonEnabled ? onRequest : null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink,
//             foregroundColor: Colors.white,
//             minimumSize: const Size(double.infinity, 50),
//           ),
//           child: Text('인증 번호 요청'),
//         ),
//       ],
//     );
//   }
// }

// class VerificationInputGroup extends StatelessWidget {
//   final TextEditingController controller;
//   final VoidCallback onConfirm;

//   const VerificationInputGroup({super.key, required this.controller, required this.onConfirm});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           '발송된 인증번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: '인증번호 입력',
//           ),
//         ),
//         const SizedBox(height: 20), // 위젯 내부의 간격
//         ElevatedButton(
//           onPressed: onConfirm,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink,
//             foregroundColor: Colors.white,
//             minimumSize: const Size(double.infinity, 50),
//           ), // 인증번호 확인 시 콜백 호출
//           child: Text('인증 번호 확인'),
//         ),
//       ],
//     );
//   }
// }

// // 계정 정보 및 회원 정보 입력 화면



// class AccountInfoScreen extends StatefulWidget {
//   final String phoneNumber;

//   const AccountInfoScreen({super.key, required this.phoneNumber});

//   @override
//   _AccountInfoScreenState createState() => _AccountInfoScreenState();
// }

// class _AccountInfoScreenState extends State<AccountInfoScreen> {
//   DateTime? _selectedDate;
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController(); // 생년월일 컨트롤러 추가

//   @override
//   void initState() {
//     super.initState();
//     // 전화번호 초기화
//     _phoneController.text = widget.phoneNumber;
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
//         _selectedDate = picked; // 선택된 날짜 저장
//         _dobController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"; // 생년월일 필드 업데이트
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('회원가입 정보'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // 뒤로 가기
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               '계정 정보',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             const TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: '아이디',
//               ),
//             ),
//             const SizedBox(height: 10),
//             const TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: '비밀번호',
//               ),
//             ),
//             const SizedBox(height: 10),
//             const TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: '이메일 주소',
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               '회원 정보',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             const TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: '이름',
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _phoneController, // 전화번호를 컨트롤러로 표시
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: '전화번호',
//               ),
//               enabled: false, // 전화번호 필드 비활성화
//             ),
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: () => _selectDate(context), // 날짜 선택 시 달력 열기
//               child: AbsorbPointer(
//                 child: TextField(
//                   controller: _dobController, // 생년월일 컨트롤러
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: '생년월일',
//                     hintText: '생년월일 선택', // 기본 힌트 텍스트
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // 다음 단계로 진행하는 로직 추가
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.pink,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               child: Text('다음'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // import 'package:flutter/material.dart';

// // class Register extends StatefulWidget {
// //   @override
// //   _RegisterState createState() => _RegisterState();
// // }

// // class _RegisterState extends State<Register> {
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _verificationController = TextEditingController();
// //   bool _isButtonEnabled = false;
// //   bool _isVerificationFieldVisible = false; // 인증번호 입력 필드 가시성 상태

// //   void _checkPhoneNumber(String value) {
// //     setState(() {
// //       _isButtonEnabled = value.length == 11; // 전화번호 길이 체크
// //     });
// //   }

// //   void _requestVerification() {
// //     setState(() {
// //       _isVerificationFieldVisible = true; // 인증번호 입력 필드 표시
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('회원가입'),
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pop(context); // 뒤로 가기
// //           },
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             if (_isVerificationFieldVisible) ...[
// //               VerificationInputGroup(
// //                 controller: _verificationController,
// //               ),
// //              Padding(padding: const EdgeInsets.only(top: 150)), // 위젯 간의 간격 조정
// //             ],
// //             PhoneInputGroup(
// //               controller: _phoneController,
// //               onChanged: _checkPhoneNumber,
// //               onRequest: _requestVerification,
// //               isButtonEnabled: _isButtonEnabled,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class PhoneInputGroup extends StatelessWidget {
// //   final TextEditingController controller;
// //   final ValueChanged<String> onChanged;
// //   final VoidCallback onRequest;
// //   final bool isButtonEnabled;

// //   PhoneInputGroup({
// //     required this.controller,
// //     required this.onChanged,
// //     required this.onRequest,
// //     required this.isButtonEnabled,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           '가입에 사용한\n휴대폰 번호를 입력해 주세요',
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //         ),
// //         SizedBox(height: 10),
// //         TextField(
// //           controller: controller,
// //           keyboardType: TextInputType.phone,
// //           maxLength: 11,
// //           decoration: InputDecoration(
// //             border: OutlineInputBorder(),
// //             hintText: '휴대폰 번호 입력',
// //             counterText: '', // 카운터 텍스트 숨기기
// //           ),
// //           onChanged: onChanged, // 전화번호 입력 시 변경 사항을 전달
// //         ),
// //         SizedBox(height: 20), // 위젯 내부의 간격
// //         ElevatedButton(
// //           onPressed: isButtonEnabled ? onRequest : null,
// //           child: Text('인증 번호 요청'),
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.pink,
// //             foregroundColor: Colors.white,
// //             minimumSize: Size(double.infinity, 50),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }

// // class VerificationInputGroup extends StatelessWidget {
// //   final TextEditingController controller;

// //   VerificationInputGroup({required this.controller});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(
// //           '발송된 인증번호를 입력해 주세요',
// //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //         ),
// //         SizedBox(height: 10),
// //         TextField(
// //           controller: controller,
// //           decoration: InputDecoration(
// //             border: OutlineInputBorder(),
// //             hintText: '인증번호 입력',
// //           ),
// //         ),
// //         SizedBox(height: 20), // 위젯 내부의 간격
// //         ElevatedButton(
// //           onPressed: () {
// //             // 인증번호 확인 로직 추가
// //           },
// //           child: Text('인증 번호 확인'),
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.pink,
// //             foregroundColor: Colors.white,
// //             minimumSize: Size(double.infinity, 50),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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
//   bool _isVerificationFieldVisible = false; // 두 번째 필드의 가시성 상태

//   void _checkPhoneNumber(String value) {
//     setState(() {
//       _isButtonEnabled = value.length == 11;
//     });
//   }
//   Future<void> _registerUser() async {
//     final response = await http.post(
//       Uri.parse('http://34.64.176.207:5000/users'), // Flask 서버 주소
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': nameController.text,
//         'phone_num':phoneController.text,
//         'login_id': loginIdController.text,
//         'pw': passwordController.text,
//         'email': emailController.text,
//         'birthdate': birthdateController.text, // 생년월일
//       }),
//     );

//     if (response.statusCode == 201) {
//       // 성공 처리
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('사용자 등록 성공!')),
//       );
//     } else {
//       // 에러 처리
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('사용자 등록 실패: ${json.decode(response.body)['error']}')),
//       );
//     }
//   }
  
//   Future<void> _requestVerification() async {
//     final phoneNumber = phoneController.text;

//     // API 요청
//     try {
//       final response = await http.post(
//         Uri.parse('http://34.64.176.207:5000/sendsms'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'phone': phoneNumber}),  // 전화번호를 JSON 형식으로 전송
//       );

//       // 서버 응답 상태 코드에 관계없이 두 번째 필드 보이기
//       setState(() {
//         _isVerificationFieldVisible = true; // 인증번호 입력 필드 표시
//       });

//       // 서버 응답 처리 (선택 사항)
//       if (response.statusCode == 200) {
//         // 추가 로직 (예: 성공 메시지 등) 구현 가능
//       } else {
//         // 에러 처리 (예: 사용자에게 알림)
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('인증 번호 요청 실패')),
//         );
//       }
//     } catch (e) {
//       // 예외 처리 (예: 네트워크 오류)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('네트워크 오류 발생')),
//       );
//     }
//   }

//   Future<void> _confirmVerification() async {
//     final phoneNumber = phoneController.text;
//     final verificationCode = verificationCodeController.text;

//     // 서버에 인증 코드 확인 요청
//     try {
//       final response = await http.post(
//         Uri.parse('http://34.64.176.207:5000/verify'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'phone': phoneNumber, 'code': verificationCode}),  // 전화번호와 인증 코드를 JSON 형식으로 전송
//       );

//       // 서버 응답 상태 코드 처리
//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         // 인증 성공 시 비밀번호 재설정 화면으로 이동
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => AccountInfoScreen(phoneNumber: phoneController.text)),
//         );
//       } else {
//         // 인증 실패 시 사용자에게 알림
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('인증 번호가 일치하지 않습니다.')),
//         );
//       }
//     } catch (e) {
//       // 예외 처리 (예: 네트워크 오류)
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('네트워크 오류 발생')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('비밀번호 찾기'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context); // 뒤로 가기
//           },
//         ),
//       ),
//       body: SingleChildScrollView( // 변경된 부분
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (_isVerificationFieldVisible) ...[
//                 VerificationInputGroup(
//                   controller: verificationCodeController,
//                   onConfirm: _confirmVerification, // 확인 콜백 추가
//                 ),
//                 Padding(padding: const EdgeInsets.only(top: 150)), // 위젯 간격
//               ],
//               PhoneInputGroup(
//                 controller: phoneController,
//                 onChanged: _checkPhoneNumber,
//                 onRequest: _requestVerification, // 요청 메서드 변경
//                 isButtonEnabled: _isButtonEnabled,
//               ),
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
//           '가입에 사용한\n휴대폰 번호를 입력해 주세요',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         SizedBox(height: 10),
//         TextField(
//           controller: controller,
//           keyboardType: TextInputType.phone, // 숫자 키보드 설정
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
//   final VoidCallback onConfirm; // 확인 버튼 콜백

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
//           keyboardType: TextInputType.number, // 숫자 키보드 설정
//           decoration: InputDecoration(
//             border: OutlineInputBorder(),
//             hintText: '인증번호 입력',
//           ),
//         ),
//         SizedBox(height: 20), // 위젯 내부의 간격
//         ElevatedButton(
//           onPressed: onConfirm, // 인증번호 확인 시 콜백 호출
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

// // 계정 정보 및 회원 정보 입력 화면



// class AccountInfoScreen extends StatefulWidget {
//   final String phoneNumber;

//   AccountInfoScreen({required this.phoneNumber});

//   @override
//   _AccountInfoScreenState createState() => _AccountInfoScreenState();
// }

// class _AccountInfoScreenState extends State<AccountInfoScreen> {
//   DateTime? _selectedDate;
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _dobController = TextEditingController(); // 생년월일 컨트롤러 추가

//   @override
//   void initState() {
//     super.initState();
//     // 전화번호 초기화
//     _phoneController.text = widget.phoneNumber;
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
//         _selectedDate = picked; // 선택된 날짜 저장
//         _dobController.text = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"; // 생년월일 필드 업데이트
//       });
//     }
//   }

// // TextEditingController 속성 정의
// final TextEditingController phoneController = TextEditingController();
// final TextEditingController verificationCodeController = TextEditingController();
// final TextEditingController nameController = TextEditingController();
// final TextEditingController loginIdController = TextEditingController();
// final TextEditingController passwordController = TextEditingController();
// final TextEditingController emailController = TextEditingController();
// final TextEditingController birthdateController = TextEditingController();

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('회원가입 정보'),
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: () {
//           Navigator.pop(context); // 뒤로 가기
//         },
//       ),
//     ),
//     body: SingleChildScrollView( // SingleChildScrollView 추가
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
//         children: [
//           Text(
//             '계정 정보',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           TextField(
//             controller: loginIdController, // 수정된 로그인 ID 컨트롤러
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: '아이디',
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: passwordController, // 수정된 비밀번호 컨트롤러
//             obscureText: true,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: '비밀번호',
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: emailController, // 수정된 이메일 컨트롤러
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: '이메일 주소',
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             '회원 정보',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           TextField(
//             controller: nameController, // 수정된 이름 컨트롤러
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: '이름',
//             ),
//           ),
//           SizedBox(height: 10),
//           TextField(
//             controller: phoneController, // 수정된 전화번호 컨트롤러
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: '전화번호',
//             ),
//             enabled: false, // 전화번호 필드 비활성화
//           ),
//           SizedBox(height: 10),
//           GestureDetector(
//             onTap: () => _selectDate(context), // 날짜 선택 시 달력 열기
//             child: AbsorbPointer(
//               child: TextField(
//                 controller: birthdateController, // 수정된 생년월일 컨트롤러
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: '생년월일',
//                   hintText: '생년월일 선택', // 기본 힌트 텍스트
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _registerUser, // 회원가입 로직 추가
//             child: Text('회원가입'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.pink,
//               foregroundColor: Colors.white,
//               minimumSize: Size(double.infinity, 50),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginScreen.dart';

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
      appBar: AppBar(
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isVerificationFieldVisible) ...[
                VerificationInputGroup(
                  controller: verificationCodeController,
                  onConfirm: _confirmVerification,
                ),
                Padding(padding: const EdgeInsets.only(top: 150)),
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
            border: OutlineInputBorder(),
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
            border: OutlineInputBorder(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Text(
              '계정 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: widget.loginIdController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '아이디',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: widget.passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '비밀번호',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget.emailController,
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
              controller: widget.nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이름',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: TextEditingController(text: widget.phoneNumber),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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


class ProfileSettingScreen extends StatelessWidget {
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

  Future<void> _registerUser(BuildContext context) async {
  final phoneNumber = phoneController.text;

  final response = await http.post(
    Uri.parse('http://34.64.176.207:5000/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': nameController.text,
      'phone_num': phoneNumber,
      'login_id': loginIdController.text,
      'pw': passwordController.text,
      'email': emailController.text,
      'birthdate': birthdateController.text,
      'nickname': nicknameController.text, // 닉네임 추가
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
    appBar: AppBar(
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
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 50, color: Colors.grey),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
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
