import 'dart:ffi';

import 'package:app_team2/components/w_studyActionButtons.dart';
import 'package:app_team2/components/w_subheading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomCard extends StatefulWidget {
  final String title;
  final String host;
  final String content;
  final String startTime;
  final String endTime;
  final String topic;
  int attendee;
  final int maxParticipants;
  final String imageUrl;
  final bool reservations; // 예약 상태를 관리하는 Map
  final bool startStudy;
  final String currentUserId; // 현재 사용자 ID
  Function(String) onButton;
  final String docId; // 추가된 docId

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
    required this.onButton,
    required this.docId, // 추가된 docId
  });


  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool open = false; // 카드가 열려 있는지 여부

  // Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateReservationStatus() async {
    try {
      // 문서 스냅샷 가져오기
      final docSnapshot = await _firestore.collection('study_rooms').doc(widget.docId).get();

      // 문서 존재 여부 확인
      if (docSnapshot.exists) {
        // 'reservations' 필드에 안전하게 접근
        final reservations = docSnapshot.data()?['reservations'] as Map<String, dynamic>? ?? {};

        // 현재 사용자의 예약 상태를 확인
        final currentUserReservation = reservations[widget.currentUserId] ?? false;

        // 예약 상태 업데이트
        await _firestore.collection('study_rooms').doc(widget.docId).update({
          'reservations.${widget.currentUserId}': !currentUserReservation, // 현재 사용자의 예약 상태 반전
        });
      } else {
        print('문서가 존재하지 않습니다. 문서 ID를 확인하세요.');
      }
    } catch (e) {
      print('문서 검색 중 오류 발생: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: open ? 300 : 140,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 42.0,
                      height: 42.0,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        subheading(title: widget.title),
                        Text(
                          widget.host,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  subheading(title: widget.topic),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        open = !open; // 상태를 반전
                      });
                    },
                    icon: Icon(open ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  widget.content,
                  maxLines: open ? 3 : 1,
                  overflow: open ? null : TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              if (open) ...[
                Text('시작 시간 : ${widget.startTime}', style: const TextStyle(fontSize: 12)),
                Text('종료 시간 : ${widget.endTime}', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                Text('현재 인원 : ${widget.attendee} / ${widget.maxParticipants}'),
                const SizedBox(height: 10),
                StudyActionButton(
                  reservations: widget.reservations,
                  startStudy: widget.startStudy,
                    onButton: () async {
                      await updateReservationStatus(); // 버튼 클릭 시 예약 상태 업데이트 메소드 호출
                    }
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
