import 'package:flutter/material.dart';

class Alarm {
  final String title; // 알람 제목
  final DateTime dateTime; // 알람 시간

  Alarm({required this.title, required this.dateTime});
}

class AlarmManager {
  static final List<Alarm> _alarms = []; // 알람 리스트

  static void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
  }

  static List<Alarm> getAlarms() {
    return _alarms;
  }
}

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final alarms = AlarmManager.getAlarms(); // 알람 리스트 가져오기

    return Scaffold(
      appBar: AppBar(title: Text('알람 목록')),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return ListTile(
            title: Text(alarm.title),
            subtitle: Text(alarm.dateTime.toString()), // 시간 표시
          );
        },
      ),
    );
  }
}
