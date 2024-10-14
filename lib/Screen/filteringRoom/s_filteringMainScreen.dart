import 'package:app_team2/components/w_topicMenuCard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilteringMainScreen extends StatelessWidget {
  const FilteringMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // 스크롤 가능
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
                      GoRouter.of(context).push('/Math'); // MathScreen으로 이동
                    },
                  ),
                  TopicMenuCard(
                    title: '영어',
                    uri: 'assets/images/topic/English.png',
                    onCardTap: () {
                      GoRouter.of(context).push('/Eng'); // EnglishScreen으로 이동
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
                      GoRouter.of(context)
                          .push('/Program'); // ProgrammingScreen으로 이동
                    },
                  ),
                  TopicMenuCard(
                    title: '디자인',
                    uri: 'assets/images/topic/Design.png',
                    onCardTap: () {
                      GoRouter.of(context).push('/Design'); // DesignScreen으로 이동
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
                      GoRouter.of(context).push('/Sports'); // SportsScreen으로 이동
                    },
                  ),
                  TopicMenuCard(
                    title: '과학',
                    uri: 'assets/images/topic/Science.png',
                    onCardTap: () {
                      GoRouter.of(context)
                          .push('/Science'); // ScienceScreen으로 이동
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
                      GoRouter.of(context)
                          .push('/Reading'); // ReadingScreen으로 이동
                    },
                  ),
                  TopicMenuCard(
                    title: '자격증',
                    uri: 'assets/images/topic/Certificate.png',
                    onCardTap: () {
                      GoRouter.of(context)
                          .push('/Certificate'); // CertificateScreen으로 이동
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
