import 'dart:async'; // Timer를 사용하기 위한 import
import 'package:app_team2/Screen/s_createRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/w_roomCard.dart';
import '../data/chatRoom.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _rooms = [];
  Timer? _timer; // Timer를 위한 변수 추가

  @override
  void initState() {
    super.initState();
    _fetchRooms(); // 방 정보 가져오기
    _startRoomFetchTimer(); // 타이머 시작
  }

  // Firestore에서 방 정보를 가져오는 메서드
  Future<void> _fetchRooms() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('study_rooms').get();
      setState(() {
        _rooms = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          // Firestore Timestamp를 String으로 변환
          String startTime = (data['startTime'] as Timestamp).toDate().toIso8601String();
          String endTime = (data['endTime'] as Timestamp).toDate().toIso8601String();

          return {
            ...data,
            'startTime': startTime,
            'endTime': endTime,
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching rooms: $e');
    }
  }

  // 30초마다 방 정보를 갱신하는 타이머 시작
  void _startRoomFetchTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchRooms();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RoomListScreen()), // MainScreen으로 이동
            );
          },
          icon: const Icon(Icons.filter_alt_outlined),
        ),
        title: const Center(child: Text('스터디 목록')),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.account_circle_outlined))
        ],
      ),
      body: _rooms.isEmpty
          ? Center(child: Text('방이 없습니다.'))
          : ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return RoomCard(
            title: room['title'],
            host: room['host'],
            content: room['content'],
            startTime: room['startTime'],
            endTime: room['endTime'],
            attendee: room['attendee'] ?? 0,
            maxParticipants: room['maxParticipants'],
            topic: room['topic'],
            imageUrl: 'https://picsum.photos/200/200',
            reservation: true,
            startStudy: false,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 방 생성 페이지로 이동하는 버튼
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRoomPage()),
          );
        },
        child: const Icon(Icons.add), // 방 추가 버튼
      ),
    );
  }
}
