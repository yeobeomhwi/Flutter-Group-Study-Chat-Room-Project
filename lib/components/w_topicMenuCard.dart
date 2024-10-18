import 'package:flutter/material.dart';

class TopicMenuCard extends StatelessWidget {
  final String title; // 카드 제목
  final String uri; // 이미지 URI
  final Function() onCardTap; // 수정: 콜백 타입 수정
  final int badgeCount; // 추가: 방 개수

  const TopicMenuCard({
    super.key,
    required this.title,
    required this.uri,
    required this.onCardTap,
    required this.badgeCount, // 방 개수 추가
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // 카드 너비
      height: 160, // 카드 높이
      child: GestureDetector(
        onTap: onCardTap,
        child: Card(
          elevation: 4, // 카드 그림자 효과
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 카드 모서리 둥글게
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                child: Image.asset(
                  uri,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Badge 추가
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 12,
                  child: Text(
                    badgeCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
