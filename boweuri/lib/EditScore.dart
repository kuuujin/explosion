import 'package:flutter/material.dart';

class EditScore extends StatefulWidget {
  final String user_id;

  EditScore({required this.user_id});

  @override
  _EditScoreState createState() => _EditScoreState();
}

class _EditScoreState extends State<EditScore> {
  DateTime selectedDate = DateTime.now(); // 기본 날짜를 오늘로 설정
  int selectedGameNumber = 1; // 기본 게임 숫자 설정

  // 버튼 클릭 시 처리할 함수
  void _onButtonPressed(int value) {
    // 여기에 버튼 클릭 시 처리할 로직 추가
    print("Button $value pressed");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // 선택된 날짜로 업데이트
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SingleChildScrollView( // SingleChildScrollView 추가
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 선택기와 드롭다운 버튼을 같은 줄에 배치
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝 정렬
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context), // 날짜 선택기 열기
                  child: Container(
                    width: MediaQuery.of(context).size.width * (1 / 3), // 너비를 화면의 1/3로 설정
                    padding: EdgeInsets.symmetric(vertical: 12.0), // 세로 패딩
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0], // YYYY-MM-DD 형식으로 표시
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.calendar_today), // 달력 아이콘
                      ],
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.0), // Underline 스타일
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16), // 드롭다운 버튼과 텍스트 사이의 간격
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16.0), // 드롭다운 버튼과의 간격
                      child: DropdownButton<int>(
                        value: selectedGameNumber,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedGameNumber = newValue!;
                          });
                        },
                        items: List.generate(30, (index) => index + 1).map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '번째 게임',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16), // 날짜와 게임 숫자 사이의 간격

            SizedBox(height: 16),
            // 점수 입력 필드
            Text(
              '메모를 입력해주세요 (50자)',
              style: TextStyle(fontSize: 14),
            ),
            TextField(
              maxLength: 50,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '메모 입력',
              ),
            ),
            SizedBox(height: 30),

            // 0~5 버튼 (위쪽)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return _buildButton(index);
              }),
            ),
            SizedBox(height: 8),

            // 6~10 버튼 및 백스페이스 버튼 (아래쪽)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return _buildButton(index + 6);
              })..add(
                _buildButton(-1, isBackspace: true), // 백스페이스 버튼
              ),
            ),
          
            SizedBox(height: 50), // 간격 추가

            // 기록 테이블
            buildScoreFrames(),


            SizedBox(height: 50),


            // 버튼
            ElevatedButton(
              onPressed: () {
                // '점수 기록하기' 버튼 클릭 시 처리
              },
              child: Text('점수 기록하기'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink, // 버튼 색상
                fixedSize: Size(500, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  // 버튼 생성 메소드
 Widget _buildButton(int value, {bool isBackspace = false}) {
  return Expanded( // 버튼을 Expanded로 감싸기
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0), // 버튼 간의 수평 간격 추가
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 252, 36, 90)), // 테두리 색상
        borderRadius: BorderRadius.circular(8), // 둥근 모서리
      ),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(value),
        child: isBackspace 
            ? Icon(Icons.arrow_back_ios) 
            : (value == 10 
                ? Text('10', style: TextStyle(fontSize: 14)) // '10'으로 수정
                : Text(value.toString(), style: TextStyle(fontSize: 14))),
        style: ElevatedButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 252, 36, 90),
          backgroundColor: Colors.white, // 버튼 색상
          padding: EdgeInsets.symmetric(vertical: 10), // 버튼의 패딩 조정
          elevation: 0, // 그림자 없애기
        ),
      ),
    ),
  );
}


  Widget buildScoreFrames() {
    return Column(
      children: [
        // 첫 번째 줄: 1~6번째 프레임
        Row(
           mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
             return _buildFrame(index + 1, isLast: index == 4);
          }),
        ),
        SizedBox(height: 50), // 두 줄 사이의 간격
        // 두 번째 줄: 7~10번째 프레임
        Row(
           mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            return _buildFrame(index + 6, isLast: index == 4);
          }),
        ),
      ],
    );
  }

  // 각 프레임을 생성하는 메소드
   Widget _buildFrame(int frameNumber, {bool isLast = false}) {
    return Container(
      // margin을 제거하여 프레임 간 간격 없애기
      child: Column(
        children: [
          // 프레임 숫자를 감싸는 큰 직사각형
          Container(
            width: frameNumber == 10 ? 90 : 60,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFFBBBB9D), // 지정된 색상
              border: Border(
                left: BorderSide(color: Colors.black), // 왼쪽 테두리
                right: BorderSide(color: isLast ? Colors.black : Colors.transparent), // 오른쪽 테두리
                top: BorderSide(color: Colors.black), // 상단 테두리
                bottom: BorderSide(color: Colors.black), // 하단 테두리
              ),
            ),
            child: Center(
              child: Text(
                frameNumber.toString(),
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // 큰 정사각형
          Container(
            width: frameNumber == 10 ? 90 : 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFFFAFAD2), // 지정된 색상
              border: Border(
                        left: BorderSide(color: Colors.black), // 왼쪽 테두리
                        right: BorderSide(color: isLast ? Colors.black : Colors.transparent), // 오른쪽 테두리
                        bottom: BorderSide(color: Colors.black), // 하단 테두리
                        top: BorderSide(color: Colors.transparent),
                        ) // 검은색 테두리
            ),
            child: Stack(
              children: [
                // 10번 프레임일 경우 작은 정사각형 두 개 추가
                if (frameNumber == 10) ...[
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAD2),
                        border: Border(
                          left: BorderSide(color: Colors.black), // 왼쪽 테두리
                          right: BorderSide(color: Colors.transparent), // 오른쪽 테두리
                          bottom: BorderSide(color: Colors.black), // 하단 테두리
                          top: BorderSide(color: Colors.transparent), // 상단 테두리 제거
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0, // 두 번째 작은 정사각형 위치 조정
                    right: 30,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAD2),
                        border: Border(
                          left: BorderSide(color: Colors.black), // 왼쪽 테두리
                          right: BorderSide(color: Colors.transparent), // 오른쪽 테두리
                          bottom: BorderSide(color: Colors.black), // 하단 테두리
                          top: BorderSide(color: Colors.transparent), // 상단 테두리 제거
                        ),
                      ),
                    ),
                  ),
                ],
                // 10번 프레임이 아닐 경우는 기존 작은 정사각형
                if (frameNumber != 10) ...[
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAD2),
                        border: Border(
                          left: BorderSide(color: Colors.black), // 왼쪽 테두리
                          right: BorderSide(color: Colors.transparent), // 오른쪽 테두리
                          bottom: BorderSide(color: Colors.black), // 하단 테두리
                          top: BorderSide(color: Colors.transparent), // 상단 테두리 제거
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}