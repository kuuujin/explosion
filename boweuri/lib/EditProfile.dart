import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfile extends StatefulWidget {
  final String user_id;

  // 컨트롤러 선언
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  EditProfile({required this.user_id});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _dobController = TextEditingController();
  File? _image; // 프로필 이미지 파일
  String? existingBirthdate; // 기존 생년월일을 저장할 변수

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // 사용자 정보를 가져오기
  }

  Future<void> _fetchUserProfile() async {
    final url = 'http://34.64.176.207:5000/users/${widget.user_id}'; // 사용자 정보 가져오기 엔드포인트

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      setState(() {
        widget.nameController.text = userData['name'] ?? '';
        widget.nicknameController.text = userData['nickname'] ?? '';
        widget.phoneController.text = userData['phone_num'] ?? '';
        existingBirthdate = userData['birthdate'] ?? ''; // 기존 생년월일 저장
        _dobController.text = existingBirthdate ?? ''; // 클라이언트에 표시
        widget.emailController.text = userData['email'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보를 불러오는 데 실패했습니다.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 선택한 이미지 파일 경로
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0]; // YYYY-MM-DD 형식
      });
    }
  }

  Future<void> _updateUserProfile() async {
    final url = 'http://34.64.176.207:5000/users/${widget.user_id}'; // 사용자 업데이트 엔드포인트

    // 사용자 정보 준비
    final Map<String, dynamic> userData = {
      'name': widget.nameController.text,
      'nickname': widget.nicknameController.text,
      'phone_num': widget.phoneController.text,
      // 'birthdate': existingBirthdate, // 생년월일은 기존 값을 사용
      'email': widget.emailController.text,
      // 'profile_image': ... // 프로필 이미지를 Base64로 변환하여 추가할 수 있습니다.
    };

    // PUT 요청
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 200) {
      // 성공적으로 업데이트된 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필이 성공적으로 업데이트되었습니다.')),
      );
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 업데이트에 실패했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              '회원 정보',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: widget.nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(), // 상자 형태로 변경
                labelText: '이름',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget.nicknameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(), // 상자 형태로 변경
                labelText: '닉네임',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget.phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(), // 상자 형태로 변경
                labelText: '전화번호',
              ),
              enabled: false, // 전화번호는 수정 불가
            ),
            SizedBox(height: 10),
            AbsorbPointer(
              child: TextField(
                controller: _dobController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(), // 상자 형태로 변경
                  labelText: '생년월일',
                  hintText: '생년월일 선택',
                ),
                enabled: false, // 생년월일은 수정 불가
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: widget.emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(), // 상자 형태로 변경
                labelText: '이메일 주소',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile, // 프로필 업데이트 함수 호출
              child: Text('편집'), // 버튼 텍스트 변경
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
