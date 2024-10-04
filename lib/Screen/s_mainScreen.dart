import 'package:app_team2/Screen/s_createRoom.dart';
import 'package:flutter/material.dart';

import '../components/w_topicAndCard.dart';
import '../data/temporaryData.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
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
              TopicAndCard(roomCards: roomCards, title: '최근 생긴 스터디'),
              TopicAndCard(roomCards: roomCards, title: '자바 스터디'),
              TopicAndCard(roomCards: roomCards, title: 'Dart 스터디'),
              TopicAndCard(roomCards: roomCards, title: '파이썬 스터디'),
              TopicAndCard(roomCards: roomCards, title: '토익 스터디'),
              TopicAndCard(roomCards: roomCards, title: '일본어 스터디'),
              TopicAndCard(roomCards: roomCards, title: '중국어 스터디'),
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
