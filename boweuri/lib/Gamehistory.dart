import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameHistory extends StatefulWidget {
  final String user_id;

  GameHistory({required this.user_id});

  @override
  _GameHistoryState createState() => _GameHistoryState();
}

class _GameHistoryState extends State<GameHistory> {
  List<dynamic> gameData = []; // 게임 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태
  String quarter = '1';

  @override
  void initState() {
    super.initState();
    fetchGameData(); // 게임 데이터 요청
  }

  Future<void> fetchGameData() async {
    final response = await http.get(Uri.parse('http://34.64.176.207:5000/detaildata?quarter=$quarter&user_id=${widget.user_id}'));

    if (response.statusCode == 200) {
      setState(() {
        gameData = json.decode(response.body); // JSON 응답을 파싱하여 리스트에 저장
        isLoading = false; // 로딩 완료
      });
    } else {
      // 오류 처리
      setState(() {
        isLoading = false;
      });
      throw Exception('게임 데이터를 가져오는 데 실패했습니다.');
    }
  }

  void updateQuarter(String q) {
    setState(() {
      quarter = q; // 선택한 분기로 업데이트
      gameData.clear(); // 이전 게임 데이터 초기화
      fetchGameData(); // 분기 변경 시 데이터 새로고침
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // 로딩 중 표시
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('게임 기록', style: TextStyle(fontWeight: FontWeight.w400)),
      ),
      body: Column(
        children: [
          // 분기 선택 버튼 추가
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.pink, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: QuarterButton(text: '1분기', isSelected: quarter == '1', onPressed: () => updateQuarter('1'))),
                Expanded(child: QuarterButton(text: '2분기', isSelected: quarter == '2', onPressed: () => updateQuarter('2'))),
                Expanded(child: QuarterButton(text: '3분기', isSelected: quarter == '3', onPressed: () => updateQuarter('3'))),
                Expanded(child: QuarterButton(text: '4분기', isSelected: quarter == '4', onPressed: () => updateQuarter('4'))),
              ],
            ),
          ),
          SizedBox(height: 20), // 버튼과 다른 내용 사이의 간격
          Expanded(
            child: gameData.isEmpty 
                ? Center(child: Text('해당 분기에 기록된 게임이 없습니다.', style: TextStyle(color: Colors.black, fontSize: 18))) // 데이터가 없을 경우 메시지 표시
                : ListView.builder(
                    itemCount: gameData.length,
                    itemBuilder: (context, index) {
                      final game = gameData[index];
                      return buildGameSummary(game); // 각 게임의 요약을 빌드
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGameSummary(Map<String, dynamic> game) {
  // 스트라이크 횟수를 세기 위한 변수
  int strikeCount = 0;

  // 프레임 위젯 생성 및 스트라이크 횟수 계산
  List<Widget> frames = _buildFrames(game['details'], (count) {
    strikeCount += count; // 스트라이크 횟수 누적
  });

  return Column(
    children: [
      // 게임 제목 표시
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${game['game_date']} ${game['game_num']}번째 게임',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      SizedBox(height: 50),
      // 프레임 위젯 생성
      ...frames, // 프레임 위젯 추가
      // 점수 요약 위젯 생성
      buildScoreSummary(
        game['total_score'],
        (game['cover'] is int) ? (game['cover'] as int).toDouble() : game['cover'], // int를 double로 변환
        strikeCount, // 계산된 스트라이크 횟수 사용
        _calculateProfit(game['pay']), // 변환된 손익 사용
      ),
      SizedBox(height: 50),
      Divider(
                color: Colors.black,
                thickness: 2,
              ),
    ],
  );
}

// 손익 계산 메서드
double _calculateProfit(dynamic pay) {
  final String profitString = pay?.toString() ?? '0'; // null일 경우 '0'으로 변환
  return double.tryParse(profitString) ?? 0.0; // 변환 실패 시 0.0 반환
}


List<Widget> _buildFrames(List<dynamic> details, Function(int) onStrikeCount) {
  List<Widget> frameWidgets = [];
  
  // 첫 번째 줄
  frameWidgets.add(Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
      return _buildFrame(index + 1, details, onStrikeCount); // 1~5번째 프레임
    }),
  ));

  frameWidgets.add(SizedBox(height: 50)); // 줄 간격

  // 두 번째 줄
  frameWidgets.add(Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
      return _buildFrame(index + 6, details, onStrikeCount); // 6~10번째 프레임
    }),
  ));

  frameWidgets.add(SizedBox(height: 50));

  return frameWidgets; // List<Widget> 반환
}


// 수정된 _buildFrame 메서드
Widget _buildFrame(int frameNumber, List<dynamic> details, Function(int) onStrikeCount) {
  final detail = details[frameNumber - 1];
  
  // 상태 필터링
  String statusSymbol = '';
  switch (detail['status']) {
    case 'open':
      statusSymbol = '-';
      break;
    case 'spare':
      statusSymbol = '/';
      break;
    case 'strike':
      statusSymbol = 'X'; // 대문자 'X'로 변경
      onStrikeCount(1); // 스트라이크 카운트 증가
      break;
    default:
      statusSymbol = ''; // 그 외의 경우는 빈 문자열
  }

  return Container(
    width: (frameNumber == 10) ? 90 : 60, // 10번째 프레임은 90
    child: Column(
      children: [
        // 프레임 숫자를 감싸는 큰 직사각형
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Color(0xFFBBBB9D),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              frameNumber.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        // 큰 정사각형
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFFAFAD2),
            border: Border.all(color: Colors.black),
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
                      detail['first_ball']?.toString() ?? '0', // 첫 번째 투구 점수
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
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
                      detail['second_ball']?.toString() ?? '0', // 두 번째 투구 점수
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
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
                        detail['bonus']?.toString() ?? '0', // 세 번째 투구 점수
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              // 프레임 상태 표시
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      statusSymbol, // 필터링된 상태
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
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




  Widget buildScoreSummary(
    int totalScore, double coverageRate, int strikeCount, double profit) {

  return Row(
    mainAxisAlignment: MainAxisAlignment.center, // 왼쪽 정렬
    children: [
      buildCustomFrame("총점", totalScore.toString()), // int를 String으로 변환
      buildCustomFrame("커버율", (coverageRate * 10).toStringAsFixed(1) + "%"), // 이미 String으로 변환됨
      buildCustomFrame("스트라이크", strikeCount.toString()), // int를 String으로 변환
      buildCustomFrame("손익", profit.toStringAsFixed(2)), // 이미 String으로 변환됨
    ],
  );
}

  Widget buildCustomFrame(String frameLabel, String dataValue) {
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
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        // 큰 정사각형
        Container(
          width: 90,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFFFAFAD2),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              dataValue, // String 타입을 그대로 사용
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget QuarterButton({required String text, required bool isSelected, required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.pink : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.pink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }


}