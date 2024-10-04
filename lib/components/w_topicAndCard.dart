import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'w_roomCard.dart';
import 'w_topicText.dart';

class TopicAndCard extends StatefulWidget {
  final List<RoomCard> roomCards;
  final String title;

  const TopicAndCard({super.key, required this.roomCards, required this.title});

  @override
  State<TopicAndCard> createState() => _TopicAndCardState();
}

class _TopicAndCardState extends State<TopicAndCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopicText(text: widget.title, initialBadgeCount: widget.roomCards.length),
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 15),
        CarouselSlider(
          options: CarouselOptions(
            height: 300, // 카드 높이에 맞추어 설정
            viewportFraction: 0.6,
            pageSnapping : false, // 페이지 스냅기능
            enlargeCenterPage: false, // 중앙 키움
            enableInfiniteScroll: true, // 무한 스크롤 비활성화
            autoPlay: false, // 자동으로 슬라이드
          ),
          items: widget.roomCards.map((item) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5), // 슬라이드 간의 여백
              child: item,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
