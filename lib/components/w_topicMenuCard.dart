import 'package:flutter/material.dart';

class TopicMenuCard extends StatefulWidget {
  final String title; // 카드 제목
  final String uri; // 이미지 URI
  final Function() onCardTap; // 수정: 콜백 타입 수정

  const TopicMenuCard({
    super.key,
    required this.title,
    required this.uri,
    required this.onCardTap, // 수정: onCardTap 매개변수 추가
  });

  @override
  State<TopicMenuCard> createState() => _TopicMenuCardState();
}

class _TopicMenuCardState extends State<TopicMenuCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180, // 카드 너비
      height: 200, // 카드 높이
      child: GestureDetector(
        onTap: widget.onCardTap, // 수정: widget.onCardTap으로 수정
        child: Card(
          elevation: 4, // 카드 그림자 효과
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 카드 모서리 둥글게
          ),
          child: Stack(
            children: [
              // 이미지 위젯
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // 모서리 둥글게
                child: Image.asset(
                  widget.uri,
                  fit: BoxFit.cover, // 이미지 크기 조정
                  height: 200, // 카드 높이에 맞춤
                  width: double.infinity, // 카드 너비
                ),
              ),
              // 이미지 위에 텍스트 표시
              Positioned(
                top: 20, // 상단 여백
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    color: Colors.black54, // 텍스트 배경색
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // 텍스트 패딩
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white, // 텍스트 색상
                        fontSize: 20, // 텍스트 크기
                        fontWeight: FontWeight.bold, // 텍스트 굵게
                      ),
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
