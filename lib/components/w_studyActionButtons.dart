import 'package:flutter/material.dart';

class StudyActionButton extends StatelessWidget {
  final bool reservations;
  final bool startStudy;
  final VoidCallback onButton; // Use VoidCallback for a function that returns void

  StudyActionButton({
    super.key,
    required this.onButton,
    required this.reservations,
    required this.startStudy,
  });

  @override
  Widget build(BuildContext context) {
    return startStudy
        ? FilledButton(
      onPressed: (){},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 36),
      ),
      child: const Text('참여 하기'),
    )
        : reservations
        ? OutlinedButton(
      onPressed: onButton, // Pass the callback directly
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 36),
      ),
      child: const Text('예약 취소'),
    )
        : FilledButton(
      onPressed: onButton, // Pass the callback directly
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 36),
      ),
      child: const Text('예약 하기'),
    );
  }
}
