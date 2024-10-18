import 'package:app_team2/components/w_topicMenuCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FilteringMainScreen extends StatefulWidget {
  const FilteringMainScreen({super.key});

  @override
  State<FilteringMainScreen> createState() => _FilteringMainScreenState();
}

class _FilteringMainScreenState extends State<FilteringMainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore 인스턴스
  bool _isLoading = true; // 로딩 상태

  Map<String, int> _topicCounts = {}; // 주제별 방 개수


  @override
  void initState() {
    super.initState();
    _loadInitialRooms(); // 초기 방 로드
  }

  Future<void> _loadInitialRooms() async {
    setState(() {
      _isLoading = true; // 로딩 상태 활성화
    });

    // 주제별 방 개수 초기화
    Map<String, int> topicCounts = {
      '수학': 0,
      '영어': 0,
      '프로그래밍': 0,
      '디자인': 0,
      '스포츠': 0,
      '과학': 0,
      '독서': 0,
      '자격증': 0,
    };

    // 각 주제에 대한 문서 가져오기
    for (String topic in topicCounts.keys) {
      QuerySnapshot snapshot = await _firestore
          .collection('study_rooms')
          .where('topic', isEqualTo: topic)
          .get();

      // 주제별 방 개수 업데이트
      topicCounts[topic] = snapshot.docs.length; // 주제에 대한 문서 개수
    }

    // 방 목록 가져오기
    QuerySnapshot allRoomsSnapshot = await _firestore
        .collection('study_rooms')
        .orderBy('createDate', descending: true) // 생성 날짜 기준 정렬
        .get();

    // 주제별 방 개수 상태 업데이트
    _topicCounts = topicCounts;

    // 디버깅: 주제별 개수 출력
    print('각 주제별 방 개수: $_topicCounts');

    setState(() {
      _isLoading = false; // 로딩 상태 비활성화
    });
  }

  // 주제 카드 행 빌드 함수
  Widget _buildTopicRow(List<TopicMenuCard> cards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주제별로 보기',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _isLoading // 로딩 상태에 따라 다르게 표시
          ? Center(child: CircularProgressIndicator()) // 로딩 인디케이터
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildTopicRow([
                TopicMenuCard(
                  title: '수학',
                  uri: 'assets/images/topic/Mathematics.png',
                  onCardTap: () => GoRouter.of(context).push('/Math'),
                  badgeCount: _topicCounts['수학'] ?? 0, // 방 개수 추가
                ),
                TopicMenuCard(
                  title: '영어',
                  uri: 'assets/images/topic/English.png',
                  onCardTap: () => GoRouter.of(context).push('/Eng'),
                  badgeCount: _topicCounts['영어'] ?? 0, // 방 개수 추가
                ),
              ]),
              const SizedBox(height: 20),
              _buildTopicRow([
                TopicMenuCard(
                  title: '프로그래밍',
                  uri: 'assets/images/topic/programming.png',
                  onCardTap: () => GoRouter.of(context).push('/Program'),
                  badgeCount: _topicCounts['프로그래밍'] ?? 0, // 방 개수 추가
                ),
                TopicMenuCard(
                  title: '디자인',
                  uri: 'assets/images/topic/Design.png',
                  onCardTap: () => GoRouter.of(context).push('/Design'),
                  badgeCount: _topicCounts['디자인'] ?? 0, // 방 개수 추가
                ),
              ]),
              const SizedBox(height: 20),
              _buildTopicRow([
                TopicMenuCard(
                  title: '스포츠',
                  uri: 'assets/images/topic/Sports.png',
                  onCardTap: () => GoRouter.of(context).push('/Sports'),
                  badgeCount: _topicCounts['스포츠'] ?? 0, // 방 개수 추가
                ),
                TopicMenuCard(
                  title: '과학',
                  uri: 'assets/images/topic/Science.png',
                  onCardTap: () => GoRouter.of(context).push('/Science'),
                  badgeCount: _topicCounts['과학'] ?? 0, // 방 개수 추가
                ),
              ]),
              const SizedBox(height: 20),
              _buildTopicRow([
                TopicMenuCard(
                  title: '독서',
                  uri: 'assets/images/topic/Reading.png',
                  onCardTap: () => GoRouter.of(context).push('/Reading'),
                  badgeCount: _topicCounts['독서'] ?? 0, // 방 개수 추가
                ),
                TopicMenuCard(
                  title: '자격증',
                  uri: 'assets/images/topic/Certificate.png',
                  onCardTap: () => GoRouter.of(context).push('/Certificate'),
                  badgeCount: _topicCounts['자격증'] ?? 0, // 방 개수 추가
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
