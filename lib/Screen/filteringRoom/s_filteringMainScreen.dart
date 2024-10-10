import 'package:app_team2/Screen/filteringRoom/s_certificateScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_designScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_engScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_mathScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_programScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_readingScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_scienceScreen.dart';
import 'package:app_team2/Screen/filteringRoom/s_sportsScreen.dart';
import 'package:app_team2/components/w_topicMenuCard.dart';
import 'package:flutter/material.dart';

class FilteringMainScreen extends StatelessWidget {
  const FilteringMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // 스크롤 가능
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                '주제별로 보기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(
                    title: '수학',
                    uri: 'assets/images/topic/Mathematics.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MathScreen()), // MathScreen으로 이동
                      );
                    },
                  ),
                  TopicMenuCard(
                    title: '영어',
                    uri: 'assets/images/topic/English.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EngScreen()), // EnglishScreen으로 이동
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20), // 행 사이 간격
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(
                    title: '프로그래밍',
                    uri: 'assets/images/topic/programming.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProgramScreen()), // ProgrammingScreen으로 이동
                      );
                    },
                  ),
                  TopicMenuCard(
                    title: '디자인',
                    uri: 'assets/images/topic/Design.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DesignScreen()), // DesignScreen으로 이동
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(
                    title: '스포츠',
                    uri: 'assets/images/topic/Sports.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SportsScreen()), // SportsScreen으로 이동
                      );
                    },
                  ),
                  TopicMenuCard(
                    title: '과학',
                    uri: 'assets/images/topic/Science.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScienceScreen()), // ScienceScreen으로 이동
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(
                    title: '독서',
                    uri: 'assets/images/topic/Reading.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadingScreen()), // ReadingScreen으로 이동
                      );
                    },
                  ),
                  TopicMenuCard(
                    title: '자격증',
                    uri: 'assets/images/topic/Certificate.png',
                    onCardTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CertificateScreen()), // CertificateScreen으로 이동
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
