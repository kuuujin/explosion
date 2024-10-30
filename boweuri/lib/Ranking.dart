import 'package:flutter/material.dart';

class Ranking extends StatelessWidget {
  final String user_id;

  Ranking({required this.user_id});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '랭킹 페이지',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // 랭킹 정보를 여기에 추가할 수 있습니다.
          // 예시로 몇 개의 랭킹 항목을 추가합니다.
          rankingItem(1, "홍길동", 251.8, 13),
          rankingItem(2, "전우치", 241.3, 10),
          rankingItem(3, "이순신", 230.0, 8),
        ],
      ),
    );
  }

  Widget rankingItem(int rank, String name, double score, int count) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$rank. $name'),
          Text('점수: ${score.toStringAsFixed(1)} (참여: $count)'),
        ],
      ),
    );
  }
}
