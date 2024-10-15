import 'package:app_team2/services/sv_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// RoomCard 클래스: 각 스터디룸 정보를 보여주는 카드 위젯
class RoomCard extends StatefulWidget {
  // 스터디룸의 각종 정보들
  final String title; // 스터디룸 제목
  final String host; // 호스트(방장) 이름
  final String content; // 스터디룸 설명
  final DateTime startTime; // 스터디 시작 시간
  final DateTime endTime; // 스터디 종료 시간
  final String topic; // 스터디 주제
  final int maxParticipants; // 최대 참석 가능 인원 수
  final String imageUrl; // 호스트의 프로필 이미지 URL
  List<dynamic> reservations; // 사용자의 예약 상태
  final bool startStudy; // 스터디 시작 여부
  final String currentUserId; // 현재 사용자 ID
  final String docId; // 스터디룸 Firestore 문서 ID
  final Function() onCardTap; // 카드 클릭 시 호출될 함수

  RoomCard({
    super.key,
    required this.title,
    required this.host,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.maxParticipants,
    required this.imageUrl,
    required this.reservations,
    required this.startStudy,
    required this.currentUserId,
    required this.docId,
    required this.onCardTap,
  });

  @override
  _RoomCardState createState() => _RoomCardState(); // 상태 클래스 생성
}

// _RoomCardState 클래스: RoomCard의 상태 관리
class _RoomCardState extends State<RoomCard> {
  bool open = false; // 카드가 펼쳐져 있는지 여부를 저장하는 변수
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore 인스턴스
  final FirebaseAuth _auth = FirebaseAuth.instance; // Auth 인스턴스
  String currentUserId = ''; // 현재 사용자 ID

  @override
  void initState() {
    super.initState();
    _getCurrentUser(); // 현재 사용자 ID를 가져옵니다.
  }

  // 스터디룸에 참여하는 함수
  Future<void> joinRoom(String docId) async {
    try {
      final docSnapshot = await _firestore
          .collection('study_rooms')
          .doc(docId)
          .get(); // 스터디룸 문서 가져오기
      if (docSnapshot.exists) {
        final reservations =
            docSnapshot.data()?['reservations'] as List<dynamic>? ?? []; // 예약 목록 가져오기

        // 현재 사용자가 이미 참여 중인지 확인
        if (!reservations.contains(currentUserId)) {
          reservations.add(currentUserId); // 사용자를 예약 목록에 추가

          // Firestore에 스터디룸 예약 리스트 업데이트
          await _firestore.collection('study_rooms').doc(docId).update({
            'reservations': reservations,
          });

          // Firestore에서 사용자 테이블(user)에 참여 정보 추가
          final userDocRef = _firestore.collection('users').doc(currentUserId);

          // 사용자 정보 가져오기
          final userDocSnapshot = await userDocRef.get();
          if (userDocSnapshot.exists) {
            // participationList를 가져와서 업데이트
            List<dynamic> participationList = userDocSnapshot.data()?['participationList'] as List<dynamic>? ?? [];

            if (!participationList.contains(docId)) {
              participationList.add(docId); // 스터디룸 ID를 참여 목록에 추가
              await userDocRef.update({
                'participationList': participationList, // 업데이트된 참여 목록 저장
              });
              print('참여 목록이 업데이트되었습니다.');
            } else {
              print('이미 참여 중입니다.');
            }
          } else {
            // 만약 user 문서가 존재하지 않을 경우 새 문서 생성
            await userDocRef.set({
              'participationList': [docId], // 새로 참여 목록 추가
            });
            print('새로운 참여 목록이 생성되었습니다.');
          }


          // 상태를 갱신하여 UI 업데이트
          setState(() {
            widget.reservations = reservations; // 업데이트된 예약 상태를 UI에 반영
          });
        } else {
          // 이미 참여 중인 경우, 경고 메시지 또는 알림을 표시할 수 있음
          print('이미 참여 중입니다.'); // 디버그용 로그
        }
      } else {
        print('문서가 존재하지 않습니다.'); // 문서가 없을 경우
      }
    } catch (e) {
      print('스터디룸 참여 중 오류 발생: $e'); // 오류 처리
    }
  }

  // 예약 상태 업데이트 함수
  Future<void> updateReservationStatus(String docId) async {
    try {
      final docSnapshot = await _firestore
          .collection('study_rooms')
          .doc(docId)
          .get(); // 스터디룸 문서 가져오기
      if (docSnapshot.exists) {
        final reservations =
            docSnapshot.data()?['reservations'] as List<dynamic>? ?? []; // 예약 목록 가져오기
        final currentUserReservation =
        reservations.contains(currentUserId); // 현재 사용자의 예약 여부 확인

        // 예약 추가 또는 취소
        if (currentUserReservation) {
          reservations.remove(currentUserId); // 예약 취소

          // 사용자 participationList에서 스터디룸 ID 삭제
          final userDocRef = _firestore.collection('users').doc(currentUserId);
          final userDocSnapshot = await userDocRef.get();
          if (userDocSnapshot.exists) {
            List<dynamic> participationList =
                userDocSnapshot.data()?['participationList'] as List<dynamic>? ?? [];

            if (participationList.contains(docId)) {
              participationList.remove(docId); // 참여 목록에서 스터디룸 ID 삭제
              await userDocRef.update({
                'participationList': participationList, // 업데이트된 참여 목록 저장
              });
              print('참여 목록에서 스터디룸 ID가 삭제되었습니다.');
            }
          }
        } else {
          reservations.add(currentUserId); // 예약 추가
        }

        // Firestore에 업데이트된 예약 목록 저장
        await _firestore.collection('study_rooms').doc(docId).update({
          'reservations': reservations, // 업데이트된 리스트 저장
        });

        // 상태를 갱신하여 UI 업데이트
        setState(() {
          widget.reservations = reservations; // 업데이트된 예약 상태를 UI에 반영
        });
      } else {
        print('문서가 존재하지 않습니다.'); // 문서가 없을 경우
      }
    } catch (e) {
      print('예약 상태 업데이트 중 오류 발생: $e'); // 오류 처리
    }
  }


  // 현재 사용자 ID 가져오기
  Future<void> _getCurrentUser() async {
    final user = _auth.currentUser; // 현재 사용자 정보 가져오기
    if (user != null) {
      setState(() {
        currentUserId = user.uid; // 사용자 ID 저장
      });
    } else {
      throw Exception('사용자가 로그인되어 있지 않습니다.'); // 로그인되지 않았을 경우 예외 발생
    }
  }

  // 예약 버튼 또는 참여 버튼 생성 함수
  Widget buildButton() {
    // 인원이 마감된 경우
    if (widget.reservations.length >= widget.maxParticipants) {
      // 현재 사용자가 이미 예약되어 있는 경우
      if (widget.reservations.contains(widget.currentUserId)) {
        return FilledButton(
          onPressed: () {
            widget.onCardTap(); // 카드 클릭 시 호출
            joinRoom(widget.docId); // 참여하기
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 36), // 버튼 최소 크기 설정
          ),
          child: const Text('참여 하기'), // 버튼 텍스트
        );
      } else {
        return OutlinedButton(
          onPressed: null, // 클릭 불가능하도록 설정
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 36), // 버튼 최소 크기 설정
          ),
          child: const Text('인원 마감'), // 버튼 텍스트
        );
      }
    }

    // 스터디가 시작된 경우
    if (widget.startStudy) {
      return FilledButton(
        onPressed: () {
          widget.onCardTap(); // 카드 클릭 시 호출
          joinRoom(widget.docId);
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 36), // 버튼 최소 크기 설정
        ),
        child: const Text('참여 하기'), // 버튼 텍스트
      );
    }

    // 스터디가 시작되지 않았다면 예약 버튼 또는 예약 취소 버튼 생성
    return widget.reservations.contains(widget.currentUserId)
        ? OutlinedButton(
            onPressed: () async {
              updateReservationStatus(widget.docId);
              NotificationService.instance.cancelNotification(widget.docId);
            }, // 예약 취소
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36), // 버튼 최소 크기 설정
            ),
            child: const Text('예약 취소'), // 버튼 텍스트
          )
        : FilledButton(
            onPressed: () async {
              updateReservationStatus(widget.docId);
              NotificationService.instance
                  .reserveNotification(widget.startTime, widget.docId);
            }, // 예약하기
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36), // 버튼 최소 크기 설정
            ),
            child: const Text('예약 하기'), // 버튼 텍스트
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210, // 카드 너비
      height: open ? 300 : 140, // 카드 높이 (펼쳐지면 300, 접히면 140)
      child: Card(
        elevation: 4, // 카드 그림자
        margin: const EdgeInsets.symmetric(vertical: 8), // 세로 여백
        child: Padding(
          padding: const EdgeInsets.all(16.0), // 내부 여백
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: <Widget>[
              Row(
                children: [
                  // 호스트 프로필 이미지
                  ClipOval(
                    child: SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: Image.network(widget.imageUrl,
                          fit: BoxFit.cover), // 이미지 불러오기
                    ),
                  ),
                  const SizedBox(width: 10), // 이미지와 텍스트 사이 여백
                  // 제목 및 호스트 이름
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)), // 제목 스타일
                        Text(widget.host,
                            style: const TextStyle(fontSize: 12)), // 호스트 이름 스타일
                      ],
                    ),
                  ),
                  // 주제 및 펼치기 버튼
                  Text(widget.topic), // 주제
                  IconButton(
                    onPressed: () {
                      setState(() {
                        open = !open; // 카드를 펼치거나 접는 기능
                      });
                    },
                    icon: Icon(open
                        ? Icons.keyboard_arrow_up_outlined // 펼칠 때 아이콘
                        : Icons.keyboard_arrow_down_outlined), // 접을 때 아이콘
                  ),
                ],
              ),
              const SizedBox(height: 10), // 제목과 설명 사이 여백
              // 스터디룸 설명 (펼쳐졌을 때 최대 3줄 표시, 접혔을 때 1줄만 표시)
              Expanded(
                child: Text(
                  widget.content,
                  maxLines: open ? 3 : 1, // 최대 줄 수 설정
                  overflow: open ? null : TextOverflow.ellipsis, // 텍스트 오버플로우 처리
                ),
              ),
              const SizedBox(height: 8), // 설명과 시간 사이 여백
              if (open) ...[
                // 스터디 시작 및 종료 시간 표시
                Text('시작 시간 : ${widget.startTime}',
                    style: const TextStyle(fontSize: 12)), // 시작 시간
                Text('종료 시간 : ${widget.endTime}',
                    style: const TextStyle(fontSize: 12)), // 종료 시간
                const SizedBox(height: 10), // 시간과 참석 인원 사이 여백
                // 참석 인원 정보 표시
                Text(
                    '현재 인원 : ${widget.reservations.length} / ${widget.maxParticipants}'), // 참석 인원
                const SizedBox(height: 10), // 참석 인원과 버튼 사이 여백
                // 예약 버튼 또는 참여 버튼 생성
                buildButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
