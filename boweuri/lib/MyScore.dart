import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Gamehistory.dart';
import 'dart:convert';

String getCurrentQuarterText() {
  final now = DateTime.now();
  final month = now.month;

  if (month >= 1 && month <= 3) {
    return '1분기';
  } else if (month >= 4 && month <= 6) {
    return '2분기';
  } else if (month >= 7 && month <= 9) {
    return '3분기';
  } else {
    return '4분기';
  }
}

String getCurrentDateRange() {
  final now = DateTime.now();
  final year = now.year;

  String startDate;
  String endDate;

  if (now.month >= 1 && now.month <= 3) {
    startDate = '$year-01-01';
    endDate = '$year-03-31';
  } else if (now.month >= 4 && now.month <= 6) {
    startDate = '$year-04-01';
    endDate = '$year-06-30';
  } else if (now.month >= 7 && now.month <= 9) {
    startDate = '$year-07-01';
    endDate = '$year-09-30';
  } else {
    startDate = '$year-10-01';
    endDate = '$year-12-31';
  }

  return '$startDate~$endDate';
}

class MyScore extends StatefulWidget {
  final String user_id;

  MyScore({required this.user_id});

  @override
  _MyScoreState createState() => _MyScoreState();
}

class _MyScoreState extends State<MyScore> {
  Future<Map<String, dynamic>> fetchGameData() async {
    final response = await http.get(Uri.parse('http://34.64.176.207:5000/get_game_data?user_id=${widget.user_id}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load game data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchGameData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('데이터가 없습니다.'));
          } else {
            final data = snapshot.data!;
            final quarterText = getCurrentQuarterText();
            final dateRangeText = getCurrentDateRange();

            final String profitString = data['pay']; // 서버에서 온 profit
            final int profit = double.parse(profitString).toInt(); // 소수점 제거 후 정수로 변환

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildScoreCard(data, quarterText, dateRangeText),
                    SizedBox(height: 40),
                    buildCheckButton(),
                    SizedBox(height: 40),
                    buildScoreTrendChart(data),
                    SizedBox(height: 40),
                    buildGameHistory(data, profit.toString()),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildScoreCard(Map<String, dynamic> data, String quarterText, String dateRangeText) {
    return Container(
      width: 500,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFC245A), Color(0xFFCC83BA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$quarterText 평균점수',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(FontAwesomeIcons.trophy, color: Colors.white, size: 45),
            ],
          ),
          Text(
            dateRangeText,
            style: TextStyle(fontSize: 15, color: Colors.white70, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              data['average_score'].toStringAsFixed(1),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          buildScoreDetails(data)
        ],
      ),
    );
  }

  Widget buildScoreDetails(Map<String, dynamic> data) {
    return Row(
      children: [
        buildScoreDetail('최고점수', data['max_score'].toString()),
        Spacer(),
        buildScoreDetail('200UP', data['count_above_200'].toString()),
        Spacer(),
        buildScoreDetail('커버율', '${data['cover_percentage'].toStringAsFixed(1)}%'),
      ],
    );
  }

  Widget buildScoreDetail(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget buildCheckButton() {
    return ElevatedButton(
      onPressed: () {
        // 버튼 클릭 시 동작 구현
      },
      child: Text('다른 분기 기록 확인'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        fixedSize: Size(500, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget buildScoreTrendChart(Map<String, dynamic> data) {
    List<ScoreData> scoreDataList = [
  ScoreData('1 분기', (data['average_scores']['1'] ?? 0).toDouble()), 
  ScoreData('2 분기', (data['average_scores']['2'] ?? 0).toDouble()), 
  ScoreData('3 분기', (data['average_scores']['3'] ?? 0).toDouble()), 
  ScoreData('4 분기', (data['average_scores']['4'] ?? 0).toDouble()), 
];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('분기별 평균점수 추이', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        ScoreTrendChart(data: scoreDataList),
      ],
    );
  }

  Widget buildGameHistory(Map<String, dynamic> data, String profit) {
  final String gameDate = data['game_date'];
  final int gameNum = data['game_num'];
  final int totalScore = data['total_score'];
  final int cover = data['cover'];
  final int strikes = data['strike_count'];
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('내 게임 기록 히스토리', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        GameHistoryWidget(user_id: widget.user_id,
        totalScore: totalScore,
        coverRate: cover,
        strikes: strikes,
        profit: profit,
        gameDate: gameDate,
        gameNum: gameNum,),
      ],
    );  
  }
}

class ScoreTrendChart extends StatelessWidget {
  final List<ScoreData> data;

  ScoreTrendChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SfCartesianChart(
        backgroundColor: Color.fromRGBO(217, 217, 217, 0.3),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          isVisible: false,
        ),
        plotAreaBorderWidth: 0,
        series: <CartesianSeries>[
          LineSeries<ScoreData, String>(
            dataSource: data,
            xValueMapper: (ScoreData score, _) => score.quarter,
            yValueMapper: (ScoreData score, _) => score.score,
            color: Colors.black,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            markerSettings: MarkerSettings(
              isVisible: true,
              color: Colors.pink,
              shape: DataMarkerType.circle,
              borderColor: Colors.pink,
              borderWidth: 4,
            ),
          )
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }
}

class ScoreData {
  final String quarter;
  final double score;

  ScoreData(this.quarter, this.score);
}

class GameHistoryWidget extends StatelessWidget {
  final String user_id;
  final int totalScore; // 총 점수
  final int coverRate; // 커버율
  final int strikes; // 스트라이크 수
  final String profit; // 손익
  final String gameDate; // 게임 날짜
  final int gameNum; // 게임 번호

  GameHistoryWidget({
    required this.user_id,
    required this.totalScore,
    required this.coverRate,
    required this.strikes,
    required this.profit,
    required this.gameDate,
    required this.gameNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 게임 날짜 및 번호 표시
          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$gameDate $gameNum번째 게임', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameHistory(user_id: user_id), // user_id 전달
              ),
            );
          },
          child: Text('상세'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ),
          
          SizedBox(height: 10),

          // 총점, 커버율, 스트라이크, 손익을 나란히 표시
          
          SizedBox(height: 10),

          // 프레임 구성
          buildScoreFrames(),

          SizedBox(height: 10),
          
        ],
      ),
    );
  }

  Widget buildStatBox(String title, String value) {
    return Container(
      width: 90, // 각 박스의 너비
      height: 60, // 각 박스의 높이
      decoration: BoxDecoration(
        color: Color(0xFFEFEFEF), // 배경 색상
        border: Border.all(color: Colors.black), // 테두리
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4), // 텍스트 간격
          Text(value, style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  Widget buildScoreFrames() {
    return Column(
      children: [
        // 프레임 정보 표시
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildFrame('총점', totalScore.toString()),
            _buildFrame('커버율', '${((coverRate / 10)*100).toStringAsFixed(1)}%'), // cover를 백분율로 표시
            _buildFrame('스트라이크', strikes.toString()),
            _buildFrame('손익', profit.toString()),
          ],
        ),
      ],
    );
  }

  Widget _buildFrame(String title, String value) {
    return Container(
      width: 85,
      child: Column(
        children: [
          // 프레임 숫자를 감싸는 큰 직사각형
          Container(
            width: 85,
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xFFBBBB9D),
              border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(
                    color: Colors.transparent),
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // 데이터 값 표시
          Container(
            width: 85,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFFFAFAD2),
              border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(
                    color: Colors.transparent),
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
