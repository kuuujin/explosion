import 'package:flutter/material.dart';

class EditScore extends StatefulWidget {
  final String user_id;

  EditScore({required this.user_id});

  @override
  _EditScoreState createState() => _EditScoreState();
}

class _EditScoreState extends State<EditScore> {
  DateTime selectedDate = DateTime.now();
  int selectedGameNumber = 1;
  List<List<String>> frames = List.generate(10, (index) => ["", "", ""]);
  int currentFrame = 0;
  bool isFirstRoll = true;
  int firstRollScore = 0;
  bool isThirdRollAllowed = false;
  bool isGameFinished = false;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _onButtonPressed(int value) {
    if (isGameFinished) {
      _showSnackbar("해당 게임 점수 기록은 끝났습니다.");
      return;
    }

    setState(() {
      if (isFirstRoll) {
        frames[currentFrame][0] = value == 10 ? "X" : value.toString();
        firstRollScore = value; // 첫 번째 투구 점수 저장
        if (value < 10) {
          isFirstRoll = false; // 두 번째 롤로 전환
        } else {
          if (currentFrame < 9) {
            currentFrame++; // 다음 프레임으로 전환
          }
        }
      } else {
        int secondRollScore = value;
        if (firstRollScore + secondRollScore > 10) return;

        frames[currentFrame][1] = (firstRollScore + secondRollScore == 10) ? "/" : secondRollScore.toString();

        // 10프레임에서 세 번째 투구를 허용할지 결정
        if (currentFrame == 9) {
          isThirdRollAllowed = (firstRollScore == 10 || secondRollScore == 10);
        }

        currentFrame++; // 다음 프레임으로 전환
        isFirstRoll = true; // 다음에는 첫 번째 롤로 돌아가기
        firstRollScore = 0; // 첫 번째 투구 점수 초기화
      }

      // 10프레임에서 세 번째 투구 처리
      if (currentFrame == 10) {
        if (isThirdRollAllowed) {
          isGameFinished = false; // 세 번째 투구를 받을 수 있는 상태
        } else {
          isGameFinished = true; // 세 번째 투구를 받을 수 없는 경우 게임 종료
          _showSnackbar("해당 게임 점수 기록은 끝났습니다.");
        }
      }
    });
  }

  void _onThirdRollPressed(int value) {
    if (isThirdRollAllowed) {
      frames[9][2] = value.toString(); // 10프레임에 세 번째 투구 점수 기록
      isThirdRollAllowed = false; // 세 번째 투구 허용 상태를 변경
      isGameFinished = true; // 게임 종료
      _showSnackbar("해당 게임 점수 기록은 끝났습니다.");
      setState(() {}); // 화면 업데이트
    }
  }

  void _backspace() {
    setState(() {
      if (currentFrame > 0) {
        if (!isFirstRoll && frames[currentFrame][1] != "") {
          frames[currentFrame][1] = ""; // 두 번째 롤 비우기
          isFirstRoll = true; // 첫 번째 롤로 돌아감
        } else if (frames[currentFrame][0] != "") {
          frames[currentFrame][0] = ""; // 첫 번째 롤 비우기
          isFirstRoll = true; // 첫 번째 롤로 돌아감
        } else {
          // 현재 프레임이 비어있다면 이전 프레임으로 이동
          currentFrame--;
          frames[currentFrame][1] = ""; // 이전 프레임의 두 번째 롤 비우기
          isFirstRoll = false; // 두 번째 롤로 전환
        }
      }
    });
  }

  void _refreshScores() {
    setState(() {
      frames = List.generate(10, (index) => ["", "", ""]); // 모든 프레임 점수 초기화
      currentFrame = 0; // 현재 프레임 초기화
      isFirstRoll = true; // 첫 번째 롤로 초기화
      firstRollScore = 0; // 첫 번째 투구 점수 초기화
      isThirdRollAllowed = false; // 세 번째 투구 허용 상태 초기화
      isGameFinished = false; // 게임 종료 상태 초기화
    });
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
        selectedDate = picked;
      });
    }
  }

  List<int> _getAvailableScores() {
    if (isFirstRoll) {
      return List.generate(11, (index) => index);
    } else {
      return List.generate(11 - firstRollScore, (index) => index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 날짜 선택기와 드롭다운 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      width: MediaQuery.of(context).size.width * (1 / 3),
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.calendar_today),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16.0),
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
                      Text('번째 게임', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              // 점수 입력 필드
              Text('메모를 입력해주세요 (50자)', style: TextStyle(fontSize: 14)),
              TextField(
                maxLength: 50,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '메모 입력',
                ),
              ),
              SizedBox(height: 30),

              // 점수 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _getAvailableScores().map((score) {
                  return _buildButton(score);
                }).toList(),
              ),

              // 세 번째 투구 버튼 (10프레임에서만)
              if (currentFrame == 9 && isThirdRollAllowed) // 세 번째 투구 점수가 허용된 경우
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(11, (index) {
                    return _buildButton(index, isThirdRoll: true);
                  }),
                ),

              SizedBox(height: 20),

              // 백스페이스 버튼 (아이콘으로 대체)
              ElevatedButton(
                onPressed: _backspace,
                child: Icon(Icons.backspace, size: 24),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  side: BorderSide(color: Colors.red, width: 1),
                ),
              ),

              // 리프레시 버튼 (아이콘으로 대체)
              ElevatedButton(
                onPressed: _refreshScores,
                child: Icon(Icons.refresh, size: 24),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),

              SizedBox(height: 50),

              // 기록 테이블
              buildScoreFrames(),

              SizedBox(height: 50),

              // 점수 기록하기 버튼
              ElevatedButton(
                onPressed: () {
                  // '점수 기록하기' 버튼 클릭 시 처리
                },
                child: Text('점수 기록하기'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink,
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

  Widget _buildButton(int value, {bool isThirdRoll = false}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 252, 36, 90)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (isThirdRoll) {
              _onThirdRollPressed(value);
            } else {
              _onButtonPressed(value);
            }
          },
          child: value == 10 
              ? Text('X', style: TextStyle(fontSize: 14)) // 스트라이크
              : Text(value.toString(), style: TextStyle(fontSize: 14)), // 점수
          style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 252, 36, 90),
            backgroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            elevation: 0,
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
      child: Column(
        children: [
          // 프레임 숫자를 감싸는 큰 직사각형
          Container(
            width: frameNumber == 10 ? 90 : 60,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFFBBBB9D),
              border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: isLast ? Colors.black : Colors.transparent),
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
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
              color: Color(0xFFFAFAD2),
              border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: isLast ? Colors.black : Colors.transparent),
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            child: Stack(
              children: [
                // 첫 번째 투구 점수
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Text(
                        frames[frameNumber - 1][0], // 첫 번째 투구 점수
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // 두 번째 투구 점수
                Positioned(
                  top: 0,
                  left: 30,
                  child: Container(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Text(
                        frames[frameNumber - 1][1], // 두 번째 투구 점수
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                // 세 번째 투구 점수 (10프레임에서만)
                if (frameNumber == 10)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      child: Center(
                        child: Text(
                          frames[frameNumber - 1][2], // 세 번째 투구 점수
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

