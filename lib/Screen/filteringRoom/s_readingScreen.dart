import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/w_roomCard.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _rooms = [];
  String currentUserId = ''; // 현재 사용자 ID
  bool _isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _initializeUserAndRooms(); // 사용자와 방 정보 초기화

    // Timer 설정: 1분마다 _checkStartTimes 호출
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkStartTimes();
      _fetchRooms();
    });
  }

  // 사용자 정보 및 방 정보 가져오는 메서드
  Future<void> _initializeUserAndRooms() async {
    try {
      await _getCurrentUser(); // 현재 사용자 ID 가져오기
      await _fetchRooms(); // 방 정보 가져오기
      await _checkStartTimes(); // 시작 시간 체크
    } catch (e) {
      print('초기화 중 오류 발생: $e');
    }
  }

  // 현재 로그인된 사용자 ID를 가져오는 메서드
  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid; // 사용자 ID 저장
      });
    } else {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }
  }

  // Firestore에서 방 정보 가져오는 메서드
  Future<void> _fetchRooms() async {
    try {
      final snapshot = await _firestore
          .collection('study_rooms')
          .where('topic', isEqualTo: '독서') // 필터링 조건 추가
          .get();

      setState(() {
        _rooms = snapshot.docs.map((doc) {
          final data = doc.data();
          final startTime = (data['startTime'] as Timestamp).toDate();
          final endTime = (data['endTime'] as Timestamp).toDate();
          final createDate =
          (data['createDate'] as Timestamp).toDate(); // createDate 가져오기

          return {
            'docId': doc.id,
            ...data,
            'startTime': startTime,
            'endTime': endTime,
            'createDate': createDate, // createDate 추가
          };
        }).toList();

        // createDate를 기준으로 최신순 정렬
        _rooms.sort((a, b) => b['createDate'].compareTo(a['createDate']));
      });
    } catch (e) {
      print('방 목록을 불러오는 중 오류 발생: $e');
    } finally {
      setState(() {
        _isLoading = false; // 로딩 완료
      });
    }
  }

  // 예약 상태 업데이트하는 메서드
  Future<void> updateReservationStatus(String docId) async {
    try {
      final docSnapshot =
      await _firestore.collection('study_rooms').doc(docId).get();
      if (docSnapshot.exists) {
        final reservations =
            docSnapshot.data()?['reservations'] as Map<String, dynamic>? ?? {};
        final currentUserReservation = reservations[currentUserId] ?? false;
        await _firestore.collection('study_rooms').doc(docId).update({
          'reservations.$currentUserId': !currentUserReservation, // 상태 반전
        });
      } else {
        print('문서가 존재하지 않습니다.');
      }
    } catch (e) {
      print('예약 상태 업데이트 중 오류 발생: $e');
    }
  }

  // 시작 시간이 되었는지 체크하여 startStudy 업데이트
  Future<void> _checkStartTimes() async {
    print('StartStudy 작동중');
    for (var room in _rooms) {
      final startTime = room['startTime'] as DateTime;
      final docId = room['docId'];
      final startStudy = room['startStudy'];

      // 현재 시간과 startTime 비교, startStudy가 false일 때만 진행
      if (!startStudy && DateTime.now().isAfter(startTime)) {
        print('작업중: $docId 방의 시작 시간이 지났습니다.');
        await _updateStartStudyStatus(docId); // 상태 업데이트는 비동기 처리
      }
    }
  }

  // Firestore에서 startStudy 상태를 true로 업데이트하는 메서드
  Future<void> _updateStartStudyStatus(String docId) async {
    try {
      await _firestore.collection('study_rooms').doc(docId).update({
        'startStudy': true,
      });
      print('startStudy 상태 업데이트 완료');

      // 방 목록 새로 고침
      await _fetchRooms(); // 상태 업데이트 후 목록 새로 고침
    } catch (e) {
      print('startStudy 상태 업데이트 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('스터디 목록')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : _rooms.isEmpty
          ? const Center(child: Text('방이 없습니다.')) // No rooms
          : Column(
        children: [
          const Text('최신순 정렬'),
          Expanded(
            child: ListView.builder(
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final room = _rooms[index];
                final reservations =
                    room['reservations'] as Map<String, dynamic>? ??
                        {};
                final userReservation =
                    reservations[currentUserId] ?? false;

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
                  // Temporary image URL
                  reservations: userReservation,
                  startStudy: room['startStudy'],
                  currentUserId: currentUserId,
                  docId: room['docId'],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
        ],
      ),
    );
  }
}
