import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // intl 패키지 불러오기
import '../components/w_roomCard.dart'; // RoomCard 불러오기
import 'filteringRoom/s_filteringRommScreen.dart';
import 's_createRoom.dart'; // 방 생성 페이지

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _rooms = [];
  String currentUserId = ''; // 현재 사용자 ID
  bool _isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _initializeUserAndRooms(); // 사용자와 방 정보 초기화
  }

  // 사용자 정보 및 방 정보 가져오는 메서드
  Future<void> _initializeUserAndRooms() async {
    try {
      await _getCurrentUser(); // 현재 사용자 ID 가져오기
      await _fetchRooms(); // 방 정보 가져오기
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
      final snapshot = await _firestore.collection('study_rooms').get();
      setState(() {
        _rooms = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // 날짜를 원하는 형식으로 변환
          final startTime = (data['startTime'] as Timestamp).toDate();
          final endTime = (data['endTime'] as Timestamp).toDate();
          final dateFormat = DateFormat('yyyy년 MM월 dd일 HH시 mm분');

          return {
            'docId': doc.id,
            ...data,
            'startTime': dateFormat.format(startTime), // 시작 시간 변환
            'endTime': dateFormat.format(endTime), // 종료 시간 변환
          };
        }).toList();
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
      final docSnapshot = await _firestore.collection('study_rooms').doc(docId).get();
      if (docSnapshot.exists) {
        final reservations = docSnapshot.data()?['reservations'] as Map<String, dynamic>? ?? {};
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilteringRommScreen()), // 방 생성 페이지로 이동
            );
          },
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 중일 때
          : _rooms.isEmpty
          ? const Center(child: Text('방이 없습니다.')) // 방이 없을 때
          : ListView.builder(
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          final reservations = room['reservations'] as Map<String, dynamic>? ?? {};
          final userReservation = reservations[currentUserId] ?? false;
          return RoomCard(
            title: room['title'],
            host: room['host'],
            content: room['content'],
            startTime: room['startTime'],
            endTime: room['endTime'],
            attendee: room['attendee'] ?? 0,
            maxParticipants: room['maxParticipants'],
            topic: room['topic'],
            imageUrl: 'https://picsum.photos/200/200', // 임시 이미지 URL
            reservations: userReservation,
            startStudy: false,
            currentUserId: currentUserId,
            docId: room['docId'],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoomPage()), // 방 생성 페이지로 이동
          );
        },
        child: const Icon(Icons.add), // 방 추가 버튼
      ),
    );
  }
}
