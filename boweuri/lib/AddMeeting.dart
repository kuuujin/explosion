// import 'package:flutter/material.dart';

// class AddMeeting extends StatelessWidget {
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
//             _buildTextField(Icons.title, '정모 이름'),
//             SizedBox(height: 10,width: 50),
//             _buildTextField(Icons.calendar_today, '12/31 (화)'),
//             SizedBox(height: 10),
//             _buildTextField(Icons.access_time, '오후 5:00'),
//             SizedBox(height: 10),
//             _buildTextField(Icons.location_on, '위치 입력'),
//             SizedBox(height: 10),
//             _buildTextField(Icons.attach_money, '1/n 분담'),
//             SizedBox(height: 10),
//             _buildTextField(Icons.people, '정원(2~20명)'),

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

//   Widget _buildTextField(IconData icon, String hint) {
//     return Row(
//       children: [
//         Icon(icon, size: 30, color: Colors.grey), // 아이콘 추가
//         SizedBox(width: 10), // 아이콘과 텍스트 필드 사이의 간격
//         Expanded(
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: hint,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide(color: Colors.grey),
//               ),
//               filled: true,
//               fillColor: Colors.grey[200], // 배경색
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ----------------------
import 'package:flutter/material.dart';

class AddMeeting extends StatefulWidget {
  @override
  _AddMeetingState createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedPeople;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정모 일정 추가'),
        backgroundColor: Color.fromARGB(255, 252, 36, 90), // 상단 바 색상
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // 배경 사진 등록 박스
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 80,
                    child: Icon(Icons.photo_outlined, size: 40, color: Colors.blue), // 박스 안 아이콘
                  ),
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
            SizedBox(height: 20),

            // 입력 필드
            _buildTextField(Icons.title, '정모 이름' ),
            SizedBox(height: 10),
            _buildDatePickerField(Icons.calendar_today, '12/31 (화)'),
            SizedBox(height: 10),
            _buildTimePickerField(Icons.access_time, '오후 5:00'),
            SizedBox(height: 10),
            _buildTextField(Icons.location_on, '위치 입력'),
            SizedBox(height: 10),
            _buildPeoplePicker(Icons.people, '정원(2~20명)'),
            SizedBox(height: 10),

            // 정모 만들기 버튼
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // 정모 만들기 기능 구현
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 252, 36, 90), // 버튼 색상
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('정모 만들기', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField(IconData icon, String hint ) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.grey), // 아이콘 추가
        SizedBox(width: 30), // 아이콘과 텍스트 필드 사이의 간격
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200], // 배경색
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              textAlign: TextAlign.left, // 텍스트 왼쪽 정렬
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey), // placeholder 색상
                border: InputBorder.none, // 테두리 없애기
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
        SizedBox(width: 370),
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200], // 배경색
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<int>(
              value: selectedPeople,
              hint: Text(hint, style: TextStyle(color: Colors.grey)), // placeholder 색상
              items: List.generate(19, (index) => index + 2).map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.toString(), style: TextStyle(color: Colors.black)), // 선택된 값 색상
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPeople = value;
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none, // 테두리 없애기
              ),
              style: TextStyle(color: selectedPeople != null ? Colors.black : Colors.grey), // 글자 색상
            ),
          ),
        ),
      ],
    );
  }
}