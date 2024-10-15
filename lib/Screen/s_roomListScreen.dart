import 'dart:async';
import 'package:app_team2/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../components/w_roomCard.dart';
import '../components/base_scrollMixin.dart'; // Mixin 가져오기

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> with ScrollMixin<RoomListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ScrollController 추가
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _rooms = [];
  String currentUserId = '';
  bool _isLoading = true;
  bool _hasMore = true; // 더 불러올 수 있는지 여부
  DocumentSnapshot? _lastDocument; // 마지막 문서 저장
  List<String> dropDownList = ['제목', '내용'];
  String selected = '제목';
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();

    // 스크롤 이벤트 리스너 추가
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        onScroll();
      }
    });

    Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkStartTimes();
    });

    // 초기 데이터 로드
    _loadInitialRooms();
  }

  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    } else {
      throw Exception('사용자가 로그인되어 있지 않습니다.');
    }
  }

  // 초기 방 목록을 가져오는 메서드
  Future<void> _loadInitialRooms() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot snapshot = await _firestore
        .collection('study_rooms')
        .orderBy('createDate', descending: true)
        .limit(6) // 처음에 로드할 문서 수 제한
        .get();

    if (snapshot.docs.isNotEmpty) {
      _rooms = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final startTime = (data['startTime'] as Timestamp).toDate();
        final endTime = (data['endTime'] as Timestamp).toDate();
        final createDate = (data['createDate'] as Timestamp).toDate();
        final reservations = data['reservations'] as List<dynamic>? ?? [];

        return {
          'docId': doc.id,
          ...data,
          'startTime': startTime,
          'endTime': endTime,
          'createDate': createDate,
          'reservations': reservations,
        };
      }).toList();

      _lastDocument = snapshot.docs.last; // 마지막 문서 저장
    } else {
      _hasMore = false; // 더 이상 불러올 문서가 없으면 false로 설정
    }

    setState(() {
      _isLoading = false;
    });
  }

  // 더 많은 방 목록을 가져오는 메서드
  Future<void> _loadMoreRooms() async {
    if (!_hasMore || _isLoading) return; // 더 이상 불러올 수 없거나 이미 로딩 중이면 종료

    setState(() {
      _isLoading = true;
    });

    QuerySnapshot snapshot = await _firestore
        .collection('study_rooms')
        .orderBy('createDate', descending: true)
        .startAfterDocument(_lastDocument!) // 마지막 문서 이후부터 시작
        .limit(10) // 추가로 로드할 문서 수 제한
        .get();

    if (snapshot.docs.isNotEmpty) {
      _rooms.addAll(snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final startTime = (data['startTime'] as Timestamp).toDate();
        final endTime = (data['endTime'] as Timestamp).toDate();
        final createDate = (data['createDate'] as Timestamp).toDate();
        final reservations = data['reservations'] as List<dynamic>? ?? [];

        return {
          'docId': doc.id,
          ...data,
          'startTime': startTime,
          'endTime': endTime,
          'createDate': createDate,
          'reservations': reservations,
        };
      }).toList());

      _lastDocument = snapshot.docs.last; // 마지막 문서 업데이트
    } else {
      _hasMore = false; // 더 이상 불러올 문서가 없으면 false로 설정
    }

    setState(() {
      _isLoading = false;
    });
  }

  // 무한 스크롤에서 호출되는 메서드
  @override
  void onScroll() {
    if (_hasMore && !_isLoading) {
      _loadMoreRooms(); // 추가 방 로드
    }
  }

  Future<void> _checkStartTimes() async {
    for (var room in _rooms) {
      final startTime = room['startTime'] as DateTime;
      final docId = room['docId'];
      final startStudy = room['startStudy'];

      if (!startStudy && DateTime.now().isAfter(startTime)) {
        await _updateStartStudyStatus(docId);
      }
    }
  }

  Future<void> _updateStartStudyStatus(String docId) async {
    try {
      await _firestore.collection('study_rooms').doc(docId).update({
        'startStudy': true,
      });
    } catch (e) {
      print('startStudy 상태 업데이트 중 오류 발생: $e');
    }
  }

  Stream<List<DocumentSnapshot>> searchByNameStream(String namePrefix) {
    return _firestore
        .collection('study_rooms')
        .where('title', isGreaterThanOrEqualTo: namePrefix)
        .where('title', isLessThanOrEqualTo: '$namePrefix\uf8ff')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _searchTextController.text.isNotEmpty
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: main_color),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: DropdownButton(
                            isExpanded: true,
                            value: selected,
                            items: dropDownList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selected = value!;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down_rounded,
                                size: 20),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            underline: Container()),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 2, color: main_color),
                            right: BorderSide(width: 2, color: main_color),
                            top: BorderSide(width: 2, color: main_color)),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: TextField(
                              controller: _searchTextController,
                              onChanged: (value) {
                                setState(() {
                                  _searchTextController.text = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.only(left: 10)))),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: searchByNameStream(_searchTextController.text),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            final room = snapshot.data![index];
                            final reservations =
                                room['reservations'] as List<dynamic>? ?? [];

                            return RoomCard(
                              title: room['title'],
                              host: room['host'],
                              content: room['content'],
                              startTime:
                                  (room['startTime'] as Timestamp).toDate(),
                              endTime: (room['endTime'] as Timestamp).toDate(),
                              maxParticipants: room['maxParticipants'],
                              topic: room['topic'],
                              imageUrl: 'https://picsum.photos/200/200',
                              reservations: reservations,
                              startStudy: room['startStudy'],
                              currentUserId: currentUserId,
                              docId: room['room_id'].toString(),
                              onCardTap: () {
                                GoRouter.of(context).push('/Chat', extra: {
                                  'room': room,
                                  'roomId': room['docId']
                                });
                              },
                            );
                          },
                        );
                      }),
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: main_color),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: DropdownButton(
                            isExpanded: true,
                            value: selected,
                            items: dropDownList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(child: Text(value)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selected = value!;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down_rounded,
                                size: 20),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            underline: Container()),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 2, color: main_color),
                            right: BorderSide(width: 2, color: main_color),
                            top: BorderSide(width: 2, color: main_color)),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: TextField(
                              controller: _searchTextController,
                              onChanged: (value) {
                                setState(() {
                                  _searchTextController.text = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.only(left: 10)))),
                    ),
                  ],
                ),
                const Text('최신순 정렬'),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _rooms.length + (_hasMore ? 1 : 0),
                    // 더 불러올 수 있을 경우 로딩 인디케이터 추가
                    itemBuilder: (context, index) {
                      if (index == _rooms.length) {
                        // 마지막 아이템에 로딩 인디케이터 표시
                        return const Column(
                          children: [
                            SizedBox(height: 10),
                            Center(child: CircularProgressIndicator())
                          ],
                        );
                      }

                      final room = _rooms[index];
                      final reservations =
                          room['reservations'] as List<dynamic>? ?? [];

                      return RoomCard(
                        title: room['title'],
                        host: room['host'],
                        content: room['content'],
                        startTime: room['startTime'],
                        endTime: room['endTime'],
                        maxParticipants: room['maxParticipants'],
                        topic: room['topic'],
                        imageUrl: room['hostProfileImage'] != null &&
                                room['hostProfileImage'].isNotEmpty
                            ? room['hostProfileImage']
                            : 'https://picsum.photos/200/200', // 프로필 이미지가 없을 때 기본 이미지 사용
                        reservations: reservations,
                        startStudy: room['startStudy'],
                        currentUserId: currentUserId,
                        docId: room['docId'],
                        onCardTap: () {
                          GoRouter.of(context).push('/Chat',
                              extra: {'room': room, 'roomId': room['docId']});
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push('/CreateRoom');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
