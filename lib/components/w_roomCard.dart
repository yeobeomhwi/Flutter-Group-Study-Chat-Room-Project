import 'package:app_team2/components/w_studyActionButtons.dart';
import 'package:app_team2/components/w_subheading.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatefulWidget {
  final String title;
  final String host;
  final String content;
  String startTime;
  String endTime;
  final String topic;
  int attendee;
  int maxParticipants;
  final String imageUrl;
  bool reservation;
  bool startStudy;

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
    required this.reservation,
    required this.startStudy,
  });

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: open ? 300 : 130, // 카드의 높이를 조정
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
                    icon: Icon(open ? Icons.remove : Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // open 상태에 따라 content 가시성 조절
              Expanded(
                child: Text(
                  widget.content,
                  maxLines: open ? null : 3, // open이 true일 경우 최대 줄 수 제한 없음
                  overflow: open ? null : TextOverflow.ellipsis, // open이 true일 경우 overflow 처리 없음
                ),
              ),
              const SizedBox(height: 8),
              if (open) ...[ // open이 true일 때만 보이는 추가 정보
                Text('시작 시간 : ${widget.startTime}', style: const TextStyle(fontSize: 12)),
                Text('종료 시간 : ${widget.endTime}', style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                Text('현재 인원 : ${widget.attendee} / ${widget.maxParticipants}'),
                const SizedBox(height: 10),
                StudyActionButton(
                  reservation: widget.reservation,
                  startStudy: widget.startStudy,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
