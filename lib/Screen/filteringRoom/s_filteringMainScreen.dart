import 'package:app_team2/components/w_topicMenuCard.dart';
import 'package:flutter/material.dart';

class FilteringMainScreen extends StatefulWidget {
  const FilteringMainScreen({super.key});

  @override
  State<FilteringMainScreen> createState() => _FilteringMainScreenState();
}

class _FilteringMainScreenState extends State<FilteringMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView( // Enable scrolling
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                '주제별로 보기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Create multiple rows with TopicMenuCard widgets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(title: '수학', uri: 'assets/images/topic/Mathematics.png'),
                  TopicMenuCard(title: '영어', uri: 'assets/images/topic/English.png'),
                ],
              ),
              SizedBox(height: 20), // Add spacing between rows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(title: '프로그래밍', uri: 'assets/images/topic/programming.png'),
                  TopicMenuCard(title: '디자인', uri: 'assets/images/topic/Design.png'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(title: '스포츠', uri: 'assets/images/topic/Sports.png'),
                  TopicMenuCard(title: '과학', uri: 'assets/images/topic/Science.png'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TopicMenuCard(title: '독서', uri: 'assets/images/topic/Reading.png'),
                  TopicMenuCard(title: '자격증', uri: 'assets/images/topic/Certificate.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
