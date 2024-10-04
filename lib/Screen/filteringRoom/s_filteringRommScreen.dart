import 'package:app_team2/Screen/s_createRoom.dart';

import 'package:flutter/material.dart';

import '../../components/w_topicAndCard.dart';
import '../../data/temporaryData.dart';
import '../s_mainScreen.dart';



class FilteringRommScreen extends StatefulWidget {
  const FilteringRommScreen({super.key});

  @override
  State<FilteringRommScreen> createState() => _FilteringRommScreenState();
}

class _FilteringRommScreenState extends State<FilteringRommScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MainScreen()), // FilteringRommScreen으로 이동
            );
          },
          icon: const Icon(Icons.filter_alt_outlined),
        ),
        title: const Center(child: Text('스터디 목록')),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.account_circle_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align items to the left
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // TopicAndCard(roomCards: roomCards, title: '최근 생긴 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '수학 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '영어 회화 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '토익 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '프로그래밍 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '디자인 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '스포츠 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '과학 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '독서 스터디'),
              // TopicAndCard(roomCards: roomCards, title: '자격증 스터디')
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateRoomPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
