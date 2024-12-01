import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Ranking extends StatefulWidget {
  final String user_id;

  Ranking({required this.user_id});

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  List<dynamic> rankings = [];
  String rankingType = 'average'; // default ranking type
  String quarter = '1'; // default quarter
  bool isLoading = true; // 로딩 상태 추가
  String errorMessage = ''; // 에러 메시지 추가

  @override
  void initState() {
    super.initState();
    fetchRankings();
  }

  Future<void> fetchRankings() async {
    setState(() {
      isLoading = true; // 데이터 로딩 시작
      errorMessage = ''; // 에러 메시지 초기화
    });

    String url = 'http://34.64.176.207:5000/rankings?type=$rankingType&quarter=$quarter&user_id=${widget.user_id}';
    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}'); // 상태 코드 출력

    if (response.statusCode == 200) {
      setState(() {
        rankings = json.decode(response.body);
        isLoading = false; // 데이터 로딩 완료
      });
    } else {
      setState(() {
        isLoading = false; // 데이터 로딩 완료
        errorMessage = '랭킹을 불러오는 데 실패했습니다: ${response.body}'; // 에러 메시지 설정
      });
    }
  }

  void updateRanking(String type) {
    setState(() {
      rankingType = type;
      fetchRankings(); // 랭킹 타입 변경 시 데이터 새로고침
    });
  }

  void updateQuarter(String q) {
    setState(() {
      quarter = q; // 선택한 분기로 업데이트
      rankings.clear(); // 이전 랭킹 데이터 초기화
      fetchRankings(); // 분기 변경 시 데이터 새로고침
    });
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
            SizedBox(height: 20),
            Text("랭킹", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
            SizedBox(height: 10),
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
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.pink, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: RankingButton(text: '평균점수', isSelected: rankingType == 'average', onPressed: () => updateRanking('average'))),
                  Expanded(child: RankingButton(text: '최고점수', isSelected: rankingType == 'highest', onPressed: () => updateRanking('highest'))),
                  Expanded(child: RankingButton(text: '손익', isSelected: rankingType == 'cost', onPressed: () => updateRanking('cost'))),
                  Expanded(child: RankingButton(text: '커버율', isSelected: rankingType == 'cover', onPressed: () => updateRanking('cover'))),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) // 로딩 인디케이터
                  : rankings.isEmpty
                      ? Center(child: Text('해당 분기 랭킹 정보가 없습니다.')) // 랭킹이 없을 경우 메시지 표시
                      : ListView.builder(
                          itemCount: rankings.length,
                          itemBuilder: (context, index) {
                            var item = rankings[index];
                            return rankingItem(
                              item['rank'] ?? 0,
                              item['name'] ?? 'Unknown',
                              double.tryParse(item['score'].toString()) ?? 0.0,
                              item['count'] ?? 0,
                              widget.user_id == item['user_id'].toString(), // 현재 사용자 확인
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rankingItem(int rank, String name, double score, int count, bool isCurrentUser) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.lightBlue[100] : Colors.white, // 현재 사용자일 경우 색상 변경
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.pink, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (rank == 1) Icon(Icons.emoji_events, color: Colors.orange),
              if (rank == 2) Icon(Icons.emoji_events, color: Colors.grey),
              if (rank == 3) Icon(Icons.emoji_events, color: const Color.fromARGB(255, 155, 98, 78)),
              SizedBox(width: 8),
              Text('$rank. $name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            ],
          ),
          Text(
            rankingType == 'cost' ? '손익: ${score.toStringAsFixed(1)}원' : 
            rankingType == 'cover' ? '커버율: ${score.toStringAsFixed(1)}%' : 
            '점수: ${score.toStringAsFixed(1)}',
            style: TextStyle(fontSize: 16),
          ),
          Text('(참여: $count)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
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

  Widget RankingButton({required String text, required bool isSelected, required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.pink : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.pink,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
