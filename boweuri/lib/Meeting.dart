import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addMeeting.dart';
import 'package:intl/intl.dart';
import 'Alarm.dart';

class Meeting extends StatefulWidget {
  final String user_id;

  Meeting({required this.user_id});

  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  List<dynamic> _joinedMeetings = []; // 참여 신청한 정모 리스트
  List<dynamic> _upcomingMeetings = []; // 진행 예정인 정모 리스트

  @override
  void initState() {
    super.initState();
    _fetchMeetings();
  }

  Future<void> _fetchMeetings() async {
    final joinedResponse = await http.get(Uri.parse(
        'http://34.64.176.207:5000/joined_meetings?user_id=${widget.user_id}'));
    final upcomingResponse = await http
        .get(Uri.parse('http://34.64.176.207:5000/upcoming_meetings'));

    if (joinedResponse.statusCode == 200 &&
        upcomingResponse.statusCode == 200) {
      final joinedMeetings = json.decode(joinedResponse.body) ?? [];
      final upcomingMeetings = json.decode(upcomingResponse.body) ?? [];

      _joinedMeetings = joinedMeetings;

      // 진행 예정인 정모에서 이미 참여한 정모를 제외
      final filteredUpcomingMeetings = upcomingMeetings.where((meeting) {
        return !joinedMeetings.any((joinedMeeting) =>
            joinedMeeting['meet_id'] == meeting['meet_id']);
      }).toList();

      setState(() {
        _upcomingMeetings = filteredUpcomingMeetings;
      });
    } else {
      setState(() {
        _joinedMeetings = [];
        _upcomingMeetings = [];
      });
    }
  }

Future<void> handleCreateMeeting(Map<String, dynamic> meetingData) async {
  final response = await http.post(
    Uri.parse('http://34.64.176.207:5000/meeting/create'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(meetingData),
  );

  if (response.statusCode == 201) {
    final meetingId = json.decode(response.body)['meet_id'];

    // 주최자가 자동으로 참여 (role: 'Host'로 설정)
    await _joinMeeting(meetingId, 'Host');

    // 알람 추가
    DateTime meetingDateTime = DateTime.parse(meetingData['date']); // 미팅 날짜
    meetingDateTime = DateTime(
      meetingDateTime.year,
      meetingDateTime.month,
      meetingDateTime.day,
      int.parse(meetingData['time'].split(':')[0]), // 시간
      int.parse(meetingData['time'].split(':')[1]), // 분
    );
    Alarm newAlarm = Alarm(title: meetingData['title'], dateTime: meetingDateTime);
    AlarmManager.addAlarm(newAlarm); // 알람 추가

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('정모가 생성되었습니다.')));
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('정모 생성에 실패했습니다.')));
  }
}





  Future<void> _deleteMeeting(String meetingId) async {
    final response = await http.post(
      Uri.parse('http://34.64.176.207:5000/delete_meeting'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': widget.user_id, 'meet_id': meetingId}),
    );

    if (response.statusCode == 200) {
      _fetchMeetings(); // 정모 리스트를 새로고침
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('정모가 삭제되었습니다.')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('정모 삭제에 실패했습니다.')));
    }
  }

  Future<void> _joinMeeting(String meetingId, [String role = 'Attendee']) async {
    final response = await http.post(
      Uri.parse('http://34.64.176.207:5000/join_meeting'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': widget.user_id,
        'meet_id': meetingId,
        'role': role // 역할을 Attendee 또는 Host로 설정
      }),
    );

    if (response.statusCode == 200) {
      _fetchMeetings();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('참여 신청이 완료되었습니다.')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('참여 신청에 실패했습니다.')));
    }
  }

  Future<void> _cancelMeeting(String meetingId) async {
    final response = await http.post(
      Uri.parse('http://34.64.176.207:5000/cancel_meeting'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': widget.user_id, 'meet_id': meetingId}),
    );

    if (response.statusCode == 200) {
      _fetchMeetings();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('신청이 취소되었습니다.')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('신청 취소에 실패했습니다.')));
    }
  }

  String formatDate(String dateString, String timeString) {
    DateTime dateTime = DateTime.parse(dateString);

    List<String> timeParts = timeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, hour, minute);

    // 포맷팅 (오전/오후 포함)
    String formattedDate = DateFormat('MM/dd (E) a h:mm ', 'ko_KR').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                              bool isHost = meeting['role'] == 'Host'; // role을 사용하여 주최자 확인
                              return _buildMeetingCard(
                                user_id: '${meeting['user_id']}',
                                title: meeting['title'],
                                date: formatDate(meeting['date'], meeting['time']),
                                status: isHost ? '정모 삭제' : '신청 취소', // 주최자일 경우
                                pay: meeting['pay'],
                                place: meeting['place'],
                                total: '${meeting['join_cnt']}/${meeting['total']} (${meeting['total'] - meeting['join_cnt']}자리 남음)',
                                images: meeting['image'],
                                meetingId: '${meeting['meet_id']}',
                                onJoin: () {
                                  _showCancelConfirmation('${meeting['meet_id']}', isHost);
                                },
                                onCancel: () {
                                  _showCancelConfirmation('${meeting['meet_id']}', isHost);
                                },
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              SizedBox(height: 20),

              // 진행 예정인 정모 제목
              Text('진행 예정인 정모',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // 진행 예정인 정모 Container
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
                    _upcomingMeetings.isEmpty
                        ? Text('진행 예정인 정모가 없습니다.',
                            style: TextStyle(fontSize: 25, color: Colors.grey))
                        : Column(
                            children: _upcomingMeetings.map((meeting) {
                              return _buildMeetingCard(
                                user_id: '${meeting['user_id']}',
                                title: meeting['title'],
                                date: formatDate(meeting['date'], meeting['time']),
                                status: '참여', // 주최자와 관계없이 '참여'로 표시
                                pay: meeting['pay'],
                                place: meeting['place'],
                                total: '${meeting['join_cnt']}/${meeting['total']} (${meeting['total'] - meeting['join_cnt']}자리 남음)',
                                images: meeting['image'],
                                meetingId: '${meeting['meet_id']}',
                                onJoin: () => _showJoinConfirmation('${meeting['meet_id']}'), // 참여 신청
                                onCancel: null, // 진행 예정인 정모에서는 신청 취소 기능 없음
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // 정모 입장 추가 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMeeting(user_id: widget.user_id)),
                  );
                },
                child: Text('정모 일정 추가'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 252, 36, 90),
                  foregroundColor: Colors.white,
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

  void _showJoinConfirmation(String? meetingId) {
    if (meetingId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('정모 ID가 유효하지 않습니다.')));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('참여 신청'),
          content: Text('해당 정모에 참여하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _joinMeeting(meetingId); // role은 기본적으로 Attendee로 설정
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            )
          ],
        );
      },
    );
  }

  void _showCancelConfirmation(String? meetingId, bool isHost) {
    if (meetingId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('정모 ID가 유효하지 않습니다.')));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isHost ? '정모 삭제' : '신청 취소'),
          content: Text(isHost ? '해당 정모를 삭제하시겠습니까?' : '해당 정모의 신청을 취소하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (isHost) {
                  _deleteMeeting(meetingId); // 정모 삭제 함수 호출
                } else {
                  _cancelMeeting(meetingId); // 일반 사용자 신청 취소
                }
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
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
                    backgroundColor: status == '신청 취소' ? Colors.blue : Color.fromARGB(255, 252, 36, 90),
                  ),
                  child: Text(status, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Image.network(images, height: 100, width: 120, fit: BoxFit.cover), // 이미지 표시
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('일시: ', style: TextStyle(color: Colors.grey.withOpacity(0.8))),
                          Text(date, style: TextStyle(color: Colors.black)), // 날짜는 기본 색상 유지
                        ],
                      ),
                      Row(
                        children: [
                          Text('위치: ', style: TextStyle(color: Colors.grey.withOpacity(0.8))),
                          Text(place, style: TextStyle(color: Colors.black)), // 위치는 기본 색상 유지
                        ],
                      ),
                      Row(
                        children: [
                          Text('비용: ', style: TextStyle(color: Colors.grey.withOpacity(0.8))),
                          Text(pay, style: TextStyle(color: Colors.black)), // 비용은 기본 색상 유지
                        ],
                      ),
                      Row(
                        children: [
                          Text('참석: ', style: TextStyle(color: Colors.grey.withOpacity(0.8))),
                          Text(total, style: TextStyle(color: Colors.black)), // 참석은 기본 색상 유지
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
}
