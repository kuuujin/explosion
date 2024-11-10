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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 표시 및 선택
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
            SizedBox(height: 16), // 날짜와 게임 숫자 사이의 간격

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 16.0), // 날짜 선택기와의 간격
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
                SizedBox(width: 8), // 콤보 박스와 텍스트 사이의 간격
                Text(
                  '번째 게임',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16), // 공백 추가

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
            SizedBox(height: 16),

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
          
            SizedBox(height: 16), // 간격 추가

            // 기록 테이블
            Expanded(
              child: Column(
                children: [
                  // 상단 기록 테이블
                  buildScoreTable([1, 2, 3, 4, 5]),
                  SizedBox(height: 8),
                  buildScoreTable([6, 7, 8, 9, 10]),
                ],
              ),
            ),

            // 총점 및 카운트 표시
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('총점', style: TextStyle(fontSize: 16)),
            //       Text('카운트', style: TextStyle(fontSize: 16)),
            //     ],
            //   ),
            // ),

            // 버튼
            ElevatedButton(
              onPressed: () {
                // '점수 기록하기' 버튼 클릭 시 처리
              },
              child: Text('점수 기록하기'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink, // 버튼 색상
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 12),
                fixedSize: Size(900, 40)
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 버튼 생성 메소드
  Widget _buildButton(int value, {bool isBackspace = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 252, 36, 90)), // 테두리 색상
        borderRadius: BorderRadius.circular(8), // 둥근 모서리
      ),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(value),
        child: isBackspace 
            ? Icon(Icons.arrow_back_ios) 
            : (value == 10 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('1'), // 1
                      Text('0'), // 0
                    ],
                  )
                : Text(value.toString(), style: TextStyle(fontSize: 14))),
        style: ElevatedButton.styleFrom(
          foregroundColor: Color.fromARGB(255, 252, 36, 90),
          backgroundColor: Colors.white, // 버튼 색상
          fixedSize: Size(10, 50), // 버튼 크기
          elevation: 0, // 그림자 없애기
        ),
      ),
    );
  }

  Widget buildScoreTable(List<int> scores) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: scores.map((score) {
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
            color: Colors.yellow[100], // 배경 색상
          ),
          child: Text(
            score.toString(),
            style: TextStyle(fontSize: 18),
          ),
        );
      }).toList(),
    );
  }
}
