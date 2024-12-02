import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Meeting.dart'; // 정모 탭의 내용을 위한 파일
import 'EditScore.dart'; // 점수기록 탭의 내용을 위한 파일
import 'MyScore.dart'; // 내기록 탭의 내용을 위한 파일
import 'Ranking.dart'; // 랭킹 탭의 내용을 위한 파일
import 'Alarm.dart'; // 알림 화면
import 'EditProfile.dart'; // 프로필 수정 화면
import 'MyProfile.dart'; // 프로필 화면
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Alarm.dart';
import 'Gamehistory.dart';

class MainScreen extends StatefulWidget {
  final String user_id;

  MainScreen({required this.user_id});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  String? _profileImageUrl;
  List<dynamic> _joinedMeetings = [];
  @override
  void initState() {
    super.initState();
    _fetchProfileImage(); // 프로필 이미지 가져오기
    _fetchJoinedMeetings();
    _fetchGameData();
    _fetchTopRankings();
  }

  Future<Map<String, dynamic>> _fetchGameData() async {
    final response = await http.get(Uri.parse(
        'http://34.64.176.207:5000/userdata?user_id=${widget.user_id}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load game data');
    }
  }

  Future<void> _fetchProfileImage() async {
    try {
      final response = await http.get(
          Uri.parse('http://34.64.176.207:5000/users/${widget.user_id}/image'));
      if (response.statusCode == 200) {
        setState(() {
          _profileImageUrl =
              'http://34.64.176.207:5000/users/${widget.user_id}/image'; // 프로필 이미지 URL
        });
      } else {
        // 오류 처리
        setState(() {
          _profileImageUrl = null;
        });
      }
    } catch (e) {
      // 오류 처리
      setState(() {
        _profileImageUrl = null;
      });
    }
  }

  Future<void> _fetchJoinedMeetings() async {
    try {
      final response = await http.get(Uri.parse(
          'http://34.64.176.207:5000/joined_meetings?user_id=${widget.user_id}'));
      if (response.statusCode == 200) {
        setState(() {
          _joinedMeetings = json.decode(response.body); // 참여 신청한 정모 데이터
        });
      } else {
        setState(() {
          _joinedMeetings = []; // 오류 발생 시 빈 리스트로 초기화
        });
      }
    } catch (e) {
      setState(() {
        _joinedMeetings = []; // 오류 발생 시 빈 리스트로 초기화
      });
    }
  }

  String formatDate(String dateString, String timeString) {
    DateTime dateTime = DateTime.parse(dateString);

    List<String> timeParts = timeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    dateTime =
        DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);

    // 포맷팅 (오전/오후 포함)
    String formattedDate =
        DateFormat('MM/dd (E) a h:mm ', 'ko_KR').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy.MM.dd').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단 바
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(_createRouteForAlarm()); // 알림 화면으로 전환
                  },
                  child: Icon(Icons.notifications,
                      color: Colors.black, size: 40), // 알림 아이콘
                ),
                Row(
                  children: [
                    Image.asset('asset/images/보으링아이콘.png',
                        width: 70, height: 70), // 이미지 경로 및 크기
                    SizedBox(width: 0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('오늘도 보으링~',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(todayDate, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(_createRoute()); // 프로필 화면으로 전환
                  },
                  child: ClipOval(
                    child: _profileImageUrl != null
                        ? Image.network(
                            _profileImageUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey, // 기본 색상
                            ),
                            child: Icon(Icons.person,
                                color: Colors.white), // 기본 아이콘
                          ),
                  ),
                ),
              ],
            ),
          ),

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
              border:
                  Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
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
                      Icon(Icons.home,
                          color: _selectedIndex == 0
                              ? const Color.fromARGB(255, 252, 36, 90)
                              : Colors.black),
                      Text('홈',
                          style: TextStyle(
                              color: _selectedIndex == 0
                                  ? const Color.fromARGB(255, 252, 36, 90)
                                  : Colors.black)),
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
                      Icon(Icons.event_available,
                          color: _selectedIndex == 1
                              ? const Color.fromARGB(255, 252, 36, 90)
                              : Colors.black),
                      Text('정모',
                          style: TextStyle(
                              color: _selectedIndex == 1
                                  ? const Color.fromARGB(255, 252, 36, 90)
                                  : Colors.black)),
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
                      Icon(Icons.edit_note,
                          color: _selectedIndex == 2
                              ? const Color.fromARGB(255, 252, 36, 90)
                              : Colors.black),
                      Text('점수기록',
                          style: TextStyle(
                              color: _selectedIndex == 2
                                  ? const Color.fromARGB(255, 252, 36, 90)
                                  : Colors.black)),
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
                      Icon(Icons.edit_calendar,
                          color: _selectedIndex == 3
                              ? const Color.fromARGB(255, 252, 36, 90)
                              : Colors.black),
                      Text('내기록',
                          style: TextStyle(
                              color: _selectedIndex == 3
                                  ? const Color.fromARGB(255, 252, 36, 90)
                                  : Colors.black)),
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
                      Icon(Icons.bar_chart,
                          color: _selectedIndex == 4
                              ? const Color.fromARGB(255, 252, 36, 90)
                              : Colors.black),
                      Text('랭킹',
                          style: TextStyle(
                              color: _selectedIndex == 4
                                  ? const Color.fromARGB(255, 252, 36, 90)
                                  : Colors.black)),
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
        return _buildHomeTab();
      case 1:
        return Meeting(user_id: widget.user_id); // 정모 탭의 내용
      case 2:
        return EditScore(user_id: widget.user_id); // 점수기록 탭의 내용
      case 3:
        return MyScore(user_id: widget.user_id); // 내기록 탭의 내용
      case 4:
        return Ranking(user_id: widget.user_id); // 랭킹 탭의 내용
      default:
        return Center(
            child: Text('내용 없음',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MyProfile(user_id: widget.user_id),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
        const end = Offset.zero; // 원래 위치로
        const curve = Curves.easeInOut; // 애니메이션 곡선

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250), // 애니메이션 시간
    );
  }

  Route _createRouteForAlarm() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AlarmScreen(), // AlarmScreen으로 변경
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0); // 왼쪽에서 시작
        const end = Offset.zero; // 원래 위치로
        const curve = Curves.easeInOut; // 애니메이션 곡선

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300), // 애니메이션 시간
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // 참여 신청한 정모 제목
            Text('참여 신청한 정모',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // 참여 신청한 정모 Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                minWidth: double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _joinedMeetings.isEmpty
                      ? Text('참여 신청한 정모가 없습니다.',
                          style: TextStyle(fontSize: 20, color: Colors.grey))
                      : Column(
                          children: _joinedMeetings.map((meeting) {
                            bool isHost =
                                meeting['role'] == 'Host'; // role을 사용하여 주최자 확인
                            return _buildMeetingCard(
                              user_id: '${meeting['user_id']}',
                              title: meeting['title'],
                              date:
                                  formatDate(meeting['date'], meeting['time']),
                              status: isHost ? '정모 삭제' : '신청 취소', // 주최자일 경우
                              pay: meeting['pay'],
                              place: meeting['place'],
                              total:
                                  '${meeting['join_cnt']}/${meeting['total']} (${meeting['total'] - meeting['join_cnt']}자리 남음)',
                              images: meeting['image'],
                              meetingId: '${meeting['meet_id']}',
                              onJoin: () {
                                _showCancelConfirmation(
                                    '${meeting['meet_id']}', isHost);
                              },
                              onCancel: () {
                                _showCancelConfirmation(
                                    '${meeting['meet_id']}', isHost);
                              },
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 게임 기록 히스토리 추가
            FutureBuilder<Map<String, dynamic>>(
              future: _fetchGameData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('게임 기록을 불러오는 데 실패했습니다.');
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final int profit = data['pay'] != null
                      ? double.parse(data['pay'].toString()).toInt()
                      : 0;
                  return buildGameHistory(data, profit, widget.user_id);
                } else {
                  return Text('데이터가 없습니다.');
                }
              },
            ),

            SizedBox(height: 20),
            Text('현재분기 평균 상위 3위 랭킹',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            FutureBuilder<List<dynamic>>(
              future: _fetchTopRankings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('랭킹 정보를 불러오는 데 실패했습니다.');
                } else if (snapshot.hasData) {
                  final rankings = snapshot.data!;
                  return Column(
                    children: rankings.map((item) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = 4; // 랭킹 탭으로 변경
                          });
                        },
                        child: rankingItem(
                          item['rank'],
                          item['name'],
                          double.tryParse(item['score'].toString()) ?? 0.0,
                          item['count'] ?? 0,
                          widget.user_id == item['user_id'].toString(),
                          item['profile_image'] ?? '',
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Text('데이터가 없습니다.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(String meetingId, bool isHost) {
    // 취소 확인 다이얼로그 표시
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isHost ? '정모 삭제' : '신청 취소'),
          content: Text(isHost ? '정모를 삭제하시겠습니까?' : '신청을 취소하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                // 여기서 취소 로직을 구현합니다.
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }
}

Widget _buildMeetingCard({
  required String title,
  required String date,
  required String status,
  required String total,
  required String place,
  required String pay,
  required String images,
  required String meetingId,
  required String user_id,
  void Function()? onJoin,
  void Function()? onCancel,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 20.0),
    color: Colors.white,
    elevation: 10,
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
              Text(title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: status == '신청 취소' ? onCancel : onJoin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: status == '신청 취소'
                      ? Colors.blue
                      : Color.fromARGB(255, 252, 36, 90),
                ),
                child: Text(status, style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Image.network(images,
                  height: 100, width: 120, fit: BoxFit.cover), // 이미지 표시
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('일시: ',
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.8))),
                        Text(date,
                            style:
                                TextStyle(color: Colors.black)), // 날짜는 기본 색상 유지
                      ],
                    ),
                    Row(
                      children: [
                        Text('위치: ',
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.8))),
                        Text(place,
                            style:
                                TextStyle(color: Colors.black)), // 위치는 기본 색상 유지
                      ],
                    ),
                    Row(
                      children: [
                        Text('비용: ',
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.8))),
                        Text(pay,
                            style:
                                TextStyle(color: Colors.black)), // 비용은 기본 색상 유지
                      ],
                    ),
                    Row(
                      children: [
                        Text('참석: ',
                            style:
                                TextStyle(color: Colors.grey.withOpacity(0.8))),
                        Text(total,
                            style:
                                TextStyle(color: Colors.black)), // 참석은 기본 색상 유지
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildGameHistory(Map<String, dynamic> data, int profit, String user_id) {
  final String gameDate = data['game_date'];
  final int gameNum = data['game_num'];
  final int totalScore = data['total_score'];
  final int cover = data['cover'];
  final int strikes = data['strike_count'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('내 게임 기록 히스토리',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      SizedBox(height: 20),
      GameHistoryWidget(
          user_id: user_id,
          totalScore: totalScore,
          coverRate: cover,
          strikes: strikes,
          profit: profit,
          gameDate: gameDate,
          gameNum: gameNum),
    ],
  );
}

class GameHistoryWidget extends StatelessWidget {
  final String user_id;
  final int totalScore; // 총 점수
  final int coverRate; // 커버율
  final int strikes; // 스트라이크 수
  final int profit; // 손익
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
              Text('$gameDate $gameNum번째 게임',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GameHistory(user_id: user_id), // user_id 전달
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
          Text(title, style: TextStyle(fontWeight: FontWeight.w700)),
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
            _buildFrame('커버율',
                '${((coverRate / 10) * 100).toStringAsFixed(1)}%'), // cover를 백분율로 표시
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
                right: BorderSide(color: Colors.transparent),
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
                    fontWeight: FontWeight.w700),
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
                right: BorderSide(color: Colors.transparent),
                bottom: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.transparent),
              ),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<List<dynamic>> _fetchTopRankings() async {
  int getCurrentQuarter() {
    final now = DateTime.now();
    return (now.month - 1) ~/ 3 + 1; // 1~4 분기 계산
  }

  String getCurrentQuarterText() {
    final now = DateTime.now();
    final month = now.month;

    if (month >= 1 && month <= 3) {
      return '1';
    } else if (month >= 4 && month <= 6) {
      return '2';
    } else if (month >= 7 && month <= 9) {
      return '3';
    } else {
      return '4';
    }
  }

  String url =
      'http://34.64.176.207:5000/rankings?type=average&quarter=${getCurrentQuarterText()}&user_id=44';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> rankings = json.decode(response.body);
    rankings = json.decode(response.body);
    // 사용자 프로필 이미지 URL 추가
    for (var item in rankings) {
      item['profile_image'] =
          'http://34.64.176.207:5000/users/${item['user_id']}/image'; // 프로필 이미지 URL 생성
    }
    return rankings.take(3).toList(); // 상위 3명만 반환
  } else {
    throw Exception('랭킹을 불러오는 데 실패했습니다');
  }
}

Widget rankingItem(int rank, String name, double score, int count,
    bool isCurrentUser, String profileImage) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isCurrentUser
          ? Colors.lightBlue[100]
          : Colors.white, // 현재 사용자일 경우 색상 변경
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.pink, width: 2),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (rank == 1)
              Icon(Icons.emoji_events, color: Colors.orange, size: 35),
            if (rank == 2)
              Icon(Icons.emoji_events, color: Colors.grey, size: 35),
            if (rank == 3)
              Icon(Icons.emoji_events,
                  color: const Color.fromARGB(255, 155, 98, 78), size: 35),
            if (rank != 1 && rank != 2 && rank != 3)
              Text('$rank',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(width: 30),
        CircleAvatar(
          backgroundImage: NetworkImage(profileImage),
          radius: 20,
          backgroundColor: Colors.white,
        ),
        Text('$name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(width: 10),
        Text(
          '${score.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text('(참여: $count)', style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
