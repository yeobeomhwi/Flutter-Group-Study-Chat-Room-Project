import 'package:app_team2/services/sv_userService.dart';
import 'package:app_team2/services/sv_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateRoom {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService(); // UserService 인스턴스 생성

  // Firestore에서 다음 ID를 가져오는 메서드
  Future<int> getNextId() async {
    QuerySnapshot snapshot =
    await _firestore.collection('study_rooms').orderBy('room_id').get();

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
    // 사용자 정보 (이름, 프로필 이미지) 가져오기
    Map<String, dynamic> userInfo = await _userService.getUserNameImage();
    String host = userInfo['name']; // 이름
    String profileImageUrl = userInfo['profileimage']; // 프로필 이미지 URL

    int newId = await getNextId();

    // 방 정보 객체 생성
    Map<String, dynamic> roomData = {
      'room_id': newId,
      'title': title,
      'topic': topic,
      'content': content,
      'maxParticipants': maxParticipants,
      'host': host, // 방 생성자 이름 추가
      'hostProfileImage': profileImageUrl, // 방 생성자의 프로필 이미지 추가
      'reservations': reservations, // String array로 설정
      'startStudy': startStudy,
      'startTime': startTime,
      'endTime': endTime,
      'createDate': DateTime.now(),
    };

    // Firestore에 방 데이터 저장
    try {
      // 다음 ID를 가져와서 문서 ID로 사용
      await _firestore
          .collection('study_rooms')
          .doc(newId.toString())
          .set(roomData);

      // 방 생성 후 채팅 데이터도 동일한 ID로 저장
      List<Map<String, dynamic>> chatData = [];
      await _firestore
          .collection('chats')
          .doc(newId.toString()) // 방 ID와 동일한 문서 ID 사용
          .set({
        'messages': chatData, // 메시지를 배열로 저장
      });

      // 방 생성 후 예약 테이블 생성
      NotificationService.instance.setNotification(startTime, newId);
    } catch (e) {
      throw Exception('방 생성 실패: ${e.toString()}');
    }
  }
}
