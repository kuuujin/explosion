import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> saveGameData(int userId, DateTime gameDate, int gameNum, int totalScore, String memo, double pay, List<Map<String, dynamic>> frameDetails) async {
  // 서버 API URL
  final String apiUrl = 'http://34.64.176.207:5000/saveGame'; // 실제 API URL로 변경하세요.

  // 게임 데이터
  final gameData = {
    'user_id': userId,
    'game_date': gameDate.toIso8601String().split('T').first, // YYYY-MM-DD 형식
    'game_num': gameNum, // 게임 번호
    'total_score': totalScore,
    'memo': memo, // 메모
    'pay': pay, // 손익
  };

  // 게임 저장 요청
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(gameData),
  );

  if (response.statusCode == 200) {
    // 게임이 성공적으로 저장됨
    final responseData = json.decode(response.body);
    int gameId = responseData['game_id']; // 저장된 게임 ID 가져오기

    // 게임 세부 정보 저장 요청
    await saveGameDetails(gameId, frameDetails);
  } else {
    // 에러 처리
    throw Exception('게임 저장 실패: ${response.body}');
  }
}

Future<void> saveGameDetails(int gameId, List<Map<String, dynamic>> frameDetails) async {
  final String apiUrl = 'http://34.64.176.207:5000/saveGameDetails';

  // 모든 프레임 정보를 묶기
  List<Map<String, dynamic>> detailsToSend = frameDetails.map((detail) {
    String status;
    if (detail['first_ball'] == 10) {
      status = 'strike';
    } else if (detail['first_ball'] + (detail['second_ball'] ?? 0) == 10) {
      status = 'spare';
    } else {
      status = 'open';
    }

    return {
      'frame_num': detail['frame_num'],
      'first_ball': detail['first_ball'],
      'second_ball': detail['second_ball'] ?? 0,
      'bonus': detail['bonus'],
      'status': status,
    };
  }).toList();

  // 서버에 한 번의 요청으로 모든 프레임 정보 보내기
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'game_id': gameId, 'details': detailsToSend}),
  );

  if (response.statusCode != 200) {
    throw Exception('게임 세부 정보 저장 실패: ${response.body}');
  }
}

class EditScore extends StatefulWidget {
  final String user_id;

  EditScore({required this.user_id});

  @override
  _EditScoreState createState() => _EditScoreState();
}

class _EditScoreState extends State<EditScore> {
  List<int> frameScores = List.filled(10, 0);
  List<int> existScores = List.filled(10, 0);
  DateTime selectedDate = DateTime.now();
  int selectedGameNumber = 1;
  List<List<String>> frames = List.generate(10, (index) => ["", "", ""]);
  int currentFrame = 0;
  bool isFirstRoll = true;
  int firstRollScore = 0;
  int secondRollScore = 0;
  int thirdRollScore = 0;
  bool isSecondRoll = false;
  bool isThirdRollAllowed = false;
  bool isGameFinished = false;
  String memo = '';
  double pay = 0.0;

  void _showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('리셋'),
          content: Text('해당 게임 기록을 리셋하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _refreshScores(); // 점수 리프레시 실행
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  int _calculateScore() {
    int totalScore = 0; // 전체 점수 초기화

    for (int frameIndex = 0; frameIndex < 10; frameIndex++) {
      int firstRoll = _getScoreForRoll(frameIndex, 0);
      int secondRoll = _getScoreForRoll(frameIndex, 1);
      int frameScore = 0; // 각 프레임의 점수 초기화

      // 10번째 프레임이 아닐 경우
      if (frameIndex < 9) {
        // 스트라이크 처리
        if (firstRoll == 10) {
          // 스트라이크
          frameScore = 10; // 기본 점수 10점
          frameScore +=
              _getScoreForRoll(frameIndex + 1, 0); // 다음 프레임 첫 번째 투구 점수
          frameScore +=
              _getScoreForRoll(frameIndex + 1, 1); // 다음 프레임 두 번째 투구 점수

          // 다음 프레임이 스트라이크인 경우
          if (_getScoreForRoll(frameIndex + 1, 0) == 10) {
            frameScore +=
                _getScoreForRoll(frameIndex + 2, 0); // 다음 다음 프레임 첫 번째 투구 점수 추가
          }
        }
        // 스페어 처리
        else if (firstRoll + secondRoll == 10) {
          // 스페어
          frameScore = 10; // 기본 점수
          frameScore +=
              _getScoreForRoll(frameIndex + 1, 0); // 다음 프레임 첫 번째 투구 점수
        }
        // 일반 점수 처리
        else {
          frameScore = firstRoll + secondRoll; // 일반 점수
        }
      } else {
        // 10번째 프레임 처리
        int thirdRoll = _getScoreForRoll(frameIndex, 2); // 세 번째 투구 점수
        frameScore = firstRoll + secondRoll + thirdRoll; // 10번째 프레임의 총 점수
      }

      totalScore += frameScore; // 전체 점수에 더하기

      // 각 프레임 점수 출력
      frameScores[frameIndex] = frameScore;

      print("프레임 ${frameIndex + 1} 점수: $frameScore");
    }
    existScores[0] > 0 ? totalScore += existScores[0] : totalScore;
    print("리스트 내용${frames}");
    print("totalScore값은${totalScore}");

    return totalScore; // 최종 점수 반환
  }

// 주어진 프레임과 투구 인덱스에 따라 점수를 반환하는 헬퍼 메서드
  int _getScoreForRoll(int frameIndex, int rollIndex) {
    if (frameIndex < 10) {
      String score = frames[frameIndex][rollIndex];
      if (score == 'X') {
        return 10; // 스트라이크
      } else if (score == '/') {
        return 10 - _getScoreForRoll(frameIndex, 0); // 스페어는 첫 번째 투구 점수로 계산
      } else if (score.isNotEmpty) {
        return int.parse(score); // 점수 반환
      }
    }
    return 0; // 잘못된 인덱스거나 점수가 없을 경우
  }

  void _onButtonPressed(int value) {
    if (isGameFinished) {
      _showSnackbar("해당 게임 점수 기록은 끝났습니다.");
      return;
    }

    setState(() {
      // 현재 프레임의 점수를 기록
      if (currentFrame < 9) {
        if (isFirstRoll) {
          // 첫 번째 투구
          frames[currentFrame][0] = value == 10 ? 'X' : value.toString();
          firstRollScore = value;

          // 스트라이크인 경우
          if (value == 10) {
            isFirstRoll = true; // 다음 프레임으로 넘어갈 준비
            currentFrame++;
            return;
          } else {
            isFirstRoll = false; // 두 번째 투구로 넘어감
          }
        } else {
          // 두 번째 투구
          frames[currentFrame][1] = value.toString();
          int totalPins = firstRollScore + value; // 두 투구의 총 점수 계산

          // 스페어인 경우
          if (totalPins == 10) {
            frames[currentFrame][1] = '/'; // 두 번째 투구에 '/' 입력
            isThirdRollAllowed = true; // 추가 투구 허용
          }

          // 다음 프레임으로 넘어감
          isFirstRoll = true;
          currentFrame++;
        }
      } else if (currentFrame == 9) {
        // 10번째 프레임 처리
        if (isFirstRoll) {
          // 첫 번째 투구
          frames[9][0] = value == 10 ? 'X' : value.toString();
          firstRollScore = value;
          isSecondRoll = true; // 두 번째 투구로 넘어감
          isFirstRoll = false; // 첫 번째 투구가 끝났으므로 isFirstRoll을 false로 설정
        } else if (isSecondRoll) {
          // 두 번째 투구
          frames[9][1] = value == 10 ? 'X' : value.toString();
          secondRollScore = value;
          int totalPins = firstRollScore + secondRollScore;

          // 첫 번째 투구가 스트라이크인 경우
          if (firstRollScore == 10) {
            if (secondRollScore == 10) {
              frames[9][1] = 'X'; // 두 번째 투구가 스트라이크
              isSecondRoll = false;
              isThirdRollAllowed = true; // 세 번째 투구 허용
            } else if (secondRollScore != 10) {
              isSecondRoll = false;
              isThirdRollAllowed = true; // 세 번째 투구 허용
            } else {
              isGameFinished = true; // 게임 종료
            }
          } else {
            // 첫 번째 투구가 스트라이크가 아닌 경우
            if (totalPins == 10) {
              frames[9][1] = '/';
              isSecondRoll = false;
              isThirdRollAllowed = true; // 세 번째 투구 허용
            } else {
              isGameFinished = true; // 스페어가 아닌 경우 게임 종료
            }
          }
        } else if (isThirdRollAllowed) {
          // 세 번째 투구 입력
          frames[9][2] =
              value == 10 ? 'X' : value.toString(); // 10번째 프레임의 세 번째 투구를 명확히 입력
          thirdRollScore = value;
          int totalPins = secondRollScore + thirdRollScore;

          if (frames[9][0] == 'X' && totalPins == 10) {
            print('asss');
            existScores[0] = value;
            print(existScores[0]);
            frames[9][2] = '/';
          }
          isGameFinished = true; // 세 번째 투구 후 게임 종료
        }
      }

      // 게임 종료 처리
      if (currentFrame >= 10) {
        isGameFinished = true; // 마지막 프레임이므로 게임 종료
      }

      // 게임이 종료된 후 총점 계산 및 출력
      if (isGameFinished) {
        int finalScore = _calculateScore();
        print("최종 점수: $finalScore"); // 총점 출력
      }
    });
  }

  List<int> _getAvailableScores() {
    if (currentFrame < 9) {
      // 1~9 프레임
      if (isFirstRoll) {
        return List.generate(11, (index) => index); // 0~10 점수 선택
      } else {
        return List.generate(11 - firstRollScore, (index) => index); // 남은 점수
      }
    } else {
      // 10번째 프레임
      if (isFirstRoll) {
        // 첫 번째 투구
        return List.generate(11, (index) => index); // 0~10 점수 선택
      } else if (isSecondRoll) {
        // 두 번째 투구
        if (firstRollScore == 10) {
          // 첫 번째 투구가 스트라이크인 경우
          return List.generate(11, (index) => index); // 두 번째 투구는 0~10 선택 가능
        } else {
          // 첫 번째 투구가 스트라이크가 아닐 경우
          return List.generate(11 - firstRollScore, (index) => index); // 남은 점수
        }
      } // 세 번째 투구 처리
      if (isThirdRollAllowed) {
        if (secondRollScore == 10) {
          return List.generate(11, (index) => index);
        } else if (firstRollScore + secondRollScore == 10) {
          return List.generate(11, (index) => index);
        } else {
          return List.generate(11 - secondRollScore, (index) => index);
        }
      }
    }
    return []; // 기본적으로 빈 리스트 반환
  }

  void _backspace() {
    setState(() {
      if (currentFrame > 0) {
        if (currentFrame == 9 && isThirdRollAllowed) {
          frames[9][2] = ""; // 세 번째 롤 비우기
          isThirdRollAllowed = false; // 세 번째 롤 허용 상태 변경
          return; // 더 이상 진행하지 않음
        }
        if (!isFirstRoll && frames[currentFrame][1] != "") {
          frames[currentFrame][1] = ""; // 두 번째 롤 비우기
          isFirstRoll = true; // 첫 번째 롤로 돌아감
        } else if (frames[currentFrame][0] != "") {
          frames[currentFrame][0] = ""; // 첫 번째 롤 비우기
          isFirstRoll = true; // 첫 번째 롤로 돌아감
        } else {
          currentFrame--; // 이전 프레임으로 이동
          frames[currentFrame][1] = ""; // 이전 프레임의 두 번째 롤 비우기
          isFirstRoll = false; // 두 번째 롤로 전환
        }
      }
      frameScores[currentFrame] = 0;
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
      isSecondRoll = false;
      frameScores = List.filled(10, 0);
      existScores = List.filled(10, 0);
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                          items: List.generate(30, (index) => index + 1)
                              .map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text('번째 게임',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

               // 손익 기록 입력 필드
            Text('손익 기록', style: TextStyle(fontSize: 14)),
            TextField(
              maxLength: 20,
              onChanged: (value) {
                pay = double.tryParse(value) ?? 0.0; // 손익 저장
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ex) 15000, -20000',
              ),
            ),
            SizedBox(height: 30),


              // 메모 입력 필드
            Text('메모를 입력해주세요 (50자)', style: TextStyle(fontSize: 14)),
            TextField(
              maxLength: 50,
              onChanged: (value) {
                memo = value; // 메모 저장
              },
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

              SizedBox(height: 20),

              // 백스페이스 버튼 (아이콘으로 대체)
              ElevatedButton(
                onPressed: _backspace,
                child: Icon(Icons.backspace, size: 24),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  fixedSize: Size(500, 30),
                  side: BorderSide(color: Colors.red, width: 1),
                ),
              ),
              SizedBox(height: 20),
              // 리프레시 버튼 (아이콘으로 대체)
              ElevatedButton(
                onPressed: () {
                  _showResetDialog(); // 리셋 다이얼로그 표시
                },
                child: Icon(Icons.refresh, size: 24),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  fixedSize: Size(500, 30), 
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),



              SizedBox(height: 40),

              // 기록 테이블
              buildScoreFrames(),

              SizedBox(height: 50),

              buildCustomFrames(),

              SizedBox(height: 40),
              // 점수 기록하기 버튼
              ElevatedButton(
  onPressed: isGameFinished ? () async {
    int userId = int.parse(widget.user_id);
    int totalScore = _calculateScore();
    List<Map<String, dynamic>> frameDetails = List.generate(10, (index) {
      int firstBall = 0;
      int secondBall = 0;
      int bonus = 0;

      // 첫 번째 투구 처리
      if (frames[index][0] == 'X') {
        firstBall = 10; // 스트라이크
      } else if (frames[index][0].isNotEmpty) {
        firstBall = int.tryParse(frames[index][0]) ?? 0; // 숫자로 변환
      }

      // 두 번째 투구 처리
      if (frames[index][1] == '/') {
        secondBall = 10 - firstBall; // 스페어 처리
      } else if (frames[index][1].isNotEmpty) {
        secondBall = int.tryParse(frames[index][1]) ?? 0; // 숫자로 변환
      }

      // 10번째 프레임의 보너스 처리
      if (index == 9) {
        if (frames[index][0] == 'X' && frames[index][1] == 'X') {
          bonus = int.tryParse(frames[index][2]) ?? 0;
        } else if (frames[index][0] == 'X' && frames[index][1].isNotEmpty) {
          secondBall = int.tryParse(frames[index][1]) ?? 0;
          bonus = 10 - secondBall; // 두 번째 투구 점수
        } else if (frames[index][1] == '/') {
          bonus = int.tryParse(frames[index][2]) ?? 0; 
        } else {
          bonus = int.tryParse(frames[index][2]) ?? 0;
        }
      }

      return {
        'frame_num': index + 1,
        'first_ball': firstBall,
        'second_ball': secondBall,
        'bonus': bonus,
      };
    });

    try {
      // 데이터 저장 호출
      await saveGameData(userId, selectedDate, selectedGameNumber, totalScore, memo, pay, frameDetails);
      _showSnackbar("게임 기록이 저장되었습니다.");
    } catch (error) {
      _showSnackbar("저장 중 오류가 발생했습니다: $error");
    }
  } : null, // isGameFinished가 false일 경우 null로 설정하여 버튼 비활성화
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

  Widget _buildButton(int value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 252, 36, 90)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(value),
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

  Widget _buildFrame(int frameNumber, {bool isLast = false}) {
    int cumulativeScoreForFrame =
        frameScores.sublist(0, frameNumber).reduce((a, b) => a + b);
    if (frameNumber == 10 && existScores[0] > 0) {
      cumulativeScoreForFrame += existScores[0];
    }
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
                right: BorderSide(
                    color: isLast ? Colors.black : Colors.transparent),
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
              ),
            ),
            child: Center(
              child: Text(
                frameNumber.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
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
                right: BorderSide(
                    color: isLast ? Colors.black : Colors.transparent),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                          frames[9][2], // 세 번째 투구 점수
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                // 프레임 점수 표시
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 30,
                    child: Center(
                      child: Text(
                        cumulativeScoreForFrame > 0
                            ? cumulativeScoreForFrame.toString()
                            : '', // 프레임 점수
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
  Widget buildCustomFrames() {
  int strikeCount = 0; // 스트라이크 개수
  int spareCount = 0; // 스페어 개수
  int total = frameScores.sublist(0, 10).reduce((a, b) => a + b);
  total = existScores[0] > 0 ? total += existScores[0] : total;

  // frames 리스트를 순회하여 스트라이크와 스페어 개수를 세기
  for (var frame in frames) {
    if (frame[0] == 'X' || frame[1] == 'X' || frame[2] == 'X') {
      strikeCount++;
    }
    if (frame[1] == '/' || frame[2] == '/') {
      spareCount++;
    }
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
    children: [
      // 왼쪽 하단 총점 프레임
      Column(
        children: [
          buildCustomFrame("총점", total), // 총점 프레임
        ],
      ),
      SizedBox(width: 20), // 프레임 간의 간격 추가
      // 오른쪽 하단 스페어 및 스트라이크 프레임
      Row(
        children: [
          buildCustomFrame("스페어", spareCount), // 스페어 프레임
          SizedBox(width: 20), // 프레임 간의 간격 추가
          buildCustomFrame("스트라이크", strikeCount), // 스트라이크 프레임
        ],
      ),
    ],
  );
}

  Widget buildCustomFrame(String frameLabel, int datavalue) {
  return Container(
    child: Column(
      children: [
        // 프레임 숫자를 감싸는 큰 직사각형
        Container(
          width: 90,
          height: 30,
          decoration: BoxDecoration(
            color: Color(0xFFBBBB9D),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              frameLabel,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // 큰 정사각형
        Container(
          width: 90,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFFAFAD2),
            border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.transparent),
                bottom: BorderSide(color: Colors.black),
              ),
          ),
          child: Center(
            child: Text(
              datavalue.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}
}
