import 'package:flutter/material.dart';

class TopicText extends StatefulWidget {
  final String text;
  final int initialBadgeCount;

  const TopicText({super.key, required this.text, required this.initialBadgeCount});

  @override
  State<TopicText> createState() => _TopicTextState();
}

class _TopicTextState extends State<TopicText> {
  late int badgeCount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    badgeCount = widget.initialBadgeCount;
  }

  void updateBadgeCount(int newCount){
    setState(() {
      badgeCount = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Badge.count(
            count: badgeCount,
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}