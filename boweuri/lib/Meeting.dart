import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/addMeeting.dart';

class Meeting extends StatelessWidget {
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
              SizedBox(height: 20),

              // 참여 신청한 정모
              Text('참여 신청한 정모', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildMeetingCard(
                title: '정모 제목',
                date: '9/4 (수) 오후 5:30',
                status: '신청함',
                total: '8/20 (12자리 남음)',
                imgPath: 'asset/images/보으링아이콘.png', // 이미지 경로 (예시)
              ),
              SizedBox(height: 20),

              // 진행 예정인 정모
              Text('진행 예정인 정모', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildMeetingCard(
                title: '정모제목',
                date: '9/8 (일) 오후 12:00',
                status: '참여',
                total: '2/20 (18자리 남음)',
                imgPath: 'asset/images/보으링아이콘.png', // 이미지 경로 (예시)
              ),
              SizedBox(height: 20),

              // 정모 입장 추가 버튼
              SizedBox(height: 20), // 추가 여백
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMeeting()),
                  );
                },
                child: Text('정모 일정 추가'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 252, 36, 90),
                  foregroundColor: Colors.white, // 버튼 색상
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

  Widget _buildMeetingCard({
    required String title,
    required String date,
    required String status,
    required String total,
    required String imgPath,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(total, style: TextStyle(color: Colors.black)),
              ],
            ),
            SizedBox(height: 10),
            Text(date, style: TextStyle(color: Colors.black)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 참여 버튼 클릭 시 행동 처리
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 252, 36, 90), // 버튼 색상
                  ),
                  child: Text(status, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Image.asset(imgPath, height: 100, fit: BoxFit.cover), // 이미지 표시
          ],
        ),
      ),
    );
  }
}
