import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateRoom {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore에서 현재 사용자 이름을 가져오는 메서드
  Future<String> getUserName() async {
    User? user = _auth.currentUser; // 현재 로그인한 사용자
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      return userDoc['name']; // Firestore에서 이름 가져오기
    }
    throw Exception('사용자가 로그인되어 있지 않습니다.');
  }

  // Firestore에서 다음 ID를 가져오는 메서드
  Future<int> getNextId() async {
    QuerySnapshot snapshot = await _firestore
        .collection('study_rooms')
        .orderBy(FieldPath.documentId)
        .get();

    if (snapshot.docs.isEmpty) {
      return 1; // 처음 문서일 경우
    } else {
      int lastId = int.parse(snapshot.docs.last.id);
      return lastId + 1; // 마지막 ID에 1을 더함
    }
  }

  // 방 데이터를 Firestore에 저장하는 메서드
  Future<void> createStudyRoom({
    required String title,
    required String topic,
    required String content,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
    required bool startStudy,
    required List<dynamic> reservations, // 예약을 String array로 변경
  }) async {
    // 사용자 이름 가져오기
    String host = await getUserName(); // 이름 가져오기
    String currentUserId = _auth.currentUser!.uid; // 현재 사용자 ID 가져오기

    // 방 정보 객체 생성
    Map<String, dynamic> roomData = {
      'title': title,
      'topic': topic,
      'content': content,
      'maxParticipants': maxParticipants,
      'host': host, // 방 생성자 이름 추가
      'reservations': reservations, // String array로 설정
      'startStudy': startStudy,
      'startTime': startTime,
      'endTime': endTime,
      'createDate': DateTime.now()
    };

    // Firestore에 방 데이터 저장
    try {
      // 다음 ID를 가져와서 문서 ID로 사용
      int newId = await getNextId();
      await _firestore
          .collection('study_rooms')
          .doc(newId.toString())
          .set(roomData);

      // 사용자의 이름을 chatData에 넣기
      String userName = await getUserName(); // 사용자 이름 가져오기

      // 방 생성 후 채팅 데이터도 동일한 ID로 저장
      List<Map<String, dynamic>> chatData = [];
      await _firestore
          .collection('chats')
          .doc(newId.toString()) // 방 ID와 동일한 문서 ID 사용
          .set({
        'messages': chatData, // 메시지를 배열로 저장
      });
    } catch (e) {
      throw Exception('방 생성 실패: ${e.toString()}');
    }
  }
}
