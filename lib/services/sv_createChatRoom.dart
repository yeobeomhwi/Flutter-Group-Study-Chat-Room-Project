import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateChatRoom {
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
  Future<void> createChatRoom(String title) async {
    String host = await getUserName(); // 사용자 이름 가져오기
    int newId = await getNextId(); // 다음 ID 가져오기

    // 채팅방 정보 객체 생성
    Map<String, dynamic> chatRoomData = {
      'title': title,
      'host': host,
      'createDate': DateTime.now(),
    };

    // Firestore에 채팅방 데이터 저장
    try {
      await _firestore
          .collection('chats')
          .doc(newId.toString())
          .set(chatRoomData);
    } catch (e) {
      throw Exception('채팅방 생성 실패: ${e.toString()}');
    }
  }

  // 메시지를 Firestore에 저장하는 메서드
  Future<void> sendMessage(String chatRoomId, String messageContent) async {
    String currentUserId = _auth.currentUser!.uid; // 현재 사용자 ID 가져오기

    // Firestore에서 사용자 이름 가져오기
    String username = await getUserName(); // 사용자 이름 가져오기

    // 메시지 객체 생성
    Map<String, dynamic> messageData = {
      'sender': username, // 보낸 사람
      'message': messageContent, // 메시지 내용
      'sentTime': DateTime.now(), // 보낸 시간
    };

    // Firestore에 메시지 저장
    try {
      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);
    } catch (e) {
      throw Exception('메시지 전송 실패: ${e.toString()}');
    }
  }
}
