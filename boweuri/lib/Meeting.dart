// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'addMeeting.dart';

// class Meeting extends StatefulWidget {
//   final String user_id;

//   Meeting({required this.user_id});

//   @override
//   _MeetingState createState() => _MeetingState();
// }

// class _MeetingState extends State<Meeting> {
//   List<dynamic> _joinedMeetings = []; // 참여 신청한 정모 리스트
//   List<dynamic> _upcomingMeetings = []; // 진행 예정인 정모 리스트

//   @override
//   void initState() {
//     super.initState();
//     _fetchMeetings();
//   }

//   Future<void> _fetchMeetings() async {
//     // 참여 신청한 정모 가져오기
//     final joinedResponse = await http.get(Uri.parse('http://34.64.176.207:5000/joined_meetings?user_id=${widget.user_id}'));
//     // 전체 정모 가져오기
//     final upcomingResponse = await http.get(Uri.parse('http://34.64.176.207:5000/upcoming_meetings'));

//     if (joinedResponse.statusCode == 200 && upcomingResponse.statusCode == 200) {
//       setState(() {
//         _joinedMeetings = json.decode(joinedResponse.body) ?? [];
//         _upcomingMeetings = json.decode(upcomingResponse.body) ?? [];
//       });
//     } else {
//       // 에러 처리
//       setState(() {
//         _joinedMeetings = [];
//         _upcomingMeetings = [];
//       });
//     }
//   }

//   Future<void> _joinMeeting(String meetingId) async {
//     // 참여 신청 API 호출
//     final response = await http.post(
//       Uri.parse('http://34.64.176.207:5000/join_meeting'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'user_id': widget.user_id, 'meet_id': meetingId}),
//     );

//     if (response.statusCode == 200) {
//       // 참여 신청 성공
//       _fetchMeetings(); // 데이터 갱신
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('참여 신청이 완료되었습니다.')));
//     } else {
//       // 에러 처리
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('참여 신청에 실패했습니다.')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20),

//               // 참여 신청한 정모
//               Text('참여 신청한 정모', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               _joinedMeetings.isEmpty
//                   ? Text('참여 신청한 정모가 없습니다.', style: TextStyle(color: Colors.grey))
//                   : Column(
//                       children: _joinedMeetings.map((meeting) {
//                         return _buildMeetingCard(
//                           title: meeting['title'],
//                           date: meeting['date'],
//                           status: '신청함',
//                           total: '${meeting['join_cnt']}/${meeting['total']} (자리 남음)',
//                           images: 'asset/images/보으링아이콘.png', // 이미지 경로 (예시)
//                           meetingId: '${meeting['meet_id']}',
//                         );
//                       }).toList(),
//                     ),
//               SizedBox(height: 20),

//               // 진행 예정인 정모
//               Text('진행 예정인 정모', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               _upcomingMeetings.isEmpty
//                   ? Text('진행 예정인 정모가 없습니다.', style: TextStyle(color: Colors.grey))
//                   : Column(
//                       children: _upcomingMeetings.map((meeting) {
//                         return _buildMeetingCard(
//                           title: meeting['title'],
//                           date: meeting['date'],
//                           status: '참여',
//                           total: '${meeting['join_cnt']}/${meeting['total']} (자리 남음)',
//                           images: 'asset/images/보으링아이콘.png', // 이미지 경로 (예시)
//                           meetingId: '${meeting['meet_id']}' ,
//                           onJoin: () {
//                             _showJoinConfirmation('${meeting['meet_id']}');
//                           },
//                         );
//                       }).toList(),
//                     ),
//               SizedBox(height: 20),

//               // 정모 입장 추가 버튼
//               SizedBox(height: 20), // 추가 여백
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddMeeting(user_id: widget.user_id)),
//                   );
//                 },
//                 child: Text('정모 일정 추가'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 252, 36, 90),
//                   foregroundColor: Colors.white, // 버튼 색상
//                   fixedSize: Size(500, 40),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// void _showJoinConfirmation(String? meetingId) {
//   if (meetingId == null) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('정모 ID가 유효하지 않습니다.')));
//     return; // 유효하지 않은 ID일 경우 함수 종료
//   }

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('참여 신청'),
//         content: Text('해당 정모에 참여하시겠습니까?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // 다이얼로그 닫기
//             },
//             child: Text('취소'),
//           ),
//           TextButton(
//             onPressed: () {
//               _joinMeeting(meetingId);
//               Navigator.of(context).pop(); // 다이얼로그 닫기
//             },
//             child: Text('확인'),
//           ),
//         ],
//       );
//     },
//   );
// }

//   Widget _buildMeetingCard({
//     required String title,
//     required String date,
//     required String status,
//     required String total,
//     required String images,
//     required String meetingId,
//     void Function()? onJoin, // 참여 버튼 클릭 시의 행동
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text(total, style: TextStyle(color: Colors.black)),

//               ],
//             ),
//             SizedBox(height: 10),
//             Text(date, style: TextStyle(color: Colors.black)),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: onJoin, // 참여 버튼 클릭 시 행동
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color.fromARGB(255, 252, 36, 90), // 버튼 색상
//                   ),
//                   child: Text(status, style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             Image.asset(images, height: 100, fit: BoxFit.cover), // 이미지 표시
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'addMeeting.dart';

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
      setState(() {
        _joinedMeetings = json.decode(joinedResponse.body) ?? [];
        _upcomingMeetings = json.decode(upcomingResponse.body) ?? [];
      });
    } else {
      setState(() {
        _joinedMeetings = [];
        _upcomingMeetings = [];
      });
    }
  }

  Future<void> _joinMeeting(String meetingId) async {
    final response = await http.post(
      Uri.parse('http://34.64.176.207:5000/join_meeting'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': widget.user_id, 'meet_id': meetingId}),
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
              SizedBox(height: 20),

              // 참여 신청한 정모
              Text('참여 신청한 정모',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _joinedMeetings.isEmpty
                  ? Text('참여 신청한 정모가 없습니다.',
                      style: TextStyle(color: Colors.grey))
                  : Column(
                      children: _joinedMeetings.map((meeting) {
                        return _buildMeetingCard(
                          title: meeting['title'],
                          date: meeting['date'],
                          status: '신청 취소', // 버튼 텍스트 변경
                          total:
                              '${meeting['join_cnt']}/${meeting['total']} (자리 남음)',
                          images: 'asset/images/보으링아이콘.png', // 이미지 경로 (예시)
                          meetingId: '${meeting['meet_id']}',
                          onJoin: () {
                            _showCancelConfirmation('${meeting['meet_id']}');
                          },
                          onCancel: () {
                            _showCancelConfirmation(
                                '${meeting['meet_id']}'); // 신청 취소 다이얼로그 호출
                          },
                        );
                      }).toList(),
                    ),
              SizedBox(height: 20),

              // 진행 예정인 정모
              Text('진행 예정인 정모',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _upcomingMeetings.isEmpty
                  ? Text('진행 예정인 정모가 없습니다.',
                      style: TextStyle(color: Colors.grey))
                  : Column(
                      children: _upcomingMeetings.map((meeting) {
                        return _buildMeetingCard(
                          title: meeting['title'],
                          date: meeting['date'],
                          status: '참여',
                          total:
                              '${meeting['join_cnt']}/${meeting['total']} (자리 남음)',
                          images: 'asset/images/보으링아이콘.png', // 이미지 경로 (예시)
                          meetingId: '${meeting['meet_id']}',
                          onJoin: () {
                            _showJoinConfirmation('${meeting['meet_id']}');
                          },
                          onCancel: () {
                            _showCancelConfirmation(
                                '${meeting['meet_id']}'); // 신청 취소 다이얼로그 호출
                          },
                        );
                      }).toList(),
                    ),
              SizedBox(height: 20),

              // 정모 입장 추가 버튼
              SizedBox(height: 20), // 추가 여백
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddMeeting(user_id: widget.user_id)),
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

  void _showJoinConfirmation(String? meetingId) {
    if (meetingId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('정모 ID가 유효하지 않습니다.')));
      return; // 유효하지 않은 ID일 경우 함수 종료
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
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _joinMeeting(meetingId);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            )
          ],
        );
      },
    );
  }

  void _showCancelConfirmation(String? meetingId) {
    if (meetingId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('정모 ID가 유효하지 않습니다.')));
      return; // 유효하지 않은 ID일 경우 함수 종료
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('신청 취소'),
          content: Text('해당 정모의 신청을 취소하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _cancelMeeting(meetingId);
                Navigator.of(context).pop(); // 다이얼로그 닫기
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
    required String images,
    required String meetingId,
    void Function()? onJoin, // 참여 버튼 클릭 시의 행동
    void Function()? onCancel, // 신청 취소 버튼 클릭 시의 행동
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
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(total, style: TextStyle(color: Colors.black)),
              ],
            ),
            SizedBox(height: 10),
            Text(date, style: TextStyle(color: Colors.black)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == '신청 취소')
                  ElevatedButton(
                    onPressed: onCancel ?? () {}, // 신청 취소 버튼 클릭 시 행동
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // 신청 취소 버튼 색상
                    ),
                    child: Text(status, style: TextStyle(color: Colors.white)),
                  )
                else
                  ElevatedButton(
                    onPressed: onJoin ?? () {}, // 참여 버튼 클릭 시 행동
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 252, 36, 90), // 기존 신청 버튼 색상
                    ),
                    child: Text(status,
                        style: TextStyle(color: Colors.white)), // 버튼 텍스트
                  ),
              ],
            ),
            SizedBox(height: 10),
            Image.asset(images, height: 100, fit: BoxFit.cover), // 이미지 표시
          ],
        ),
      ),
    );
  }
}
