import 'package:app_team2/components/w_studyActionButtons.dart';
import 'package:flutter/material.dart';


class RoomCard extends StatefulWidget {
  final String title;
  final String host;
  final String content;
  String startTime;
  String endTime;
  final String type;
  int inUser;
  int maxUser;
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
    required this.type,
    required this.inUser,
    required this.maxUser,
    required this.imageUrl,
    required this.reservation,
    required this.startStudy,
  });

  @override
  _RoomCardState createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 300,
      child: Card(
        elevation: 4, // Card shadow depth
        margin: const EdgeInsets.symmetric(vertical: 8), // Card vertical margin
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Inner padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Left alignment
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
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.host,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Text(
                  widget.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              Text('시작 시간 : ${widget.startTime}',
                  style: const TextStyle(fontSize: 12)),
              Text('종료 시간 : ${widget.endTime}',
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 10),
              Text('현재 인원 : ${widget.inUser} / ${widget.maxUser}'),
              const SizedBox(height: 10),
              StudyActionButton(
                reservation: widget.reservation,
                startStudy: widget.startStudy,
              )
            ],
          ),
        ),
      ),
    );
  }
}
