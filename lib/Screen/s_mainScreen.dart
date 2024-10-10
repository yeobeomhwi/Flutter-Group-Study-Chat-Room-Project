import 'dart:async'; // Timer를 사용하기 위한 import
import 'package:app_team2/Screen/s_chatScreen.dart';
import 'package:app_team2/Screen/s_createRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/w_roomCard.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import 추가

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth 인스턴스 생성

  List<Map<String, dynamic>> _rooms = [];
  Timer? _timer; // Timer를 위한 변수 추가
  String currentUserId = ''; // 현재 사용자 ID를 여기에 정의
  bool _isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // 현재 사용자 정보를 가져오는 메서드 호출
    _fetchRooms(); // 방 정보 가져오기
  }

  // Firestore에서 현재 사용자 이름과 문서 ID를 가져오는 메서드
  Future<void> _getCurrentUser() async {
    User? user = _auth.currentUser; // 현재 로그인한 사용자
    if (user != null) {
      currentUserId = user.uid; // Firestore에서 사용자 ID 저장
    } else {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }
  }

  Future<void> _fetchRooms() async {
    setState(() {
      _isLoading = true; // 로딩 시작
    });
    try {
      QuerySnapshot snapshot = await _firestore.collection('study_rooms').get();
      setState(() {
        _rooms = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          String startTime =
              (data['startTime'] as Timestamp).toDate().toIso8601String();
          String endTime =
              (data['endTime'] as Timestamp).toDate().toIso8601String();

          return {
            'docId': doc.id, // 문서 ID 추가
            ...data,
            'startTime': startTime,
            'endTime': endTime,
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching rooms: $e');
    } finally {
      setState(() {
        _isLoading = false; // 로딩 끝
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_alt_outlined),
        ),
        title: const Center(child: Text('스터디 목록')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: _isLoading // 로딩 상태에 따라 보여주는 위젯
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
              ? const Center(child: Text('방이 없습니다.'))
              : ListView.builder(
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    final Map<String, dynamic> reservations =
                        room['reservations'] as Map<String, dynamic>? ?? {};

                    // 현재 사용자의 예약 상태 가져오기
                    final userReservation = reservations[currentUserId] ?? true;
                    print(userReservation);
                    false; // 해당 사용자의 예약 상태 가져오기
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    room: room, roomId: room['docId'])));
                      },
                      child: RoomCard(
                        title: room['title'],
                        host: room['host'],
                        content: room['content'],
                        startTime: room['startTime'],
                        endTime: room['endTime'],
                        attendee: room['attendee'] ?? 0,
                        maxParticipants: room['maxParticipants'],
                        topic: room['topic'],
                        imageUrl: 'https://picsum.photos/200/200',
                        reservations: userReservation,
                        onButton: (docId) async {
                          // 문서 ID를 사용하여 예약 상태 업데이트 메소드 호출
                          await updateReservationStatus(docId);
                        },
                        startStudy: false,
                        currentUserId: currentUserId,
                        docId: room['docId'], // 문서 ID를 RoomCard에 전달
                      ),
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
            MaterialPageRoute(builder: (context) => const CreateRoomPage()),
          );
        },
        child: const Icon(Icons.add), // 방 추가 버튼
      ),
    );
  }

  // 예약 상태를 업데이트하는 메서드
  Future<void> updateReservationStatus(String docId) async {
    try {
      // 문서 스냅샷 가져오기
      final docSnapshot =
          await _firestore.collection('study_rooms').doc(docId).get();

      // 문서 존재 여부 확인
      if (docSnapshot.exists) {
        // 'reservations' 필드에 안전하게 접근
        final reservations =
            docSnapshot.data()?['reservations'] as Map<String, dynamic>?;

        // 현재 사용자의 예약 상태를 확인
        if (reservations != null) {
          final currentUserReservation =
              reservations[currentUserId] ?? false; // 현재 사용자의 예약 상태 가져오기

          // 예약 상태 업데이트 로직
          await _firestore.collection('study_rooms').doc(docId).update({
            'reservations.$currentUserId': !currentUserReservation,
            // 현재 사용자의 예약 상태 반전
          });
        } else {
          print('예약 정보가 없습니다.');
        }
      } else {
        print('문서가 존재하지 않습니다. 문서 ID를 확인하세요.');
      }
    } catch (e) {
      print('문서 검색 중 오류 발생: $e');
    }
  }
}
