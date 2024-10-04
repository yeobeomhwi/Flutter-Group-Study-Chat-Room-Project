import 'package:flutter/material.dart';

class StudyActionButton extends StatefulWidget {
  bool reservation;
  bool startStudy;

  StudyActionButton({
    super.key,
    required this.reservation,
    required this.startStudy,
  });

  @override
  _StudyActionButtonState createState() => _StudyActionButtonState();
}

class _StudyActionButtonState extends State<StudyActionButton> {
  @override
  Widget build(BuildContext context) {
    return widget.startStudy
        ? FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('스터디에 참여합니다.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('참여 하기'),
          )
        : widget.reservation
            ? OutlinedButton(
                onPressed: () {
                  setState(() {
                    widget.reservation = false; // 예약 취소 로직
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36),
                ),
                child: const Text('예약 취소'),
              )
            : FilledButton(
                onPressed: () {
                  setState(() {
                    widget.reservation = true; // 예약하기 로직
                  });
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36),
                ),
                child: const Text('예약 하기'),
              );
  }
}
