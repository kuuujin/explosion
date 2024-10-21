import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Meeting.dart'; // 정모 탭의 내용을 위한 파일
import 'EditScore.dart'; // 점수기록 탭의 내용을 위한 파일
import 'MyScore.dart'; // 내기록 탭의 내용을 위한 파일
import 'Ranking.dart'; // 랭킹 탭의 내용을 위한 파일
import 'Alarm.dart'; // 알림 화면
import 'EditProfile.dart'; // 프로필 수정 화면

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy.MM.dd').format(DateTime.now());

    return Scaffold(
      body: Column(
        children: [
          // 상단 바
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Alarm()), // 알림 화면으로 전환
                    );
                  },
                  child: Icon(Icons.notifications, color: Colors.black, size: 40), // 알림 아이콘
                ),
                Row(
                  children: [
                    Image.asset('asset/images/보으링아이콘.png', width: 70, height: 70), // 이미지 경로 및 크기
                    SizedBox(width: 0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('오늘도 보으링~', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(todayDate, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()), // 프로필 수정 화면으로 전환
                    );
                  },
                  child: Icon(Icons.account_circle, size: 40), // 사용자 아이콘
                ),
              ],
            ),
          ),
          // 내용 영역
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _getTabContent(),
            ),
          ),
          // 커스텀 하단 내비게이션 바
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0; // 홈 탭 선택
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, color: _selectedIndex == 0 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black),
                      Text('홈', style: TextStyle(color: _selectedIndex == 0 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1; // 정모 탭 선택
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_available, color: _selectedIndex == 1 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black),
                      Text('정모', style: TextStyle(color: _selectedIndex == 1 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2; // 점수기록 탭 선택
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_note, color: _selectedIndex == 2 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black),
                      Text('점수기록', style: TextStyle(color: _selectedIndex == 2 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 3; // 내기록 탭 선택
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_calendar, color: _selectedIndex == 3 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black),
                      Text('내기록', style: TextStyle(color: _selectedIndex == 3 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4; // 랭킹 탭 선택
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bar_chart, color: _selectedIndex == 4 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black),
                      Text('랭킹', style: TextStyle(color: _selectedIndex == 4 ? const Color.fromARGB(255, 252, 36, 90) : Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTabContent() {
    switch (_selectedIndex) {
      case 0:
        return Center(child: Text('홈 탭 내용', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
      case 1:
        return Meeting(); // 정모 탭의 내용
      case 2:
        return EditScore(); // 점수기록 탭의 내용
      case 3:
        return MyScore(); // 내기록 탭의 내용
      case 4:
        return Ranking(); // 랭킹 탭의 내용
      default:
        return Center(child: Text('내용 없음', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
    }
  }
}
