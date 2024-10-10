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
  int attendee; // 현재 참석 인원 수
  final int maxParticipants; // 최대 참석 가능 인원 수
  final String imageUrl; // 호스트의 프로필 이미지 URL
  bool reservations; // 사용자의 예약 상태
  final bool startStudy; // 스터디 시작 여부
  final String currentUserId; // 현재 사용자 ID
  final String docId; // 스터디룸 Firestore 문서 ID
  final Function() onCardTap;

  RoomCard({
    super.key,
    required this.title,
    required this.host,
    required this.content,
    required this.startTime,
    required this.endTime,
    required this.topic,
    required this.attendee,
    required this.maxParticipants,
    required this.imageUrl,
    required this.reservations,
    required this.startStudy,
    required this.currentUserId,
    required this.docId,
    required this.onCardTap,
  });

  @override
  _RoomCardState createState() => _RoomCardState();
}

// _RoomCardState 클래스: RoomCard의 상태 관리
class _RoomCardState extends State<RoomCard> {
  bool open = false; // 카드가 펼쳐져 있는지 여부를 저장하는 변수
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore 인스턴스

  // 예약 상태를 Firestore에서 업데이트하는 비동기 함수
  Future<void> updateReservationStatus() async {
    try {
      final docRef =
          _firestore.collection('study_rooms').doc(widget.docId); // 스터디룸 문서 참조
      final docSnapshot = await docRef.get(); // 문서 데이터 가져오기

      if (docSnapshot.exists) {
        // 현재 사용자의 예약 상태 가져오기 (예약이 없으면 기본값은 false)
        final currentReservation =
            (docSnapshot.data()?['reservations'] ?? {})[widget.currentUserId] ??
                false;

        // 예약 상태 업데이트
        await docRef.update({
          'reservations.${widget.currentUserId}': !currentReservation,
        });

        // 예약 상태 업데이트 후 UI 갱신
        setState(() {
          widget.reservations = !currentReservation;
        });
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error updating reservation: $e');
    }
  }

  // 예약 버튼 또는 참여 버튼 생성 함수
  Widget buildButton() {
    if (widget.startStudy) {
      // 스터디가 시작되었으면 '참여하기' 버튼 생성
      return FilledButton(
        onPressed: widget.onCardTap,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 36),
        ),
        child: const Text('참여 하기'),
      );
    }
    // 스터디가 시작되지 않았다면 예약 버튼 또는 예약 취소 버튼 생성
    return widget.reservations
        ? OutlinedButton(
            onPressed: updateReservationStatus, // 예약 취소
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('예약 취소'),
          )
        : FilledButton(
            onPressed: updateReservationStatus, // 예약하기
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('예약 하기'),
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
                  const SizedBox(width: 10),
                  // 제목 및 호스트 이름
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(widget.host, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  // 주제 및 펼치기 버튼
                  Text(widget.topic),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        open = !open; // 카드를 펼치거나 접는 기능
                      });
                    },
                    icon: Icon(open
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 스터디룸 설명 (펼쳐졌을 때 최대 3줄 표시, 접혔을 때 1줄만 표시)
              Expanded(
                child: Text(
                  widget.content,
                  maxLines: open ? 3 : 1,
                  overflow: open ? null : TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              if (open) ...[
                // 스터디 시작 및 종료 시간 표시
                Text('시작 시간 : ${widget.startTime}',
                    style: const TextStyle(fontSize: 12)),
                Text('종료 시간 : ${widget.endTime}',
                    style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                // 참석 인원 정보 표시
                Text('현재 인원 : ${widget.attendee} / ${widget.maxParticipants}'),
                const SizedBox(height: 10),
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
