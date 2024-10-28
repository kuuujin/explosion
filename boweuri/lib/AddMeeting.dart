// import 'package:flutter/material.dart';

// class AddMeeting extends StatefulWidget {
//   @override
//   _AddMeetingState createState() => _AddMeetingState();
// }

// class _AddMeetingState extends State<AddMeeting> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//   int? selectedPeople;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('정모 일정 추가'),
//         backgroundColor: Color.fromARGB(255, 252, 36, 90), // 상단 바 색상
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),

//             // 배경 사진 등록 박스
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Positioned(
//                     top: 80,
//                     child: Icon(Icons.photo_outlined, size: 40, color: Colors.blue), // 박스 안 아이콘
//                   ),
//                   Positioned(
//                     bottom: 50,
//                     child: Text(
//                       '배경사진을 등록해주세요',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),

//             // 입력 필드
//             _buildTextField(Icons.title, '정모 이름' ),
//             SizedBox(height: 10),
//             _buildDatePickerField(Icons.calendar_today, '12/31 (화)'),
//             SizedBox(height: 10),
//             _buildTimePickerField(Icons.access_time, '오후 5:00'),
//             SizedBox(height: 10),
//             _buildTextField(Icons.location_on, '위치 입력'),
//             SizedBox(height: 10),
//             _buildPeoplePicker(Icons.people, '정원(2~20명)'),
//             SizedBox(height: 10),

//             // 정모 만들기 버튼
//             Spacer(),
//             ElevatedButton(
//               onPressed: () {
//                 // 정모 만들기 기능 구현
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color.fromARGB(255, 252, 36, 90), // 버튼 색상
//                 padding: EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//               child: Text('정모 만들기', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildTextField(IconData icon, String hint ) {
//     return Row(
//       children: [
//         Icon(icon, size: 30, color: Colors.grey), // 아이콘 추가
//         SizedBox(width: 30), // 아이콘과 텍스트 필드 사이의 간격
//         Expanded(
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white10),
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey[200], // 배경색
//             ),
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: TextField(
//               textAlign: TextAlign.left, // 텍스트 왼쪽 정렬
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: TextStyle(color: Colors.grey), // placeholder 색상
//                 border: InputBorder.none, // 테두리 없애기
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

// Widget _buildDatePickerField(IconData icon, String hint) {
//     return Row(
//       children: [
//         Icon(icon, size: 30, color: Colors.grey),
//         SizedBox(width: 30),
//         Expanded(
//           child: GestureDetector(
//             onTap: () async {
//               DateTime? date = await showDatePicker(
//                 context: context,
//                 initialDate: selectedDate ?? DateTime.now(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(2101),
//               );
//               if (date != null && date != selectedDate) {
//                 setState(() {
//                   selectedDate = date;
//                 });
//               }
//             },
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white10),
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey[200],
//               ),
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 selectedDate != null
//                     ? "${selectedDate!.month}/${selectedDate!.day} (${_getWeekdayString(selectedDate!.weekday)})"
//                     : hint,
//                 style: TextStyle(color: selectedDate != null ? Colors.black : Colors.grey),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   String _getWeekdayString(int weekday) {
//     switch (weekday) {
//       case 1:
//         return '월';
//       case 2:
//         return '화';
//       case 3:
//         return '수';
//       case 4:
//         return '목';
//       case 5:
//         return '금';
//       case 6:
//         return '토';
//       case 7:
//         return '일';
//       default:
//         return '';
//     }
//   }

//   Widget _buildTimePickerField(IconData icon, String hint) {
//     return Row(
//       children: [
//         Icon(icon, size: 30, color: Colors.grey),
//         SizedBox(width: 30),
//         Expanded(
//           child: GestureDetector(
//             onTap: () async {
//               TimeOfDay? time = await showTimePicker(
//                 context: context,
//                 initialTime: selectedTime ?? TimeOfDay.now(),
//               );
//               if (time != null && time != selectedTime) {
//                 setState(() {
//                   selectedTime = time;
//                 });
//               }
//             },
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.white10),
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.grey[200],
//               ),
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 selectedTime != null ? "${selectedTime!.hour}:${selectedTime!.minute}" : hint,
//                 style: TextStyle(color: selectedTime != null ? Colors.black : Colors.grey),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//    Widget _buildPeoplePicker(IconData icon, String hint) {
//     return Row(
//       children: [
//         Icon(icon, size: 30, color: Colors.grey),
//         SizedBox(width: 370),
//         Expanded(
//           child: Container(
//             height: 50,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white10),
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey[200], // 배경색
//             ),
//             alignment: Alignment.centerLeft,
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: DropdownButtonFormField<int>(
//               value: selectedPeople,
//               hint: Text(hint, style: TextStyle(color: Colors.grey)), // placeholder 색상
//               items: List.generate(19, (index) => index + 2).map((value) {
//                 return DropdownMenuItem(
//                   value: value,
//                   child: Text(value.toString(), style: TextStyle(color: Colors.black)), // 선택된 값 색상
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedPeople = value;
//                 });
//               },
//               decoration: InputDecoration(
//                 border: InputBorder.none, // 테두리 없애기
//               ),
//               style: TextStyle(color: selectedPeople != null ? Colors.black : Colors.grey), // 글자 색상
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert'; // JSON 처리를 위한 패키지
import 'dart:io'; // 파일 처리 위한 패키지
import 'package:flutter/material.dart'; // Flutter 관련 패키지
import 'package:image_picker/image_picker.dart'; // 이미지 선택 패키지
//import 'package:path/path.dart'; // 경로 처리 패키지
import 'package:http/http.dart' as http; 


class AddMeeting extends StatefulWidget {
  @override
  _AddMeetingState createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedPeople;
  XFile? _image;
  String title ='';
  String place = '';
  String pay = '';

  final ImagePicker _picker = ImagePicker(); // ImagePicker 인스턴스 생성

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile; // 선택한 이미지 파일 저장
      });
    }
  }

  Future<void> _submitMeeting() async {
  if (_image == null || selectedDate == null || selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('모든 필드를 입력해주세요.')),
    );
    return;
  }

  // 이미지 파일 읽기
  final bytes = await File(_image!.path).readAsBytes();
  String base64Image = base64Encode(bytes); // Base64로 인코딩

  // JSON 데이터 생성
  Map<String, dynamic> data = {
    'title': title, // TextField에서 입력 받은 값으로 변경
    'date': '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
    'time': '${selectedTime!.hour}:${selectedTime!.minute}',
    'place': place, // TextField에서 입력 받은 값으로 변경
    'join_cnt': selectedPeople.toString(),
    'images': base64Image, // Base64 인코딩된 이미지
  };

  // JSON을 서버로 전송
  var response = await http.post(
    Uri.parse('http://34.64.176.207:5000/meeting/create'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(data), // JSON 형식으로 변환
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('정모가 추가되었습니다.')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('정모 추가 실패: ${response.statusCode}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정모 일정 추가'),
        backgroundColor: Color.fromARGB(255, 252, 36, 90),
        foregroundColor: Colors.white, // 상단 바 색상
      ),
      body: SingleChildScrollView( // 여기에서 SingleChildScrollView 추가
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),

            // 배경 사진 등록 박스
            GestureDetector(
              onTap: _pickImage, // 박스를 클릭하면 이미지 선택
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(File(_image!.path)), // 선택한 이미지 표시
                          fit: BoxFit.cover,
                        )
                      : null, // 이미지가 없으면 배경 없음
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_image == null) // 이미지가 없을 때만 아이콘과 텍스트 표시
                      Positioned(
                        top: 80,
                        child: Icon(Icons.photo_outlined, size: 40, color: Colors.blue),
                      ),
                    if (_image == null)
                      Positioned(
                        bottom: 50,
                        child: Text(
                          '배경사진을 등록해주세요',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),

            // 입력 필드
            _buildTextField(Icons.title, '정모 이름', (value) {
              setState(() {
                title = value; // 사용자 입력 업데이트
              });
            }),
            SizedBox(height: 30),
            _buildDatePickerField(Icons.calendar_today, '12/31 (화)'),
            SizedBox(height: 30),
            _buildTimePickerField(Icons.access_time, '오후 5:00'),
            SizedBox(height: 30),
            _buildTextField(Icons.location_on, '위치 입력', (value) {
              setState(() {
                place = value; // 사용자 입력 업데이트
              });
            }),
            SizedBox(height: 30),
            _buildTextField(Icons.attach_money, '비용 입력', (value) {
              setState(() {
                pay = value; // 사용자 입력 업데이트
              });
            }),
            SizedBox(height: 30),
            _buildPeoplePicker(Icons.people, '정원(2~20명)'),
            SizedBox(height: 30),

            // 정모 만들기 버튼
            SizedBox(height: 20), // 버튼 위 여백 추가
            ElevatedButton(
              onPressed: () {
                _submitMeeting;
              },
              child: Text('정모 일정 추가'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 252, 36, 90), // 버튼 색상
                foregroundColor: Colors.white,
                fixedSize: Size(500, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, Function(String) onChanged) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.grey),
        SizedBox(width: 30),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              onChanged: onChanged, // 입력이 변경될 때 호출
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(IconData icon, String hint) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.grey),
        SizedBox(width: 30),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (date != null && date != selectedDate) {
                setState(() {
                  selectedDate = date;
                });
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedDate != null
                    ? "${selectedDate!.month}/${selectedDate!.day} (${_getWeekdayString(selectedDate!.weekday)})"
                    : hint,
                style: TextStyle(color: selectedDate != null ? Colors.black : Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return '';
    }
  }

  Widget _buildTimePickerField(IconData icon, String hint) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.grey),
        SizedBox(width: 30),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
              );
              if (time != null && time != selectedTime) {
                setState(() {
                  selectedTime = time;
                });
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedTime != null ? "${selectedTime!.hour}:${selectedTime!.minute}" : hint,
                style: TextStyle(color: selectedTime != null ? Colors.black : Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeoplePicker(IconData icon, String hint) {
  return Row(
    children: [
      Icon(icon, size: 30, color: Colors.grey),
      SizedBox(width: 30), // 아이콘과 텍스트 사이의 간격
      Text(
        hint, // '정원(2~20명)' 텍스트
        style: TextStyle(color: Colors.black),
      ),
      SizedBox(width: 100), // 텍스트와 드롭다운 사이의 간격
      Expanded(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonFormField<int>(
            value: selectedPeople,
            hint: Text(hint, style: TextStyle(color: Colors.grey)),
            items: List.generate(19, (index) => index + 2).map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value.toString(), style: TextStyle(color: Colors.black)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedPeople = value;
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: TextStyle(color: selectedPeople != null ? Colors.black : Colors.grey),
          ),
        ),
      ),
    ],
  );
}
}
